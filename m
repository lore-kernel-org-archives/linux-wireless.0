Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64181 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1BUC0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:26:09 -0500
Received: by ywj3 with SMTP id 3so600977ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:26:08 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52072.748100.382094@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:48:16 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 04/23] ath9k_htc: Fix error handling in add_interface
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
index 4ced5cd..ebc5dbf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1140,7 +1140,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
 		ret = -ENOBUFS;
-		goto out;
+		mutex_unlock(&priv->mutex);
+		return ret;
 	}
 
 	ath9k_htc_ps_wakeup(priv);
@@ -1168,18 +1169,19 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
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
1.7.4.1

