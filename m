Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2KZKpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:45:24 -0500
Message-ID: <1353926751.9488.19.camel@jlt4.sipsolutions.net> (sfid-20121126_114527_404136_768F5A27)
Subject: Re: [RFC 14/14] mac80211: mesh PS individually-addressed frame
 release
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:45:51 +0100
In-Reply-To: <50ABC7D0.2030303@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	  <1353134886-13256-15-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353145246.9543.39.camel@jlt4.sipsolutions.net>
	 <50ABC7D0.2030303@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 10:11 -0800, Marco Porsch wrote:

> > This is ... strange? Can a single station really own *two* num_psp
> > refcounts?
> 
> Yes it can. A station can be both owner and recipient. And it would just 
> be overhead to distinguish between num_psp_owner and num_psp_recipient, 
> when in the end we only want to know if there is  any PSP ongoing at all.
> 
> I'll change the comment to:
> 	/* number of active PSPs (owner and recipient counted independently) */
> 	atomic_t num_psp;

Ok.

> >> +	nullfunc = (struct ieee80211_hdr *) skb->data;
> >> +	if (!eosp)
> >> +		nullfunc->frame_control |=
> >> +				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
> >
> > This seems wrong -- EOSP and moredata are orthogonal (with the
> > restriction that "!EOSP => moredata") -- but if you just have that in
> > the code the moredata bit won't always be set correctly.
> 
> Imho, in the context of PSP trigger frames it does.
> Sending a trigger frame to a mesh PS STA with no EOSP implies the start 
> of a PSP with the sender as owner -> following data. The other two 
> combinations imply that there is no more data following in that direction.

The EOSP bit in a trigger frame should always be 0 unless the frame is
also a PSP response, no?

What you seem to be missing though is the case when there _is_ more
data, but the service period has to end nonetheless, say because it was
limited to a few packets? Nothing here seems to indicate that an MPSP
ends only after all queued packets are transmitted, which would be a
requirement if this was supposed to be correct.

(Btw, maybe it would be worthwhile to call all of this "MPSP" like the
spec, not just "PSP"?)

> But now that you mention it... is there any interest in having that 
> function used for uAPSD? Because ieee80211_sta_ps_deliver_response sets 
> the EOSP flag during uAPSD, but does not enforce a QoS Data frame to 
> carry it. But maybe uAPSD just permits transmitting anything else than 
> QoS Data frames...

Well, not really, but non-QoS frames won't happen in that case, because
the peer will have QoS enabled. Similarly here I think, why would there
ever be a non-QoS frame? But maybe this can happen with forwarding,
which can't happen in the non-mesh case.

> >
> >> +		ieee80211_sta_ps_deliver_response(sta, 1, 0,
> >> +				IEEE80211_FRAME_RELEASE_UAPSD);
> >
> > uAPSD?
> >
> > The standard *explicitly* states that ASPD is *not* supported in mesh.
> 
> Absolutely correct. The PSP mechanism is just very similar to uAPSD, 
> though. So once the PSP is set up, the mechanisms are the same actually. 
> What do you advise? Renaming the release reason? Creating a different 
> one that is handled equally?

Well so far the more-data bit seems to be handled different, although I
argue above that you're actually not doing that correctly ;-)

But I think doing different reasons could be helpful, if only to
understand the code better.

johannes

