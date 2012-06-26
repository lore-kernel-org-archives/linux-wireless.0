Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab2FZM4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:56:04 -0400
Message-ID: <1340715352.14634.17.camel@jlt3.sipsolutions.net> (sfid-20120626_145621_645934_6540E7F9)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 14:55:52 +0200
In-Reply-To: <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com> (sfid-20120626_131846_817319_4144240C)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 <1340707305.14634.9.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
	 (sfid-20120626_131846_817319_4144240C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 14:18 +0300, Eliad Peller wrote:

> > Yes, we should keep that in mind, but I have a feeling that we should
> > treat it separately. It's quite different as mac80211 is doing a lot
> > less -- for example, mac80211 is managing retries, comeback timeouts,
> > etc. in the managed case.
> >
> i guess it makes sense. i just don't like it being managed in multiple
> places (userspace for ap, kernel for sta).

I don't really understand why? We already manage managed/AP *very*
differently, this just extends that. We'll never unify them, and trying
to unify small bits of it seems bad to me.

> > I'm pretty much happy with that for the AP case, but given how much
> > mac80211 really manages for auth/assoc I don't think it makes sense in
> > the managed case.
> >
> i think that's true for open networks, but for encrypted ones the
> EAPOLs are not handled by mac80211, which pretty much complicates the
> flow.

Yeah, but I think the only thing you could possibly do in the EAPOL case
is reserve some time right after association, before you go into PS.
Either it completes quickly (including DHCP maybe even!) or you have
quite a bit of latency anyway and will need to go into PS again before
it all completes.


> >> also, when waiting for EAPOLs after association you might have to
> >> reserve the channel for a pretty long time anyway (since you still
> >> can't enter ps, and some APs don't send the first EAPOL immediately).
> >
> > Yeah, but you might only want to wait a little bit and then stop doing
> > ROC and actually enter PS mode if the AP is really slow, etc. That can
> > pretty much be managed from the STA state though since once you're
> > associated you're past the bit where mac80211 is doing a lot?
> >
> you can't enter ps while you are not authorized (it's probably not
> forbidden by the spec, but i'm pretty sure some APs won't like it).

You'll have to enter PS after you associate but before you're authorized
if the AP is slow enough. If the AP is fast, then you don't want to
because it'll increase the connection latency significantly.

> managing it from the STA state doesn't make much sense to me (why add
> another management point?), and if you're going to handle it from
> userspace, well... just do it from the beginning :)

That's what I'm saying though -- I don't think you can manage this from
userspace, not authentication/association anyway. And if you really want
to delay going into PS (keep in mind multi-vif/multi-channel!) until
after authorization, you already can since you're told when
authorization finishes.

johannes

