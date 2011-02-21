Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55997 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:18:38 -0500
Received: by yxs7 with SMTP id 7so122851yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:18:38 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52080.359089.399509@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:48:24 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 05/23] ath9k_htc: Remove OP_PREAMBLE_SHORT
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

mac80211's BSS info can be used for this.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   13 ++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 ---------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ab8d1f0..ed6af32 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -335,13 +335,12 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 #define OP_SCANNING		   BIT(1)
 #define OP_LED_ASSOCIATED	   BIT(2)
 #define OP_LED_ON		   BIT(3)
-#define OP_PREAMBLE_SHORT	   BIT(4)
-#define OP_PROTECT_ENABLE	   BIT(5)
-#define OP_ASSOCIATED		   BIT(6)
-#define OP_ENABLE_BEACON	   BIT(7)
-#define OP_LED_DEINIT		   BIT(8)
-#define OP_BT_PRIORITY_DETECTED    BIT(9)
-#define OP_BT_SCAN                 BIT(10)
+#define OP_PROTECT_ENABLE	   BIT(4)
+#define OP_ASSOCIATED		   BIT(5)
+#define OP_ENABLE_BEACON	   BIT(6)
+#define OP_LED_DEINIT		   BIT(7)
+#define OP_BT_PRIORITY_DETECTED    BIT(8)
+#define OP_BT_SCAN                 BIT(9)
 
 struct ath9k_htc_priv {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ebc5dbf..13e9dec 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1524,15 +1524,6 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_htc_beacon_config(priv, vif);
 	}
 
-	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
-			bss_conf->use_short_preamble);
-		if (bss_conf->use_short_preamble)
-			priv->op_flags |= OP_PREAMBLE_SHORT;
-		else
-			priv->op_flags &= ~OP_PREAMBLE_SHORT;
-	}
-
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
 			bss_conf->use_cts_prot);
-- 
1.7.4.1

