Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57469 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:19:45 -0500
Received: by ywj3 with SMTP id 3so599530ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:19:45 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52147.200376.92948@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:31 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 14/23] ath9k_htc: Calculate and set the HW opmode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 51a8c51..9733580 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -166,6 +166,18 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
 	ath_hw_setbssidmask(common);
 }
 
+static void ath9k_htc_set_opmode(struct ath9k_htc_priv *priv)
+{
+	if (priv->num_ibss_vif)
+		priv->ah->opmode = NL80211_IFTYPE_ADHOC;
+	else if (priv->num_ap_vif)
+		priv->ah->opmode = NL80211_IFTYPE_AP;
+	else
+		priv->ah->opmode = NL80211_IFTYPE_STATION;
+
+	ath9k_hw_setopmode(priv->ah);
+}
+
 void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
@@ -1252,12 +1264,12 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_htc_set_bssid_mask(priv, vif);
 
-	priv->ah->opmode = vif->type;
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
 	priv->vif = vif;
 
 	INC_VIF(priv, vif->type);
+	ath9k_htc_set_opmode(priv);
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
@@ -1293,6 +1305,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	priv->vif = NULL;
 
 	DEC_VIF(priv, vif->type);
+	ath9k_htc_set_opmode(priv);
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
 
-- 
1.7.4.1

