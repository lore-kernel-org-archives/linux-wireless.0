Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeCZFlP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:41:15 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 09/12] ath10k: Add QMI HOST CAP request support
Date: Mon, 26 Mar 2018 11:11:06 +0530
Message-Id: <1522042866-26304-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_074118_661217_529B3C92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for host capablity request
qmi message for wcn3990 target.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 65 +++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 65a43af..a33681d 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -357,6 +357,67 @@ static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
 	return ret;
 }
 
+static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
+{
+	struct wlfw_host_cap_resp_msg_v01 *resp;
+	struct wlfw_host_cap_req_msg_v01 *req;
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
+	req->daemon_support_valid = 1;
+	req->daemon_support = 0;
+
+	pr_debug("daemon_support is %d\n", req->daemon_support);
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_host_cap_resp_msg_v01_ei, resp);
+	if (ret < 0) {
+		pr_err("Fail to init txn for Capability resp %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_HOST_CAP_REQ_V01,
+			       WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_host_cap_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		pr_err("Fail to send Capability req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		pr_err("qmi host capability req rejected, result:%d error:%d\n",
+		       resp->resp.result, resp->resp.error);
+		ret = -resp->resp.result;
+		goto out;
+	}
+
+	pr_debug("host cap request completed\n");
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
 static int
 ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
 {
@@ -500,6 +561,10 @@ static void ath10k_qmi_event_server_arrive(struct work_struct *work)
 	if (ret)
 		return;
 
+	ret = ath10k_qmi_host_cap_send_sync(qmi);
+	if (ret)
+		return;
+
 	ret = ath10k_qmi_msa_mem_info_send_sync_msg(qmi);
 	if (ret)
 		return;
-- 
1.9.1
