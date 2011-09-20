Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39532 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1ITN22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 09:28:28 -0400
Received: by wyg34 with SMTP id 34so498066wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 06:28:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNxxRY4FvrrbDnuXd0PYPxfJpt6Q4rSdOw3WdofYQvJeYw@mail.gmail.com>
References: <20110919160124.GA3218@makis.lan>
	<CAD2nsn0+hMHBLW_5mtJwxfu37_f3aw-8a7Y2tCkh-btVpcfYPQ@mail.gmail.com>
	<CAFtRNNxxRY4FvrrbDnuXd0PYPxfJpt6Q4rSdOw3WdofYQvJeYw@mail.gmail.com>
Date: Tue, 20 Sep 2011 18:58:26 +0530
Message-ID: <CAD2nsn0LYatQ9CPOJ6ZF028ePojYwd0ts_4+jd+G98G3Ozf_Tg@mail.gmail.com> (sfid-20110920_152834_344399_38155AED)
Subject: Re: [RFT][PATCH] ath5k: Add rfkill_disable module parameter
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 4:42 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2011/9/20 Mohammed Shafi <shafi.wireless@gmail.com>:
>> Hi Nick,
>>
>> On Mon, Sep 19, 2011 at 9:31 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>>> Add a module parameter to disable hw rf kill (GPIO interrupt) because in some cases when the card doesn't come with the laptop, EEPROM configuration
>>> doesn't match laptop's configuration and rf kill interrupt always fires up and disables hw. I thought of moving this to debugfs and make it per-card
>>
>> i think this seems to happen with a card that comes with laptop.
>> AR5212802.11abg NIC (rev 01) in the lenovo T61
>>
>> i just cannot bring up the card again once i toggle the rfkill switch
>> (unblock -> block -> unblock)
>> the card is still hard blocked.
>>
>> quickly, i just commented out those function calls(same as your patch)
>>  in compat-wireless
>> ath5k_rfkill_hw_start(ah);
>> ath5k_rfkill_stop(ah);
>> as expected the problem disappears, but i can unblock the card via
>> soft-rfkill even when it is hard blocked.
>> is it ok to unblock via software unblock when the card is
>> hard-blocked?. please share your thoughts. meanwhile i will start
>> comparing ath5k and ath9k for this. thanks!
>>
>
> Soft-blocked -> The rfkill subsystem indicates the card is blocked by
> the system so cfg80211 doesn't allow you to bring it up and notifies
> the driver to do any additional steps to reduce power consumption (eg.
> unload firmware or sending some firmware commands etc).
>
> Hard-blocked -> The hardware/driver indicates that hw is on a
> power-save state on it's own -probably due to an rfkill switch
> connected directly to the card- and can't be used until this state
> changes, so the rf-kill subsystem marks it as "hard blocked" and
> cfg80211 brings it down and doesn't allow you to bring it up. In some
> cards this can also be related to internal firmware operations so the
> driver can't directly switch state -can't bypass the firmware block-
> (I haven't seen such card but that's the theory).
>
> In our case there is no such thing, when the rfkill switch changes
> state, the card just generates an interrupt and lets driver do the
> rest which means bringing the interface down (almost the same as
> power-off) and marking the interface as "hard blocked" on the rf-kill
> subsystem (through cfg80211), so "hard blocked" and "soft blocked" are
> the same in our case -> bring the interface down.

Nick, thanks a lot for taking time and explaining about rfkill, it
implementation completely.
just now tested with an on-board ath9k laptop and it seems to work fine.
the drv_rfkill_poll(which is polled for every 5s from cfg80211)
callback returns the proper value when the hardware rfkill is toggled.
looks like the gpio pins are properly matched with the system.

>
> What this patch disables is the interrupt generation because some
> laptops don't implement this correctly, they have the switch plugged
> on a different pin than the one indicated on the EEPROM or they don't
> use that approach at all and are based on BIOS/acpi or other switches
> (we 've even seen a switch that turns off the whole pci-e bus :P) +
> some cards that don't come with the laptop don't match laptop's
> configuration (different pin/polarity or again no hw switch at all).

>
> MadWiFi had a module parameter that did the same and I think even
> windows driver has a parameter for this, it makes sense to have a way
> to disable rfkill interrupt generation.
>
> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
>



-- 
shafi
