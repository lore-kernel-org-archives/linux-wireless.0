Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44780 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1AUDAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:00:14 -0500
Received: by pzk35 with SMTP id 35so218028pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:00:14 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63120.476359.846887@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:29:28 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 03/33] ath9k_htc: Fix error handling in add_interface
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Addition of a station might fail - handle this error
properly by removing the VAP on the target.
Also, bail out immediately if the max. no of interfaces
has been reached.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c960330..b3b33ff 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1138,7 +1138,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
 		ret = -ENOBUFS;
-		goto out;
+		mutex_unlock(&priv->mutex);
+		return ret;
 	}
 
 	ath9k_htc_ps_wakeup(priv);
@@ -1166,18 +1167,19 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	priv->nvifs++;
-
 	/*
 	 * We need a node in target to tx mgmt frames
 	 * before association.
 	 */
 	ret = ath9k_htc_add_station(priv, vif, NULL);
-	if (ret)
+	if (ret) {
+		WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
 		goto out;
+	}
 
 	priv->ah->opmode = vif->type;
 	priv->vif_slot |= (1 << avp->index);
+	priv->nvifs++;
 	priv->vif = vif;
 
 	ath_dbg(common, ATH_DBG_CONFIG,
-- 
1.7.3.5

