Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50493 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab0KLTQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:16:25 -0500
Received: by qwi2 with SMTP id 2so100028qwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 11:16:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <12495562.1171289487502962.JavaMail.wlan@CHBU500181>
References: <5575430.811289486702581.JavaMail.wlan@CHBU500181>
	<12495562.1171289487502962.JavaMail.wlan@CHBU500181>
Date: Fri, 12 Nov 2010 14:16:24 -0500
Message-ID: <AANLkTinE7LE7OXOq+DrUQfwOAjckaV5A3JbGUSD3vp9h@mail.gmail.com>
Subject: Re: [PATCH 9/9] ath5k: AHB port. Fix reset and interrupts for AHB
 type of devices.
From: Bob Copeland <me@bobcopeland.com>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 9:58 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
> On WiSoc we cannot access mac register before it is resetted.
> Otherwise it will crash hardware.
>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c  |    7 ++-
>  drivers/net/wireless/ath/ath5k/reset.c |  113 ++++++++++++++++++++++++-------
>  2 files changed, 93 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 13d5da5..00ebb81 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2175,7 +2175,8 @@ ath5k_intr(int irq, void *dev_id)
>        unsigned int counter = 1000;
>
>        if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
> -                               !ath5k_hw_is_intr_pending(ah)))
> +               ((ath5k_get_bus_type(ah) != ATH_AHB) &&
> +                               !ath5k_hw_is_intr_pending(ah))))
>                return IRQ_NONE;
>

Hrm, we really don't want to sprinkle these special cases all around
the driver.  Perhaps it'd be better to make sure ATH_STAT_INVALID
isn't set until the soc is ready.  And, in other cases, using
capability bits or something?  Bus type seems a bit crude.

> @@ -2241,6 +2242,10 @@ ath5k_intr(int irq, void *dev_id)
>                                tasklet_schedule(&sc->rf_kill.toggleq);
>
>                }
> +
> +               if(ath5k_get_bus_type(ah) == ATH_AHB)
> +                       break;
> +
>        } while (ath5k_hw_is_intr_pending(ah) && --counter > 0);

Why?

>  static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
>  {
> -       int ret;
> +       int ret = 0;

In general, I dislike assigning ret until the last possible moment,
because leaving it unassigned sometimes catches errors like:

  int ret;

+ if (new_boolean_test)
+     goto out;

  ret = xyz();

  out:
      return ret;

In this particular case it doesn't matter that much, but the
early assignment shouldn't really be needed.


>
>        /*
>         * Reset configuration register (for hw byte-swap). Note that this
> @@ -334,6 +377,9 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
>        u32 bus_flags;
>        int ret;
>
> +       if(ath5k_get_bus_type(ah) == ATH_AHB)
> +               return 0;
> +
>        /* Make sure device is awake */
>        ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
>        if (ret) {
> @@ -390,22 +436,30 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>        mode = 0;
>        clock = 0;
>
> -       /* Wakeup the device */
> -       ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
> -       if (ret) {
> -               ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
> -               return ret;
> +       if(ath5k_get_bus_type(ah) == ATH_AHB && !initial){
> +               /* Wakeup the device */
> +               ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
> +               if (ret) {
> +                       ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
> +                       return ret;
> +               }
>        }
>
>        /*
>         * Put chipset on warm reset...
>         *
> -        * Note: putting PCI core on warm reset on PCI-E cards
> -        * results card to hang and always return 0xffff... so
> -        * we ingore that flag for PCI-E cards. On PCI cards
> -        * this flag gets cleared after 64 PCI clocks.
>         */
> -       bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
> +       if(ath5k_get_bus_type(ah) == ATH_AHB){
> +               /* Reset MAC on WiSoc devices */
> +               bus_flags = (initial) ? AR5K_RESET_CTL_MAC : 0;
> +       } else {
> +               /* Note: putting PCI core on warm reset on PCI-E cards
> +                * results card to hang and always return 0xffff... so
> +                * we ingore that flag for PCI-E cards. On PCI cards
> +                * this flag gets cleared after 64 PCI clocks.
> +                */
> +               bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;


Maybe ath5k_get_bus_flags or something here.


 +       }
>
>        if (ah->ah_version == AR5K_AR5210) {
>                ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
> @@ -536,6 +590,9 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
>        struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
>        u32 scal, spending, usec32;
>
> +       if(ath5k_get_bus_type(ah) == ATH_AHB)
> +               enable = false;
> +

Do you need this hunk?  We never enable the sleep clock for AP mode.

-- 
Bob Copeland %% www.bobcopeland.com
