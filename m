Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaAVKUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:20:03 -0500
Message-ID: <1390385995.4334.27.camel@jlt4.sipsolutions.net> (sfid-20140122_112008_041302_9664E87D)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 22 Jan 2014 11:19:55 +0100
In-Reply-To: <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com> (sfid-20140122_111301_086907_C6814DB8)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 (sfid-20140122_111301_086907_C6814DB8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 11:13 +0100, Michal Kazior wrote:

> > That seems pretty much fine, though I was talking to Luca yesterday and
> > there is actually a case where a CSA chanctx should be usable later, for
> > example if you have this:
> >  * managed mode interface receives a channel switch announcements and
> > acts on it
> >  * it also sends an event to userspace (this is a TODO but we're on it)
> >  * wpa_s decides that a concurrent GO should also switch
> 
> Hmm. This sounds interesting. But it makes me wonder..
> 
> If STA iface receives CSA it starts it right away? It doesn't care if
> other interfaces are using a given channel context too? It just
> assumes other intefaces may actively request channel switch and if
> they do, the CSA will be 'aggregated/merged'?

Well, in Luca's implementation a new channel context has to be
available. In the current implementation, it will simply disconnect if
using chanctx, or if there's any other interface using the channel (I
believe)

> What about cfg80211 intf combinations? If GO sends a channel switch it
> will fail on num_available_channels unless you implicitly consider the
> userspace event you mentioned or export CSA state down to cfg80211.

Yeah, that's a good point, need to consider that.

> At one point I was wondering if channel contexts should be actually
> exposed in cfg80211. It would probably make it easier to coordinate
> some CSA scenarios like this in a sane way, don't you think? But then
> again that's quite big of a change.

Yeah that'd be a bit of a change, but maybe it's worth it? Not sure.

johannes

