Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934194AbeGCR51 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 13:57:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990 client
References: <20180605123732.1993-1-govinds@codeaurora.org>
Date: Tue, 03 Jul 2018 20:57:19 +0300
In-Reply-To: <20180605123732.1993-1-govinds@codeaurora.org> (Govind Singh's
        message of "Tue, 5 Jun 2018 18:07:32 +0530")
Message-ID: <87bmbonqww.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_195732_317576_702CF8C8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
> subsystem. This layer is responsible for communicating qmi control
> messages to wifi fw QMI service using QMI messaging protocol.
>
> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
> between components running between application processor and remote
> processors with underlying transport layer based on integrated
> chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
>
> With this patch-set basic functionality(STA/SAP) can be tested
> with WCN3990 chipset. The changes are verified with the firmware
> WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>

[...]

> +#define WLFW_CLIENT_ID			0x4b4e454c

Should this be in qmi_wlfw_v01.h? If qmi.c is the correct place a better
name would be ATH10K_QMI_CLIENT_ID.

> +#define WLFW_TIMEOUT			30

ATH10K_QMI_TIMEOUT?

> +static int ath10k_qmi_map_msa_permission(struct ath10k_qmi *qmi,
> +					 struct ath10k_msa_mem_info *mem_info)
> +{
> +	struct qcom_scm_vmperm dst_perms[3];
> +	struct ath10k *ar = qmi->ar;
> +	unsigned int src_perms;
> +	u32 perm_count;
> +	int ret;
> +
> +	src_perms = BIT(QCOM_SCM_VMID_HLOS);
> +
> +	dst_perms[0].vmid = QCOM_SCM_VMID_MSS_MSA;
> +	dst_perms[0].perm = QCOM_SCM_PERM_RW;
> +	dst_perms[1].vmid = QCOM_SCM_VMID_WLAN;
> +	dst_perms[1].perm = QCOM_SCM_PERM_RW;
> +
> +	if (mem_info->secure) {
> +		perm_count = 2;
> +	} else {
> +		dst_perms[2].vmid = QCOM_SCM_VMID_WLAN_CE;
> +		dst_perms[2].perm = QCOM_SCM_PERM_RW;
> +		perm_count = 3;
> +	}
> +
> +	ret = qcom_scm_assign_mem(mem_info->addr, mem_info->size,
> +				  &src_perms, dst_perms, perm_count);
> +	if (ret < 0)
> +		ath10k_err(ar, "msa map permission failed=%d\n", ret);

"failed to assign msa map permissions: %d\n"

> +static int ath10k_qmi_unmap_msa_permission(struct ath10k_qmi *qmi,
> +					   struct ath10k_msa_mem_info *mem_info)
> +{
> +	struct qcom_scm_vmperm dst_perms;
> +	struct ath10k *ar = qmi->ar;
> +	unsigned int src_perms;
> +	int ret;
> +
> +	src_perms = BIT(QCOM_SCM_VMID_MSS_MSA) | BIT(QCOM_SCM_VMID_WLAN);
> +
> +	if (!mem_info->secure)
> +		src_perms |= BIT(QCOM_SCM_VMID_WLAN_CE);
> +
> +	dst_perms.vmid = QCOM_SCM_VMID_HLOS;
> +	dst_perms.perm = QCOM_SCM_PERM_RW;
> +
> +	ret = qcom_scm_assign_mem(mem_info->addr, mem_info->size,
> +				  &src_perms, &dst_perms, 1);
> +	if (ret < 0)
> +		ath10k_err(ar, "msa unmap permission failed=%d\n", ret);

"failed to unmap msa permissions: %d\n"

> +static int ath10k_qmi_msa_mem_info_send_sync_msg(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_msa_info_resp_msg_v01 resp = {};
> +	struct wlfw_msa_info_req_msg_v01 req = {};
> +	struct ath10k *ar = qmi->ar;
> +	struct qmi_txn txn;
> +	int ret;
> +	int i;
> +
> +	req.msa_addr = qmi->msa_pa;
> +	req.size = qmi->msa_mem_size;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_msa_info_resp_msg_v01_ei, &resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_MSA_INFO_REQ_V01,
> +			       WLFW_MSA_INFO_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_msa_info_req_msg_v01_ei, &req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "fail to send msa mem info req %d\n", ret);

"failed to send msa mem info req: %d\n"

> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "msa info req rejected, err:%d\n", resp.resp.error);

"msa info req rejected: %d\n"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (resp.mem_region_info_len > QMI_WLFW_MAX_MEM_REG_V01) {
> +		ath10k_err(ar, "invalid memory region length received: %d\n",
> +			   resp.mem_region_info_len);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	qmi->nr_mem_region = resp.mem_region_info_len;
> +	for (i = 0; i < resp.mem_region_info_len; i++) {
> +		qmi->mem_region[i].addr = resp.mem_region_info[i].region_addr;
> +		qmi->mem_region[i].size = resp.mem_region_info[i].size;
> +		qmi->mem_region[i].secure = resp.mem_region_info[i].secure_flag;
> +		ath10k_dbg(ar, ATH10K_DBG_QMI, "mem region: %d Addr: 0x%llx Size: 0x%x Flag: 0x%08x\n",
> +			   i, qmi->mem_region[i].addr,
> +			   qmi->mem_region[i].size,
> +			   qmi->mem_region[i].secure);
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa mem info request completed\n");

Please start debug messages with the debug level:

"qmi msa mem info request completed\n"

Also no commas or colons in the debug messages, please.

> +static int ath10k_qmi_msa_ready_send_sync_msg(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_msa_ready_resp_msg_v01 resp = {};
> +	struct wlfw_msa_ready_req_msg_v01 req = {};
> +	struct ath10k *ar = qmi->ar;
> +	struct qmi_txn txn;
> +	int ret;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_msa_ready_resp_msg_v01_ei, &resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_MSA_READY_REQ_V01,
> +			       WLFW_MSA_READY_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_msa_ready_req_msg_v01_ei, &req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "fail to send msa mem ready req %d\n", ret);

"failed to send msa mem ready request: %d\n"


> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "msa ready req rejected, error:%d\n", resp.resp.error);

"msa ready request rejected: %d\n"

> +		ret = -EINVAL;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa mem ready request completed\n");

"qmi msa mem ready request completed\n"

> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
> +int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_bdf_download_resp_msg_v01 resp = {};
> +	struct wlfw_bdf_download_req_msg_v01 *req;
> +	struct ath10k *ar = qmi->ar;
> +	unsigned int remaining;
> +	struct qmi_txn txn;
> +	const u8 *temp;
> +	int ret;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	temp = ar->normal_mode_fw.board_data;
> +	remaining = ar->normal_mode_fw.board_len;
> +
> +	while (remaining) {
> +		req->valid = 1;
> +		req->file_id_valid = 1;
> +		req->file_id = 0;
> +		req->total_size_valid = 1;
> +		req->total_size = ar->normal_mode_fw.board_len;
> +		req->seg_id_valid = 1;
> +		req->data_valid = 1;
> +		req->end_valid = 1;
> +
> +		if (remaining > QMI_WLFW_MAX_DATA_SIZE_V01) {
> +			req->data_len = QMI_WLFW_MAX_DATA_SIZE_V01;
> +		} else {
> +			req->data_len = remaining;
> +			req->end = 1;
> +		}
> +
> +		memcpy(req->data, temp, req->data_len);
> +
> +		ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +				   wlfw_bdf_download_resp_msg_v01_ei,
> +				   &resp);
> +		if (ret < 0)
> +			goto out;
> +
> +		ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +				       QMI_WLFW_BDF_DOWNLOAD_REQ_V01,
> +				       WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
> +				       wlfw_bdf_download_req_msg_v01_ei, req);
> +		if (ret < 0) {
> +			qmi_txn_cancel(&txn);
> +			goto err_send;
> +		}
> +
> +		ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +
> +		if (ret < 0)
> +			goto err_send;
> +
> +		if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +			ath10k_err(ar, "bdf download failed, err:%d\n", resp.resp.error);

"failed to download board data file: %d"

> +			ret = -EINVAL;
> +			goto err_send;
> +		}
> +
> +		remaining -= req->data_len;
> +		temp += req->data_len;
> +		req->seg_id++;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "bdf download request completed\n");

