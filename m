Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55997 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:18:45 -0500
Received: by mail-yx0-f174.google.com with SMTP id 7so122851yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:18:45 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52087.718374.964802@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:48:31 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 06/23] ath9k_htc: Remove OP_PROTECT_ENABLE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

CTS protection can be obtained from mac80211 directly.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   11 +++++------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   10 ----------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ed6af32..4e19e14 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -335,12 +335,11 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 #define OP_SCANNING		   BIT(1)
 #define OP_LED_ASSOCIATED	   BIT(2)
 #define OP_LED_ON		   BIT(3)
-#define OP_PROTECT_ENABLE	   BIT(4)
-#define OP_ASSOCIATED		   BIT(5)
-#define OP_ENABLE_BEACON	   BIT(6)
-#define OP_LED_DEINIT		   BIT(7)
-#define OP_BT_PRIORITY_DETECTED    BIT(8)
-#define OP_BT_SCAN                 BIT(9)
+#define OP_ASSOCIATED		   BIT(4)
+#define OP_ENABLE_BEACON	   BIT(5)
+#define OP_LED_DEINIT		   BIT(6)
+#define OP_BT_PRIORITY_DETECTED    BIT(7)
+#define OP_BT_SCAN                 BIT(8)
 
 struct ath9k_htc_priv {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 13e9dec..dbde491 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1524,16 +1524,6 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_htc_beacon_config(priv, vif);
 	}
 
-	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
-			bss_conf->use_cts_prot);
-		if (bss_conf->use_cts_prot &&
-		    hw->conf.channel->band != IEEE80211_BAND_5GHZ)
-			priv->op_flags |= OP_PROTECT_ENABLE;
-		else
-			priv->op_flags &= ~OP_PROTECT_ENABLE;
-	}
-
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
 			ah->slottime = 9;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index d5f0f41..884deeb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -156,7 +156,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 
 		/* CTS-to-self */
 		if (!(flags & ATH9K_HTC_TX_RTSCTS) &&
-		    (priv->op_flags & OP_PROTECT_ENABLE))
+		    (vif && vif->bss_conf.use_cts_prot))
 			flags |= ATH9K_HTC_TX_CTSONLY;
 
 		tx_hdr.flags = cpu_to_be32(flags);
-- 
1.7.4.1

