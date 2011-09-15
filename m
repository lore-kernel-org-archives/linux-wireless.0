Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43967 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1IOHUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 03:20:16 -0400
Message-ID: <4E71A71F.60306@openwrt.org> (sfid-20110915_092020_110198_222F9454)
Date: Thu, 15 Sep 2011 09:19:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 1/3] ath9k: fix enabling interrupts after a hardware error
 interrupt
References: <1316028183-33734-1-git-send-email-nbd@openwrt.org> <CAD2nsn2G645x00RCLpk7xvT8iBxr+RGN=mdCVAN9jkjKNh7M7Q@mail.gmail.com>
In-Reply-To: <CAD2nsn2G645x00RCLpk7xvT8iBxr+RGN=mdCVAN9jkjKNh7M7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-15 9:14 AM, Mohammed Shafi wrote:
> Hi Felix,
>
> On Thu, Sep 15, 2011 at 12:53 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  The interrupt handler increases the interrupt disable refcount, so the
>>  tasklet needs to always call ath9k_hw_enable_interrupts.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>    drivers/net/wireless/ath/ath9k/main.c |    9 +++++----
>>    1 files changed, 5 insertions(+), 4 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>  index 8a17cff5..a3c3316 100644
>>  --- a/drivers/net/wireless/ath/ath9k/main.c
>>  +++ b/drivers/net/wireless/ath/ath9k/main.c
>>  @@ -669,15 +669,15 @@ void ath9k_tasklet(unsigned long data)
>>          u32 status = sc->intrstatus;
>>          u32 rxmask;
>>
>>  +       ath9k_ps_wakeup(sc);
>
> this is done in ath_reset, is there any corner cases that I had missed ?
>
>>  +       spin_lock(&sc->sc_pcu_lock);
>
> spin_lock_bh(&sc->sc_pcu_lock) in ath_reset_internal, won't be a
> problem know, or should we need to move this lock
>
>>  +
>>          if ((status&  ATH9K_INT_FATAL) ||
>>              (status&  ATH9K_INT_BB_WATCHDOG)) {
>>                  ieee80211_queue_work(sc->hw,&sc->hw_reset_work);
>>  -               return;
>>  +               goto out;
>>          }
>>
>>  -       ath9k_ps_wakeup(sc);
>>  -       spin_lock(&sc->sc_pcu_lock);
>>  -
>>          /*
>>           * Only run the baseband hang check if beacons stop working in AP or
>>           * IBSS mode, because it has a high false positive rate. For station
>>  @@ -725,6 +725,7 @@ void ath9k_tasklet(unsigned long data)
>>                  if (status&  ATH9K_INT_GENTIMER)
>>                          ath_gen_timer_isr(sc->sc_ah);
>>
>>  +out:
>>          /* re-enable hardware interrupt */
>>          ath9k_hw_enable_interrupts(ah);
>
>
> this is done in ath_complete_reset, should we enable interrupts if
> some times ath9k_hw_reset fails?
> please correct me if I had understood wrongly. thanks!
ath9k_hw_enable_interrupts was changed to use refcounting to keep 
interrupts blocked. The interrupt handler increses the refcount, so the 
tasklet needs to decrease it. When a reset is issued, it starts by 
disabling interrupts, then re-enables them after completing the reset.
Disabling interrupts in the ISR, but not enabling them in the tasklet 
causes an imbalance which leaves interrupts disabled after the reset is 
done.

- Felix
