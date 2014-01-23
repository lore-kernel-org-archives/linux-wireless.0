Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53416 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaAWCz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 21:55:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: Fix RX interrupt mitigation
Date: Thu, 23 Jan 2014 08:20:30 +0530
Message-Id: <1390445430-16626-1-git-send-email-sujith@msujith.org> (sfid-20140123_035601_007995_7A53120C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The threshold values for RX interrupt mitigation
are different for AR9003 and AR9002 families.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 12 ++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h |  2 ++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ce41658..fbf43c0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -358,6 +358,14 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 
 	ah->config.rx_intr_mitigation = true;
 
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ah->config.rimt_last = 500;
+		ah->config.rimt_first = 2000;
+	} else {
+		ah->config.rimt_last = 250;
+		ah->config.rimt_first = 700;
+	}
+
 	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
 	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
@@ -1876,8 +1884,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		REG_WRITE(ah, AR_OBS, 8);
 
 	if (ah->config.rx_intr_mitigation) {
-		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
-		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
+		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, ah->config.rimt_last);
+		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, ah->config.rimt_first);
 	}
 
 	if (ah->config.tx_intr_mitigation) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e766399..0acd4b5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -310,6 +310,8 @@ struct ath9k_ops_config {
 	u8 max_txtrig_level;
 	u16 ani_poll_interval; /* ANI poll interval in ms */
 	u16 hw_hang_checks;
+	u16 rimt_first;
+	u16 rimt_last;
 
 	/* Platform specific config */
 	u32 aspm_l1_fix;
-- 
1.8.5.3

