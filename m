Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbeCZFki (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:40:38 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 07/12] ath10k: Add MSA handshake QMI mgs support
Date: Mon, 26 Mar 2018 11:10:32 +0530
Message-Id: <1522042832-25975-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_074041_319439_CB1662CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HOST allocates 2mb of region for modem and WCN3990
secure access and provides the address and access
control to target for secure access.
Add MSA handshake request/response messages.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 288 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/qmi.h |  14 ++
 2 files changed, 300 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index bc80b8f..763b812 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -26,6 +26,8 @@
 #include <linux/string.h>
 #include <net/sock.h>
 #include <linux/soc/qcom/qmi.h>
+#include <linux/qcom_scm.h>
+#include <linux/of.h>
 #include "qmi.h"
 #include "qmi_svc_v01.h"
 
@@ -35,6 +37,240 @@
 static struct ath10k_qmi *qmi;
 
 static int
+ath10k_qmi_map_msa_permissions(struct ath10k_msa_mem_region_info *mem_region)
+{
+	struct qcom_scm_vmperm dst_perms[3];
+	unsigned int src_perms;
+	phys_addr_t addr;
+	u32 perm_count;
+	u32 size;
+	int ret;
+
+	addr = mem_region->reg_addr;
+	size = mem_region->size;
+
+	src_perms = BIT(QCOM_SCM_VMID_HLOS);
+
+	dst_perms[0].vmid = QCOM_SCM_VMID_MSS_MSA;
+	dst_perms[0].perm = QCOM_SCM_PERM_RW;
+	dst_perms[1].vmid = QCOM_SCM_VMID_WLAN;
+	dst_perms[1].perm = QCOM_SCM_PERM_RW;
+
+	if (!mem_region->secure_flag) {
+		dst_perms[2].vmid = QCOM_SCM_VMID_WLAN_CE;
+		dst_perms[2].perm = QCOM_SCM_PERM_RW;
+		perm_count = 3;
+	} else {
+		dst_perms[2].vmid = 0;
+		dst_perms[2].perm = 0;
+		perm_count = 2;
+	}
+
+	ret = qcom_scm_assign_mem(addr, size, &src_perms,
+				  dst_perms, perm_count);
+	if (ret < 0)
+		pr_err("msa map permission failed=%d\n", ret);
+
+	return ret;
+}
+
+static int
+ath10k_qmi_unmap_msa_permissions(struct ath10k_msa_mem_region_info *mem_region)
+{
+	struct qcom_scm_vmperm dst_perms;
+	unsigned int src_perms;
+	phys_addr_t addr;
+	u32 size;
+	int ret;
+
+	addr = mem_region->reg_addr;
+	size = mem_region->size;
+
+	src_perms = BIT(QCOM_SCM_VMID_MSS_MSA) | BIT(QCOM_SCM_VMID_WLAN);
+
+	if (!mem_region->secure_flag)
+		src_perms |= BIT(QCOM_SCM_VMID_WLAN_CE);
+
+	dst_perms.vmid = QCOM_SCM_VMID_HLOS;
+	dst_perms.perm = QCOM_SCM_PERM_RW;
+
+	ret = qcom_scm_assign_mem(addr, size, &src_perms, &dst_perms, 1);
+	if (ret < 0)
+		pr_err("msa unmap permission failed=%d\n", ret);
+
+	return ret;
+}
+
+static int ath10k_qmi_setup_msa_permissions(struct ath10k_qmi *qmi)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < qmi->nr_mem_region; i++) {
+		ret = ath10k_qmi_map_msa_permissions(&qmi->mem_region[i]);
+		if (ret)
+			goto err_unmap;
+	}
+
+	return 0;
+
+err_unmap:
+	for (i--; i >= 0; i--)
+		ath10k_qmi_unmap_msa_permissions(&qmi->mem_region[i]);
+	return ret;
+}
+
+static void ath10k_qmi_remove_msa_permissions(struct ath10k_qmi *qmi)
+{
+	int i;
+
+	for (i = 0; i < qmi->nr_mem_region; i++)
+		ath10k_qmi_unmap_msa_permissions(&qmi->mem_region[i]);
+}
+
+static int
+	ath10k_qmi_msa_mem_info_send_sync_msg(struct ath10k_qmi *qmi)
+{
+	struct wlfw_msa_info_resp_msg_v01 *resp;
+	struct wlfw_msa_info_req_msg_v01 *req;
+	struct qmi_txn txn;
+	int ret;
+	int i;
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
+	req->msa_addr = qmi->msa_pa;
+	req->size = qmi->msa_mem_size;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_msa_info_resp_msg_v01_ei, resp);
+	if (ret < 0) {
+		pr_err("fail to init txn for MSA mem info resp %d\n",
+		       ret);
+		goto out;
+	}
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_MSA_INFO_REQ_V01,
+			       WLFW_MSA_INFO_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_msa_info_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		pr_err("fail to send MSA mem info req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		pr_err("MSA mem info request rejected, result:%d error:%d\n",
+		       resp->resp.result, resp->resp.error);
+		ret = -resp->resp.result;
+		goto out;
+	}
+
+	pr_debug("receive mem_region_info_len: %d\n",
+		 resp->mem_region_info_len);
+
+	if (resp->mem_region_info_len > QMI_WLFW_MAX_NUM_MEMORY_REGIONS_V01) {
+		pr_err("invalid memory region length received: %d\n",
+		       resp->mem_region_info_len);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	qmi->nr_mem_region = resp->mem_region_info_len;
+	for (i = 0; i < resp->mem_region_info_len; i++) {
+		qmi->mem_region[i].reg_addr =
+			resp->mem_region_info[i].region_addr;
+		qmi->mem_region[i].size =
+			resp->mem_region_info[i].size;
+		qmi->mem_region[i].secure_flag =
+			resp->mem_region_info[i].secure_flag;
+		pr_debug("mem region: %d Addr: 0x%llx Size: 0x%x Flag: 0x%08x\n",
+			 i, qmi->mem_region[i].reg_addr,
+			 qmi->mem_region[i].size,
+			 qmi->mem_region[i].secure_flag);
+	}
+
+	pr_debug("MSA mem info request completed\n");
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
+static int ath10k_qmi_msa_ready_send_sync_msg(struct ath10k_qmi *qmi)
+{
+	struct wlfw_msa_ready_resp_msg_v01 *resp;
+	struct wlfw_msa_ready_req_msg_v01 *req;
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
+			   wlfw_msa_ready_resp_msg_v01_ei, resp);
+	if (ret < 0) {
+		pr_err("fail to init txn for MSA mem ready resp %d\n",
+		       ret);
+		goto out;
+	}
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_MSA_READY_REQ_V01,
+			       WLFW_MSA_READY_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_msa_ready_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		pr_err("fail to send MSA mem ready req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		pr_err("qmi MSA mem ready request rejected, result:%d error:%d\n",
+		       resp->resp.result, resp->resp.error);
+		ret = -resp->resp.result;
+	}
+
+	pr_debug("MSA mem ready request completed\n");
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
 ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
 {
 	struct wlfw_ind_register_resp_msg_v01 *resp;
@@ -173,7 +409,27 @@ static void ath10k_qmi_event_server_arrive(struct work_struct *work)
 	if (ret)
 		return;
 
-	ath10k_qmi_ind_register_send_sync_msg(qmi);
+	ret = ath10k_qmi_ind_register_send_sync_msg(qmi);
+	if (ret)
+		return;
+
+	ret = ath10k_qmi_msa_mem_info_send_sync_msg(qmi);
+	if (ret)
+		return;
+
+	ret = ath10k_qmi_setup_msa_permissions(qmi);
+	if (ret)
+		return;
+
+	ret = ath10k_qmi_msa_ready_send_sync_msg(qmi);
+	if (ret)
+		goto err_setup_msa;
+
+	return;
+
+err_setup_msa:
+	ath10k_qmi_remove_msa_permissions(qmi);
+	return;
 }
 
 static void ath10k_qmi_event_server_exit(struct work_struct *work)