"qmi bdf download request completed\n"

> +
> +	kfree(req);
> +	return 0;
> +
> +err_send:
> +	kfree(req);
> +
> +out:
> +	return ret;
> +}
> +
> +int ath10k_qmi_send_cal_report_req(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_cal_report_resp_msg_v01 resp = {};
> +	struct wlfw_cal_report_req_msg_v01 req = {};
> +	struct ath10k *ar = qmi->ar;
> +	struct qmi_txn txn;
> +	int i, j = 0;
> +	int ret;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "sending cal report\n");

"qmi sending cal report\n"

> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_cal_report_resp_msg_v01_ei,
> +			   &resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	for (i = 0; i < QMI_WLFW_MAX_NUM_CAL_V01; i++) {
> +		if (qmi->cal_data[i].total_size &&
> +		    qmi->cal_data[i].data) {
> +			req.meta_data[j] = qmi->cal_data[i].cal_id;
> +			j++;
> +		}
> +	}
> +	req.meta_data_len = j;
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_CAL_REPORT_REQ_V01,
> +			       WLFW_CAL_REPORT_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_cal_report_req_msg_v01_ei, &req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "fail to send cal req %d\n", ret);

failed to send calibration request: %d\n

> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "cal req rejected, error:%d\n", resp.resp.error);

