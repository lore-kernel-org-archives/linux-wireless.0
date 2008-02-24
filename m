Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:13592 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYBXErB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 23:47:01 -0500
Received: by wx-out-0506.google.com with SMTP id h31so936811wxd.4
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2008 20:47:01 -0800 (PST)
Message-ID: <40f31dec0802232047v137553daobb3d079d304977a4@mail.gmail.com> (sfid-20080224_044707_537864_7975B63E)
Date: Sun, 24 Feb 2008 06:47:00 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com, "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
In-Reply-To: <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/24, Nick Kossifidis <mickflemm@gmail.com>:
> 2008/2/24, Nick Kossifidis <mick@madwifi.org>:
>
> >  * Fix nic_wakeup for PCI-E chips (don't set AR5K_RESET_CTL_PCI bit)
>  >
>  >   * Fix dma size setting for PCI-E chips (thanx to Bob Copeland).
>  >
>  >  Changes-licensed-under: ISC
>  >  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>  >
>  >  ---
>  >  diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
>  >  index c0b6596..d8ec373 100644
>  >  --- a/drivers/net/wireless/ath5k/ath5k.h
>  >  +++ b/drivers/net/wireless/ath5k/ath5k.h
>  >  @@ -971,6 +971,7 @@ struct ath5k_hw {
>  >         enum ath5k_version      ah_version;
>  >         enum ath5k_radio        ah_radio;
>  >         u32                     ah_phy;
>  >  +       bool                    ah_pcie;
>  >
>  >         bool                    ah_5ghz;
>  >         bool                    ah_2ghz;
>  >  diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>  >  index 3ae5522..cd640ed 100644
>  >  --- a/drivers/net/wireless/ath5k/hw.c
>  >  +++ b/drivers/net/wireless/ath5k/hw.c
>  >  @@ -214,6 +214,14 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>  >                 ah->ah_single_chip = false;
>  >         }
>  >
>  >  +       /* Identify PCI-E cards */
>  >  +       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
>  >  +       srev >= AR5K_SREV_VER_AR5416) {
>  >  +               ah->ah_pcie = true;
>  >  +       } else {
>  >  +               ah->ah_pcie = false;
>  >  +       }
>  >  +
>  >         /* Single chip radio */
>  >         if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
>  >                 ah->ah_radio_2ghz_revision = 0;
>  >  @@ -377,9 +385,12 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>  >                                         AR5K_PHY_TURBO);
>  >         }
>  >
>  >  -       /* ...reset chipset and PCI device */
>  >  -       if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
>  >  -                               AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
>  >  +       /* ...reset chipset
>  >  +        * Warning: reseting PCI on PCI-E cards results card to hang
>  >  +        * and always return 0xffff...
>  >  +        */
>  >  +       if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND |
>  >  +                               (ah->ah_pcie == false ? AR5K_RESET_CTL_PCI : 0) )) {
>  >                 ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
>  >                 return -EIO;
>  >         }
>  >  @@ -900,13 +911,25 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>  >
>  >         /*
>  >          * Set Rx/Tx DMA Configuration
>  >  -        *(passing dma size not available on 5210)
>  >  +        *
>  >  +        * Set maximum DMA size (512) except for PCI-E cards since
>  >  +        * it causes rx overruns and tx errors (tested on 5424 but since
>  >  +        * rx overruns also occur on 5416/5418 with madwifi we set 128
>  >  +        * for all PCI-E cards to be safe).
>  >  +        *
>  >  +        * In dumps this is 128 for allchips.
>  >  +        *
>  >  +        * XXX: need to check 5210 for this
>  >  +        * TODO: Check out tx triger level, it's always 64 on dumps but i
>  >  +        * guess we can tweak it and see how it goes ;-)
>  >          */
>  >         if (ah->ah_version != AR5K_AR5210) {
>  >                 AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG, AR5K_TXCFG_SDMAMR,
>  >  -                               AR5K_DMASIZE_512B | AR5K_TXCFG_DMASIZE);
>  >  +                               (ah->ah_pcie == true ?
>  >  +                               AR5K_DMASIZE_128B : AR5K_DMASIZE_512B));
>  >                 AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_SDMAMW,
>  >  -                               AR5K_DMASIZE_512B);
>  >  +                               (ah->ah_pcie == true ?
>  >  +                               AR5K_DMASIZE_128B : AR5K_DMASIZE_512B));
>  >         }
>  >
>  >         /*
>  >
>
>
> Sorry, forgot to CC Bob...
>
>  Bob can you test this on your 5242 (together with the next patch) and
>  see what happens ?
>

hmm i mean 5424, time for sleep :P


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