@@ -252,6 +508,34 @@ static int ath10k_alloc_qmi_resources(struct ath10k_qmi *qmi)
 	return ret;
 }
 
+static int ath10k_qmi_setup_msa_resources(struct device *dev,
+					  struct ath10k_qmi *qmi)
+{
+	int ret;
+
+	ret = of_property_read_u32(dev->of_node, "qcom,wlan-msa-memory",
+				   &qmi->msa_mem_size);
+
+	if (ret || qmi->msa_mem_size == 0) {
+		pr_err("fail to get MSA memory size: %u, ret: %d\n",
+		       qmi->msa_mem_size, ret);
+		return -ENOMEM;
+	}
+
+	qmi->msa_va = dmam_alloc_coherent(dev, qmi->msa_mem_size,
+					  &qmi->msa_pa, GFP_KERNEL);
+	if (!qmi->msa_va) {
+		pr_err("dma alloc failed for MSA\n");
+		return -ENOMEM;
+	}
+
+	pr_debug("MSA pa: %pa, MSA va: 0x%p\n",
+		 &qmi->msa_pa,
+		 qmi->msa_va);
+
+	return 0;
+}
+
 static void ath10k_remove_qmi_resources(struct ath10k_qmi *qmi)
 {
 	cancel_work_sync(&qmi->work_svc_arrive);
@@ -272,7 +556,7 @@ static int ath10k_qmi_probe(struct platform_device *pdev)
 
 	qmi->pdev = pdev;
 	platform_set_drvdata(pdev, qmi);
-
+	ath10k_qmi_setup_msa_resources(&pdev->dev, qmi);
 	ret = ath10k_alloc_qmi_resources(qmi);
 	if (ret < 0)
 		goto err;
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index 7697d24..47af020 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -16,6 +16,8 @@
 #ifndef _QMI_H_
 #define _QMI_H_
 
+#define MAX_NUM_MEMORY_REGIONS			2
+
 enum ath10k_qmi_driver_event_type {
 	ATH10K_QMI_EVENT_SERVER_ARRIVE,
 	ATH10K_QMI_EVENT_SERVER_EXIT,
@@ -23,6 +25,12 @@ enum ath10k_qmi_driver_event_type {
 	ATH10K_QMI_EVENT_MAX,
 };
 
+struct ath10k_msa_mem_region_info {
+	u64 reg_addr;
+	u32 size;
+	u8 secure_flag;
+};
+
 struct ath10k_qmi {
 	struct platform_device *pdev;
 	struct qmi_handle qmi_hdl;
@@ -33,5 +41,11 @@ struct ath10k_qmi {
 	struct work_struct work_svc_exit;
 	struct workqueue_struct *event_wq;
 	spinlock_t event_lock; /* spinlock for fw ready status*/
+	u32 nr_mem_region;
+	struct ath10k_msa_mem_region_info
+		mem_region[MAX_NUM_MEMORY_REGIONS];
+	phys_addr_t msa_pa;
+	u32 msa_mem_size;
+	void *msa_va;
 };
 #endif /* _QMI_H_ */
-- 
1.9.1
