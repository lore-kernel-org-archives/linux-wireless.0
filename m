Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeCZFlc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:41:32 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 10/12] ath10k: add bdf/cal indication support
Date: Mon, 26 Mar 2018 11:11:26 +0530
Message-Id: <1522042886-26343-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_074135_504214_2FC6428C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for bdf download and cold boot
calibration trigger qmi message support.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 195 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/qmi.h |  10 ++
 2 files changed, 205 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index a33681d..f23d0fe 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -28,6 +28,7 @@
 #include <linux/soc/qcom/qmi.h>
 #include <linux/qcom_scm.h>
 #include <linux/of.h>
+#include <linux/firmware.h>
 #include "qmi.h"
 #include "qmi_svc_v01.h"
 
@@ -270,6 +271,179 @@ static int ath10k_qmi_msa_ready_send_sync_msg(struct ath10k_qmi *qmi)
 	return ret;
 }
 
+int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
+{
+	struct wlfw_bdf_download_resp_msg_v01 *resp;
+	struct wlfw_bdf_download_req_msg_v01 *req;
+	const struct firmware *fw_entry;
+	unsigned int remaining;
+	struct qmi_txn txn;
+	const u8 *temp;
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
+	ret = request_firmware(&fw_entry, BDF_FILE_NAME, &qmi->pdev->dev);
+	if (ret < 0) {
+		pr_err("fail to load bdf: %s\n", BDF_FILE_NAME);
+		goto err_req_fw;
+	}
+
+	temp = fw_entry->data;
+	remaining = fw_entry->size;
+
+	pr_debug("downloading bdf: %s, size: %u\n",
+		 BDF_FILE_NAME, remaining);
+
+	while (remaining) {
+		req->valid = 1;
+		req->file_id_valid = 1;
+		req->file_id = 0;
+		req->total_size_valid = 1;
+		req->total_size = fw_entry->size;
+		req->seg_id_valid = 1;
+		req->data_valid = 1;
+		req->end_valid = 1;
+
+		if (remaining > QMI_WLFW_MAX_DATA_SIZE_V01) {
+			req->data_len = QMI_WLFW_MAX_DATA_SIZE_V01;
+		} else {
+			req->data_len = remaining;
+			req->end = 1;
+		}
+
+		memcpy(req->data, temp, req->data_len);
+
+		ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+				   wlfw_bdf_download_resp_msg_v01_ei,
+				   resp);
+		if (ret < 0) {
+			pr_err("fail to init txn for bdf download %d\n", ret);
+			goto out;
+		}
+
+		ret =
+		qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+				 QMI_WLFW_BDF_DOWNLOAD_REQ_V01,
+				 WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
+				 wlfw_bdf_download_req_msg_v01_ei, req);
+		if (ret < 0) {
+			qmi_txn_cancel(&txn);
+			goto err_send;
+		}
+
+		ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+
+		if (ret < 0)
+			goto err_send;
+
+		if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+			pr_err("bdf download failed, res:%d, err:%d\n",
+			       resp->resp.result, resp->resp.error);
+			ret = resp->resp.result;
+			goto err_send;
+		}
+
+		remaining -= req->data_len;
+		temp += req->data_len;
+		req->seg_id++;
+	}
+
+	pr_debug("bdf download request completed\n");
+
+	kfree(resp);
+	kfree(req);
+	return 0;
+
+err_send:
+	release_firmware(fw_entry);
+
+err_req_fw:
+	kfree(req);
+	kfree(resp);
+
+out:
+	return ret;
+}
+
+int ath10k_qmi_send_cal_report_req(struct ath10k_qmi *qmi)
+{
+	struct wlfw_cal_report_resp_msg_v01 *resp;
+	struct wlfw_cal_report_req_msg_v01 *req;
+	struct qmi_txn txn;
+	int i, j = 0;
+	int ret;
+
+	pr_debug("sending cal report\n");
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
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_cal_report_resp_msg_v01_ei,
+			   resp);
+	if (ret < 0) {
+		pr_err("fail to init txn for bdf download req %d\n", ret);
+		goto out;
+	}
+
+	for (i = 0; i < QMI_WLFW_MAX_NUM_CAL_V01; i++) {
+		if (qmi->cal_data[i].total_size &&
+		    qmi->cal_data[i].data) {
+			req->meta_data[j] = qmi->cal_data[i].cal_id;
+			j++;
+		}
+	}
+	req->meta_data_len = j;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_CAL_REPORT_REQ_V01,
+			       WLFW_CAL_REPORT_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_cal_report_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		pr_err("fail to send cal req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		pr_err("qmi cal reoprt request rejected:");
+		pr_err("resut:%d error:%d\n",
+		       resp->resp.result, resp->resp.error);
+		ret = resp->resp.result;
+		goto out;
+	}
+
+	pr_debug("cal report request completed\n");
+
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
 static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
 {
 	struct wlfw_cap_resp_msg_v01 *resp;
@@ -509,6 +683,7 @@ static void ath10k_qmi_msa_ready_ind(struct qmi_handle *qmi_hdl,
 	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
 
 	qmi->msa_ready = true;
+	queue_work(qmi->event_wq, &qmi->work_msa_ready);
 }
 
 static struct qmi_msg_handler qmi_msg_handler[] = {
@@ -599,6 +774,24 @@ static void ath10k_qmi_event_server_exit(struct work_struct *work)
 	pr_info("wlan fw service disconnected\n");
 }
 
+static void ath10k_qmi_event_msa_ready(struct work_struct *work)
+{
+	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
+					      work_msa_ready);
+	int ret;
+
+	ret = ath10k_qmi_bdf_dnld_send_sync(qmi);
+	if (ret)
+		goto out;
+
+	ret = ath10k_qmi_send_cal_report_req(qmi);
+	if (ret)
+		goto out;
+
+out:
+	return;
+}
+
 static int ath10k_qmi_new_server(struct qmi_handle *qmi_hdl,
 				 struct qmi_service *service)
 {
@@ -649,6 +842,7 @@ static int ath10k_alloc_qmi_resources(struct ath10k_qmi *qmi)
 	spin_lock_init(&qmi->event_lock);
 	INIT_WORK(&qmi->work_svc_arrive, ath10k_qmi_event_server_arrive);
 	INIT_WORK(&qmi->work_svc_exit, ath10k_qmi_event_server_exit);
+	INIT_WORK(&qmi->work_msa_ready, ath10k_qmi_event_msa_ready);
 
 	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
 			     WLFW_SERVICE_VERS_V01, 0);
