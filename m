Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44816 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeCZFkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:40:53 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 08/12] ath10k: Add QMI CAP request support
Date: Mon, 26 Mar 2018 11:10:47 +0530
Message-Id: <1522042847-26245-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_074056_506866_921FDE5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for target capablity request
qmi message for wcn3990 target.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 91 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/qmi.h | 25 ++++++++++
 2 files changed, 116 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 763b812..65a43af 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -270,6 +270,93 @@ static int ath10k_qmi_msa_ready_send_sync_msg(struct ath10k_qmi *qmi)
 	return ret;
 }
 
+static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
+{
+	struct wlfw_cap_resp_msg_v01 *resp;
+	struct wlfw_cap_req_msg_v01 *req;
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
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_cap_resp_msg_v01_ei, resp);
+	if (ret < 0) {
+		pr_err("fail to init txn for capability resp %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_CAP_REQ_V01,
+			       WLFW_CAP_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_cap_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		pr_err("fail to send capability req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		pr_err("qmi capability request rejected, result:%d error:%d\n",
+		       resp->resp.result, resp->resp.error);
+		ret = -resp->resp.result;
+		goto out;
+	}
+
+	if (resp->chip_info_valid) {
+		qmi->chip_info.chip_id = resp->chip_info.chip_id;
+		qmi->chip_info.chip_family = resp->chip_info.chip_family;
+	}
+
+	if (resp->board_info_valid)
+		qmi->board_info.board_id = resp->board_info.board_id;
+	else
+		qmi->board_info.board_id = 0xFF;
+
+	if (resp->soc_info_valid)
+		qmi->soc_info.soc_id = resp->soc_info.soc_id;
+
+	if (resp->fw_version_info_valid) {
+		qmi->fw_version_info.fw_version =
+			resp->fw_version_info.fw_version;
+		strlcpy(qmi->fw_version_info.fw_build_timestamp,
+			resp->fw_version_info.fw_build_timestamp,
+			MAX_TIMESTAMP_LEN + 1);
+	}
+
+	if (resp->fw_build_id_valid)
+		strlcpy(qmi->fw_build_id, resp->fw_build_id,
+			MAX_BUILD_ID_LEN + 1);
+
+	pr_debug("chip_id: 0x%x, chip_family: 0x%x, board_id: 0x%x, soc_id: 0x%x, fw_version: 0x%x, fw_build_timestamp: %s, fw_build_id: %s",
+		 qmi->chip_info.chip_id, qmi->chip_info.chip_family,
+		 qmi->board_info.board_id, qmi->soc_info.soc_id,
+		 qmi->fw_version_info.fw_version,
+		 qmi->fw_version_info.fw_build_timestamp,
+		 qmi->fw_build_id);
+
+	pr_debug("target cap request completed\n");
+	kfree(resp);
+	kfree(req);
+
+	return 0;
+out:
+	kfree(resp);
+	kfree(req);
+	return ret;
+}
+
 static int
 ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
 {
@@ -425,6 +512,10 @@ static void ath10k_qmi_event_server_arrive(struct work_struct *work)
 	if (ret)
 		goto err_setup_msa;
 
+	ret = ath10k_qmi_cap_send_sync_msg(qmi);
+	if (ret)
+		goto err_setup_msa;
+
 	return;
 
 err_setup_msa:
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index 47af020..09d20a0 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -17,6 +17,8 @@
 #define _QMI_H_
 
 #define MAX_NUM_MEMORY_REGIONS			2
+#define MAX_TIMESTAMP_LEN			32
+#define MAX_BUILD_ID_LEN			128
 
 enum ath10k_qmi_driver_event_type {
 	ATH10K_QMI_EVENT_SERVER_ARRIVE,
@@ -31,6 +33,24 @@ struct ath10k_msa_mem_region_info {
 	u8 secure_flag;
 };
 
+struct ath10k_qmi_chip_info {
+	u32 chip_id;
+	u32 chip_family;
+};
+
+struct ath10k_qmi_board_info {
+	u32 board_id;
+};
+
+struct ath10k_qmi_soc_info {
+	u32 soc_id;
+};
+
+struct ath10k_qmi_fw_version_info {
+	u32 fw_version;
+	char fw_build_timestamp[MAX_TIMESTAMP_LEN + 1];
+};
+
 struct ath10k_qmi {
 	struct platform_device *pdev;
 	struct qmi_handle qmi_hdl;
@@ -47,5 +67,10 @@ struct ath10k_qmi {
 	phys_addr_t msa_pa;
 	u32 msa_mem_size;
 	void *msa_va;
+	struct ath10k_qmi_chip_info chip_info;
+	struct ath10k_qmi_board_info board_info;
+	struct ath10k_qmi_soc_info soc_info;
+	struct ath10k_qmi_fw_version_info fw_version_info;
+	char fw_build_id[MAX_BUILD_ID_LEN + 1];
 };
 #endif /* _QMI_H_ */
-- 
1.9.1
