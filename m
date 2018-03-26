Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeCZFlx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:41:53 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 11/12] ath10k: Add wlan mode on/off qmi message
Date: Mon, 26 Mar 2018 11:11:44 +0530
Message-Id: <1522042904-26559-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_074156_344736_3A3A4353)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add qmi message required for enabling and disabling
target to qmi server running in Q6.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 226 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/qmi.h |  62 ++++++----
 2 files changed, 264 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index f23d0fe..331a528 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -35,7 +35,30 @@
 #define WLFW_CLIENT_ID			0x4b4e454c
 #define WLFW_TIMEOUT			500
 
-static struct ath10k_qmi *qmi;
+static struct ath10k_qmi {
+	struct platform_device *pdev;
+	struct qmi_handle qmi_hdl;
+	struct sockaddr_qrtr sq;
+	bool fw_ready;
+	bool msa_ready;
+	struct work_struct work_svc_arrive;
+	struct work_struct work_svc_exit;
+	struct work_struct work_msa_ready;
+	struct workqueue_struct *event_wq;
+	spinlock_t event_lock; /* spinlock for fw ready status*/
+	u32 nr_mem_region;
+	struct ath10k_msa_mem_region_info
+		mem_region[MAX_NUM_MEMORY_REGIONS];
+	phys_addr_t msa_pa;
+	u32 msa_mem_size;
+	void *msa_va;
+	struct ath10k_qmi_chip_info chip_info;
+	struct ath10k_qmi_board_info board_info;
+	struct ath10k_qmi_soc_info soc_info;
+	struct ath10k_qmi_fw_version_info fw_version_info;
+	char fw_build_id[MAX_BUILD_ID_LEN + 1];
+	struct ath10k_qmi_cal_data cal_data[MAX_NUM_CAL_V01];
+} *qmi;
 
 static int
 ath10k_qmi_map_msa_permissions(struct ath10k_msa_mem_region_info *mem_region)
@@ -444,6 +467,207 @@ int ath10k_qmi_send_cal_report_req(struct ath10k_qmi *qmi)
 	return ret;
 }
 
