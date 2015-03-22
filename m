Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61966 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbbCVSbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:31:49 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 12/18] ath9k: use rmw buffer in ath9k_hw_set_operating_mode and ath9k_hw_reset
Date: Sun, 22 Mar 2015 19:29:57 +0100
Message-Id: <1427049003-8443-13-git-send-email-linux@rempel-privat.de> (sfid-20150322_193418_426573_B7C4C48C)
In-Reply-To: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
References: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/hw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 662ef3f..1bae771 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1227,6 +1227,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 	u32 mask = AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC;
 	u32 set = AR_STA_ID1_KSRCH_MODE;
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	switch (opmode) {
 	case NL80211_IFTYPE_ADHOC:
 		if (!AR_SREV_9340_13(ah)) {
@@ -1248,6 +1249,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 		break;
 	}
 	REG_RMW(ah, AR_STA_ID1, set, mask);
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
@@ -1960,6 +1962,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_mci_is_enabled(ah))
 		REG_WRITE(ah, AR_OBS, 8);
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	if (ah->config.rx_intr_mitigation) {
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, ah->config.rimt_last);
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, ah->config.rimt_first);
@@ -1969,6 +1972,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		REG_RMW_FIELD(ah, AR_TIMT, AR_TIMT_LAST, 300);
 		REG_RMW_FIELD(ah, AR_TIMT, AR_TIMT_FIRST, 750);
 	}
+	REG_RMW_BUFFER_FLUSH(ah);
 
 	ath9k_hw_init_bb(ah, chan);
 
-- 
1.9.1

