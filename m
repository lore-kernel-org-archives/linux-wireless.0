Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39011 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3LMJs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 04:48:29 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so738535eaj.35
        for <linux-wireless@vger.kernel.org>; Fri, 13 Dec 2013 01:48:25 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [Cerowrt-devel] Wireless failures 3.10.17-3
From: Sebastian Moeller <sebastian.moeller@gmail.com>
In-Reply-To: <21162.54025.118938.614891@gargle.gargle.HOWL>
Date: Fri, 13 Dec 2013 10:48:24 +0100
Cc: cerowrt-devel@lists.bufferbloat.net,
	Stephen Hemminger <stephen@networkplumber.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Message-Id: <24E1A6F1-E642-43D3-8FB1-B6C27B6D8E24@gmail.com> (sfid-20131213_104920_954789_485CF15A)
References: <20131211174519.34966001@nehalam.linuxnetplumber.net> <21161.18818.926049.511664@gargle.gargle.HOWL> <C0DD393A-6810-4CB6-B705-AE801ED5BBBA@gmx.de> <21162.54025.118938.614891@gargle.gargle.HOWL>
To: Sujith Manoharan <sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Dec 13, 2013, at 10:27 , Sujith Manoharan <sujith@msujith.org> wrote:

> Sebastian Moeller wrote:
>> It is a net gear WNDR3700 v2, so according to:
>> http://wiki.openwrt.org/toh/netgear/wndr3700 it is a Atheros AR7161 rev 2 680
>> MHz soc with the following wireless parts: Atheros AR9223 802.11bgn / Atheros
>> AR9220 802.11an.
>> 
>> Sure, I hope I got the right one. Now this is not from the same boot as the
>> one with the errors, but I assume that does not make a difference… Since I am
>> located in Germany I set the regulatory domain to DE. please let me know if I
>> you need any additional information or testing (note I am not set up to build
>> cerowrt myself, so I would need Dave Täht's help to build a modified firmware)
> 
> Can you try this patch ?

	I will, but it will take some time, as I cannot build the firmware for this device myself, but need help. So I let you know once I tested the patched kernel.

Best Regards & many thanks
	Sebastian


> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> index 8d78253..0337de7 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> @@ -76,9 +76,16 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
> 				mask2 |= ATH9K_INT_CST;
> 			if (isr2 & AR_ISR_S2_TSFOOR)
> 				mask2 |= ATH9K_INT_TSFOOR;
> +
> +			if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
> +				REG_WRITE(ah, AR_ISR_S2, isr2);
> +				isr &= ~AR_ISR_BCNMISC;
> +			}
> 		}
> 
> -		isr = REG_READ(ah, AR_ISR_RAC);
> +		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)
> +			isr = REG_READ(ah, AR_ISR_RAC);
> +
> 		if (isr == 0xffffffff) {
> 			*masked = 0;
> 			return false;
> @@ -97,11 +104,23 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
> 
> 			*masked |= ATH9K_INT_TX;
> 
> -			s0_s = REG_READ(ah, AR_ISR_S0_S);
> +			if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
> +				s0_s = REG_READ(ah, AR_ISR_S0_S);
> +				s1_s = REG_READ(ah, AR_ISR_S1_S);
> +			} else {
> +				s0_s = REG_READ(ah, AR_ISR_S0);
> +				REG_WRITE(ah, AR_ISR_S0, s0_s);
> +				s1_s = REG_READ(ah, AR_ISR_S1);
> +				REG_WRITE(ah, AR_ISR_S1, s1_s);
> +
> +				isr &= ~(AR_ISR_TXOK |
> +					 AR_ISR_TXDESC |
> +					 AR_ISR_TXERR |
> +					 AR_ISR_TXEOL);
> +			}
> +
> 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
> 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
> -
> -			s1_s = REG_READ(ah, AR_ISR_S1_S);
> 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
> 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
> 		}
> @@ -120,7 +139,12 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
> 	if (isr & AR_ISR_GENTMR) {
> 		u32 s5_s;
> 
> -		s5_s = REG_READ(ah, AR_ISR_S5_S);
> +		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
> +			s5_s = REG_READ(ah, AR_ISR_S5_S);
> +		} else {
> +			s5_s = REG_READ(ah, AR_ISR_S5);
> +		}
> +
> 		ah->intr_gen_timer_trigger =
> 				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
> 
> @@ -133,6 +157,16 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
> 		if ((s5_s & AR_ISR_S5_TIM_TIMER) &&
> 		    !(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
> 			*masked |= ATH9K_INT_TIM_TIMER;
> +
> +		if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
> +			REG_WRITE(ah, AR_ISR_S5, s5_s);
> +			isr &= ~AR_ISR_GENTMR;
> +		}
> +	}
> +
> +	if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
> +		REG_WRITE(ah, AR_ISR, isr);
> +		REG_READ(ah, AR_ISR);
> 	}
> 
> 	if (sync_cause) {
> 
> 
> A version that applies over OpenWrt trunk is here:
> http://msujith.org/dir/patches/wl/Dec-13-2013/0001-ath9k-Interrupt-handling-fix-for-AR9002-family.patch
> 
> Sujith

-- 
Sandra, Okko, Joris, & Sebastian Moeller
Telefon: +49 7071 96 49 783, +49 7071 96 49 784, +49 7071 96 49 785
GSM: +49-1577-190 31 41
GSM: +49-1517-00 70 355

Moltkestrasse 6
72072 Tuebingen
Deutschland