+static int
+ath10k_qmi_mode_send_sync_msg(enum wlfw_driver_mode_enum_v01 mode)
+{
+	struct wlfw_wlan_mode_resp_msg_v01 *resp;
+	struct wlfw_wlan_mode_req_msg_v01 *req;
+	struct qmi_txn txn;
+	int ret;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
+	if (!resp) {
+		kfree(req);
+		return -ENOMEM;
+	}
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_wlan_mode_resp_msg_v01_ei,
+			   resp);
+	if (ret < 0) {
+		pr_err("fail to init txn for mode req %d ret %d\n", mode, ret);
+		goto out;
+	}
+
+	req->mode = mode;
+	req->hw_debug_valid = 1;
+	req->hw_debug = 0;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_WLAN_MODE_REQ_V01,
+			       WLFW_WLAN_MODE_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_wlan_mode_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		pr_err("send mode req failed, mode: %d ret: %d\n",
+		       mode, ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		pr_err("qmi mode request rejected:");
+		pr_err("mode:%d result:%d error:%d\n",
+		       mode, resp->resp.result, resp->resp.error);
+		ret = resp->resp.result;
+		goto out;
+	}
+
+	pr_debug("wlan Mode request completed, mode: %d\n", mode);
+	kfree(resp);
+	kfree(req);
+	return 0;
+
+out:
+	kfree(resp);
+	kfree(req);
+	return ret;
+}
+
+static int
+ath10k_qmi_cfg_send_sync_msg(struct wlfw_wlan_cfg_req_msg_v01 *data)
+{
+	struct wlfw_wlan_cfg_resp_msg_v01 *resp;
+	struct wlfw_wlan_cfg_req_msg_v01 *req;
+	struct qmi_txn txn;
+	int ret;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
+	if (!resp) {
+		kfree(req);
+		return -ENOMEM;
+	}
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_wlan_cfg_resp_msg_v01_ei,
+			   resp);
+	if (ret < 0) {
+		pr_err("fail to init txn for config req %d\n", ret);
+		goto out;
+	}
+
+	memcpy(req, data, sizeof(*req));
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_WLAN_CFG_REQ_V01,
+			       WLFW_WLAN_CFG_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_wlan_cfg_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		pr_err("send config req failed %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		pr_err("qmi cfg request rejected:");
+		pr_err("result:%d error:%d\n",
+		       resp->resp.result, resp->resp.error);
+		ret = resp->resp.result;
+		goto out;
+	}
+
+	pr_debug("wlan config request completed\n");
+	kfree(resp);
+	kfree(req);
+	return 0;
+
+out:
+	kfree(resp);
+	kfree(req);
+	return ret;
+}
+
+int ath10k_qmi_wlan_enable(struct ath10k_qmi_wlan_enable_cfg *config,
+			   enum ath10k_qmi_driver_mode mode,
+			   const char *host_version)
+{
+	struct wlfw_wlan_cfg_req_msg_v01 req;
+	int ret;
+	u32 i;
+
+	pr_debug("mode: %d, config: %p:\n",
+		 mode, config);
+	memset(&req, 0, sizeof(req));
+	if (!config) {
+		pr_err("wlan enable Config Invalid:%p\n",
+		       config);
+		ret = -EINVAL;
+		return ret;
+	}
+
+	req.host_version_valid = 0;
+
+	req.tgt_cfg_valid = 1;
+	if (config->num_ce_tgt_cfg > QMI_WLFW_MAX_NUM_CE_V01)
+		req.tgt_cfg_len = QMI_WLFW_MAX_NUM_CE_V01;
+	else
+		req.tgt_cfg_len = config->num_ce_tgt_cfg;
+	for (i = 0; i < req.tgt_cfg_len; i++) {
+		req.tgt_cfg[i].pipe_num = config->ce_tgt_cfg[i].pipe_num;
+		req.tgt_cfg[i].pipe_dir = config->ce_tgt_cfg[i].pipe_dir;
+		req.tgt_cfg[i].nentries = config->ce_tgt_cfg[i].nentries;
+		req.tgt_cfg[i].nbytes_max = config->ce_tgt_cfg[i].nbytes_max;
+		req.tgt_cfg[i].flags = config->ce_tgt_cfg[i].flags;
+	}
+
+	req.svc_cfg_valid = 1;
+	if (config->num_ce_svc_pipe_cfg > QMI_WLFW_MAX_NUM_SVC_V01)
+		req.svc_cfg_len = QMI_WLFW_MAX_NUM_SVC_V01;
+	else
+		req.svc_cfg_len = config->num_ce_svc_pipe_cfg;
+	for (i = 0; i < req.svc_cfg_len; i++) {
+		req.svc_cfg[i].service_id = config->ce_svc_cfg[i].service_id;
+		req.svc_cfg[i].pipe_dir = config->ce_svc_cfg[i].pipe_dir;
+		req.svc_cfg[i].pipe_num = config->ce_svc_cfg[i].pipe_num;
+	}
+
+	req.shadow_reg_valid = 1;
+	if (config->num_shadow_reg_cfg >
+	    QMI_WLFW_MAX_NUM_SHADOW_REG_V01)
+		req.shadow_reg_len = QMI_WLFW_MAX_NUM_SHADOW_REG_V01;
+	else
+		req.shadow_reg_len = config->num_shadow_reg_cfg;
+
+	memcpy(req.shadow_reg, config->shadow_reg_cfg,
+	       sizeof(struct wlfw_shadow_reg_cfg_s_v01) * req.shadow_reg_len);
+
+	ret = ath10k_qmi_cfg_send_sync_msg(&req);
+	if (ret) {
+		pr_err("wlan qmi config send failed\n");
+		return ret;
+	}
+
+	ret = ath10k_qmi_mode_send_sync_msg(mode);
+	if (ret) {
+		pr_err("wlan qmi mode send failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ath10k_qmi_wlan_enable);
+
+int ath10k_qmi_wlan_disable(void)
+{
+	return ath10k_qmi_mode_send_sync_msg(QMI_WLFW_OFF_V01);
+}
+EXPORT_SYMBOL_GPL(ath10k_qmi_wlan_disable);
+
 static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
 {
 	struct wlfw_cap_resp_msg_v01 *resp;
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index 94f14d4..4d456c8 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -29,6 +29,13 @@ enum ath10k_qmi_driver_event_type {
 	ATH10K_QMI_EVENT_MAX,
 };
 
+enum ath10k_qmi_driver_mode {
+	QMI_MISSION,
+	QMI_FTM,
+	QMI_EPPING,
+	QMI_OFF,
+};
+
 struct ath10k_msa_mem_region_info {
 	u64 reg_addr;
 	u32 size;
@@ -59,28 +66,37 @@ struct ath10k_qmi_cal_data {
 	u8 *data;
 };
 
-struct ath10k_qmi {
-	struct platform_device *pdev;
-	struct qmi_handle qmi_hdl;
-	struct sockaddr_qrtr sq;
-	bool fw_ready;
-	bool msa_ready;
-	struct work_struct work_svc_arrive;
-	struct work_struct work_svc_exit;
-	struct work_struct work_msa_ready;
-	struct workqueue_struct *event_wq;
-	spinlock_t event_lock; /* spinlock for fw ready status*/
-	u32 nr_mem_region;
-	struct ath10k_msa_mem_region_info
-		mem_region[MAX_NUM_MEMORY_REGIONS];
-	phys_addr_t msa_pa;
-	u32 msa_mem_size;
-	void *msa_va;
-	struct ath10k_qmi_chip_info chip_info;
-	struct ath10k_qmi_board_info board_info;
-	struct ath10k_qmi_soc_info soc_info;
-	struct ath10k_qmi_fw_version_info fw_version_info;
-	char fw_build_id[MAX_BUILD_ID_LEN + 1];
-	struct ath10k_qmi_cal_data cal_data[MAX_NUM_CAL_V01];
+struct ath10k_tgt_pipe_cfg {
+	u32 pipe_num;
+	u32 pipe_dir;
+	u32 nentries;
+	u32 nbytes_max;
+	u32 flags;
+	u32 reserved;
 };
+
+struct ath10k_svc_pipe_cfg {
+	u32 service_id;
+	u32 pipe_dir;
+	u32 pipe_num;
+};
+
+struct ath10k_shadow_reg_cfg {
+	u16 ce_id;
+	u16 reg_offset;
+};
+
+struct ath10k_qmi_wlan_enable_cfg {
+	u32 num_ce_tgt_cfg;
+	struct ath10k_tgt_pipe_cfg *ce_tgt_cfg;
+	u32 num_ce_svc_pipe_cfg;
+	struct ath10k_svc_pipe_cfg *ce_svc_cfg;
+	u32 num_shadow_reg_cfg;
+	struct ath10k_shadow_reg_cfg *shadow_reg_cfg;
+};
+
+int ath10k_qmi_wlan_enable(struct ath10k_qmi_wlan_enable_cfg *config,
+			   enum ath10k_qmi_driver_mode mode,
+			   const char *host_version);
+int ath10k_qmi_wlan_disable(void);
 #endif /* _QMI_H_ */
-- 
1.9.1
