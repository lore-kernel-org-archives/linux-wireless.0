Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15252 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:22:57 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 07/11] ath6kl: Move initialization/deinitialization of scan_table to appropriate functions
Date: Sat, 23 Jul 2011 19:43:13 +0530
Message-ID: <1311430397-4960-7-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162259_788093_CD42F4B6)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By having scan_table in struct ath6kl, it makes sense to move initialization
to ath6kl_init() and deinitialization to ath6kl_destroy().

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    9 +++++++--
 drivers/net/wireless/ath/ath6kl/wmi.c  |    2 --
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 1d6294f..e8ec617 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1062,6 +1062,8 @@ static int ath6kl_init(struct net_device *dev)
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: got wmi @ 0x%p.\n", __func__, ar->wmi);
 
+	wlan_node_table_init(&ar->scan_table);
+
 	/*
 	 * The reason we have to wait for the target here is that the
 	 * driver layer has to init BMI in order to set the host block
@@ -1069,7 +1071,7 @@ static int ath6kl_init(struct net_device *dev)
 	 */
 	if (htc_wait_target(ar->htc_target)) {
 		status = -EIO;
-		goto err_wmi_cleanup;
+		goto err_node_cleanup;
 	}
 
 	if (ath6kl_init_service_ep(ar)) {
@@ -1142,7 +1144,8 @@ err_rxbuf_cleanup:
 	ath6kl_cleanup_amsdu_rxbufs(ar);
 err_cleanup_scatter:
 	ath6kl_hif_cleanup_scatter(ar);
-err_wmi_cleanup:
+err_node_cleanup:
+	wlan_node_table_cleanup(&ar->scan_table);
 	ath6kl_wmi_shutdown(ar->wmi);
 	clear_bit(WMI_ENABLED, &ar->flag);
 	ar->wmi = NULL;
@@ -1289,5 +1292,7 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 
 	free_netdev(dev);
 
+	wlan_node_table_cleanup(&ar->scan_table);
+
 	ath6kl_cfg80211_deinit(ar);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 6f145d4..742eaa1 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2727,7 +2727,6 @@ void *ath6kl_wmi_init(struct ath6kl *dev)
 
 	wmi->parent_dev = dev;
 
-	wlan_node_table_init(&dev->scan_table);
 	ath6kl_wmi_qos_state_init(wmi);
 
 	wmi->pwr_mode = REC_POWER;
@@ -2747,6 +2746,5 @@ void ath6kl_wmi_shutdown(struct wmi *wmi)
 	if (!wmi)
 		return;
 
-	wlan_node_table_cleanup(&wmi->parent_dev->scan_table);
 	kfree(wmi);
 }
-- 
1.7.0.4

