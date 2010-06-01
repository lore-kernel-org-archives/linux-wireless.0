Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42269 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0FAKNv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 06:13:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 03:13:51 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.56743.50858.600654@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:45:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/13] ath9k_htc: Handle monitor interface removal
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The monitor interface instance on the target has
to be removed before setting it to FULLSLEEP.
Handle this properly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5dad5cd..1ed88fb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1266,12 +1266,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
-	ath9k_hw_phy_disable(ah);
-	ath9k_hw_disable(ah);
-	ath9k_hw_configpcipowersave(ah, 1, 1);
-	ath9k_htc_ps_restore(priv);
-	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
-
 	skb_queue_purge(&priv->tx_queue);
 
 	/* Remove monitor interface here */
@@ -1284,6 +1278,12 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 				  "Monitor interface removed\n");
 	}
 
+	ath9k_hw_phy_disable(ah);
+	ath9k_hw_disable(ah);
+	ath9k_hw_configpcipowersave(ah, 1, 1);
+	ath9k_htc_ps_restore(priv);
+	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
+
 	priv->op_flags |= OP_INVALID;
 
 	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");
-- 
1.7.1

