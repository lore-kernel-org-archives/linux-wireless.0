Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbeFEMhl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 08:37:41 -0400
From: Govind Singh <govinds@codeaurora.org>
To: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990 client
Date: Tue,  5 Jun 2018 18:07:32 +0530
Message-Id: <20180605123732.1993-1-govinds@codeaurora.org> (sfid-20180605_143745_722973_F84E227E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
subsystem. This layer is responsible for communicating qmi control
messages to wifi fw QMI service using QMI messaging protocol.

Qualcomm MSM Interface(QMI) is a messaging format used to communicate
between components running between application processor and remote
processors with underlying transport layer based on integrated
chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).

With this patch-set basic functionality(STA/SAP) can be tested
with WCN3990 chipset. The changes are verified with the firmware
WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig  |   13 +-
 drivers/net/wireless/ath/ath10k/Makefile |    4 +-
 drivers/net/wireless/ath/ath10k/core.c   |    6 +-
 drivers/net/wireless/ath/ath10k/core.h   |    2 +
 drivers/net/wireless/ath/ath10k/qmi.c    | 1030 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/qmi.h    |  136 +++
 drivers/net/wireless/ath/ath10k/snoc.c   |  209 ++++-
 drivers/net/wireless/ath/ath10k/snoc.h   |    3 +
 8 files changed, 1387 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 84f071ac0d84..4be6443f1e9d 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -41,12 +41,13 @@ config ATH10K_USB
 	  work in progress and will not fully work.
 
 config ATH10K_SNOC
-        tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
-        depends on ATH10K && ARCH_QCOM
-        ---help---
-          This module adds support for integrated WCN3990 chip connected
-          to system NOC(SNOC). Currently work in progress and will not
-          fully work.
+	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
+	depends on ATH10K && ARCH_QCOM
+	select QCOM_QMI_HELPERS
+	---help---
+	This module adds support for integrated WCN3990 chip connected
+	to system NOC(SNOC). Currently work in progress and will not
+	fully work.
 
 config ATH10K_DEBUG
 	bool "Atheros ath10k debugging"
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 44d60a61b242..66326b949ab1 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -36,7 +36,9 @@ obj-$(CONFIG_ATH10K_USB) += ath10k_usb.o
 ath10k_usb-y += usb.o
 
 obj-$(CONFIG_ATH10K_SNOC) += ath10k_snoc.o
-ath10k_snoc-y += snoc.o
+ath10k_snoc-y += qmi.o \
+		 qmi_wlfw_v01.o \
+		 snoc.o
 
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 8a592019cc4d..cd6c71a1eeed 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1134,7 +1134,7 @@ static int ath10k_download_fw(struct ath10k *ar)
 	return ret;
 }
 
-static void ath10k_core_free_board_files(struct ath10k *ar)
+void ath10k_core_free_board_files(struct ath10k *ar)
 {
 	if (!IS_ERR(ar->normal_mode_fw.board))
 		release_firmware(ar->normal_mode_fw.board);
@@ -1143,6 +1143,7 @@ static void ath10k_core_free_board_files(struct ath10k *ar)
 	ar->normal_mode_fw.board_data = NULL;
 	ar->normal_mode_fw.board_len = 0;
 }
+EXPORT_SYMBOL(ath10k_core_free_board_files);
 
 static void ath10k_core_free_firmware_files(struct ath10k *ar)
 {
@@ -1454,7 +1455,7 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 	return 0;
 }
 
-static int ath10k_core_fetch_board_file(struct ath10k *ar)
+int ath10k_core_fetch_board_file(struct ath10k *ar)
 {
 	char boardname[100], fallback_boardname[100];
 	int ret;
@@ -1492,6 +1493,7 @@ static int ath10k_core_fetch_board_file(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "using board api %d\n", ar->bd_api);
 	return 0;
 }
+EXPORT_SYMBOL(ath10k_core_fetch_board_file);
 
 int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 				     struct ath10k_fw_file *fw_file)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0a2e4a5c3612..526a088131b7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1165,5 +1165,7 @@ int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar, u32 chip_id);
 void ath10k_core_unregister(struct ath10k *ar);
