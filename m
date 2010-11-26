Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36875 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab0KZOKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 09:10:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 06:10:02 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Remove code which enables btcoex based on subsys id
Date: Fri, 26 Nov 2010 06:10:07 -0800
Message-ID: <1290780607-2582-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1290780607-2582-1-git-send-email-vasanth@atheros.com>
References: <1290780607-2582-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   23 -----------------------
 drivers/net/wireless/ath/ath9k/btcoex.h |    1 -
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 6a92e57..d33bf20 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -35,29 +35,6 @@ struct ath_btcoex_config {
 	bool bt_hold_rx_clear;
 };
 
-static const u16 ath_subsysid_tbl[] = {
-	AR9280_COEX2WIRE_SUBSYSID,
-	AT9285_COEX3WIRE_SA_SUBSYSID,
-	AT9285_COEX3WIRE_DA_SUBSYSID
-};
-
-/*
- * Checks the subsystem id of the device to see if it
- * supports btcoex
- */
-bool ath9k_hw_btcoex_supported(struct ath_hw *ah)
-{
-	int i;
-
-	if (!ah->hw_version.subsysid)
-		return false;
-
-	for (i = 0; i < ARRAY_SIZE(ath_subsysid_tbl); i++)
-		if (ah->hw_version.subsysid == ath_subsysid_tbl[i])
-			return true;
-
-	return false;
-}
 
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 {
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 1ee5a15..588dfd4 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -49,7 +49,6 @@ struct ath_btcoex_hw {
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
 };
 
-bool ath9k_hw_btcoex_supported(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
-- 
1.7.0.4