"calibration request rejected: %d\n"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "cal report request completed\n");

"qmi ..."

> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
> +static int
> +ath10k_qmi_mode_send_sync_msg(struct ath10k *ar, enum wlfw_driver_mode_enum_v01 mode)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	struct ath10k_qmi *qmi = ar_snoc->qmi;
> +	struct wlfw_wlan_mode_resp_msg_v01 resp = {};
> +	struct wlfw_wlan_mode_req_msg_v01 req = {};
> +	struct qmi_txn txn;
> +	int ret;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_wlan_mode_resp_msg_v01_ei,
> +			   &resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	req.mode = mode;
> +	req.hw_debug_valid = 1;
> +	req.hw_debug = 0;
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_WLAN_MODE_REQ_V01,
> +			       WLFW_WLAN_MODE_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_wlan_mode_req_msg_v01_ei, &req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "send mode req failed, mode: %d ret: %d\n",

"failed to send wlan mode %d request: %d\n", mode, ret

> +			   mode, ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "mode req rejected, error:%d\n", resp.resp.error);

"more request rejected: %d\n"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "wlan mode req completed, mode: %d\n", mode);

"qmi ..."

> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
> +static int
> +ath10k_qmi_cfg_send_sync_msg(struct ath10k *ar,
> +			     struct ath10k_qmi_wlan_enable_cfg *config,
> +			     const char *version)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	struct ath10k_qmi *qmi = ar_snoc->qmi;
> +	struct wlfw_wlan_cfg_resp_msg_v01 resp = {};
> +	struct wlfw_wlan_cfg_req_msg_v01 *req;
> +	struct qmi_txn txn;
> +	int ret;
> +	u32 i;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_wlan_cfg_resp_msg_v01_ei,
> +			   &resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	req->host_version_valid = 0;
> +
> +	req->tgt_cfg_valid = 1;
> +	if (config->num_ce_tgt_cfg > QMI_WLFW_MAX_NUM_CE_V01)
> +		req->tgt_cfg_len = QMI_WLFW_MAX_NUM_CE_V01;
> +	else
> +		req->tgt_cfg_len = config->num_ce_tgt_cfg;
> +	for (i = 0; i < req->tgt_cfg_len; i++) {
> +		req->tgt_cfg[i].pipe_num = config->ce_tgt_cfg[i].pipe_num;
> +		req->tgt_cfg[i].pipe_dir = config->ce_tgt_cfg[i].pipe_dir;
> +		req->tgt_cfg[i].nentries = config->ce_tgt_cfg[i].nentries;
> +		req->tgt_cfg[i].nbytes_max = config->ce_tgt_cfg[i].nbytes_max;
> +		req->tgt_cfg[i].flags = config->ce_tgt_cfg[i].flags;
> +	}
> +
> +	req->svc_cfg_valid = 1;
> +	if (config->num_ce_svc_pipe_cfg > QMI_WLFW_MAX_NUM_SVC_V01)
> +		req->svc_cfg_len = QMI_WLFW_MAX_NUM_SVC_V01;
> +	else
> +		req->svc_cfg_len = config->num_ce_svc_pipe_cfg;
> +	for (i = 0; i < req->svc_cfg_len; i++) {
> +		req->svc_cfg[i].service_id = config->ce_svc_cfg[i].service_id;
> +		req->svc_cfg[i].pipe_dir = config->ce_svc_cfg[i].pipe_dir;
> +		req->svc_cfg[i].pipe_num = config->ce_svc_cfg[i].pipe_num;
> +	}
> +
> +	req->shadow_reg_valid = 1;
> +	if (config->num_shadow_reg_cfg >
> +	    QMI_WLFW_MAX_NUM_SHADOW_REG_V01)
> +		req->shadow_reg_len = QMI_WLFW_MAX_NUM_SHADOW_REG_V01;
> +	else
> +		req->shadow_reg_len = config->num_shadow_reg_cfg;
> +
> +	memcpy(req->shadow_reg, config->shadow_reg_cfg,
> +	       sizeof(struct wlfw_shadow_reg_cfg_s_v01) * req->shadow_reg_len);
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_WLAN_CFG_REQ_V01,
> +			       WLFW_WLAN_CFG_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_wlan_cfg_req_msg_v01_ei, req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "send config req failed %d\n", ret);

