Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42996 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeCZFjk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:39:40 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 04/12] ath10k: add support to start and stop qmi service
Date: Mon, 26 Mar 2018 11:09:33 +0530
Message-Id: <1522042773-25775-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_073944_049844_14392A03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to start qmi service to configure the wlan
firmware component and register event notifier to communicate
with the WLAN firmware over qmi communication interface.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 155 ++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/qmi.h |  13 +++
 2 files changed, 160 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 2235182..3a7fcc6 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -31,15 +31,115 @@
 
 static struct ath10k_qmi *qmi;
 
+static int ath10k_qmi_event_fw_ready_ind(struct ath10k_qmi *qmi)
+{
+	pr_debug("fw ready event received\n");
+	spin_lock(&qmi->event_lock);
+	qmi->fw_ready = true;
+	spin_unlock(&qmi->event_lock);
+
+	return 0;
+}
+
+static void ath10k_qmi_fw_ready_ind(struct qmi_handle *qmi_hdl,
+				    struct sockaddr_qrtr *sq,
+				    struct qmi_txn *txn, const void *data)
+{
+	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
+
+	ath10k_qmi_event_fw_ready_ind(qmi);
+}
+
+static void ath10k_qmi_msa_ready_ind(struct qmi_handle *qmi_hdl,
+				     struct sockaddr_qrtr *sq,
+				     struct qmi_txn *txn, const void *data)
+{
+	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
+
+	qmi->msa_ready = true;
+}
+
+static struct qmi_msg_handler qmi_msg_handler[] = {
+	{
+		.type = QMI_INDICATION,
+		.msg_id = QMI_WLFW_FW_READY_IND_V01,
+		.ei = wlfw_fw_ready_ind_msg_v01_ei,
+		.decoded_size = sizeof(struct wlfw_fw_ready_ind_msg_v01),
+		.fn = ath10k_qmi_fw_ready_ind,
+	},
+	{
+		.type = QMI_INDICATION,
+		.msg_id = QMI_WLFW_MSA_READY_IND_V01,
+		.ei = wlfw_msa_ready_ind_msg_v01_ei,
+		.decoded_size = sizeof(struct wlfw_msa_ready_ind_msg_v01),
+		.fn = ath10k_qmi_msa_ready_ind,
+	},
+	{}
+};
+
+static int ath10k_qmi_connect_to_fw_server(struct ath10k_qmi *qmi)
+{
+	struct qmi_handle *qmi_hdl = &qmi->qmi_hdl;
+	int ret;
+
+	ret = kernel_connect(qmi_hdl->sock, (struct sockaddr *)&qmi->sq,
+			     sizeof(qmi->sq), 0);
+	if (ret) {
+		pr_err("fail to connect to remote service port\n");
+		return ret;
+	}
+
+	pr_info("wlan qmi service connected\n");
+
+	return 0;
+}
+
+static void ath10k_qmi_event_server_arrive(struct work_struct *work)
+{
+	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
+					      work_svc_arrive);
+	int ret;
+
+	ret = ath10k_qmi_connect_to_fw_server(qmi);
+	if (ret)
+		return;
+
+	pr_debug("qmi server arrive\n");
+}
+
+static void ath10k_qmi_event_server_exit(struct work_struct *work)
+{
+	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
+					      work_svc_exit);
+
+	spin_lock(&qmi->event_lock);
+	qmi->fw_ready = false;
+	spin_unlock(&qmi->event_lock);
+	pr_info("wlan fw service disconnected\n");
+}
+
 static int ath10k_qmi_new_server(struct qmi_handle *qmi_hdl,
 				 struct qmi_service *service)
 {
+	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
+	struct sockaddr_qrtr *sq = &qmi->sq;
+
+	sq->sq_family = AF_QIPCRTR;
+	sq->sq_node = service->node;
+	sq->sq_port = service->port;
+
+	queue_work(qmi->event_wq, &qmi->work_svc_arrive);
+
 	return 0;
 }
 
 static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
 				  struct qmi_service *service)
 {
+	struct ath10k_qmi *qmi =
+		container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
+
+	queue_work(qmi->event_wq, &qmi->work_svc_exit);
 }
 
 static struct qmi_ops ath10k_qmi_ops = {
@@ -47,6 +147,51 @@ static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
 	.del_server = ath10k_qmi_del_server,
 };
 
