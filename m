Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab2FZKlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 06:41:49 -0400
Message-ID: <1340707305.14634.9.camel@jlt3.sipsolutions.net> (sfid-20120626_124154_319847_B98F11DA)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 12:41:45 +0200
In-Reply-To: <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com> (sfid-20120626_120955_428711_576C264F)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 (sfid-20120626_120955_428711_576C264F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 13:09 +0300, Eliad Peller wrote:

> > With multi-channel, one problem that we get is managing the channel
> > timing for authentication/association. We'll have bound the channel
> > context (once we have that) before we even send a frame of course, but
> > setting up the timing as to when to use the channel is very hard, in
> > particular for connections to P2P GOs that might potentially be asleep.
> >
> the other scenario we should have in mind here is the AP side - making
> sure we'll be able to auth/assoc a new station.

Yes, we should keep that in mind, but I have a feeling that we should
treat it separately. It's quite different as mac80211 is doing a lot
less -- for example, mac80211 is managing retries, comeback timeouts,
etc. in the managed case.

> > 5) do remain-on-channel from mac80211, but this doesn't address P2P GO
> >   synchronisation requirements
> >
> what are the unfulfilled requirements here?

It would be a more special ROC because the driver would be expected to
only start it when the P2P GO is available. This isn't the case for any
other ROC, and my gut feeling is that requiring that in this special ROC
would "pollute" the ROC API and a lot of people would forget about it
etc.

> > I haven't been able to come up with any other ways, and here we really
> > don't have much of a choice -- #1 is the only thing that seems sane to
> > me. Thoughts?
> 
> our current approach is making the kernel part as simple as possible,
> and let userspace handle the channel management.
> before authentication (or after getting auth request in the ap case)
> the supplicant requests the kernel to "give priority" to a specific
> vif. it's up to the low-level driver to decide on the right way to do
> it (internally we implement it with ROC on the specified vif).

I'm pretty much happy with that for the AP case, but given how much
mac80211 really manages for auth/assoc I don't think it makes sense in
the managed case.

> the con here is that this might result in the channel being reserved
> for a pretty long time (retransmits, etc.), but that's why we refer it
> as setting "priority" rather than actual channel reservation. if the
> fw has to do other things (e.g. beacon on each beacon interval) it
> will do it, even though we asked it to ROC on a different channel.

That seems highly implementation-dependent :-)
The point with that though is that I think it shouldn't be necessary to
have a firmware implementation that does this.

> i think the "tx sync" (method 1) is good for sta mode, but it's less
> suitable for ap mode.

Totally agree.

> also, when waiting for EAPOLs after association you might have to
> reserve the channel for a pretty long time anyway (since you still
> can't enter ps, and some APs don't send the first EAPOL immediately).

Yeah, but you might only want to wait a little bit and then stop doing
ROC and actually enter PS mode if the AP is really slow, etc. That can
pretty much be managed from the STA state though since once you're
associated you're past the bit where mac80211 is doing a lot?

johannes

