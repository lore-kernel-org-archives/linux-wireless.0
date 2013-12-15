Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35208 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3LOUT2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 15:19:28 -0500
Message-ID: <52AE0EC1.4050706@openwrt.org> (sfid-20131215_211931_426327_D0A564AC)
Date: Sun, 15 Dec 2013 21:19:13 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix interrupt handling for the AR9002 family
References: <1387030293-7928-1-git-send-email-sujith@msujith.org> <52AE0D63.9090309@openwrt.org>
In-Reply-To: <52AE0D63.9090309@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-15 21:13, Felix Fietkau wrote:
> On 2013-12-14 15:11, Sujith Manoharan wrote:
>> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>> 
>> This patch adds a driver workaround for a HW issue.
>> 
>> A race condition in the HW results in missing interrupts,
>> which can be avoided by a read/write with the ISR register.
>> All chips in the AR9002 series are affected by this bug - AR9003
>> and above do not have this problem.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Please don't apply this patch just yet, it seems to be causing interrupt
> storms. I'm currently looking into it.
This change on top of it should fix the interrupt storms (which were
observed on AR913x):
---
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -133,6 +133,11 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		*masked |= mask2;
 	}
 
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+		REG_WRITE(ah, AR_ISR, isr);
+		REG_READ(ah, AR_ISR);
+	}
+
 	if (AR_SREV_9100(ah))
 		return true;
 
@@ -164,11 +169,6 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		}
 	}
 
-	if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
-		REG_WRITE(ah, AR_ISR, isr);
-		REG_READ(ah, AR_ISR);
-	}
-
 	if (sync_cause) {
 		ath9k_debug_sync_cause(common, sync_cause);
 		fatal_int =


