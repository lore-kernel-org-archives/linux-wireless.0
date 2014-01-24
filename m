Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaAXIko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 03:40:44 -0500
Message-ID: <1390552837.4257.33.camel@jlt4.sipsolutions.net> (sfid-20140124_094048_069742_CC317F47)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Fri, 24 Jan 2014 09:40:37 +0100
In-Reply-To: <1390549306.19968.6.camel@porter.coelho.fi>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
	 <1390403432.4334.33.camel@jlt4.sipsolutions.net>
	 <1390403634.4189.39.camel@porter.coelho.fi>
	 <CA+BoTQ=+TGFo0f0z1SymiN5DkeLZUPC_p_YVZ59s=FFqpGV3vQ@mail.gmail.com>
	 <1390458664.4189.48.camel@porter.coelho.fi>
	 <CA+BoTQnyd5HQxU9n=7G8bhJTukMJqZwNmD1FgWowHm2LJ=NUsA@mail.gmail.com>
	 <1390462306.4189.56.camel@porter.coelho.fi>
	 <CA+BoTQn-wjQYfUVxJU+xOUoANKE=8ajmq=ytmzAqVuiqMXJj=w@mail.gmail.com>
	 <1390470648.4189.88.camel@porter.coelho.fi>
	 <CA+BoTQm768pE7w1x9p5dN+qTxYjzf8R5u4WASd4zEaQ=v717BQ@mail.gmail.com>
	 <1390479620.4142.14.camel@jlt4.sipsolutions.net>
	 <CA+BoTQkd6XLYpJPAb-HLosbmT3duVCdpEStpxNCcHCGTx9djzw@mail.gmail.com>
	 <1390549306.19968.6.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 09:41 +0200, Luca Coelho wrote:

> Yeah, I agree that updating the IEs in mac80211 is not a good idea.
> That's why I would prefer to have the notifications to the user space
> ("your interface must switch channel") and wait for the userspace to
> request a channel switch (with all the necessary information).

Even in the sentence "your interface must switch channel" you're
conflating multiple things though. Consider a managed+AP interface being
concurrent, with the managed one receiving CSA from its BSS.

 1) maybe it's a radar channel, and the AP detected radar, then we must
switch
    (to make authorities happy); but in this case we should have
detected radar
    as well on the AP we're running...
 2) maybe it's a non-radar 5 GHz channel, and the device (like iwlwifi)
only
    permitted beaconing on 5 GHz as long as connected to another AP,
then we
    also must switch (to make the device happy)
 3) maybe it's neither, or the device is allowed to use non-radar
channels for
    AP/GO operation, but the AP we're connected to just decided to
switch for
    other implementation-specific reasons, e.g. wanting to use a better
channel,
    *AND* we don't have enough channel contexts to stay, so we "must"
switch

The same cases exist if, like you suggested, we'd make such a
notification when one AP interface starts to switch. I'm still mostly
against that though.

"[Y]our interface must switch channel" is therefore not very well
defined, and I'd hate to see a client interface CSA-started notification
interpreted as such; you can see that there's at least one sub-case
where other interfaces don't have to switch.

It sounds to me like you're still hung up on the whole "ohh, what if
there's wpa_s and hostapd running" thing ... I really don't think it's a
concern. I'd be rather surprised if this was the only thing that'd break
then.


The question also is whether we want to handle all the corner cases.
Consider this corner case:
 * non-chanctx driver
 * running at least one AP/GO
 * running one station interface connected to BSS1
 * BSS1 decides to do a CSA

Even today, we'll try to execute the channel switch, even though that
completely leaves the AP/GO interface dead in the water and beaconing
wrongly. That's something we should probably address. The question is
how we should address it. It seems to me that you actually want to
handle that case by asking wpa_s to switch the AP/GO interface, but I'm
not really sure it's necessary? The question also is how to handle it if
wpa_s doesn't respond (e.g. old wpa_s version that has no idea what's
going on) - which interface should "lose"?

IMHO we don't have to design it to handle all these quirky corner cases.
This particular case might be something we want to handle for case 2)
above, but who actually cares? The only driver that is looking at case 2
is ours, and that has channel contexts, so we don't really have to
handle it with non-chanctx.

It's obvious that we need a "CSA started" notification for managed mode
interfaces. It's not clear to me that we need it for AP interfaces,
since handling multiple AP interfaces with different hostapd instances
is stupid to start with, and IMHO this makes the situation more complex.

Let's enumerate all the corner cases. Let me know if I missed some.

 1. chanctx drivers
   a) managed mode CSA received with other interfaces present, but no
available
      channel context(s)
   b) AP CSA requested by userspace with other interfaces present, but
no
      available channel context(s)
   c) (mesh CSA has similar cases, I believe)
   d) (IBSS CSA has similar cases for drivers that allow IBSS/other
combinations)
 2. non-chanctx drivers
   a) managed mode CSA received with other interfaces present
   b) AP CSA requested by userspace with other interfaces present
   c) (mesh)
   d) (IBSS)

(Is that all?)

Those cases are (mostly) identical if we treat non-chanctx drivers as
having exactly one channel context.

I can't really speak for cases c) and d), but would think handling them
like the others would make sense. I'd also leave the question of
regulatory compliance out of the CSA mechanism entirely. If we discuss
the CSA case 2) at the beginning of this email, for example, then we
could argue that we should require the CSA or whatever. I say that we
should enforce the regulatory stuff after the fact, and stop the AP
interface if the managed one is gone for a while/too long from that
channel. That can be enforced in cfg80211 fairly easily.

With that then, I'd suggest that in case a), the managed mode interface
just disconnects, as it does today. There would be a possibility that we
could send the "I need to do CSA" event to userspace so it could
simultaneously switch the AP to the same channel, but I'm not convinced
it's worth it.

In case b), I'd say that the CSA should be refused. If needed,
wpa_supplicant could have disconnected the managed interfaces (it knows
about possible channel combinations), otherwise this will fail and it
needs to be prepared for failures anyway (and will likely shut down the
GO in that case.) This does, however, imply that we need multi-AP
switching like Michał implemented. I don't really see how else to do it,
because if you want to keep this as multiple single-interface switches
you (i) can't enforce the switch time and (ii) have to add complex code
to handle the case where userspace 'forgets' to switch one of the many
interfaces.

IMHO the complexity of multi-switch is less than for trying to handle
that (ii) case and similar corner cases.

johannes

