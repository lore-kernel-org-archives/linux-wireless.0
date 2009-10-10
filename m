Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:33857 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZJJK5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 06:57:44 -0400
MIME-Version: 1.0
In-Reply-To: <m3tyy8fkda.fsf@intrepid.localdomain>
References: <m3tyy8fkda.fsf@intrepid.localdomain>
Date: Sat, 10 Oct 2009 13:56:36 +0300
Message-ID: <40f31dec0910100356i470a93d0x3244867e1160e9df@mail.gmail.com>
Subject: Re: Ath5k data aborts
From: Nick Kossifidis <mickflemm@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/10/9 Krzysztof Halasa <khc@pm.waw.pl>:
> Hi,
>
> I have done a small investigation. IXP425 (ARM) in big-endian mode,
> EABI, mini-PCI atk5k wifi card, hostapd.
>
> Atheros Communications Inc. Atheros AR5001X+ Wireless Network Adapter (rev 01)
> Subsystem: Wistron NeWeb Corp. CM9 Wireless a/b/g MiniPCI Adapter
> 168c:0013 subsystem 185f:1012
>
>
> Results:
> Bad mode in data abort handler detected
> Internal error: Oops - bad mode: 0 [#1]
> LR is at ath5k_beacon_config+0x150/0x1d4 [ath5k]
>
> This means the PCI device didn't respond on the bus or something
> like that. Obviously the card is then unusable and the system needs to
> be restarted.
>
> Bisecting (I had to modify the procedure a bit since it only started to
> show up after other unrelated code was merged) shows the guilty commit:
> e8f055f0c3ba226ca599c14c2e5fe829f6f57cbb (ath5k: Update reset code).
>
> The problem exists with 2.6.30, 2.6.31 and current Linus' tree.
>
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
>
> ----------------------------------------------
> 2.6.30 appears to be fixed by:
>
> --- a/drivers/net/wireless/ath5k/reset.c
> +++ b/drivers/net/wireless/ath5k/reset.c
> @@ -476,7 +476,7 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
>                (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
>                        ath5k_hw_reg_write(ah, 0x26, AR5K_PHY_SLMT);
>                        ath5k_hw_reg_write(ah, 0x0d, AR5K_PHY_SCAL);
> -                       ath5k_hw_reg_write(ah, 0x07, AR5K_PHY_SCLOCK);
> +                       ath5k_hw_reg_write(ah, 0x0C, AR5K_PHY_SCLOCK);
>                        ath5k_hw_reg_write(ah, 0x3f, AR5K_PHY_SDELAY);
>                        AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
>                                AR5K_PCICFG_SLEEP_CLOCK_RATE, 0x02);
> @@ -490,8 +490,10 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
>                }
>
>                /* Enable sleep clock operation */
> +#if 0
>                AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG,
>                                AR5K_PCICFG_SLEEP_CLOCK_EN);
> +#endif
>
>        } else {
>
>
>
> The AR5K_PHY_SCLOCK brings the old value (before the commit in question)
> back, I have no idea what is it. Leaving the new value causes the second
> run of hostapd to make the driver fail, the chip seems to not respond.
> It seems the value itself may be correct (as it works with 2.6.31+) but
> there is some additional bug fixed after 2.6.30, gitk show several
> candidate patches for this.
>
>
> Only disabling AR5K_PCICFG write makes the data abort go away.
>
> ----------------------------------------------
> 2.6.31 and Linus-current only need the AR5K_PCICFG change:
>
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -489,9 +489,10 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
>                }
>
>                /* Enable sleep clock operation */
> +#if 0
>                AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG,
>                                AR5K_PCICFG_SLEEP_CLOCK_EN);
> -
> +#endif
>        } else {
>
>                /* Disable sleep clock operation and
>
>
> The question is, obviously, how to fix that for good. I can test the
> result.

Interesting, can you provide us with an eeprom info dump from your
card (using ath_info tool from madwifi svn) ?
It seems we need to skip sleep clock operation in your case.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
