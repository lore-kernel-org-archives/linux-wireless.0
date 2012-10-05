Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39988 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479Ab2JEMeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 08:34:36 -0400
Message-ID: <506ED3D4.7050107@openwrt.org> (sfid-20121005_143439_947130_8039925D)
Date: Fri, 05 Oct 2012 14:34:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <506B0628.6070201@openwrt.org> <CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com> <2629427.e28b8DS3gI@bentobox>
In-Reply-To: <2629427.e28b8DS3gI@bentobox>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-05 1:08 PM, Sven Eckelmann wrote:
> On Wednesday 03 October 2012 07:51:28 Adrian Chadd wrote:
>> On 2 October 2012 08:20, Felix Fietkau <nbd@openwrt.org> wrote:
>> >> This sync cause 0x20 isn't handled anywhere and may be the cause of the
>> >> hang/crash. At least this is the symptom which can be fixed without
>> >> crashing the system.
>> > 
>> > I checked the AR933x datasheet, and it says that cause 0x20 is tx
>> > descriptor corruption.
>> 
>> Ah hey, for Hornet they redefined those bits:
>> 
>> 5: MAC_TXC_CORRUPTION_FLAG_SYNC (TX descriptor integrity flag)
>> 6: INVALID_ADDRESS_ACCESS (invalid register access)
>> 
>> Good catch. That's definitely something in the right direction.
> 
> Ok, I've just created a dirty hack to trace some of the register reads/writes. 
> 
> I used following test setup: Two Hornets, one is the "internet gateway" (just 
> attached using ethernet to a test server) and is running one AP vif with 
> standard OpenWRT settings. The other Hornet is placed next to it (only some 
> centimeter far away) and is connected to the AP using WiFi.
> 
> The client device is just trying to download a large file using HTTP. The 
> serial consoles on both devices will now print the "same" log. I already 
> searched for the interesting section. It is started in ath_ani_calibrate and 
> contains ~42 register access operations.
> 
> My best guess is the REG_RMW_FIELD for ATH9K_ANI_MRC_CCK in 
> ar9003_hw_ani_control (just checked sync_cause before and after the access).
> 
> So, now I need some input again from the guis with the spec. :)
Actually, this makes a lot of sense. Maximal Ratio Combining can only
be done if you have multiple inputs, and Hornet is a single-chain
device ;)

Please try this patch to see if it gets rid of these interrupts:
---
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -307,7 +307,8 @@ void ath9k_ani_reset(struct ath_hw *ah, 
 		if (IS_CHAN_2GHZ(chan)) {
 			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
 					    ATH9K_ANI_FIRSTEP_LEVEL);
-			if (AR_SREV_9300_20_OR_LATER(ah))
+			if (AR_SREV_9300_20_OR_LATER(ah) &&
+			    ah->caps.rx_chainmask != 1)
 				ah->ani_function |= ATH9K_ANI_MRC_CCK;
 		} else
 			ah->ani_function = 0;

