Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeCZFmQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:42:16 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 12/12] ath10k: Add qmi wlan enable/disable support for WCN3990
Date: Mon, 26 Mar 2018 11:12:08 +0530
Message-Id: <1522042928-26618-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_074219_281293_84272F17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send wlan mode on/off request dynamically to bring up
target to active state during load and put in power
down state during unload.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 179 ++++++++++++++++++++++++++++++++-
 1 file changed, 178 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 2e490ff..f6592a9 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -21,6 +21,7 @@
 #include "htc.h"
 #include "ce.h"
 #include "snoc.h"
+#include "qmi.h"
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -67,6 +68,24 @@
 	.dma_mask = DMA_BIT_MASK(37),
 };
 
+#define WCN3990_SRC_WR_INDEX_OFFSET 0x3C
+#define WCN3990_DST_WR_INDEX_OFFSET 0x40
+
+static struct ath10k_shadow_reg_cfg target_shadow_reg_cfg_map[] = {
+		{ 0, WCN3990_SRC_WR_INDEX_OFFSET},
+		{ 3, WCN3990_SRC_WR_INDEX_OFFSET},
+		{ 4, WCN3990_SRC_WR_INDEX_OFFSET},
+		{ 5, WCN3990_SRC_WR_INDEX_OFFSET},
+		{ 7, WCN3990_SRC_WR_INDEX_OFFSET},
+		{ 1, WCN3990_DST_WR_INDEX_OFFSET},
+		{ 2, WCN3990_DST_WR_INDEX_OFFSET},
+		{ 7, WCN3990_DST_WR_INDEX_OFFSET},
+		{ 8, WCN3990_DST_WR_INDEX_OFFSET},
+		{ 9, WCN3990_DST_WR_INDEX_OFFSET},
+		{ 10, WCN3990_DST_WR_INDEX_OFFSET},
+		{ 11, WCN3990_DST_WR_INDEX_OFFSET},
+};
+
 static struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control streams */
 	{
@@ -174,6 +193,128 @@
 	},
 };
 
+static struct ce_pipe_config target_ce_config_wlan[] = {
+	/* CE0: host->target HTC control and raw streams */
+	{
+		.pipenum = __cpu_to_le32(0),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE1: target->host HTT + HTC control */
+	{
+		.pipenum = __cpu_to_le32(1),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE2: target->host WMI */
+	{
+		.pipenum = __cpu_to_le32(2),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(64),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE3: host->target WMI */
+	{
+		.pipenum = __cpu_to_le32(3),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE4: host->target HTT */
+	{
+		.pipenum = __cpu_to_le32(4),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(256),
+		.nbytes_max = __cpu_to_le32(256),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS | CE_ATTR_DIS_INTR),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE5: target->host HTT (HIF->HTT) */
+	{
+		.pipenum = __cpu_to_le32(5),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(1024),
+		.nbytes_max = __cpu_to_le32(64),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS | CE_ATTR_DIS_INTR),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE6: Reserved for target autonomous hif_memcpy */
+	{
+		.pipenum = __cpu_to_le32(6),
+		.pipedir = __cpu_to_le32(PIPEDIR_INOUT),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(16384),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE7 used only by Host */
+	{
+		.pipenum = __cpu_to_le32(7),
+		.pipedir = __cpu_to_le32(4),
+		.nentries = __cpu_to_le32(0),
+		.nbytes_max = __cpu_to_le32(0),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS | CE_ATTR_DIS_INTR),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE8 Target to uMC */
+	{
+		.pipenum = __cpu_to_le32(8),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(0),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE9 target->host HTT */
+	{
+		.pipenum = __cpu_to_le32(9),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE10 target->host HTT */
+	{
+		.pipenum = __cpu_to_le32(10),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+
+	/* CE11 target autonomous qcache memcpy */
+	{
+		.pipenum = __cpu_to_le32(11),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
+	},
+};
+
 static struct service_to_pipe target_service_to_ce_map_wlan[] = {
 	{
 		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_VO),
@@ -755,11 +896,47 @@ static int ath10k_snoc_init_pipes(struct ath10k *ar)
 
 static int ath10k_snoc_wlan_enable(struct ath10k *ar)
 {
-	return 0;
+	struct ath10k_tgt_pipe_cfg tgt_cfg[CE_COUNT_MAX];
+	struct ath10k_qmi_wlan_enable_cfg cfg;
+	enum ath10k_qmi_driver_mode mode;
+	int pipe_num;
+
+	for (pipe_num = 0; pipe_num < CE_COUNT_MAX; pipe_num++) {
+		tgt_cfg[pipe_num].pipe_num =
+				target_ce_config_wlan[pipe_num].pipenum;
+		tgt_cfg[pipe_num].pipe_dir =
+				target_ce_config_wlan[pipe_num].pipedir;
+		tgt_cfg[pipe_num].nentries =
+				target_ce_config_wlan[pipe_num].nentries;
+		tgt_cfg[pipe_num].nbytes_max =
+				target_ce_config_wlan[pipe_num].nbytes_max;
+		tgt_cfg[pipe_num].flags =
+				target_ce_config_wlan[pipe_num].flags;
+		tgt_cfg[pipe_num].reserved = 0;
+	}
+
+	cfg.num_ce_tgt_cfg = sizeof(target_ce_config_wlan) /
+				sizeof(struct ath10k_tgt_pipe_cfg);
+	cfg.ce_tgt_cfg = (struct ath10k_tgt_pipe_cfg *)
+		&tgt_cfg;
+	cfg.num_ce_svc_pipe_cfg = sizeof(target_service_to_ce_map_wlan) /
+				  sizeof(struct ath10k_svc_pipe_cfg);
+	cfg.ce_svc_cfg = (struct ath10k_svc_pipe_cfg *)
+		&target_service_to_ce_map_wlan;
+	cfg.num_shadow_reg_cfg = sizeof(target_shadow_reg_cfg_map) /
+					sizeof(struct ath10k_shadow_reg_cfg);
+	cfg.shadow_reg_cfg = (struct ath10k_shadow_reg_cfg *)
+		&target_shadow_reg_cfg_map;
+
+	mode = ar->testmode.utf_monitor ? QMI_FTM : QMI_MISSION;
+
+	return ath10k_qmi_wlan_enable(&cfg, mode,
+				       NULL);
 }
 
 static void ath10k_snoc_wlan_disable(struct ath10k *ar)
 {
+	ath10k_qmi_wlan_disable();
 }
 
 static void ath10k_snoc_hif_power_down(struct ath10k *ar)
-- 
1.9.1
