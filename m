Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50085 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab0KVOjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 09:39:49 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: fix A-MPDU key search issues on AR9003
Date: Mon, 22 Nov 2010 15:39:39 +0100
Message-Id: <1290436779-85434-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under load, a large number of frames can produce decryption errors, even when
no key cache update is being done. Performing a key search for every single
frame in an A-MPDU improves reliability.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    4 ++++
 drivers/net/wireless/ath/ath9k/reg.h |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1dbe53b..3b69046 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1829,6 +1829,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
 
+	/* enable key search for every frame in an aggregate */
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ah->misc_mode |= AR_PCU_ALWAYS_PERFORM_KEYSEARCH;
+
 	pCap->low_2ghz_chan = 2312;
 	pCap->high_2ghz_chan = 2732;
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 443407d..f1bbc75 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1575,6 +1575,7 @@ enum {
 #define AR_PCU_TBTT_PROTECT        0x00200000
 #define AR_PCU_CLEAR_VMF           0x01000000
 #define AR_PCU_CLEAR_BA_VALID      0x04000000
+#define AR_PCU_ALWAYS_PERFORM_KEYSEARCH 0x10000000
 
 #define AR_PCU_BT_ANT_PREVENT_RX   0x00100000
 #define AR_PCU_BT_ANT_PREVENT_RX_S 20
-- 
1.7.3.2

