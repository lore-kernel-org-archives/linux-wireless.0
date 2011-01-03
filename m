Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:43885 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1ACPwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 10:52:40 -0500
Received: by pxi15 with SMTP id 15so2472970pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 07:52:40 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19745.61618.822195.30087@gargle.gargle.HOWL>
Date: Mon, 3 Jan 2011 21:22:18 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@atheros.com
Subject: [PATCH] ath9k_htc: Fix packet injection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

To inject a packet in monitor mode, a dummy station has
to be associated with the monitor interface in the target.
Failing to do this would result in a firmware crash on the device.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   72 ++++++++++++++++++++++---
 1 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ad3dd31..845b4c9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -235,16 +235,38 @@ err:
 	return ret;
 }
 
+static void __ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_vif hvif;
+	int ret = 0;
+	u8 cmd_rsp;
+
+	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
+	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
+	hvif.index = 0; /* Should do for now */
+	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
+	priv->nvifs--;
+}
+
 static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_target_vif hvif;
+	struct ath9k_htc_target_sta tsta;
 	int ret = 0;
 	u8 cmd_rsp;
 
 	if (priv->nvifs > 0)
 		return -ENOBUFS;
 
+	if (priv->nstations >= ATH9K_HTC_MAX_STA)
+		return -ENOBUFS;
+
+	/*
+	 * Add an interface.
+	 */
+
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
 	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
 
@@ -257,23 +279,57 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 		return ret;
 
 	priv->nvifs++;
+
+	/*
+	 * Associate a station with the interface for packet injection.
+	 */
+
+	memset(&tsta, 0, sizeof(struct ath9k_htc_target_sta));
+
+	memcpy(&tsta.macaddr, common->macaddr, ETH_ALEN);
+
+	tsta.is_vif_sta = 1;
+	tsta.sta_index = priv->nstations;
+	tsta.vif_index = hvif.index;
+	tsta.maxampdu = 0xffff;
+
+	WMI_CMD_BUF(WMI_NODE_CREATE_CMDID, &tsta);
+	if (ret) {
+		ath_err(common, "Unable to add station entry for monitor mode\n");
+		goto err_vif;
+	}
+
+	priv->nstations++;
+
 	return 0;
+
+err_vif:
+	/*
+	 * Remove the interface from the target.
+	 */
+	__ath9k_htc_remove_monitor_interface(priv);
+	return ret;
 }
 
 static int ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct ath9k_htc_target_vif hvif;
 	int ret = 0;
-	u8 cmd_rsp;
+	u8 cmd_rsp, sta_idx;
 
-	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
-	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
-	hvif.index = 0; /* Should do for now */
-	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
-	priv->nvifs--;
+	__ath9k_htc_remove_monitor_interface(priv);
 
-	return ret;
+	sta_idx = 0; /* Only single interface, for now */
+
+	WMI_CMD_BUF(WMI_NODE_REMOVE_CMDID, &sta_idx);
+	if (ret) {
+		ath_err(common, "Unable to remove station entry for monitor mode\n");
+		return ret;
+	}
+
+	priv->nstations--;
+
+	return 0;
 }
 
 static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
-- 
1.7.3.4