@@ -696,6 +890,7 @@ static void ath10k_remove_qmi_resources(struct ath10k_qmi *qmi)
 {
 	cancel_work_sync(&qmi->work_svc_arrive);
 	cancel_work_sync(&qmi->work_svc_exit);
+	cancel_work_sync(&qmi->work_msa_ready);
 	destroy_workqueue(qmi->event_wq);
 	qmi_handle_release(&qmi->qmi_hdl);
 	qmi = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index 09d20a0..94f14d4 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -19,6 +19,8 @@
 #define MAX_NUM_MEMORY_REGIONS			2
 #define MAX_TIMESTAMP_LEN			32
 #define MAX_BUILD_ID_LEN			128
+#define BDF_FILE_NAME			"bdwlan.bin"
+#define MAX_NUM_CAL_V01			5
 
 enum ath10k_qmi_driver_event_type {
 	ATH10K_QMI_EVENT_SERVER_ARRIVE,
@@ -51,6 +53,12 @@ struct ath10k_qmi_fw_version_info {
 	char fw_build_timestamp[MAX_TIMESTAMP_LEN + 1];
 };
 
+struct ath10k_qmi_cal_data {
+	u32 cal_id;
+	u32 total_size;
+	u8 *data;
+};
+
 struct ath10k_qmi {
 	struct platform_device *pdev;
 	struct qmi_handle qmi_hdl;
@@ -59,6 +67,7 @@ struct ath10k_qmi {
 	bool msa_ready;
 	struct work_struct work_svc_arrive;
 	struct work_struct work_svc_exit;
+	struct work_struct work_msa_ready;
 	struct workqueue_struct *event_wq;
 	spinlock_t event_lock; /* spinlock for fw ready status*/
 	u32 nr_mem_region;
@@ -72,5 +81,6 @@ struct ath10k_qmi {
 	struct ath10k_qmi_soc_info soc_info;
 	struct ath10k_qmi_fw_version_info fw_version_info;
 	char fw_build_id[MAX_BUILD_ID_LEN + 1];
+	struct ath10k_qmi_cal_data cal_data[MAX_NUM_CAL_V01];
 };
 #endif /* _QMI_H_ */
-- 
1.9.1
