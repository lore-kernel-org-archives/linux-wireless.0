Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40986 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab1IVNyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 09:54:46 -0400
Message-ID: <4E7B3E19.2020001@openwrt.org> (sfid-20110922_155449_947791_4CD45CC3)
Date: Thu, 22 Sep 2011 07:54:33 -0600
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vivek Natarajan <vivek.natraj@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH 09/12] ath9k: optimize ath9k_ps_restore
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org> <1316028267-34187-2-git-send-email-nbd@openwrt.org> <1316028267-34187-3-git-send-email-nbd@openwrt.org> <1316028267-34187-4-git-send-email-nbd@openwrt.org> <1316028267-34187-5-git-send-email-nbd@openwrt.org> <1316028267-34187-6-git-send-email-nbd@openwrt.org> <1316028267-34187-7-git-send-email-nbd@openwrt.org> <1316028267-34187-8-git-send-email-nbd@openwrt.org> <1316028267-34187-9-git-send-email-nbd@openwrt.org> <CAJqpcCQ9gpKG1ivvDReSyvMq9i5kxwDmRZwvNbYfRhwByOOC4w@mail.gmail.com>
In-Reply-To: <CAJqpcCQ9gpKG1ivvDReSyvMq9i5kxwDmRZwvNbYfRhwByOOC4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-21 11:49 PM, Vivek Natarajan wrote:
> On Thu, Sep 15, 2011 at 12:54 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  ath_hw_cycle_counters_update only needs to be called if the power state
>>  changes. Most of the time this does not happen, even when ps_usecount
>>  goes down to 0.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>    drivers/net/wireless/ath/ath9k/main.c |   17 +++++++++++------
>>    1 files changed, 11 insertions(+), 6 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>  index a75810a..a16f539 100644
>>  --- a/drivers/net/wireless/ath/ath9k/main.c
>>  +++ b/drivers/net/wireless/ath/ath9k/main.c
>>  @@ -111,24 +111,29 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
>>    void ath9k_ps_restore(struct ath_softc *sc)
>>    {
>>          struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>>  +       enum ath9k_power_mode mode;
>>          unsigned long flags;
>>
>>          spin_lock_irqsave(&sc->sc_pm_lock, flags);
>>          if (--sc->ps_usecount != 0)
>>                  goto unlock;
>>
>>  -       spin_lock(&common->cc_lock);
>>  -       ath_hw_cycle_counters_update(common);
>>  -       spin_unlock(&common->cc_lock);
>>  -
>>          if (sc->ps_idle)
>>  -               ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
>>  +               mode = ATH9K_PM_FULL_SLEEP;
>>          else if (sc->ps_enabled&&
>>                   !(sc->ps_flags&  (PS_WAIT_FOR_BEACON |
>>                                PS_WAIT_FOR_CAB |
>>                                PS_WAIT_FOR_PSPOLL_DATA |
>>                                PS_WAIT_FOR_TX_ACK)))
>>  -               ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
>>  +               mode = ATH9K_PM_NETWORK_SLEEP;
>
> What is the use of setting the mode above if you use NETWORK_SLEEP by
> default in the below code.
Yes, I forgot to change it in the call below. I'll send a fix ASAP.

>>  +       else
>>  +               goto unlock;
>>  +
>>  +       spin_lock(&common->cc_lock);
>>  +       ath_hw_cycle_counters_update(common);
>>  +       spin_unlock(&common->cc_lock);
>>  +
>>  +       ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
>
> huh???
>
> It shows this patch was never tested and please clarify what you tried
> to achieve with this patch. Do you ever test a patch before sending it
> upstream?
>
> There is no wonder Johannes reports that power save is completely
> broken with ath9k if we have patches like these. We have better work
> to concentrate on, than to fix the regression your patch introduces
> every time.
>
> Please fix this and __test__ properly.
I did test this patch, and while it clearly has a bug (always setting 
network sleep instead of full sleep), I don't think this would break 
powersave. The only consequence I can think of is more battery drain 
when the card is idle and not connected.

What this patch achieves is this: ath9k_ps_restore is called frequently 
from functions handling the data path, also setting ps_usecount to 0 
frequently. That caused excessive calls to ath_hw_cycle_counters_update 
vasting a noticeable amount of CPU cycles (showed up during profiling).
My patch changes the code to only call ath_hw_cycle_counters_update 
before the card's power state changes.

- Felix
