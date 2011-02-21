Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:45084 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab1BUCXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:23:40 -0500
Received: by gwj23 with SMTP id 23so745448gwj.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:23:39 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52065.303778.11773@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:48:09 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 03/23] ath9k_htc: Unify target capability updating
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Update capabilites on the target once, when
start() is called, there is no need for redundant
updating on adding an interface.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 618670d..4ced5cd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -318,15 +318,6 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 
 	priv->sta_slot |= (1 << sta_idx);
 	priv->nstations++;
-
-	/*
-	 * Set chainmask etc. on the target.
-	 */
-	ret = ath9k_htc_update_cap_target(priv);
-	if (ret)
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Failed to update capability in target\n");
-
 	priv->vif_sta_pos[priv->mon_vif_idx] = sta_idx;
 	priv->ah->is_monitoring = true;
 
@@ -1050,6 +1041,11 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	ath9k_host_rx_init(priv);
 
+	ret = ath9k_htc_update_cap_target(priv);
+	if (ret)
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Failed to update capability in target\n");
+
 	priv->op_flags &= ~OP_INVALID;
 	htc_start(priv->htc);
 
@@ -1182,11 +1178,6 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = ath9k_htc_update_cap_target(priv);
-	if (ret)
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Failed to update capability in target\n");
-
 	priv->ah->opmode = vif->type;
 	priv->vif_slot |= (1 << avp->index);
 	priv->vif = vif;
-- 
1.7.4.1

