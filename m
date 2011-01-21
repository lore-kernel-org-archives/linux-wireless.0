Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AUDCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:02:01 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so1249489iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:02:01 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63228.133369.173625@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:31:16 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 14/33] ath9k_htc: Calculate and set the HW opmode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0694f2e..ce11b96 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -177,6 +177,18 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
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
@@ -1250,12 +1262,12 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_htc_set_bssid_mask(priv, vif);
 
-	priv->ah->opmode = vif->type;
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
 	priv->vif = vif;
 
 	INC_VIF(priv, vif->type);
+	ath9k_htc_set_opmode(priv);
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
@@ -1291,6 +1303,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	priv->vif = NULL;
 
 	DEC_VIF(priv, vif->type);
+	ath9k_htc_set_opmode(priv);
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
 
-- 
1.7.3.5

