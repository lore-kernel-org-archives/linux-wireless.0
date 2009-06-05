Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([207.115.11.56]:49055 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZFEWiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 18:38:15 -0400
Message-ID: <4A299E57.4020007@lwfinger.net>
Date: Fri, 05 Jun 2009 17:38:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net> <200906052101.47168.mb@bu3sch.de> <4A298C37.9030503@lwfinger.net> <200906052338.05653.mb@bu3sch.de>
In-Reply-To: <200906052338.05653.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Friday 05 June 2009 23:20:55 Larry Finger wrote:
>> That is what the driver already does.
> 
> No. If the device is down, then it _is_ down. There won't be an rfkill thing
> trying to bring it up again although the interface is down.

But in the current driver, turning the radio switch off only shuts
down the radio. The rest of the interface is still up.

>>> We can't we just accept that the RF-kill status is unknown while the device is down?
>> The problem is that while the interface is down the switch status
>> cannot be interrogated. If you try, you get a fatal SSB error. Thus
>> the only way to bring it back up is to flip the switch, then
>> rmmod/insmod the driver. If you want hardware rfkill to be one-way,
>> then take Johannes's patch. We would save a little power by calling
>> b43_wireless_exit() if we brought it up to test the switch, and the
>> switch was still off. That would leave everything off most of the time.
> 
> Yeah well. We cannot read the rfkill status while the device is down. That is
> a hardware limitation. I think we should _live_ with that limitation instead of
> working around it by always keeping the device initialized.
> Can't we teach the rfkill subsystem about an "unknown" state? Because that's what we're in.

An "unknown" state would be OK, but I don't know how to get the state
of the switch to the rfkill system.

> Yeah. But wasting huge amounts of power to keep polling a bit that's not even used
> most of the time is not really what I like.


> +void b43_rfkill_poll(struct ieee80211_hw *hw)
>  {
> -       struct b43_wldev *dev = data;
> -       struct b43_wl *wl = dev->wl;
> +       struct b43_wl *wl = hw_to_b43_wl(hw);
> +       struct b43_wldev *dev = wl->current_dev;
>         bool enabled;
>  
>         mutex_lock(&wl->mutex);
>         if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
> -               mutex_unlock(&wl->mutex);
> -               return;
> +               if (b43_wireless_core_init(dev)) {
> +                       mutex_unlock(&wl->mutex);
> +                       return;
> +               }
>         }
> 
> This is the part of the code which I really really really dislike.
> Hell, just return a freaking error from b43_rfkill_poll(), if the interface
> is down. If rfkill can't handle that, it should probably be taught to handle it.
> Especially as there can be other errors as well, like memory allocation failures.

I understand that this is the part that you do not like. I don't like
it either, but unless we can read the switch-state bit, the interface
will never come back up. I do not find rmmod/insmod a suitable
recovery mechanism.

>> 2. We continue to use the old rfkill mechanism. It works just fine,
>> but this method runs the risk of the old method being deprecated and
>> eliminated.
> 
> I agree that this is not really an option.
> 
>> 3. We get new callbacks that will only power down/up the radio when it
>> is blocked. That saves a little power.
> 
> What is wrong with the current mechanism to power up the radio, if the interface is up
> and powering it down if the interface is down? I think the power of the PHY/Radio should
> not be affected by rfkill. It should work the other way around instead. Rfkill should
> be tolerant to a radio that is down and simply live with an unknown switch state.

I don't know what was intended in the new rfkill method. Remember, I
don't read those E-mails either, but what I observe is that cfg80211
calls the stop callback when the switch goes from on to off, but the
start callback is not called when the off to on transition occurs.
That may be a bug - I don't know. Johannes, is there a simple
explanation as to why the start routine is not called? If that were to
happen, the rfkill poll routine would happily exit immediately if the
interface were down.

I think rfkill should just be a means of letting drivers know that the
user wants the radio off, either by turning off a switch, or by
setting some software flag from userland, and the driver should honor
those wishes.

Larry

