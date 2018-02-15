Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58510 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755206AbeBOItH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:49:07 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 06/13] ath10k: Add hif power-up/power-down methods
Date: Thu, 15 Feb 2018 14:19:02 +0530
Message-Id: <1518684542-5604-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_094913_922015_60A013B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add hif power-up/power-down methods for wcn3990
target.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 61 ++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index a39eee7..9d402e4 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -519,6 +519,65 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_snoc_init_pipes(struct ath10k *ar)
+{
+	int i, ret;
+
+	for (i = 0; i < CE_COUNT; i++) {
+		ret = ath10k_ce_init_pipe(ar, i, &host_ce_config_wlan[i]);
+		if (ret) {
+			ath10k_err(ar, "failed to initialize copy engine pipe %d: %d\n",
+				   i, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath10k_snoc_wlan_enable(struct ath10k *ar)
+{
+	return 0;
+}
+
+static void ath10k_snoc_wlan_disable(struct ath10k *ar)
+{
+}
+
+static void ath10k_snoc_hif_power_down(struct ath10k *ar)
+{
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power down\n");
+
+	ath10k_snoc_wlan_disable(ar);
+}
+
+static int ath10k_snoc_hif_power_up(struct ath10k *ar)
+{
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "%s:WCN3990 driver state = %d\n",
+		   __func__, ar->state);
+
+	ret = ath10k_snoc_wlan_enable(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to enable wcn3990: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_snoc_init_pipes(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to initialize CE: %d\n", ret);
+		goto err_wlan_enable;
+	}
+
+	return 0;
+
+err_wlan_enable:
+	ath10k_snoc_wlan_disable(ar);
+
+	return ret;
+}
+
 static const struct ath10k_hif_ops ath10k_snoc_hif_ops = {
 	.read32		= ath10k_snoc_read32,
 	.write32	= ath10k_snoc_write32,
@@ -526,6 +585,8 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 	.stop		= ath10k_snoc_hif_stop,
 	.map_service_to_pipe	= ath10k_snoc_hif_map_service_to_pipe,
 	.get_default_pipe	= ath10k_snoc_hif_get_default_pipe,
+	.power_up		= ath10k_snoc_hif_power_up,
+	.power_down		= ath10k_snoc_hif_power_down,
 };
 
 static const struct ath10k_bus_ops ath10k_snoc_bus_ops = {
-- 
1.9.1