+static int ath10k_alloc_qmi_resources(struct ath10k_qmi *qmi)
+{
+	int ret;
+
+	ret = qmi_handle_init(&qmi->qmi_hdl,
+			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
+			      &ath10k_qmi_ops, qmi_msg_handler);
+	if (ret)
+		goto err;
+
+	qmi->event_wq = alloc_workqueue("qmi_driver_event",
+					WQ_UNBOUND, 1);
+	if (!qmi->event_wq) {
+		pr_err("workqueue alloc failed\n");
+		ret = -EFAULT;
+		goto err_qmi_service;
+	}
+
+	spin_lock_init(&qmi->event_lock);
+	INIT_WORK(&qmi->work_svc_arrive, ath10k_qmi_event_server_arrive);
+	INIT_WORK(&qmi->work_svc_exit, ath10k_qmi_event_server_exit);
+
+	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
+			     WLFW_SERVICE_VERS_V01, 0);
+	if (ret)
+		goto err_qmi_service;
+
+	return 0;
+
+err_qmi_service:
+	qmi_handle_release(&qmi->qmi_hdl);
+
+err:
+	return ret;
+}
+
+static void ath10k_remove_qmi_resources(struct ath10k_qmi *qmi)
+{
+	cancel_work_sync(&qmi->work_svc_arrive);
+	cancel_work_sync(&qmi->work_svc_exit);
+	destroy_workqueue(qmi->event_wq);
+	qmi_handle_release(&qmi->qmi_hdl);
+	qmi = NULL;
+}
+
 static int ath10k_qmi_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -58,14 +203,8 @@ static int ath10k_qmi_probe(struct platform_device *pdev)
 
 	qmi->pdev = pdev;
 	platform_set_drvdata(pdev, qmi);
-	ret = qmi_handle_init(&qmi->qmi_hdl,
-			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
-			      &ath10k_qmi_ops, NULL);
-	if (ret < 0)
-		goto err;
 
-	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
-			     WLFW_SERVICE_VERS_V01, 0);
+	ret = ath10k_alloc_qmi_resources(qmi);
 	if (ret < 0)
 		goto err;
 
@@ -81,7 +220,7 @@ static int ath10k_qmi_remove(struct platform_device *pdev)
 {
 	struct ath10k_qmi *qmi = platform_get_drvdata(pdev);
 
-	qmi_handle_release(&qmi->qmi_hdl);
+	ath10k_remove_qmi_resources(qmi);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index ad256ef..7697d24 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -16,9 +16,22 @@
 #ifndef _QMI_H_
 #define _QMI_H_
 
+enum ath10k_qmi_driver_event_type {
+	ATH10K_QMI_EVENT_SERVER_ARRIVE,
+	ATH10K_QMI_EVENT_SERVER_EXIT,
+	ATH10K_QMI_EVENT_FW_READY_IND,
+	ATH10K_QMI_EVENT_MAX,
+};
+
 struct ath10k_qmi {
 	struct platform_device *pdev;
 	struct qmi_handle qmi_hdl;
 	struct sockaddr_qrtr sq;
+	bool fw_ready;
+	bool msa_ready;
+	struct work_struct work_svc_arrive;
+	struct work_struct work_svc_exit;
+	struct workqueue_struct *event_wq;
+	spinlock_t event_lock; /* spinlock for fw ready status*/
 };
 #endif /* _QMI_H_ */
-- 
1.9.1
