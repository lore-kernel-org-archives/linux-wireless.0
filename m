Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:33613 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab2B2RTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:42 -0500
Subject: [PATCH 08/12] ath6kl: fix error handling
	ath6kl_target_config_wlan_params()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:19:38 +0200
Message-ID: <20120229171937.24264.92914.stgit@localhost6.localdomain6> (sfid-20120229_181945_981378_BF36462D)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The error handling in ath6kl_target_config_wlan_params() was just weird,
fix that. This also fixes some of the open parenthesis alignment issues
reported by checkpatch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   66 ++++++++++++++++++--------------
 1 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d1d121d..c7d5149 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -378,7 +378,6 @@ out:
 
 static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 {
-	int status = 0;
 	int ret;
 
 	/*
@@ -386,43 +385,54 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 	 * default values. Required if checksum offload is needed. Set
 	 * RxMetaVersion to 2.
 	 */
-	if (ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi, idx,
-					       ar->rx_meta_ver, 0, 0)) {
-		ath6kl_err("unable to set the rx frame format\n");
-		status = -EIO;
+	ret = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi, idx,
+						 ar->rx_meta_ver, 0, 0);
+	if (ret) {
+		ath6kl_err("unable to set the rx frame format: %d\n", ret);
+		return ret;
 	}
 
-	if (ar->conf_flags & ATH6KL_CONF_IGNORE_PS_FAIL_EVT_IN_SCAN)
-		if ((ath6kl_wmi_pmparams_cmd(ar->wmi, idx, 0, 1, 0, 0, 1,
-		     IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN)) != 0) {
-			ath6kl_err("unable to set power save fail event policy\n");
-			status = -EIO;
+	if (ar->conf_flags & ATH6KL_CONF_IGNORE_PS_FAIL_EVT_IN_SCAN) {
+		ret = ath6kl_wmi_pmparams_cmd(ar->wmi, idx, 0, 1, 0, 0, 1,
+					      IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN);
+		if (ret) {
+			ath6kl_err("unable to set power save fail event policy: %d\n",
+				   ret);
+			return ret;
 		}
+	}
 
-	if (!(ar->conf_flags & ATH6KL_CONF_IGNORE_ERP_BARKER))
-		if ((ath6kl_wmi_set_lpreamble_cmd(ar->wmi, idx, 0,
-		     WMI_DONOT_IGNORE_BARKER_IN_ERP)) != 0) {
-			ath6kl_err("unable to set barker preamble policy\n");
-			status = -EIO;
+	if (!(ar->conf_flags & ATH6KL_CONF_IGNORE_ERP_BARKER)) {
+		ret = ath6kl_wmi_set_lpreamble_cmd(ar->wmi, idx, 0,
+						   WMI_DONOT_IGNORE_BARKER_IN_ERP);
+		if (ret) {
+			ath6kl_err("unable to set barker preamble policy: %d\n",
+				   ret);
+			return ret;
 		}
+	}
 
-	if (ath6kl_wmi_set_keepalive_cmd(ar->wmi, idx,
-					 WLAN_CONFIG_KEEP_ALIVE_INTERVAL)) {
-		ath6kl_err("unable to set keep alive interval\n");
-		status = -EIO;
+	ret = ath6kl_wmi_set_keepalive_cmd(ar->wmi, idx,
+					   WLAN_CONFIG_KEEP_ALIVE_INTERVAL);
+	if (ret) {
+		ath6kl_err("unable to set keep alive interval: %d\n", ret);
+		return ret;
 	}
 
-	if (ath6kl_wmi_disctimeout_cmd(ar->wmi, idx,
-				       WLAN_CONFIG_DISCONNECT_TIMEOUT)) {
-		ath6kl_err("unable to set disconnect timeout\n");
-		status = -EIO;
+	ret = ath6kl_wmi_disctimeout_cmd(ar->wmi, idx,
+					 WLAN_CONFIG_DISCONNECT_TIMEOUT);
+	if (ret) {
+		ath6kl_err("unable to set disconnect timeout: %d\n", ret);
+		return ret;
 	}
 
-	if (!(ar->conf_flags & ATH6KL_CONF_ENABLE_TX_BURST))
-		if (ath6kl_wmi_set_wmm_txop(ar->wmi, idx, WMI_TXOP_DISABLED)) {
-			ath6kl_err("unable to set txop bursting\n");
-			status = -EIO;
+	if (!(ar->conf_flags & ATH6KL_CONF_ENABLE_TX_BURST)) {
+		ret = ath6kl_wmi_set_wmm_txop(ar->wmi, idx, WMI_TXOP_DISABLED);
+		if (ret) {
+			ath6kl_err("unable to set txop bursting: %d\n", ret);
+			return ret;
 		}
+	}
 
 	if (ar->p2p && (ar->vif_max == 1 || idx)) {
 		ret = ath6kl_wmi_info_req_cmd(ar->wmi, idx,
@@ -446,7 +456,7 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 		}
 	}
 
-	return status;
+	return ret;
 }
 
 int ath6kl_configure_target(struct ath6kl *ar)