"failed to send config request: %d\n"

> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "cfg req rejected, error:%d\n", resp.resp.error);

"config request rejected: %d\n"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "wlan config request completed\n");

"qmi ..."

> +	kfree(req);
> +	return 0;
> +
> +out:
> +	kfree(req);
> +	return ret;
> +}
> +
> +int ath10k_qmi_wlan_enable(struct ath10k *ar,
> +			   struct ath10k_qmi_wlan_enable_cfg *config,
> +			   enum ath10k_qmi_driver_mode mode,
> +			   const char *version)
> +{
> +	int ret;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "mode: %d, config: %p:\n",
> +		   mode, config);

"qmi mode %d config %p"

> +	ret = ath10k_qmi_cfg_send_sync_msg(ar, config, version);
> +	if (ret) {
> +		ath10k_err(ar, "wlan qmi config send failed\n");

"failed to send qmi config: %d\n"

> +		return ret;
> +	}
> +
> +	ret = ath10k_qmi_mode_send_sync_msg(ar, mode);
> +	if (ret) {
> +		ath10k_err(ar, "wlan qmi mode send failed\n");

"failed to send qmi mode: %d\n"

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +int ath10k_qmi_wlan_disable(struct ath10k *ar)
> +{
> +	return ath10k_qmi_mode_send_sync_msg(ar, QMI_WLFW_OFF_V01);
> +}
> +
> +static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_cap_resp_msg_v01 *resp;
> +	struct wlfw_cap_req_msg_v01 req = {};
> +	struct ath10k *ar = qmi->ar;
> +	struct qmi_txn txn;
> +	int ret;
> +
> +	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
> +	if (!resp)
> +		return -ENOMEM;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_cap_resp_msg_v01_ei, resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_CAP_REQ_V01,
> +			       WLFW_CAP_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_cap_req_msg_v01_ei, &req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "fail to send capability req %d\n", ret);

"failed to send capability request: %d\n"

> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "capablity req rejected, error:%d\n", resp->resp.error);

"capability request rejected: %d\n"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (resp->chip_info_valid) {
> +		qmi->chip_info.chip_id = resp->chip_info.chip_id;
> +		qmi->chip_info.chip_family = resp->chip_info.chip_family;
> +	}
> +
> +	if (resp->board_info_valid)
> +		qmi->board_info.board_id = resp->board_info.board_id;
> +	else
> +		qmi->board_info.board_id = 0xFF;
> +
> +	if (resp->soc_info_valid)
> +		qmi->soc_info.soc_id = resp->soc_info.soc_id;
> +
> +	if (resp->fw_version_info_valid) {
> +		qmi->fw_version = resp->fw_version_info.fw_version;
> +		strlcpy(qmi->fw_build_timestamp, resp->fw_version_info.fw_build_timestamp,
> +			sizeof(qmi->fw_build_timestamp));
> +	}
> +
> +	if (resp->fw_build_id_valid)
> +		strlcpy(qmi->fw_build_id, resp->fw_build_id,
> +			MAX_BUILD_ID_LEN + 1);
> +
> +	ath10k_info(ar, "chip_id: 0x%x, chip_family: 0x%x, board_id: 0x%x, soc_id: 0x%x",
> +		    qmi->chip_info.chip_id, qmi->chip_info.chip_family,
> +		    qmi->board_info.board_id, qmi->soc_info.soc_id);
> +	ath10k_info(ar, "fw_version: 0x%x, fw_build_timestamp: %s, fw_build_id: %s",
> +		    qmi->fw_version, qmi->fw_build_timestamp, qmi->fw_build_id);

