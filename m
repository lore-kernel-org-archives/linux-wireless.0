Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2K1NHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 08:07:32 -0500
Message-ID: <1354108076.9345.22.camel@jlt4.sipsolutions.net> (sfid-20121128_140737_015667_7DE78163)
Subject: Re: [RFC 14/14] mac80211: mesh PS individually-addressed frame
 release
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 14:07:56 +0100
In-Reply-To: <50B3B4A2.5000908@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	   <1353134886-13256-15-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	  <1353145246.9543.39.camel@jlt4.sipsolutions.net>
	  <50ABC7D0.2030303@etit.tu-chemnitz.de>
	 <1353926751.9488.19.camel@jlt4.sipsolutions.net>
	 <50B3B4A2.5000908@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 10:27 -0800, Marco Porsch wrote:

> >> Imho, in the context of PSP trigger frames it does.
> >> Sending a trigger frame to a mesh PS STA with no EOSP implies the start
> >> of a PSP with the sender as owner -> following data. The other two
> >> combinations imply that there is no more data following in that direction.
> >
> > The EOSP bit in a trigger frame should always be 0 unless the frame is
> > also a PSP response, no?
> 
> No. That is one weird thing about the standard: the combination 
> RSPI:EOSP 0:0 is seen as a MPSP trigger frame when sent towards a 
> station in PS mode towards the sender. So whenever a frame should be 
> sent in a non-PSP context it has to set the EOSP flag.
> Another situation that sets the EOSP flag is a kind of MPSP poll: if one 
> STA indicates buffered frames, the other STA can poll it with RSPI:EOSP 1:1.

What's RSPI?

> > What you seem to be missing though is the case when there _is_ more
> > data, but the service period has to end nonetheless, say because it was
> > limited to a few packets? Nothing here seems to indicate that an MPSP
> > ends only after all queued packets are transmitted, which would be a
> > requirement if this was supposed to be correct.
> 
> MPSPs themselves are not defined in length by the standard.
> My current mechanism always sends all packets that are buffered at the 
> start of the MPSP. At the time the MPSP starts, the last 
> to-be-transmitted frame is the last buffered frame.
> Of course, by the time the MPSP ends, new frames may have been buffered 
> in the meantime, which are not taken into account here. That would 
> require additional feedback from ieee80211_tx_status which always seems 
> a bit racy to me.
> (In an earlier version I had something like a feedback loop with 
> ieee80211_tx_status, where the 'last' frame of a MPSP would always 
> trigger a re-check of the PS buffers. That allowed to have infinite 
> length MPSPs as long as data is enqueued for transmission. But that 
> seemed to be overly complex when something like dynamic PS state 
> switching is possible and advised by the standard.)
> 
> But I see one situation where the More Data flag is indeed not set 
> correctly. That is the case where I only send a single frame to a PS STA 
> in a non-MPSP context when no peering is established yet. I'll fix that.

Hmm, ok. I don't really follow all of that, but hey :)

> > Well, not really, but non-QoS frames won't happen in that case, because
> > the peer will have QoS enabled. Similarly here I think, why would there
> > ever be a non-QoS frame? But maybe this can happen with forwarding,
> > which can't happen in the non-mesh case.
> 
> For mesh also the HWMP routing (Management) frames are transmitted in 
> MPSPs. So a valid PSP would look like that:
> 1) QoS Null (RSPI:EOSP 0:0)
> 2) Mgmt frame (e.g. HWMP Path Reply)
> 3) QoS Null (RSPI:EOSP 0:1)
> here the additional trailing Null is needed to end the MPSP. That 
> scenario happens regularly when no path has been set up previously.

I assume the packet flow is
1 ->
  <- 2
  <- 3

correct? But in any case, I hadn't considered management frames.
Actually, those can be bufferable too without mesh, so that might be
buggy here right now, not sure they can be released with uAPSD.

> >> Absolutely correct. The PSP mechanism is just very similar to uAPSD,
> >> though. So once the PSP is set up, the mechanisms are the same actually.
> >> What do you advise? Renaming the release reason? Creating a different
> >> one that is handled equally?
> >
> > Well so far the more-data bit seems to be handled different, although I
> > argue above that you're actually not doing that correctly ;-)
> >
> > But I think doing different reasons could be helpful, if only to
> > understand the code better.
> 
> In the last iteration of my RFC I created an own function similar to 
> ieee80211_sta_ps_deliver_response. That spares adding even more 
> complexity to ieee80211_sta_ps_deliver_response and allows me to keep 
> the mesh PA code separated in mesh_ps.c. I don't seem to need the 
> release reason then.

Ok. Not for the driver maybe, if that has to release buffered frames,
say with aggregation? But I don't know.

johannes