+int ath10k_core_fetch_board_file(struct ath10k *ar);
+void ath10k_core_free_board_files(struct ath10k *ar);
 
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
new file mode 100644
index 000000000000..6cbc04c849b5
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -0,0 +1,1030 @@
+/*
+ * Copyright (c) 2018 The Linux Foundation. All rights reserved.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/net.h>
+#include <linux/completion.h>
+#include <linux/idr.h>
+#include <linux/string.h>
+#include <net/sock.h>
+#include <linux/qcom_scm.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include "debug.h"
+#include "snoc.h"
+#include "qmi_wlfw_v01.h"
+
+#define WLFW_CLIENT_ID			0x4b4e454c
+#define WLFW_TIMEOUT			30
+
+static int ath10k_qmi_map_msa_permission(struct ath10k_qmi *qmi,
+					 struct ath10k_msa_mem_info *mem_info)
+{
+	struct qcom_scm_vmperm dst_perms[3];
+	struct ath10k *ar = qmi->ar;
+	unsigned int src_perms;
+	u32 perm_count;
+	int ret;
+
+	src_perms = BIT(QCOM_SCM_VMID_HLOS);
+
+	dst_perms[0].vmid = QCOM_SCM_VMID_MSS_MSA;
+	dst_perms[0].perm = QCOM_SCM_PERM_RW;
+	dst_perms[1].vmid = QCOM_SCM_VMID_WLAN;
+	dst_perms[1].perm = QCOM_SCM_PERM_RW;
+
+	if (mem_info->secure) {
+		perm_count = 2;
+	} else {
+		dst_perms[2].vmid = QCOM_SCM_VMID_WLAN_CE;
+		dst_perms[2].perm = QCOM_SCM_PERM_RW;
+		perm_count = 3;
+	}
+
+	ret = qcom_scm_assign_mem(mem_info->addr, mem_info->size,
+				  &src_perms, dst_perms, perm_count);
+	if (ret < 0)
+		ath10k_err(ar, "msa map permission failed=%d\n", ret);
+
+	return ret;
+}
+
+static int ath10k_qmi_unmap_msa_permission(struct ath10k_qmi *qmi,
+					   struct ath10k_msa_mem_info *mem_info)
+{
+	struct qcom_scm_vmperm dst_perms;
+	struct ath10k *ar = qmi->ar;
+	unsigned int src_perms;
+	int ret;
+
+	src_perms = BIT(QCOM_SCM_VMID_MSS_MSA) | BIT(QCOM_SCM_VMID_WLAN);
+
+	if (!mem_info->secure)
+		src_perms |= BIT(QCOM_SCM_VMID_WLAN_CE);
+
+	dst_perms.vmid = QCOM_SCM_VMID_HLOS;
+	dst_perms.perm = QCOM_SCM_PERM_RW;
+
+	ret = qcom_scm_assign_mem(mem_info->addr, mem_info->size,
+				  &src_perms, &dst_perms, 1);
+	if (ret < 0)
+		ath10k_err(ar, "msa unmap permission failed=%d\n", ret);
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
+		ret = ath10k_qmi_map_msa_permission(qmi, &qmi->mem_region[i]);
+		if (ret)
+			goto err_unmap;
+	}
+
+	return 0;
+
+err_unmap:
+	for (i--; i >= 0; i--)
+		ath10k_qmi_unmap_msa_permission(qmi, &qmi->mem_region[i]);
+	return ret;
+}
+
+static void ath10k_qmi_remove_msa_permission(struct ath10k_qmi *qmi)
+{
+	int i;
+
+	for (i = 0; i < qmi->nr_mem_region; i++)
+		ath10k_qmi_unmap_msa_permission(qmi, &qmi->mem_region[i]);
+}
+
+static int ath10k_qmi_msa_mem_info_send_sync_msg(struct ath10k_qmi *qmi)
+{
+	struct wlfw_msa_info_resp_msg_v01 resp = {};
+	struct wlfw_msa_info_req_msg_v01 req = {};
+	struct ath10k *ar = qmi->ar;
+	struct qmi_txn txn;
+	int ret;
+	int i;
+
+	req.msa_addr = qmi->msa_pa;
+	req.size = qmi->msa_mem_size;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_msa_info_resp_msg_v01_ei, &resp);
+	if (ret < 0)
+		goto out;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_MSA_INFO_REQ_V01,
+			       WLFW_MSA_INFO_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_msa_info_req_msg_v01_ei, &req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "fail to send msa mem info req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "msa info req rejected, err:%d\n", resp.resp.error);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (resp.mem_region_info_len > QMI_WLFW_MAX_MEM_REG_V01) {
+		ath10k_err(ar, "invalid memory region length received: %d\n",
+			   resp.mem_region_info_len);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	qmi->nr_mem_region = resp.mem_region_info_len;
+	for (i = 0; i < resp.mem_region_info_len; i++) {
+		qmi->mem_region[i].addr = resp.mem_region_info[i].region_addr;
+		qmi->mem_region[i].size = resp.mem_region_info[i].size;
+		qmi->mem_region[i].secure = resp.mem_region_info[i].secure_flag;
+		ath10k_dbg(ar, ATH10K_DBG_QMI, "mem region: %d Addr: 0x%llx Size: 0x%x Flag: 0x%08x\n",
+			   i, qmi->mem_region[i].addr,
+			   qmi->mem_region[i].size,
+			   qmi->mem_region[i].secure);
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa mem info request completed\n");
+	return 0;
+
+out:
+	return ret;
+}
+
+static int ath10k_qmi_msa_ready_send_sync_msg(struct ath10k_qmi *qmi)
+{
+	struct wlfw_msa_ready_resp_msg_v01 resp = {};
+	struct wlfw_msa_ready_req_msg_v01 req = {};
+	struct ath10k *ar = qmi->ar;
+	struct qmi_txn txn;
+	int ret;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_msa_ready_resp_msg_v01_ei, &resp);
+	if (ret < 0)
+		goto out;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_MSA_READY_REQ_V01,
+			       WLFW_MSA_READY_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_msa_ready_req_msg_v01_ei, &req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "fail to send msa mem ready req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "msa ready req rejected, error:%d\n", resp.resp.error);
+		ret = -EINVAL;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa mem ready request completed\n");
+	return 0;
+
+out:
+	return ret;
+}
+
+int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
+{
+	struct wlfw_bdf_download_resp_msg_v01 resp = {};
+	struct wlfw_bdf_download_req_msg_v01 *req;
+	struct ath10k *ar = qmi->ar;
+	unsigned int remaining;
+	struct qmi_txn txn;
+	const u8 *temp;
+	int ret;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	temp = ar->normal_mode_fw.board_data;
+	remaining = ar->normal_mode_fw.board_len;
+
+	while (remaining) {
+		req->valid = 1;
+		req->file_id_valid = 1;
+		req->file_id = 0;
+		req->total_size_valid = 1;
+		req->total_size = ar->normal_mode_fw.board_len;
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
+				   &resp);
+		if (ret < 0)
+			goto out;
+
+		ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+				       QMI_WLFW_BDF_DOWNLOAD_REQ_V01,
+				       WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
+				       wlfw_bdf_download_req_msg_v01_ei, req);
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
+		if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+			ath10k_err(ar, "bdf download failed, err:%d\n", resp.resp.error);
+			ret = -EINVAL;
+			goto err_send;
+		}
+
+		remaining -= req->data_len;
+		temp += req->data_len;
+		req->seg_id++;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "bdf download request completed\n");
+
+	kfree(req);
+	return 0;
+
+err_send:
+	kfree(req);
+
+out:
+	return ret;
+}
+
+int ath10k_qmi_send_cal_report_req(struct ath10k_qmi *qmi)
+{
+	struct wlfw_cal_report_resp_msg_v01 resp = {};
+	struct wlfw_cal_report_req_msg_v01 req = {};
+	struct ath10k *ar = qmi->ar;
+	struct qmi_txn txn;
+	int i, j = 0;
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "sending cal report\n");
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_cal_report_resp_msg_v01_ei,
+			   &resp);
+	if (ret < 0)
+		goto out;
+
+	for (i = 0; i < QMI_WLFW_MAX_NUM_CAL_V01; i++) {
+		if (qmi->cal_data[i].total_size &&
+		    qmi->cal_data[i].data) {
+			req.meta_data[j] = qmi->cal_data[i].cal_id;
+			j++;
+		}
+	}
+	req.meta_data_len = j;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_CAL_REPORT_REQ_V01,
+			       WLFW_CAL_REPORT_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_cal_report_req_msg_v01_ei, &req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "fail to send cal req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "cal req rejected, error:%d\n", resp.resp.error);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "cal report request completed\n");
+	return 0;
+
+out:
+	return ret;
+}
+
+static int
+ath10k_qmi_mode_send_sync_msg(struct ath10k *ar, enum wlfw_driver_mode_enum_v01 mode)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct ath10k_qmi *qmi = ar_snoc->qmi;
+	struct wlfw_wlan_mode_resp_msg_v01 resp = {};
+	struct wlfw_wlan_mode_req_msg_v01 req = {};
+	struct qmi_txn txn;
+	int ret;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_wlan_mode_resp_msg_v01_ei,
+			   &resp);
+	if (ret < 0)
+		goto out;
+
+	req.mode = mode;
+	req.hw_debug_valid = 1;
+	req.hw_debug = 0;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_WLAN_MODE_REQ_V01,
+			       WLFW_WLAN_MODE_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_wlan_mode_req_msg_v01_ei, &req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "send mode req failed, mode: %d ret: %d\n",
+			   mode, ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "mode req rejected, error:%d\n", resp.resp.error);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "wlan mode req completed, mode: %d\n", mode);
+	return 0;
+
+out:
+	return ret;
+}
+
+static int
+ath10k_qmi_cfg_send_sync_msg(struct ath10k *ar,
+			     struct ath10k_qmi_wlan_enable_cfg *config,
+			     const char *version)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct ath10k_qmi *qmi = ar_snoc->qmi;
+	struct wlfw_wlan_cfg_resp_msg_v01 resp = {};
+	struct wlfw_wlan_cfg_req_msg_v01 *req;
+	struct qmi_txn txn;
+	int ret;
+	u32 i;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_wlan_cfg_resp_msg_v01_ei,
+			   &resp);
+	if (ret < 0)
+		goto out;
+
+	req->host_version_valid = 0;
+
+	req->tgt_cfg_valid = 1;
+	if (config->num_ce_tgt_cfg > QMI_WLFW_MAX_NUM_CE_V01)
+		req->tgt_cfg_len = QMI_WLFW_MAX_NUM_CE_V01;
+	else
+		req->tgt_cfg_len = config->num_ce_tgt_cfg;
+	for (i = 0; i < req->tgt_cfg_len; i++) {
+		req->tgt_cfg[i].pipe_num = config->ce_tgt_cfg[i].pipe_num;
+		req->tgt_cfg[i].pipe_dir = config->ce_tgt_cfg[i].pipe_dir;
+		req->tgt_cfg[i].nentries = config->ce_tgt_cfg[i].nentries;
+		req->tgt_cfg[i].nbytes_max = config->ce_tgt_cfg[i].nbytes_max;
+		req->tgt_cfg[i].flags = config->ce_tgt_cfg[i].flags;
+	}
+
+	req->svc_cfg_valid = 1;
+	if (config->num_ce_svc_pipe_cfg > QMI_WLFW_MAX_NUM_SVC_V01)
+		req->svc_cfg_len = QMI_WLFW_MAX_NUM_SVC_V01;
+	else
+		req->svc_cfg_len = config->num_ce_svc_pipe_cfg;
+	for (i = 0; i < req->svc_cfg_len; i++) {
+		req->svc_cfg[i].service_id = config->ce_svc_cfg[i].service_id;
+		req->svc_cfg[i].pipe_dir = config->ce_svc_cfg[i].pipe_dir;
+		req->svc_cfg[i].pipe_num = config->ce_svc_cfg[i].pipe_num;
+	}
+
+	req->shadow_reg_valid = 1;
+	if (config->num_shadow_reg_cfg >
+	    QMI_WLFW_MAX_NUM_SHADOW_REG_V01)
+		req->shadow_reg_len = QMI_WLFW_MAX_NUM_SHADOW_REG_V01;
+	else
+		req->shadow_reg_len = config->num_shadow_reg_cfg;
+
+	memcpy(req->shadow_reg, config->shadow_reg_cfg,
+	       sizeof(struct wlfw_shadow_reg_cfg_s_v01) * req->shadow_reg_len);
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_WLAN_CFG_REQ_V01,
+			       WLFW_WLAN_CFG_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_wlan_cfg_req_msg_v01_ei, req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "send config req failed %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "cfg req rejected, error:%d\n", resp.resp.error);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "wlan config request completed\n");
+	kfree(req);
+	return 0;
+
+out:
+	kfree(req);
+	return ret;
+}
+
+int ath10k_qmi_wlan_enable(struct ath10k *ar,
+			   struct ath10k_qmi_wlan_enable_cfg *config,
+			   enum ath10k_qmi_driver_mode mode,
+			   const char *version)
+{
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "mode: %d, config: %p:\n",
+		   mode, config);
+
+	ret = ath10k_qmi_cfg_send_sync_msg(ar, config, version);
+	if (ret) {
+		ath10k_err(ar, "wlan qmi config send failed\n");
+		return ret;
+	}
+
+	ret = ath10k_qmi_mode_send_sync_msg(ar, mode);
+	if (ret) {
+		ath10k_err(ar, "wlan qmi mode send failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+int ath10k_qmi_wlan_disable(struct ath10k *ar)
+{
+	return ath10k_qmi_mode_send_sync_msg(ar, QMI_WLFW_OFF_V01);
+}
+
+static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
+{
+	struct wlfw_cap_resp_msg_v01 *resp;
+	struct wlfw_cap_req_msg_v01 req = {};
+	struct ath10k *ar = qmi->ar;
+	struct qmi_txn txn;
+	int ret;
+
+	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_cap_resp_msg_v01_ei, resp);
+	if (ret < 0)
+		goto out;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_CAP_REQ_V01,
+			       WLFW_CAP_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_cap_req_msg_v01_ei, &req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "fail to send capability req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "capablity req rejected, error:%d\n", resp->resp.error);
+		ret = -EINVAL;
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
+		qmi->fw_version = resp->fw_version_info.fw_version;
+		strlcpy(qmi->fw_build_timestamp, resp->fw_version_info.fw_build_timestamp,
+			sizeof(qmi->fw_build_timestamp));
+	}
+
+	if (resp->fw_build_id_valid)
+		strlcpy(qmi->fw_build_id, resp->fw_build_id,
+			MAX_BUILD_ID_LEN + 1);
+
+	ath10k_info(ar, "chip_id: 0x%x, chip_family: 0x%x, board_id: 0x%x, soc_id: 0x%x",
+		    qmi->chip_info.chip_id, qmi->chip_info.chip_family,
+		    qmi->board_info.board_id, qmi->soc_info.soc_id);
+	ath10k_info(ar, "fw_version: 0x%x, fw_build_timestamp: %s, fw_build_id: %s",
+		    qmi->fw_version, qmi->fw_build_timestamp, qmi->fw_build_id);
+
+	kfree(resp);
+	return 0;
+
+out:
+	kfree(resp);
+	return ret;
+}
+
+static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
+{
+	struct wlfw_host_cap_resp_msg_v01 resp = {};
+	struct wlfw_host_cap_req_msg_v01 req = {};
+	struct ath10k *ar = qmi->ar;
+	struct qmi_txn txn;
+	int ret;
+
+	req.daemon_support_valid = 1;
+	req.daemon_support = 0;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_host_cap_resp_msg_v01_ei, &resp);
+	if (ret < 0)
+		goto out;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_HOST_CAP_REQ_V01,
+			       WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_host_cap_req_msg_v01_ei, &req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "Fail to send Capability req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "host cap req rejected, error:%d\n", resp.resp.error);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "host capablity request completed\n");
+	return 0;
+
+out:
+	return ret;
+}
+
+static int
+ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
+{
+	struct wlfw_ind_register_resp_msg_v01 resp = {};
+	struct wlfw_ind_register_req_msg_v01 req = {};
+	struct ath10k *ar = qmi->ar;
+	struct qmi_txn txn;
+	int ret;
+
+	req.client_id_valid = 1;
+	req.client_id = WLFW_CLIENT_ID;
+	req.fw_ready_enable_valid = 1;
+	req.fw_ready_enable = 1;
+	req.msa_ready_enable_valid = 1;
+	req.msa_ready_enable = 1;
+
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
+			   wlfw_ind_register_resp_msg_v01_ei, &resp);
+	if (ret < 0)
+		goto out;
+
+	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
+			       QMI_WLFW_IND_REGISTER_REQ_V01,
+			       WLFW_IND_REGISTER_REQ_MSG_V01_MAX_MSG_LEN,
+			       wlfw_ind_register_req_msg_v01_ei, &req);
+	if (ret < 0) {
+		qmi_txn_cancel(&txn);
+		ath10k_err(ar, "fail to send ind register req %d\n", ret);
+		goto out;
+	}
+
+	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
+	if (ret < 0)
+		goto out;
+
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		ath10k_err(ar, "indication req rejected, error:%d\n", resp.resp.error);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (resp.fw_status_valid) {
+		if (resp.fw_status & QMI_WLFW_FW_READY_V01)
+			qmi->fw_ready = true;
+	}
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "indication register request completed\n");
+	return 0;
+
+out:
+	return ret;
+}
+
+static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
+{
+	struct ath10k *ar = qmi->ar;
+	int ret;
+
+	ret = ath10k_qmi_ind_register_send_sync_msg(qmi);
+	if (ret)
+		return;
+
+	if (qmi->fw_ready) {
+		ath10k_snoc_fw_indication(ar, ATH10K_QMI_EVENT_FW_READY_IND);
+		return;
+	}
+
+	ret = ath10k_qmi_host_cap_send_sync(qmi);
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
+	ret = ath10k_qmi_cap_send_sync_msg(qmi);
+	if (ret)
+		goto err_setup_msa;
+
+	return;
+
+err_setup_msa:
+	ath10k_qmi_remove_msa_permission(qmi);
+}
+
+static int ath10k_qmi_fetch_board_file(struct ath10k_qmi *qmi)
+{
+	struct ath10k *ar = qmi->ar;
+	int ret;
+
+	ar->hif.bus = ATH10K_BUS_SNOC;
+	ar->id.qmi_ids_valid = true;
+	ar->id.qmi_board_id = qmi->board_info.board_id;
+
+	ret = ath10k_core_fetch_board_file(qmi->ar);
+
+	return ret;
+}
+
+static int
+ath10k_qmi_driver_event_post(struct ath10k_qmi *qmi,
+			     enum ath10k_qmi_driver_event_type type,
+			     void *data)
+{
+	struct ath10k_qmi_driver_event *event;
+	int ret = 0;
+
+	event = kzalloc(sizeof(*event), GFP_ATOMIC);
+	if (!event)
+		return -ENOMEM;
+
+	event->type = type;
+	event->data = data;
+
+	spin_lock(&qmi->event_lock);
+	list_add_tail(&event->list, &qmi->event_list);
+	spin_unlock(&qmi->event_lock);
+
+	queue_work(qmi->event_wq, &qmi->event_work);
+
+	return ret;
+}
+
+static void ath10k_qmi_event_server_exit(struct ath10k_qmi *qmi)
+{
+	struct ath10k *ar = qmi->ar;
+
+	ath10k_qmi_remove_msa_permission(qmi);
+	ath10k_core_free_board_files(ar);
+	ath10k_info(ar, "wifi fw qmi service disconnected\n");
+}
+
+static void ath10k_qmi_event_msa_ready(struct ath10k_qmi *qmi)
+{
+	int ret;
+
+	ret = ath10k_qmi_fetch_board_file(qmi);
+	if (ret)
+		goto out;
+
+	ret = ath10k_qmi_bdf_dnld_send_sync(qmi);
+	if (ret)
+		goto out;
+
+	ret = ath10k_qmi_send_cal_report_req(qmi);
+
+out:
+	return;
+}
+
+static int ath10k_qmi_event_fw_ready_ind(struct ath10k_qmi *qmi)
+{
+	struct ath10k *ar = qmi->ar;
+
+	ath10k_info(ar, "wifi fw ready event received\n");
+	ath10k_snoc_fw_indication(ar, ATH10K_QMI_EVENT_FW_READY_IND);
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
+	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_FW_READY_IND, NULL);
+}
+
+static void ath10k_qmi_msa_ready_ind(struct qmi_handle *qmi_hdl,
+				     struct sockaddr_qrtr *sq,
+				     struct qmi_txn *txn, const void *data)
+{
+	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
+
+	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_MSA_READY_IND, NULL);
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
+static int ath10k_qmi_new_server(struct qmi_handle *qmi_hdl,
+				 struct qmi_service *service)
+{
+	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
+	struct sockaddr_qrtr *sq = &qmi->sq;
+	struct ath10k *ar = qmi->ar;
+	int ret;
+
+	sq->sq_family = AF_QIPCRTR;
+	sq->sq_node = service->node;
+	sq->sq_port = service->port;
+
+	ath10k_info(ar, "wifi fw qmi server arrive\n");
+
+	ret = kernel_connect(qmi_hdl->sock, (struct sockaddr *)&qmi->sq,
+			     sizeof(qmi->sq), 0);
+	if (ret) {
+		ath10k_err(ar, "fail to connect to remote service port\n");
+		return ret;
+	}
+
+	ath10k_info(ar, "wifi fw qmi service connected\n");
+	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_SERVER_ARRIVE, NULL);
+
+	return ret;
+}
+
+static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
+				  struct qmi_service *service)
+{
+	struct ath10k_qmi *qmi =
+		container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
+
+	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_SERVER_EXIT, NULL);
+}
+
+static struct qmi_ops ath10k_qmi_ops = {
+	.new_server = ath10k_qmi_new_server,
+	.del_server = ath10k_qmi_del_server,
+};
+
+static void ath10k_qmi_driver_event_work(struct work_struct *work)
+{
+	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
+					      event_work);
+	struct ath10k_qmi_driver_event *event;
+	struct ath10k *ar = qmi->ar;
+
+	spin_lock(&qmi->event_lock);
+	while (!list_empty(&qmi->event_list)) {
+		event = list_first_entry(&qmi->event_list,
+					 struct ath10k_qmi_driver_event, list);
+		list_del(&event->list);
+		spin_unlock(&qmi->event_lock);
+
+		switch (event->type) {
+		case ATH10K_QMI_EVENT_SERVER_ARRIVE:
+			ath10k_qmi_event_server_arrive(qmi);
+			break;
+		case ATH10K_QMI_EVENT_SERVER_EXIT:
+			ath10k_qmi_event_server_exit(qmi);
+			break;
+		case ATH10K_QMI_EVENT_FW_READY_IND:
+			ath10k_qmi_event_fw_ready_ind(qmi);
+			break;
+		case ATH10K_QMI_EVENT_MSA_READY_IND:
+			ath10k_qmi_event_msa_ready(qmi);
+			break;
+		default:
+			ath10k_err(ar, "invalid event type: %d", event->type);
+			break;
+		}
+		kfree(event);
+		spin_lock(&qmi->event_lock);
+	}
+	spin_unlock(&qmi->event_lock);
+}
+
+static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi)
+{
+	struct ath10k *ar = qmi->ar;
+	struct device *dev = ar->dev;
+	struct device_node *np;
+	const __be32 *addrp;
+	u64 prop_size = 0;
+	int ret;
+
+	np = of_parse_phandle(dev->of_node, "msa-fixed-region", 0);
+	if (np) {
+		addrp = of_get_address(np, 0, &prop_size, NULL);
+		if (!addrp) {
+			ath10k_err(ar, "failed to get msa fixed addresses\n");
+			return -EINVAL;
+		}
+
+		qmi->msa_pa = of_translate_address(np, addrp);
+		if (qmi->msa_pa == OF_BAD_ADDR) {
+			ath10k_err(ar, "failed to translate fixed msa pa\n");
+			return -EINVAL;
+		}
+
+		qmi->msa_va = memremap(qmi->msa_pa, (unsigned long)prop_size,
+				       MEMREMAP_WT);
+		if (!qmi->msa_va) {
+			ath10k_err(ar, "fixed msa ioremap failed: phy addr: %pa\n",
+				   &qmi->msa_pa);
+			return -EINVAL;
+		}
+		qmi->msa_mem_size = prop_size;
+	} else {
+		ret = of_property_read_u32(dev->of_node, "msa-size",
+					   &qmi->msa_mem_size);
+
+		if (ret || qmi->msa_mem_size == 0) {
+			ath10k_err(ar, "failed to get msa memory size node\n");
+			return -ENOMEM;
+		}
+
+		qmi->msa_va = dmam_alloc_coherent(dev, qmi->msa_mem_size,
+						  &qmi->msa_pa, GFP_KERNEL);
+		if (!qmi->msa_va) {
+			ath10k_err(ar, "dma alloc failed for msa region\n");
+			return -ENOMEM;
+		}
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa pa: %pad , msa va: 0x%p\n",
+		   &qmi->msa_pa,
+		   qmi->msa_va);
+
+	return 0;
+}
+
+int ath10k_qmi_init(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct ath10k_qmi *qmi;
+	int ret;
+
+	qmi = kzalloc(sizeof(*qmi), GFP_KERNEL);
+	if (!qmi)
+		return -ENOMEM;
+
+	qmi->ar = ar;
+	ar_snoc->qmi = qmi;
+
+	ret = ath10k_qmi_setup_msa_resources(qmi);
+	if (ret)
+		goto err;
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
+		ath10k_err(ar, "workqueue alloc failed\n");
+		ret = -EFAULT;
+		goto err_release_qmi_handle;
+	}
+
+	INIT_LIST_HEAD(&qmi->event_list);
+	spin_lock_init(&qmi->event_lock);
+	INIT_WORK(&qmi->event_work, ath10k_qmi_driver_event_work);
+
+	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
+			     WLFW_SERVICE_VERS_V01, 0);
+	if (ret)
+		goto err_release_qmi_handle;
+
+	return 0;
+
+err_release_qmi_handle:
+	qmi_handle_release(&qmi->qmi_hdl);
+
+err:
+	return ret;
+}
+
+int ath10k_qmi_deinit(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct ath10k_qmi *qmi = ar_snoc->qmi;
+
+	cancel_work_sync(&qmi->event_work);
+	destroy_workqueue(qmi->event_wq);
+	qmi_handle_release(&qmi->qmi_hdl);
+	qmi = NULL;
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
new file mode 100644
index 000000000000..c126d0373e4e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2018 The Linux Foundation. All rights reserved.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef _ATH10K_QMI_H_
+#define _ATH10K_QMI_H_
+
+#include <linux/soc/qcom/qmi.h>
+#include <linux/qrtr.h>
+
+#define MAX_NUM_MEMORY_REGIONS			2
+#define MAX_TIMESTAMP_LEN			32
+#define MAX_BUILD_ID_LEN			128
+#define MAX_NUM_CAL_V01			5
+
+enum ath10k_qmi_driver_event_type {
+	ATH10K_QMI_EVENT_SERVER_ARRIVE,
+	ATH10K_QMI_EVENT_SERVER_EXIT,
+	ATH10K_QMI_EVENT_FW_READY_IND,
+	ATH10K_QMI_EVENT_FW_DOWN_IND,
+	ATH10K_QMI_EVENT_MSA_READY_IND,
+	ATH10K_QMI_EVENT_MAX,
+};
+
+enum ath10k_qmi_driver_mode {
+	QMI_MISSION,
+	QMI_FTM,
+	QMI_EPPING,
+	QMI_OFF,
+};
+
+struct ath10k_msa_mem_info {
+	phys_addr_t addr;
+	u32 size;
+	bool secure;
+};
+
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
+struct ath10k_qmi_cal_data {
+	u32 cal_id;
+	u32 total_size;
+	u8 *data;
+};
+
+struct ath10k_tgt_pipe_cfg {
+	u32 pipe_num;
+	u32 pipe_dir;
+	u32 nentries;
+	u32 nbytes_max;
+	u32 flags;
+	u32 reserved;
+};
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
+struct ath10k_qmi_driver_event {
+	struct list_head list;
+	enum ath10k_qmi_driver_event_type type;
+	void *data;
+};
+
+struct ath10k_qmi {
+	struct ath10k *ar;
+	struct qmi_handle qmi_hdl;
+	struct sockaddr_qrtr sq;
+	bool fw_ready;
+	struct work_struct event_work;
+	struct workqueue_struct *event_wq;
+	struct list_head event_list;
+	spinlock_t event_lock; /* spinlock for qmi event list */
+	u32 nr_mem_region;
+	struct ath10k_msa_mem_info
+		mem_region[MAX_NUM_MEMORY_REGIONS];
+	dma_addr_t msa_pa;
+	u32 msa_mem_size;
+	void *msa_va;
+	struct ath10k_qmi_chip_info chip_info;
+	struct ath10k_qmi_board_info board_info;
+	struct ath10k_qmi_soc_info soc_info;
+	char fw_build_id[MAX_BUILD_ID_LEN + 1];
+	u32 fw_version;
+	char fw_build_timestamp[MAX_TIMESTAMP_LEN + 1];
+	struct ath10k_qmi_cal_data cal_data[MAX_NUM_CAL_V01];
+};
+
+int ath10k_qmi_wlan_enable(struct ath10k *ar,
+			   struct ath10k_qmi_wlan_enable_cfg *config,
+			   enum ath10k_qmi_driver_mode mode,
+			   const char *version);
+int ath10k_qmi_wlan_disable(struct ath10k *ar);
+int ath10k_qmi_register_service_notifier(struct notifier_block *nb);
+int ath10k_qmi_init(struct ath10k *ar);
+int ath10k_qmi_deinit(struct ath10k *ar);
+
+#endif /* ATH10K_QMI_H */
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index a3a7042fe13a..aa8a9b36250e 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -67,6 +67,24 @@ static const struct ath10k_snoc_drv_priv drv_priv = {
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
@@ -174,6 +192,128 @@ static struct ce_attr host_ce_config_wlan[] = {
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
@@ -755,11 +895,47 @@ static int ath10k_snoc_init_pipes(struct ath10k *ar)
 
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
+	return ath10k_qmi_wlan_enable(ar, &cfg, mode,
+				       NULL);
 }
 
 static void ath10k_snoc_wlan_disable(struct ath10k *ar)
 {
+	ath10k_qmi_wlan_disable(ar);
 }
 
 static void ath10k_snoc_hif_power_down(struct ath10k *ar)
@@ -947,6 +1123,27 @@ static int ath10k_snoc_resource_init(struct ath10k *ar)
 	return ret;
 }
 
