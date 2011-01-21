Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40986 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1AUDAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:00:02 -0500
Received: by mail-iy0-f174.google.com with SMTP id 18so1245111iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:00:02 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63108.720163.333915@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:29:16 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 02/33] ath9k_htc: Unify target capability updation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Update capabilites on the target once, when
start() is called, there is no need for redundant
updation on adding an interface.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e8e512a..c960330 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -327,15 +327,6 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 
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
 
@@ -1058,6 +1049,11 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	ath9k_host_rx_init(priv);
 
+	ret = ath9k_htc_update_cap_target(priv);
+	if (ret)
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Failed to update capability in target\n");
+
 	priv->op_flags &= ~OP_INVALID;
 	htc_start(priv->htc);
 
@@ -1180,11 +1176,6 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
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
1.7.3.5

