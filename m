Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40986 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1AUDAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:00:24 -0500
Received: by mail-iy0-f174.google.com with SMTP id 18so1245111iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:00:23 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63129.521681.626480@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:29:37 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 04/33] ath9k_htc: Remove OP_PREAMBLE_SHORT
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
index ff6bfd9..08ab28d 100644
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
index b3b33ff..8e76589 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1521,15 +1521,6 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
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
1.7.3.5