We have already similar information printed in
ath10k_debug_print_hwfw_info(), for example firmware versions etc. I
think this is duplicating that, at least partly. The best is to turn
these to debug messages and we can later decide what extra information
wwe should print via ath10k_info() or in ath10k_debug_print_hwfw_info().

ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi chip_id 0x%x chip_family 0x%x board_id 0x%x soc_id 0x%x",
	    qmi->chip_info.chip_id, qmi->chip_info.chip_family,
	    qmi->board_info.board_id, qmi->soc_info.soc_id);
ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi fw_version 0x%x fw_build_timestamp %s fw_build_id %s",
	    qmi->fw_version, qmi->fw_build_timestamp, qmi->fw_build_id);


> +	kfree(resp);
> +	return 0;
> +
> +out:
> +	kfree(resp);
> +	return ret;
> +}
> +
> +static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_host_cap_resp_msg_v01 resp = {};
> +	struct wlfw_host_cap_req_msg_v01 req = {};
> +	struct ath10k *ar = qmi->ar;
> +	struct qmi_txn txn;
> +	int ret;
> +
> +	req.daemon_support_valid = 1;
> +	req.daemon_support = 0;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_host_cap_resp_msg_v01_ei, &resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_HOST_CAP_REQ_V01,
> +			       WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_host_cap_req_msg_v01_ei, &req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "Fail to send Capability req %d\n", ret);

"failed to send host capability request: %d\n"

Do note that error/warning messages need to be unique, that's why I
added the word "host" here.

> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "host cap req rejected, error:%d\n", resp.resp.error);

"host capability request rejected: %d\n"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "host capablity request completed\n");

"qmi ..."

> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
> +static int
> +ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_ind_register_resp_msg_v01 resp = {};
> +	struct wlfw_ind_register_req_msg_v01 req = {};
> +	struct ath10k *ar = qmi->ar;
> +	struct qmi_txn txn;
> +	int ret;
> +
> +	req.client_id_valid = 1;
> +	req.client_id = WLFW_CLIENT_ID;
> +	req.fw_ready_enable_valid = 1;
> +	req.fw_ready_enable = 1;
> +	req.msa_ready_enable_valid = 1;
> +	req.msa_ready_enable = 1;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_ind_register_resp_msg_v01_ei, &resp);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_IND_REGISTER_REQ_V01,
> +			       WLFW_IND_REGISTER_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_ind_register_req_msg_v01_ei, &req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		ath10k_err(ar, "fail to send ind register req %d\n", ret);

"failed to send indication registed request: %d\n"

I assume "ind" means "indication".

> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "indication req rejected, error:%d\n", resp.resp.error);

"indication request rejected: %d\n"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (resp.fw_status_valid) {
> +		if (resp.fw_status & QMI_WLFW_FW_READY_V01)
> +			qmi->fw_ready = true;
> +	}
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "indication register request completed\n");

"qmi ..."

