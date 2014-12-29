Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46783 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaL2GTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:19:09 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Enable RX batching
Date: Mon, 29 Dec 2014 11:51:24 +0530
Message-Id: <1419834084-11859-1-git-send-email-sujith@msujith.org> (sfid-20141229_071947_840315_F856CB21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This feature allows the FW to batch RX indications,
reducing the rate of host interrupt generation, which
in turn reduces CPU load. Currently, this is enabled
only for the 10.2 firmware.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b103122..aad08a2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3710,7 +3710,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	struct wmi_init_cmd_10_2 *cmd;
 	struct sk_buff *buf;
 	struct wmi_resource_config_10x config = {};
-	u32 len, val;
+	u32 len, val, features = 0;
 
 	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
 	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
@@ -3764,6 +3764,9 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 
 	cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
+	features |= WMI_10_2_RX_BATCH_MODE;
+	cmd->resource_config.feature_mask = __cpu_to_le32(features);
+
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
 	ath10k_wmi_put_host_mem_chunks(ar, &cmd->mem_chunks);
 
-- 
2.2.1