+int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int ret;
+
+	switch (type) {
+	case ATH10K_QMI_EVENT_FW_READY_IND:
+		ret = ath10k_core_register(ar,
+					   ar_snoc->target_info.soc_version);
+		if (ret) {
+			ath10k_err(ar, "Failed to register driver core: %d\n",
+				   ret);
+		}
+		break;
+	case ATH10K_QMI_EVENT_FW_DOWN_IND:
+		break;
+	}
+
+	return 0;
+}
+
 static int ath10k_snoc_setup_resource(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
@@ -1340,10 +1537,10 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
-	ret = ath10k_core_register(ar, drv_data->hw_rev);
+	ret = ath10k_qmi_init(ar);
 	if (ret) {
-		ath10k_err(ar, "failed to register driver core: %d\n", ret);
-		goto err_hw_power_off;
+		ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
+		goto err_core_destroy;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
@@ -1351,9 +1548,6 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_hw_power_off:
-	ath10k_hw_power_off(ar);
-
 err_free_irq:
 	ath10k_snoc_free_irq(ar);
 
@@ -1375,6 +1569,7 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
 	ath10k_hw_power_off(ar);
 	ath10k_snoc_free_irq(ar);
 	ath10k_snoc_release_resource(ar);
+	ath10k_qmi_deinit(ar);
 	ath10k_core_destroy(ar);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 05dc98f46ccd..d69bd6007bac 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -20,6 +20,7 @@
 #include "hw.h"
 #include "ce.h"
 #include "pci.h"
+#include "qmi.h"
 
 struct ath10k_snoc_drv_priv {
 	enum ath10k_hw_rev hw_rev;
@@ -82,6 +83,7 @@ struct ath10k_snoc {
 	struct timer_list rx_post_retry;
 	struct ath10k_wcn3990_vreg_info *vreg;
 	struct ath10k_wcn3990_clk_info *clk;
+	struct ath10k_qmi *qmi;
 };
 
 static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
@@ -91,5 +93,6 @@ static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
 
 void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value);
 u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset);
+int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type);
 
 #endif /* _SNOC_H_ */
-- 
2.17.0