> +static void ath10k_qmi_event_server_exit(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +
> +	ath10k_qmi_remove_msa_permission(qmi);
> +	ath10k_core_free_board_files(ar);
> +	ath10k_info(ar, "wifi fw qmi service disconnected\n");

This should be a debug message. ath10k_info() should be used very
sparingly, in general no new messages using it.

> +static int ath10k_qmi_event_fw_ready_ind(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +
> +	ath10k_info(ar, "wifi fw ready event received\n");

Ditto.

> +static int ath10k_qmi_new_server(struct qmi_handle *qmi_hdl,
> +				 struct qmi_service *service)
> +{
> +	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
> +	struct sockaddr_qrtr *sq = &qmi->sq;
> +	struct ath10k *ar = qmi->ar;
> +	int ret;
> +
> +	sq->sq_family = AF_QIPCRTR;
> +	sq->sq_node = service->node;
> +	sq->sq_port = service->port;
> +
> +	ath10k_info(ar, "wifi fw qmi server arrive\n");

Ditto.

> +
> +	ret = kernel_connect(qmi_hdl->sock, (struct sockaddr *)&qmi->sq,
> +			     sizeof(qmi->sq), 0);
> +	if (ret) {
> +		ath10k_err(ar, "fail to connect to remote service port\n");

"failed to connect to a remote QMI service port: %d\n"

> +		return ret;
> +	}
> +
> +	ath10k_info(ar, "wifi fw qmi service connected\n");

Debug message with "qmi ...".

> +static void ath10k_qmi_driver_event_work(struct work_struct *work)
> +{
> +	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
> +					      event_work);
> +	struct ath10k_qmi_driver_event *event;
> +	struct ath10k *ar = qmi->ar;
> +
> +	spin_lock(&qmi->event_lock);
> +	while (!list_empty(&qmi->event_list)) {
> +		event = list_first_entry(&qmi->event_list,
> +					 struct ath10k_qmi_driver_event, list);
> +		list_del(&event->list);
> +		spin_unlock(&qmi->event_lock);
> +
> +		switch (event->type) {
> +		case ATH10K_QMI_EVENT_SERVER_ARRIVE:
> +			ath10k_qmi_event_server_arrive(qmi);
> +			break;
> +		case ATH10K_QMI_EVENT_SERVER_EXIT:
> +			ath10k_qmi_event_server_exit(qmi);
> +			break;
> +		case ATH10K_QMI_EVENT_FW_READY_IND:
> +			ath10k_qmi_event_fw_ready_ind(qmi);
> +			break;
> +		case ATH10K_QMI_EVENT_MSA_READY_IND:
> +			ath10k_qmi_event_msa_ready(qmi);
> +			break;
> +		default:
> +			ath10k_err(ar, "invalid event type: %d", event->type);

The error message should be a bit more descriptive. And as we continue
execution it should be ath10k_warn().

> +			break;
> +		}
> +		kfree(event);
> +		spin_lock(&qmi->event_lock);
> +	}
> +	spin_unlock(&qmi->event_lock);
> +}
> +
> +static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +	struct device *dev = ar->dev;
> +	struct device_node *np;
> +	const __be32 *addrp;
> +	u64 prop_size = 0;
> +	int ret;
> +
> +	np = of_parse_phandle(dev->of_node, "msa-fixed-region", 0);
> +	if (np) {
> +		addrp = of_get_address(np, 0, &prop_size, NULL);
> +		if (!addrp) {
> +			ath10k_err(ar, "failed to get msa fixed addresses\n");
> +			return -EINVAL;
> +		}
> +
> +		qmi->msa_pa = of_translate_address(np, addrp);
> +		if (qmi->msa_pa == OF_BAD_ADDR) {
> +			ath10k_err(ar, "failed to translate fixed msa pa\n");
> +			return -EINVAL;
> +		}
> +
> +		qmi->msa_va = memremap(qmi->msa_pa, (unsigned long)prop_size,
> +				       MEMREMAP_WT);
> +		if (!qmi->msa_va) {
> +			ath10k_err(ar, "fixed msa ioremap failed: phy addr: %pa\n",
> +				   &qmi->msa_pa);

"failed to ioremap fixed msa (%pa)\n"

> +			return -EINVAL;
> +		}
> +		qmi->msa_mem_size = prop_size;
> +	} else {
> +		ret = of_property_read_u32(dev->of_node, "msa-size",
> +					   &qmi->msa_mem_size);
> +
> +		if (ret || qmi->msa_mem_size == 0) {
> +			ath10k_err(ar, "failed to get msa memory size node\n");
> +			return -ENOMEM;
> +		}

Please add a separate check and an error message for "qmi->msa_mem_size
== 0" with -EINVAL. And if of_property_read_u32() fails, return ret and
don't overwrite it.

> +
> +		qmi->msa_va = dmam_alloc_coherent(dev, qmi->msa_mem_size,
> +						  &qmi->msa_pa, GFP_KERNEL);
> +		if (!qmi->msa_va) {
> +			ath10k_err(ar, "dma alloc failed for msa region\n");

"failed to allocate dma memory for msa region"

> +			return -ENOMEM;
> +		}
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa pa: %pad , msa va: 0x%p\n",

"qmi msa pa %pad msa va 0x%p\n"

> +		   &qmi->msa_pa,
> +		   qmi->msa_va);
> +
> +	return 0;
> +}
> +
> +int ath10k_qmi_init(struct ath10k *ar)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	struct ath10k_qmi *qmi;
> +	int ret;
> +
> +	qmi = kzalloc(sizeof(*qmi), GFP_KERNEL);
> +	if (!qmi)
> +		return -ENOMEM;
> +
> +	qmi->ar = ar;
> +	ar_snoc->qmi = qmi;
> +
> +	ret = ath10k_qmi_setup_msa_resources(qmi);
> +	if (ret)
> +		goto err;
> +
> +	ret = qmi_handle_init(&qmi->qmi_hdl,
> +			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
> +			      &ath10k_qmi_ops, qmi_msg_handler);
> +	if (ret)
> +		goto err;
> +
> +	qmi->event_wq = alloc_workqueue("qmi_driver_event",
> +					WQ_UNBOUND, 1);

"ath10k_qmi_driver_event"?

> +	if (!qmi->event_wq) {
> +		ath10k_err(ar, "workqueue alloc failed\n");

"failed to allocate workqueue\n"

> +struct ath10k_qmi {
> +	struct ath10k *ar;
> +	struct qmi_handle qmi_hdl;
> +	struct sockaddr_qrtr sq;
> +	bool fw_ready;
> +	struct work_struct event_work;
> +	struct workqueue_struct *event_wq;
> +	struct list_head event_list;
> +	spinlock_t event_lock; /* spinlock for qmi event list */
> +	u32 nr_mem_region;
> +	struct ath10k_msa_mem_info
> +		mem_region[MAX_NUM_MEMORY_REGIONS];

I think this should fit within one 90 char line.

>  static int ath10k_snoc_wlan_enable(struct ath10k *ar)
>  {
> -	return 0;
> +	struct ath10k_tgt_pipe_cfg tgt_cfg[CE_COUNT_MAX];
> +	struct ath10k_qmi_wlan_enable_cfg cfg;
> +	enum ath10k_qmi_driver_mode mode;
> +	int pipe_num;
> +
> +	for (pipe_num = 0; pipe_num < CE_COUNT_MAX; pipe_num++) {
> +		tgt_cfg[pipe_num].pipe_num =
> +				target_ce_config_wlan[pipe_num].pipenum;
> +		tgt_cfg[pipe_num].pipe_dir =
> +				target_ce_config_wlan[pipe_num].pipedir;
> +		tgt_cfg[pipe_num].nentries =
> +				target_ce_config_wlan[pipe_num].nentries;
> +		tgt_cfg[pipe_num].nbytes_max =
> +				target_ce_config_wlan[pipe_num].nbytes_max;
> +		tgt_cfg[pipe_num].flags =
> +				target_ce_config_wlan[pipe_num].flags;
> +		tgt_cfg[pipe_num].reserved = 0;
> +	}
> +
> +	cfg.num_ce_tgt_cfg = sizeof(target_ce_config_wlan) /
> +				sizeof(struct ath10k_tgt_pipe_cfg);
> +	cfg.ce_tgt_cfg = (struct ath10k_tgt_pipe_cfg *)
> +		&tgt_cfg;
> +	cfg.num_ce_svc_pipe_cfg = sizeof(target_service_to_ce_map_wlan) /
> +				  sizeof(struct ath10k_svc_pipe_cfg);
> +	cfg.ce_svc_cfg = (struct ath10k_svc_pipe_cfg *)
> +		&target_service_to_ce_map_wlan;
> +	cfg.num_shadow_reg_cfg = sizeof(target_shadow_reg_cfg_map) /
> +					sizeof(struct ath10k_shadow_reg_cfg);
> +	cfg.shadow_reg_cfg = (struct ath10k_shadow_reg_cfg *)
> +		&target_shadow_reg_cfg_map;
> +
> +	mode = ar->testmode.utf_monitor ? QMI_FTM : QMI_MISSION;

That utf_monitor check looks suspicious, please add that in a separate
patch. So only support mission mode for now.

> +int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	int ret;
> +
> +	switch (type) {
> +	case ATH10K_QMI_EVENT_FW_READY_IND:
> +		ret = ath10k_core_register(ar,
> +					   ar_snoc->target_info.soc_version);
> +		if (ret) {
> +			ath10k_err(ar, "Failed to register driver core: %d\n",

"failed to register driver core: %d\n"

-- 
Kalle Valo
