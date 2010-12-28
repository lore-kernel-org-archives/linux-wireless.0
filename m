Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0L1I64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:58:56 -0500
Received: by iwn9 with SMTP id 9so9170471iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 00:58:55 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19737.42685.373525.602985@gargle.gargle.HOWL>
Date: Tue, 28 Dec 2010 14:28:37 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH v2 5/6] ath9k_htc: Fix fast channel change
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

When returning to the operating channel, a full HW
reset has to be done instead of a fast channel change.
Since sw_scan_complete() is called after the config() call for the
home channel, we end up doing a FCC. Fix this issue by checking
the OFFCHANNEL flag to determine FCC.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   19 +++++++++----------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    8 ++------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 1062274..34456a8 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -331,16 +331,15 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 
 #define OP_INVALID		   BIT(0)
 #define OP_SCANNING		   BIT(1)
-#define OP_FULL_RESET		   BIT(2)
-#define OP_LED_ASSOCIATED	   BIT(3)
-#define OP_LED_ON		   BIT(4)
-#define OP_PREAMBLE_SHORT	   BIT(5)
-#define OP_PROTECT_ENABLE	   BIT(6)
-#define OP_ASSOCIATED		   BIT(7)
-#define OP_ENABLE_BEACON	   BIT(8)
-#define OP_LED_DEINIT		   BIT(9)
-#define OP_BT_PRIORITY_DETECTED    BIT(10)
-#define OP_BT_SCAN                 BIT(11)
+#define OP_LED_ASSOCIATED	   BIT(2)
+#define OP_LED_ON		   BIT(3)
+#define OP_PREAMBLE_SHORT	   BIT(4)
+#define OP_PROTECT_ENABLE	   BIT(5)
+#define OP_ASSOCIATED		   BIT(6)
+#define OP_ENABLE_BEACON	   BIT(7)
+#define OP_LED_DEINIT		   BIT(8)
+#define OP_BT_PRIORITY_DETECTED    BIT(9)
+#define OP_BT_SCAN                 BIT(10)
 
 struct ath9k_htc_priv {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 07f10dd..6da5e88 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -177,7 +177,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
-	bool fastcc = true;
+	bool fastcc;
 	struct ieee80211_channel *channel = hw->conf.channel;
 	struct ath9k_hw_cal_data *caldata;
 	enum htc_phymode mode;
@@ -188,8 +188,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	if (priv->op_flags & OP_INVALID)
 		return -EIO;
 
-	if (priv->op_flags & OP_FULL_RESET)
-		fastcc = false;
+	fastcc = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
 
 	ath9k_htc_ps_wakeup(priv);
 	htc_stop(priv->htc);
@@ -231,8 +230,6 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 		goto err;
 
 	htc_start(priv->htc);
-
-	priv->op_flags &= ~OP_FULL_RESET;
 err:
 	ath9k_htc_ps_restore(priv);
 	return ret;
@@ -1847,7 +1844,6 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 	spin_lock_bh(&priv->beacon_lock);
 	priv->op_flags &= ~OP_SCANNING;
 	spin_unlock_bh(&priv->beacon_lock);
-	priv->op_flags |= OP_FULL_RESET;
 	if (priv->op_flags & OP_ASSOCIATED) {
 		ath9k_htc_beacon_config(priv, priv->vif);
 		ath_start_ani(priv);
-- 
1.7.3.4

