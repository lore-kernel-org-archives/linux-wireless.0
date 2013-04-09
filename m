Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3DIUmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 16:42:38 -0400
Message-ID: <1365540154.8465.51.camel@jlt4.sipsolutions.net> (sfid-20130409_224242_541781_C2D23321)
Subject: Re: [PATCH] cfg80211: introduce critical protocol indication from
 user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 09 Apr 2013 22:42:34 +0200
In-Reply-To: <516471FC.6000209@broadcom.com>
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
	 <1365501997.8465.23.camel@jlt4.sipsolutions.net>
	 <516471FC.6000209@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-09 at 21:54 +0200, Arend van Spriel wrote:

> I should at least try :-) The given protocol can help the driver decide 
> what actions should be taken. As an example, for a streaming protocol 
> like Miracast [1] other wireless parameters/features may be changed as 
> for DHCP.

Ok? I guess I don't really see what you'd do differently, but hey, what
do I know :)

> >> + * @NL80211_CRIT_PROTO_UNSPEC: protocol unspecified.
> >> + * @NL80211_CRIT_PROTO_BOOTP: BOOTP protocol.
> >> + * @NL80211_CRIT_PROTO_EAPOL: EAPOL protocol.
> >> + * @NL80211_CRIT_PROTO_ARP: ARP protocol for APIPA.
> >
> > Don't like IPv6? :-)
> 
> I am a dark-ages guy :-p I think I will rename the BOOTP one and 
> indicate it should be used for BOOTP and DHCPv6.

Might also be worth it to rename ARP to APIPA since ARP is ... well
often done :-)

> >> @@ -648,6 +648,9 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
> >>
> >>   	spin_unlock_bh(&wdev->mgmt_registrations_lock);
> >>
> >> +	if (rdev->ops->crit_proto_stop)
> >> +		rdev_crit_proto_stop(rdev, wdev);
> >
> > This is broken, you're not checking that it's the correct socket.
> > Therefore, if you run, for example, "iw wlan0 link" while the critical
> > operation is ongoing it will be aborted.
> 
> I was wondering about that. Will change it checking nlportid, right?

Well you have to store the nlportid (rather than crit_proto_started) and
then check it.

> >> +	duration = min_t(u16, duration, NL80211_MAX_CRIT_PROT_DURATION);
> >
> > Why not reject it if too large (although then the max should be defined
> > in the header file)? Is there a reason, like maybe wanting to be able to
> > increase the kernel value later? If so, might want to have a comment?
> 
> There were people in earlier discussions that considered a timeguard 
> appropriate, ie. not trusting user-space. I do not have a strong opinion 
> on this so....

I'm not really arguing there shouldn't be any limit, but I guess I'm not
sure why it should be limited rather than refusing anything above the
limit? Maybe it'd be worthwhile to advertise the limit instead and then
just take it?

It really doesn't matter all that much though ... mostly I'm curious
whether any design thought went into this :-)

> >> +	rdev_crit_proto_stop(rdev, wdev);
> >
> > What if it's not even started?
> 
> That is handled in rdev_crit_proto_stop() itself.

Oh, I see. In a way I guess that makes sense, but should this not return
an error? Also, I'd like the rdev_* inlines to not actually have such
logic, I tend to simply ignore them when reading ...

Or maybe just give that another name / put it elsewhere? Maybe even give
it a return value then to refuse stopping crit proto when it's not
started?

> > Do you expect drivers to call this function even when explicitly asked
> > to stop? That should be documented then, I think.
> 
> No, I don't and I will add that in documentation.

I was going to say this is broken then ... but that's again only because
the wrapper sets started=false. See what you did there? I totally
ignored the rdev_*() wrapper code :)

johannes

