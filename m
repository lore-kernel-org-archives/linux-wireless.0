Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37724 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZFEViQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 17:38:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
Date: Fri, 5 Jun 2009 23:38:05 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net> <200906052101.47168.mb@bu3sch.de> <4A298C37.9030503@lwfinger.net>
In-Reply-To: <4A298C37.9030503@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200906052338.05653.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 June 2009 23:20:55 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > This is pretty silly behavior IMO. Just to bring it to the point:
> > We initialize a huge wireless MAC, PHY and Radio that consume several watts of power
> > just to poll a silly RF-kill bit.
> 
> That is what the driver already does.

No. If the device is down, then it _is_ down. There won't be an rfkill thing
trying to bring it up again although the interface is down.

> > We can't we just accept that the RF-kill status is unknown while the device is down?
> 
> The problem is that while the interface is down the switch status
> cannot be interrogated. If you try, you get a fatal SSB error. Thus
> the only way to bring it back up is to flip the switch, then
> rmmod/insmod the driver. If you want hardware rfkill to be one-way,
> then take Johannes's patch. We would save a little power by calling
> b43_wireless_exit() if we brought it up to test the switch, and the
> switch was still off. That would leave everything off most of the time.

Yeah well. We cannot read the rfkill status while the device is down. That is
a hardware limitation. I think we should _live_ with that limitation instead of
working around it by always keeping the device initialized.
Can't we teach the rfkill subsystem about an "unknown" state? Because that's what we're in.

> > I really do hate all that rfkill crap and I'm still refusing to sign off on anything that's
> > related to rfkill (like I did for the past year or so). If people want this merged,
> > somebody else maintain and sign it off, please.
> 
> I'm sick of rfkill as well and really detest the endless discussions
> that have taken place; however, I do want the stuff to work.

Yeah. But wasting huge amounts of power to keep polling a bit that's not even used
most of the time is not really what I like.

> 1. We switch to the cfg80211 rfkill and use this patch modified to
> turn the interface back off if the switch is still off.

+void b43_rfkill_poll(struct ieee80211_hw *hw)
 {
-       struct b43_wldev *dev = data;
-       struct b43_wl *wl = dev->wl;
+       struct b43_wl *wl = hw_to_b43_wl(hw);
+       struct b43_wldev *dev = wl->current_dev;
        bool enabled;
 
        mutex_lock(&wl->mutex);
        if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
-               mutex_unlock(&wl->mutex);
-               return;
+               if (b43_wireless_core_init(dev)) {
+                       mutex_unlock(&wl->mutex);
+                       return;
+               }
        }

This is the part of the code which I really really really dislike.
Hell, just return a freaking error from b43_rfkill_poll(), if the interface
is down. If rfkill can't handle that, it should probably be taught to handle it.
Especially as there can be other errors as well, like memory allocation failures.

> 2. We continue to use the old rfkill mechanism. It works just fine,
> but this method runs the risk of the old method being deprecated and
> eliminated.

I agree that this is not really an option.

> 3. We get new callbacks that will only power down/up the radio when it
> is blocked. That saves a little power.

What is wrong with the current mechanism to power up the radio, if the interface is up
and powering it down if the interface is down? I think the power of the PHY/Radio should
not be affected by rfkill. It should work the other way around instead. Rfkill should
be tolerant to a radio that is down and simply live with an unknown switch state.

-- 
Greetings, Michael.
