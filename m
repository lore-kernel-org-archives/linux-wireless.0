Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:35055 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab0K2LUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 06:20:06 -0500
Date: Mon, 29 Nov 2010 12:19:59 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org
Message-ID: <7972330.161291029594275.JavaMail.wlan@CHBU500181>
In-Reply-To: <31403932.141291029281159.JavaMail.wlan@CHBU500181>
Subject: Re: [PATCH v6 9/9] ath5k: Fix reset and interrupts for AHB type of
 devices.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2010/11/26 Wojciech Dubowik <dubowoj@neratec.com>:
> > From: Felix Fietkau <nbd@openwrt.org>
> >
> > On WiSoc we cannot access mac register before it is resetted.
> > It will crash hardware otherwise.
> >
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> > ---
> >  drivers/net/wireless/ath/ath5k/base.c  |    7 ++-
> >  drivers/net/wireless/ath/ath5k/reset.c |  114
> ++++++++++++++++++++++++-------
> >  2 files changed, 94 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c
> > index 4d5ac71..87a4bb6 100644
> > --- a/drivers/net/wireless/ath/ath5k/base.c
> > +++ b/drivers/net/wireless/ath/ath5k/base.c
> > @@ -2169,7 +2169,8 @@ ath5k_intr(int irq, void *dev_id)
> >        unsigned int counter = 1000;
> >
> >        if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
> > -                               !ath5k_hw_is_intr_pending(ah)))
> > +               ((ath5k_get_bus_type(ah) != ATH_AHB) &&
> > +                               !ath5k_hw_is_intr_pending(ah))))
> >                return IRQ_NONE;
> >
> >        do {
> > @@ -2235,6 +2236,10 @@ ath5k_intr(int irq, void *dev_id)
> >                              
>  tasklet_schedule(&sc->rf_kill.toggleq);
> >
> >                }
> > +
> > +               if (ath5k_get_bus_type(ah) == ATH_AHB)
> > +                       break;
> > +
> >        } while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
> >
> >        if (unlikely(!counter))
> > diff --git a/drivers/net/wireless/ath/ath5k/reset.c
> b/drivers/net/wireless/ath/ath5k/reset.c
> > index 198a146..4f54655 100644
> > --- a/drivers/net/wireless/ath/ath5k/reset.c
> > +++ b/drivers/net/wireless/ath/ath5k/reset.c
> > @@ -27,6 +27,7 @@
> >
> >  #include <linux/pci.h>                 /* To determine if a card is
> pci-e */
> >  #include <linux/log2.h>
> > +#include <linux/platform_device.h>
> >  #include "ath5k.h"
> >  #include "reg.h"
> >  #include "base.h"
> > @@ -198,31 +199,74 @@ static inline void
> ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
> >  */
> >  static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
> >  {
> > -       int ret;
> > +       int ret = 0;
> >        u32 mask = val ? val : ~0U;
> >
> >        /* Read-and-clear RX Descriptor Pointer*/
> > -       ath5k_hw_reg_read(ah, AR5K_RXDP);
> > +       if (!(mask & AR5K_RESET_CTL_MAC))
> > +               ath5k_hw_reg_read(ah, AR5K_RXDP);
> >
> >        /*
> >         * Reset the device and wait until success
> >         */
> > -       ath5k_hw_reg_write(ah, val, AR5K_RESET_CTL);
> > +       if (ath5k_get_bus_type(ah) == ATH_AHB) {
> > +               volatile u32 *reg;
> > +               u32 regval;
> > +               val = 0;
> > +
> > +               /* ah->ah_mac_srev is not available at this point
> yet */
> > +               if (ah->ah_sc->devid >= AR5K_SREV_AR2315_R6) {
> > +                       reg = (u32 *) AR5K_AR2315_RESET;
> > +                       if (mask & AR5K_RESET_CTL_MAC)
> > +                               val |= AR5K_AR2315_RESET_WMAC;
> > +                       if (mask & AR5K_RESET_CTL_BASEBAND)
> > +                               val |= AR5K_AR2315_RESET_BB_WARM;
> > +               } else {
> > +                       reg = (u32 *) AR5K_AR5312_RESET;
> > +                       if (to_platform_device(ah->ah_sc->dev)->id
> == 0) {
> > +                               if (mask & AR5K_RESET_CTL_MAC)
> > +                                       val |=
> AR5K_AR5312_RESET_WMAC0;
> > +                               if (mask & AR5K_RESET_CTL_BASEBAND)
> > +                                       val |=
> AR5K_AR5312_RESET_BB0_COLD |
> > +                                            
>  AR5K_AR5312_RESET_BB0_WARM;
> > +                       } else {
> > +                               if (mask & AR5K_RESET_CTL_MAC)
> > +                                       val |=
> AR5K_AR5312_RESET_WMAC1;
> > +                               if (mask & AR5K_RESET_CTL_BASEBAND)
> > +                                       val |=
> AR5K_AR5312_RESET_BB1_COLD |
> > +                                            
>  AR5K_AR5312_RESET_BB1_WARM;
> > +                       }
> > +               }
> >
> > -       /* Wait at least 128 PCI clocks */
> > -       udelay(15);
> > +               /* Put BB/MAC into reset */
> > +               regval = __raw_readl(reg);
> > +               __raw_writel(regval | val, reg);
> > +               regval = __raw_readl(reg);
> > +               udelay(100);
> >
> > -       if (ah->ah_version == AR5K_AR5210) {
> > -               val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_DMA
> > -                       | AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_PHY;
> > -               mask &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_DMA
> > -                       | AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_PHY;
> > +               /* Bring BB/MAC out of reset */
> > +               __raw_writel(regval & ~val, reg);
> > +               regval = __raw_readl(reg);
> >        } else {
> > -               val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
> > -               mask &= AR5K_RESET_CTL_PCU |
> AR5K_RESET_CTL_BASEBAND;
> > -       }
> >
> > -       ret = ath5k_hw_register_timeout(ah, AR5K_RESET_CTL, mask,
> val, false);
> > +               ath5k_hw_reg_write(ah, val, AR5K_RESET_CTL);
> > +
> > +               /* Wait at least 128 PCI clocks */
> > +               udelay(15);
> > +
> > +               if (ah->ah_version == AR5K_AR5210) {
> > +                       val &= AR5K_RESET_CTL_PCU |
> AR5K_RESET_CTL_DMA
> > +                               | AR5K_RESET_CTL_MAC |
> AR5K_RESET_CTL_PHY;
> > +                       mask &= AR5K_RESET_CTL_PCU |
> AR5K_RESET_CTL_DMA
> > +                               | AR5K_RESET_CTL_MAC |
> AR5K_RESET_CTL_PHY;
> > +               } else {
> > +                       val &= AR5K_RESET_CTL_PCU |
> AR5K_RESET_CTL_BASEBAND;
> > +                       mask &= AR5K_RESET_CTL_PCU |
> AR5K_RESET_CTL_BASEBAND;
> > +               }
> > +
> > +               ret = ath5k_hw_register_timeout(ah, AR5K_RESET_CTL,
> > +                               mask, val, false);
> > +       }
> >
> 
> I think it would be much cleaner if we had a different function to
> handle wisoc reset instead
> of putting both on nic_reset. How about having a ath5k_hw_wisoc_reset
> and call that instead ?

I will rework the reset functions and come up with the proposal. The only
problem is that I don't have AR2316 or AR2317 to test all the possible
paths. I have only AR5312/AR2313 and a bunch of miniPCI cards.

I will look whether I can find a cheap one for testing.

Wojtek

> 
> >        /*
> >         * Reset configuration register (for hw byte-swap). Note that
> this
> > @@ -334,6 +378,9 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
> >        u32 bus_flags;
> >        int ret;
> >
> > +       if (ath5k_get_bus_type(ah) == ATH_AHB)
> > +               return 0;
> > +
> >        /* Make sure device is awake */
> >        ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
> >        if (ret) {
> > @@ -390,22 +437,30 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah,
> int flags, bool initial)
> >        mode = 0;
> >        clock = 0;
> >
> > -       /* Wakeup the device */
> > -       ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
> > -       if (ret) {
> > -               ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC
> Chip\n");
> > -               return ret;
> > +       if (ath5k_get_bus_type(ah) == ATH_AHB && !initial) {
> > +               /* Wakeup the device */
> > +               ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true,
> 0);
> > +               if (ret) {
> > +                       ATH5K_ERR(ah->ah_sc, "failed to wakeup the
> MAC Chip\n");
> > +                       return ret;
> > +               }
> >        }
> >
> 
> You only call ath5k_hw_set_power for AHB devices this way !
> 
> >        /*
> >         * Put chipset on warm reset...
> >         *
> > -        * Note: putting PCI core on warm reset on PCI-E cards
> > -        * results card to hang and always return 0xffff... so
> > -        * we ingore that flag for PCI-E cards. On PCI cards
> > -        * this flag gets cleared after 64 PCI clocks.
> >         */
> > -       bus_flags = (pdev && pdev->is_pcie) ? 0 :
> AR5K_RESET_CTL_PCI;
> > +       if (ath5k_get_bus_type(ah) == ATH_AHB) {
> > +               /* Reset MAC on WiSoc devices */
> > +               bus_flags = (initial) ? AR5K_RESET_CTL_MAC : 0;
> > +       } else {
> > +               /* Note: putting PCI core on warm reset on PCI-E
> cards
> > +                * results card to hang and always return 0xffff...
> so
> > +                * we ingore that flag for PCI-E cards. On PCI cards
> > +                * this flag gets cleared after 64 PCI clocks.
> > +                */
> > +               bus_flags = (pdev && pdev->is_pcie) ? 0 :
> AR5K_RESET_CTL_PCI;
> > +       }
> >
> 
> This is wrong...
> #define AR5K_RESET_CTL_MAC      0x00000004      /* MAC reset
> (PCU+Baseband ?) [5210] */
> this bit was only available on earlier chips. To reset mac on later
> chips (WiSoC too) you need to use
> AR5K_RESET_CTL_PCU  and we already do that below.
> 
> This is something I have to clean up actually, bit 0 is reset mac
> (both PCU + DMA) and bit 1 resets Baseband. Note there is poor
> documentation on that, documentation on AR2317 eg. says mac reset for
> bit 0 and "warm reset to baseband logic" for bit 1 (which is correct)
> but on description for bit 1 says "PCU and DMA but not baseband"
> (that's actually the description of bit 0) and above says "in order to
> reset both baseband and mac and pci write 0x13" (0x10 is pci) that
> doesn't make sense because according to descriptions none of the 2
> first bits resets baseband :P If you go on AR5213, documentation is
> correct, it says that bit 0 is for PCU and DMA and bit 1 is for
> baseband and that also works on all post-5211 chips. That's why I've
> put the comments on reg.h, all [5210] are only available on AR5210,
> only bits/registers marked with [5211+] are available on later macs.
> 
> So what you are really doing here is activate bit 3 that is reserved
> according to docs and should be zeroed ! We already do what's needed
> to reset both mac and baseband later.
> 
> val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
> 
> Notice that AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND = 0x13 as
> documentation suggests.
> 

Need to study documentation for this part. Till now it was more of the
trial and error.

Wojtek

> >        if (ah->ah_version == AR5K_AR5210) {
> >                ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
> > @@ -536,6 +591,9 @@ static void ath5k_hw_set_sleep_clock(struct
> ath5k_hw *ah, bool enable)
> >        struct ath5k_eeprom_info *ee =
> &ah->ah_capabilities.cap_eeprom;
> >        u32 scal, spending, usec32;
> >
> > +       if (ath5k_get_bus_type(ah) == ATH_AHB)
> > +               enable = false;
> > +
> >        /* Only set 32KHz settings if we have an external
> >         * 32KHz crystal present */
> >        if ((AR5K_EEPROM_HAS32KHZCRYSTAL(ee->ee_misc1) ||
> > @@ -607,6 +665,7 @@ static void ath5k_hw_set_sleep_clock(struct
> ath5k_hw *ah, bool enable)
> >
> >                if ((ah->ah_radio == AR5K_RF5112) ||
> >                (ah->ah_radio == AR5K_RF5413) ||
> > +               (ah->ah_radio == AR5K_RF2316) ||
> >                (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
> >                        spending = 0x14;
> >                else
> > @@ -614,7 +673,9 @@ static void ath5k_hw_set_sleep_clock(struct
> ath5k_hw *ah, bool enable)
> >                ath5k_hw_reg_write(ah, spending, AR5K_PHY_SPENDING);
> >
> >                if ((ah->ah_radio == AR5K_RF5112) ||
> > -               (ah->ah_radio == AR5K_RF5413))
> > +               (ah->ah_radio == AR5K_RF5413) ||
> > +               (ah->ah_radio == AR5K_RF2316) ||
> > +               (ah->ah_radio == AR5K_RF2317))
> >                        usec32 = 39;
> >                else
> >                        usec32 = 31;
> > @@ -678,7 +739,8 @@ static void
> ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
> >
> >        /* Set fast ADC */
> >        if ((ah->ah_radio == AR5K_RF5413) ||
> > -       (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
> > +               (ah->ah_radio == AR5K_RF2317) ||
> > +               (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
> >                u32 fast_adc = true;
> >
> >                if (channel->center_freq == 2462 ||
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick

-- 
Wojciech Dubowik
Senior Software Engineer
Neratec Solutions AG
Rosswiesstr. 29, CH-8608 Bubikon, Switzerland
Tel: +41 55 253 2096 (office)
Fax: +41 55 253 2070
wojciech.dubowik@neratec.com
http://www.neratec.com
