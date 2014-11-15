Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46210 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaKOTGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 14:06:38 -0500
Received: by mail-pd0-f169.google.com with SMTP id fp1so1374763pdb.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2014 11:06:37 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 2/2] ath9k_htc: Enable software crypto for mgmt frame in Tx for USB devices
Date: Sun, 16 Nov 2014 03:05:41 +0800
Message-Id: <1416078341-4411-3-git-send-email-yeohchunyeow@gmail.com> (sfid-20141115_201538_970077_437DB372)
In-Reply-To: <1416078341-4411-1-git-send-email-yeohchunyeow@gmail.com>
References: <1416078341-4411-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In secured mesh, the unicast mgmt frame is encrypted using
the same key that used for encrypting the unicast data frame.
This patch "ath9k_htc_firmware: fix the offset of CCMP header
for mesh data frame" applied to open-ath9k-htc-firmware allows
the ath9k_htc to be loaded without "nohwcrypt=1". Unfortunately,
this is not working and we still need CCMP encryption of
transmitted management frames to be done in software.

So this patch allows the software encryption for transmitted
management frame to be done in software but remain the hardware
decryption for received management frame.

This patch is tested with the following hardwares:
- TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
- AR9271 802.11n

and managed to work with peer mesh STA equipped with ath9k.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a53d304..99d5dcf4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1585,7 +1585,10 @@ static void ath9k_hw_init_mfp(struct ath_hw *ah)
 		 * frames when constructing CCMP AAD. */
 		REG_RMW_FIELD(ah, AR_AES_MUTE_MASK1, AR_AES_MUTE_MASK1_FC_MGMT,
 			      0xc7ff);
-		ah->sw_mgmt_crypto_tx = false;
+		if (AR_SREV_9271(ah) || AR_DEVID_7010(ah))
+			ah->sw_mgmt_crypto_tx = true;
+		else
+			ah->sw_mgmt_crypto_tx = false;
 		ah->sw_mgmt_crypto_rx = false;
 	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
 		/* Disable hardware crypto for management frames */
-- 
2.1.1

