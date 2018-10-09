Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB2AC64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 06:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5D98213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 06:32:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="OCOEzfeP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5D98213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbeJINr4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 09:47:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37503 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbeJINrz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 09:47:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id c10-v6so300529pgq.4
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 23:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8u6cvWY3IvZxUhnLAE24tk/GH9F9amMXSrrHd9PXAkM=;
        b=OCOEzfePLl9KTVMj2/+eVrNwSe2flAaV0MsEXfgTZHiTM04Fb03Zssx8K1kaMTbS8Z
         PDrB0REnUynnJ1rKCAM/GWzp7XwntEAKaHEfuKl/6xK8/QgvSMahqM5+qESV97ew0VYy
         /fZjycxBvs4hM60PFoRs9Ng/kDh5L9MaptGe8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8u6cvWY3IvZxUhnLAE24tk/GH9F9amMXSrrHd9PXAkM=;
        b=qF+WZLXPemaqB3DU+5BufWb1PNQ8vm79FE+Ws4QdUJzH/W7v8l4WX3MdEnvD0COW5D
         W24OGVT3tlXbP3x3w1Lzi75SQTb3MiycTrGI7F4xH7V8k3B3CPxyiaz/tDhkxqdGSgst
         K+tcCohdw3Nsld+hPhVxPAuolJ0PYs/ti0lE2sEjtKwJ2i0yThwEQ9gMy2N7oGaRi6Ec
         cBsi0LRdvYtHfK2SU5sOnbavHTySJ57x0iXf8179LQdd5tRcQNLMqNIh0A5RUMcBjiEV
         +Of54rXqv8TpF3BZF5lsR2XsofWnaiET6xkOw7GyaK1ocjzRwWOQrA0c/VpBabzKQTQE
         MG0w==
X-Gm-Message-State: ABuFfojo7btDLkYykiYz66m99N8OpPO0LpZxxVNnXERVziL5Bi7U1xMJ
        XIJM9nR80b0F+WnIeWzoFRbAyw==
X-Google-Smtp-Source: ACcGV60GpD4geqtdnchs9yDAnZP4eoorvtzbD80E9G6H4cyNZeXb1QDfdoEER21tnNjR8Qtvmcx+dg==
X-Received: by 2002:a63:f347:: with SMTP id t7-v6mr23706793pgj.255.1539066752904;
        Mon, 08 Oct 2018 23:32:32 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id z26-v6sm15027470pfh.77.2018.10.08.23.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 23:32:32 -0700 (PDT)
Date:   Mon, 8 Oct 2018 23:32:29 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, briannorris@chromium.org,
        niklas.cassel@linaro.org, andy.gross@linaro.org,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 6/6] ath10k: Add QMI message handshake for wcn3990
 client
Message-ID: <20181009063229.GC8498@tuxbook-pro>
References: <20180815092637.11455-1-govinds@codeaurora.org>
 <20180815092637.11455-7-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180815092637.11455-7-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed 15 Aug 02:26 PDT 2018, Govind Singh wrote:

> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
> subsystem. This layer is responsible for communicating qmi control
> messages to wifi fw QMI service using QMI messaging protocol.
> 
> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
> between components running between remote processors with underlying
> transport layer based on integrated chipset(shared memory) or
> discrete chipset(PCI/USB/SDIO/UART).
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/Kconfig  |    1 +
>  drivers/net/wireless/ath/ath10k/Makefile |    4 +-
>  drivers/net/wireless/ath/ath10k/core.c   |    6 +-
>  drivers/net/wireless/ath/ath10k/core.h   |    2 +
>  drivers/net/wireless/ath/ath10k/qmi.c    | 1019 ++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/qmi.h    |  129 +++
>  drivers/net/wireless/ath/ath10k/snoc.c   |  262 +++++-
>  drivers/net/wireless/ath/ath10k/snoc.h   |    4 +
>  8 files changed, 1417 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
> 
> diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
> index 54ff5930126c..7bf3615bd89c 100644
> --- a/drivers/net/wireless/ath/ath10k/Kconfig
> +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> @@ -43,6 +43,7 @@ config ATH10K_USB
>  config ATH10K_SNOC
>  	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
>  	depends on ATH10K && ARCH_QCOM
> +	select QCOM_QMI_HELPERS
>  	---help---
>  	  This module adds support for integrated WCN3990 chip connected
>  	  to system NOC(SNOC). Currently work in progress and will not
> diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
> index 44d60a61b242..66326b949ab1 100644
> --- a/drivers/net/wireless/ath/ath10k/Makefile
> +++ b/drivers/net/wireless/ath/ath10k/Makefile
> @@ -36,7 +36,9 @@ obj-$(CONFIG_ATH10K_USB) += ath10k_usb.o
>  ath10k_usb-y += usb.o
>  
>  obj-$(CONFIG_ATH10K_SNOC) += ath10k_snoc.o
> -ath10k_snoc-y += snoc.o
> +ath10k_snoc-y += qmi.o \
> +		 qmi_wlfw_v01.o \
> +		 snoc.o
>  
>  # for tracing framework to find trace.h
>  CFLAGS_trace.o := -I$(src)
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 840e301b6a6e..dfaf7e32ca32 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1145,7 +1145,7 @@ static int ath10k_download_fw(struct ath10k *ar)
>  	return ret;
>  }
>  
> -static void ath10k_core_free_board_files(struct ath10k *ar)
> +void ath10k_core_free_board_files(struct ath10k *ar)
>  {
>  	if (!IS_ERR(ar->normal_mode_fw.board))
>  		release_firmware(ar->normal_mode_fw.board);
> @@ -1154,6 +1154,7 @@ static void ath10k_core_free_board_files(struct ath10k *ar)
>  	ar->normal_mode_fw.board_data = NULL;
>  	ar->normal_mode_fw.board_len = 0;
>  }
> +EXPORT_SYMBOL(ath10k_core_free_board_files);
>  
>  static void ath10k_core_free_firmware_files(struct ath10k *ar)
>  {
> @@ -1459,7 +1460,7 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
>  	return 0;
>  }
>  
> -static int ath10k_core_fetch_board_file(struct ath10k *ar)
> +int ath10k_core_fetch_board_file(struct ath10k *ar)
>  {
>  	char boardname[100], fallback_boardname[100];
>  	int ret;
> @@ -1497,6 +1498,7 @@ static int ath10k_core_fetch_board_file(struct ath10k *ar)
>  	ath10k_dbg(ar, ATH10K_DBG_BOOT, "using board api %d\n", ar->bd_api);
>  	return 0;
>  }
> +EXPORT_SYMBOL(ath10k_core_fetch_board_file);
>  
>  int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
>  				     struct ath10k_fw_file *fw_file)
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 3a4ac3c0d5a6..a4d70005c4fe 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -1166,5 +1166,7 @@ int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
>  void ath10k_core_stop(struct ath10k *ar);
>  int ath10k_core_register(struct ath10k *ar, u32 chip_id);
>  void ath10k_core_unregister(struct ath10k *ar);
> +int ath10k_core_fetch_board_file(struct ath10k *ar);
> +void ath10k_core_free_board_files(struct ath10k *ar);
>  
>  #endif /* _CORE_H_ */
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> new file mode 100644
> index 000000000000..784e082e4a28
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -0,0 +1,1019 @@
> +/*
> + * Copyright (c) 2018 The Linux Foundation. All rights reserved.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#include <linux/completion.h>
> +#include <linux/device.h>
> +#include <linux/debugfs.h>
> +#include <linux/idr.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/module.h>
> +#include <linux/net.h>
> +#include <linux/platform_device.h>
> +#include <linux/qcom_scm.h>
> +#include <linux/string.h>
> +#include <net/sock.h>
> +
> +#include "debug.h"
> +#include "snoc.h"
> +
> +#define ATH10K_QMI_CLIENT_ID		0x4b4e454c
> +#define ATH10K_QMI_TIMEOUT		30
> +
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
> +		ath10k_err(ar, "failed to assign msa map permissions: %d\n", ret);
> +
> +	return ret;
> +}
> +
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
> +		ath10k_err(ar, "failed to unmap msa permissions: %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int ath10k_qmi_setup_msa_permissions(struct ath10k_qmi *qmi)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < qmi->nr_mem_region; i++) {
> +		ret = ath10k_qmi_map_msa_permission(qmi, &qmi->mem_region[i]);
> +		if (ret)
> +			goto err_unmap;
> +	}
> +
> +	return 0;
> +
> +err_unmap:
> +	for (i--; i >= 0; i--)
> +		ath10k_qmi_unmap_msa_permission(qmi, &qmi->mem_region[i]);
> +	return ret;
> +}
> +
> +static void ath10k_qmi_remove_msa_permission(struct ath10k_qmi *qmi)
> +{
> +	int i;
> +
> +	for (i = 0; i < qmi->nr_mem_region; i++)
> +		ath10k_qmi_unmap_msa_permission(qmi, &qmi->mem_region[i]);
> +}
> +
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
> +		ath10k_err(ar, "failed to send msa mem info req: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "msa info req rejected: %d\n", resp.resp.error);
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
> +		ath10k_dbg(ar, ATH10K_DBG_QMI,
> +			   "qmi msa mem region %d addr 0x%pa size 0x%x flag 0x%08x\n",
> +			   i, &qmi->mem_region[i].addr,
> +			   qmi->mem_region[i].size,
> +			   qmi->mem_region[i].secure);
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi msa mem info request completed\n");
> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
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
> +		ath10k_err(ar, "failed to send msa mem ready request: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "msa ready request rejected: %d\n", resp.resp.error);
> +		ret = -EINVAL;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi msa mem ready request completed\n");
> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
> +static int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
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
> +			goto out;
> +		}
> +
> +		ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +
> +		if (ret < 0)
> +			goto out;
> +
> +		if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +			ath10k_err(ar, "failed to download board data file: %d\n",
> +				   resp.resp.error);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		remaining -= req->data_len;
> +		temp += req->data_len;
> +		req->seg_id++;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi bdf download request completed\n");
> +
> +	kfree(req);
> +	return 0;
> +
> +out:
> +	kfree(req);
> +	return ret;
> +}
> +
> +static int ath10k_qmi_send_cal_report_req(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_cal_report_resp_msg_v01 resp = {};
> +	struct wlfw_cal_report_req_msg_v01 req = {};
> +	struct ath10k *ar = qmi->ar;
> +	struct qmi_txn txn;
> +	int i, j = 0;
> +	int ret;
> +
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
> +		ath10k_err(ar, "failed to send calibration request: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "calibration request rejected: %d\n", resp.resp.error);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi cal report request completed\n");
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
> +		ath10k_err(ar, "failed to send wlan mode %d request: %d\n", mode, ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "more request rejected: %d\n", resp.resp.error);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi wlan mode req completed: %d\n", mode);
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
> +		ath10k_err(ar, "failed to send config request: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "config request rejected: %d\n", resp.resp.error);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi config request completed\n");
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
> +			   enum wlfw_driver_mode_enum_v01 mode,
> +			   const char *version)
> +{
> +	int ret;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi mode %d config %p\n",
> +		   mode, config);
> +
> +	ret = ath10k_qmi_cfg_send_sync_msg(ar, config, version);
> +	if (ret) {
> +		ath10k_err(ar, "failed to send qmi config: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = ath10k_qmi_mode_send_sync_msg(ar, mode);
> +	if (ret) {
> +		ath10k_err(ar, "failed to send qmi mode: %d\n", ret);
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
> +		ath10k_err(ar, "failed to send capability request: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "capablity req rejected: %d\n", resp->resp.error);
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
> +	ath10k_dbg(ar, ATH10K_DBG_QMI,
> +		   "qmi chip_id 0x%x chip_family 0x%x board_id 0x%x soc_id 0x%x",
> +		   qmi->chip_info.chip_id, qmi->chip_info.chip_family,
> +		   qmi->board_info.board_id, qmi->soc_info.soc_id);
> +	ath10k_dbg(ar, ATH10K_DBG_QMI,
> +		   "qmi fw_version 0x%x fw_build_timestamp %s fw_build_id %s",
> +		   qmi->fw_version, qmi->fw_build_timestamp, qmi->fw_build_id);
> +
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
> +		ath10k_err(ar, "failed to send host capability request: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "host capability request rejected: %d\n", resp.resp.error);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi host capablity request completed\n");
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
> +	req.client_id = ATH10K_QMI_CLIENT_ID;
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
> +		ath10k_err(ar, "failed to send indication registed request: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, ATH10K_QMI_TIMEOUT * HZ);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> +		ath10k_err(ar, "indication request rejected: %d\n", resp.resp.error);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (resp.fw_status_valid) {
> +		if (resp.fw_status & QMI_WLFW_FW_READY_V01)
> +			qmi->fw_ready = true;
> +	}
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi indication register request completed\n");
> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
> +static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +	int ret;
> +
> +	ret = ath10k_qmi_ind_register_send_sync_msg(qmi);
> +	if (ret)
> +		return;
> +
> +	if (qmi->fw_ready) {
> +		ath10k_snoc_fw_indication(ar, ATH10K_QMI_EVENT_FW_READY_IND);
> +		return;
> +	}
> +
> +	ret = ath10k_qmi_host_cap_send_sync(qmi);
> +	if (ret)
> +		return;
> +
> +	ret = ath10k_qmi_msa_mem_info_send_sync_msg(qmi);
> +	if (ret)
> +		return;
> +
> +	ret = ath10k_qmi_setup_msa_permissions(qmi);
> +	if (ret)
> +		return;
> +
> +	ret = ath10k_qmi_msa_ready_send_sync_msg(qmi);
> +	if (ret)
> +		goto err_setup_msa;
> +
> +	ret = ath10k_qmi_cap_send_sync_msg(qmi);
> +	if (ret)
> +		goto err_setup_msa;
> +
> +	return;
> +
> +err_setup_msa:
> +	ath10k_qmi_remove_msa_permission(qmi);
> +}
> +
> +static int ath10k_qmi_fetch_board_file(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +
> +	ar->hif.bus = ATH10K_BUS_SNOC;
> +	ar->id.qmi_ids_valid = true;
> +	ar->id.qmi_board_id = qmi->board_info.board_id;
> +	ar->hw_params.fw.dir = WCN3990_HW_1_0_FW_DIR;
> +
> +	return ath10k_core_fetch_board_file(qmi->ar);
> +}
> +
> +static int
> +ath10k_qmi_driver_event_post(struct ath10k_qmi *qmi,
> +			     enum ath10k_qmi_driver_event_type type,
> +			     void *data)
> +{
> +	struct ath10k_qmi_driver_event *event;
> +
> +	event = kzalloc(sizeof(*event), GFP_ATOMIC);
> +	if (!event)
> +		return -ENOMEM;
> +
> +	event->type = type;
> +	event->data = data;
> +
> +	spin_lock(&qmi->event_lock);
> +	list_add_tail(&event->list, &qmi->event_list);
> +	spin_unlock(&qmi->event_lock);
> +
> +	queue_work(qmi->event_wq, &qmi->event_work);
> +
> +	return 0;
> +}
> +
> +static void ath10k_qmi_event_server_exit(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +
> +	ath10k_qmi_remove_msa_permission(qmi);
> +	ath10k_core_free_board_files(ar);
> +	ath10k_snoc_fw_indication(ar, ATH10K_QMI_EVENT_FW_DOWN_IND);
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "wifi fw qmi service disconnected\n");
> +}
> +
> +static void ath10k_qmi_event_msa_ready(struct ath10k_qmi *qmi)
> +{
> +	int ret;
> +
> +	ret = ath10k_qmi_fetch_board_file(qmi);
> +	if (ret)
> +		goto out;
> +
> +	ret = ath10k_qmi_bdf_dnld_send_sync(qmi);
> +	if (ret)
> +		goto out;
> +
> +	ret = ath10k_qmi_send_cal_report_req(qmi);
> +
> +out:
> +	return;
> +}
> +
> +static int ath10k_qmi_event_fw_ready_ind(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "wifi fw ready event received\n");
> +	ath10k_snoc_fw_indication(ar, ATH10K_QMI_EVENT_FW_READY_IND);
> +
> +	return 0;
> +}
> +
> +static void ath10k_qmi_fw_ready_ind(struct qmi_handle *qmi_hdl,
> +				    struct sockaddr_qrtr *sq,
> +				    struct qmi_txn *txn, const void *data)
> +{
> +	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
> +
> +	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_FW_READY_IND, NULL);
> +}
> +
> +static void ath10k_qmi_msa_ready_ind(struct qmi_handle *qmi_hdl,
> +				     struct sockaddr_qrtr *sq,
> +				     struct qmi_txn *txn, const void *data)
> +{
> +	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
> +
> +	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_MSA_READY_IND, NULL);
> +}
> +
> +static struct qmi_msg_handler qmi_msg_handler[] = {
> +	{
> +		.type = QMI_INDICATION,
> +		.msg_id = QMI_WLFW_FW_READY_IND_V01,
> +		.ei = wlfw_fw_ready_ind_msg_v01_ei,
> +		.decoded_size = sizeof(struct wlfw_fw_ready_ind_msg_v01),
> +		.fn = ath10k_qmi_fw_ready_ind,
> +	},
> +	{
> +		.type = QMI_INDICATION,
> +		.msg_id = QMI_WLFW_MSA_READY_IND_V01,
> +		.ei = wlfw_msa_ready_ind_msg_v01_ei,
> +		.decoded_size = sizeof(struct wlfw_msa_ready_ind_msg_v01),
> +		.fn = ath10k_qmi_msa_ready_ind,
> +	},
> +	{}
> +};
> +
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
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "wifi fw qmi service found\n");
> +
> +	ret = kernel_connect(qmi_hdl->sock, (struct sockaddr *)&qmi->sq,
> +			     sizeof(qmi->sq), 0);
> +	if (ret) {
> +		ath10k_err(ar, "failed to connect to a remote QMI service port\n");
> +		return ret;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi wifi fw qmi service connected\n");
> +	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_SERVER_ARRIVE, NULL);
> +
> +	return ret;
> +}
> +
> +static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
> +				  struct qmi_service *service)
> +{
> +	struct ath10k_qmi *qmi =
> +		container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
> +
> +	qmi->fw_ready = false;
> +	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_SERVER_EXIT, NULL);
> +}
> +
> +static struct qmi_ops ath10k_qmi_ops = {
> +	.new_server = ath10k_qmi_new_server,
> +	.del_server = ath10k_qmi_del_server,
> +};
> +
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
> +			ath10k_warn(ar, "invalid event type: %d", event->type);
> +			break;
> +		}
> +		kfree(event);
> +		spin_lock(&qmi->event_lock);
> +	}
> +	spin_unlock(&qmi->event_lock);
> +}
> +
> +static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi, u32 msa_size)
> +{
> +	struct ath10k *ar = qmi->ar;
> +	struct device *dev = ar->dev;
> +	struct device_node *node;
> +	struct resource r;
> +	int ret;
> +
> +	node = of_parse_phandle(dev->of_node, "memory-region", 0);
> +	if (node) {
> +		ret = of_address_to_resource(node, 0, &r);
> +		if (ret) {
> +			dev_err(dev, "failed to resolve msa fixed region\n");
> +			return ret;
> +		}
> +		of_node_put(node);
> +
> +		qmi->msa_pa = r.start;
> +		qmi->msa_mem_size = resource_size(&r);
> +		qmi->msa_va = devm_memremap(dev, qmi->msa_pa, qmi->msa_mem_size,
> +					    MEMREMAP_WT);
> +		if (!qmi->msa_pa) {
> +			dev_err(dev, "failed to map memory region: %pa\n", &r.start);
> +			return -EBUSY;
> +		}
> +	} else {
> +		qmi->msa_va = dmam_alloc_coherent(dev, msa_size,
> +						  &qmi->msa_pa, GFP_KERNEL);
> +		if (!qmi->msa_va) {
> +			ath10k_err(ar, "failed to allocate dma memory for msa region\n");
> +			return -ENOMEM;
> +		}
> +		qmi->msa_mem_size = msa_size;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa pa: %pad , msa va: 0x%p\n",
> +		   &qmi->msa_pa,
> +		   qmi->msa_va);
> +
> +	return 0;
> +}
> +
> +int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
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
> +	ret = ath10k_qmi_setup_msa_resources(qmi, msa_size);
> +	if (ret)
> +		goto err;
> +
> +	ret = qmi_handle_init(&qmi->qmi_hdl,
> +			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
> +			      &ath10k_qmi_ops, qmi_msg_handler);
> +	if (ret)
> +		goto err;
> +
> +	qmi->event_wq = alloc_workqueue("ath10k_qmi_driver_event",
> +					WQ_UNBOUND, 1);
> +	if (!qmi->event_wq) {
> +		ath10k_err(ar, "failed to allocate workqueue\n");
> +		ret = -EFAULT;
> +		goto err_release_qmi_handle;
> +	}
> +
> +	INIT_LIST_HEAD(&qmi->event_list);
> +	spin_lock_init(&qmi->event_lock);
> +	INIT_WORK(&qmi->event_work, ath10k_qmi_driver_event_work);
> +
> +	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
> +			     WLFW_SERVICE_VERS_V01, 0);
> +	if (ret)
> +		goto err_qmi_lookup;
> +
> +	return 0;
> +
> +err_qmi_lookup:
> +	destroy_workqueue(qmi->event_wq);
> +
> +err_release_qmi_handle:
> +	qmi_handle_release(&qmi->qmi_hdl);
> +
> +err:
> +	kfree(qmi);
> +	return ret;
> +}
> +
> +int ath10k_qmi_deinit(struct ath10k *ar)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	struct ath10k_qmi *qmi = ar_snoc->qmi;
> +
> +	qmi_handle_release(&qmi->qmi_hdl);
> +	cancel_work_sync(&qmi->event_work);
> +	destroy_workqueue(qmi->event_wq);
> +	ar_snoc->qmi = NULL;
> +
> +	return 0;
> +}
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
> new file mode 100644
> index 000000000000..1efe1d22fc2f
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/qmi.h
> @@ -0,0 +1,129 @@
> +/*
> + * Copyright (c) 2018 The Linux Foundation. All rights reserved.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +#ifndef _ATH10K_QMI_H_
> +#define _ATH10K_QMI_H_
> +
> +#include <linux/soc/qcom/qmi.h>
> +#include <linux/qrtr.h>
> +#include "qmi_wlfw_v01.h"
> +
> +#define MAX_NUM_MEMORY_REGIONS			2
> +#define MAX_TIMESTAMP_LEN			32
> +#define MAX_BUILD_ID_LEN			128
> +#define MAX_NUM_CAL_V01			5
> +
> +enum ath10k_qmi_driver_event_type {
> +	ATH10K_QMI_EVENT_SERVER_ARRIVE,
> +	ATH10K_QMI_EVENT_SERVER_EXIT,
> +	ATH10K_QMI_EVENT_FW_READY_IND,
> +	ATH10K_QMI_EVENT_FW_DOWN_IND,
> +	ATH10K_QMI_EVENT_MSA_READY_IND,
> +	ATH10K_QMI_EVENT_MAX,
> +};
> +
> +struct ath10k_msa_mem_info {
> +	phys_addr_t addr;
> +	u32 size;
> +	bool secure;
> +};
> +
> +struct ath10k_qmi_chip_info {
> +	u32 chip_id;
> +	u32 chip_family;
> +};
> +
> +struct ath10k_qmi_board_info {
> +	u32 board_id;
> +};
> +
> +struct ath10k_qmi_soc_info {
> +	u32 soc_id;
> +};
> +
> +struct ath10k_qmi_cal_data {
> +	u32 cal_id;
> +	u32 total_size;
> +	u8 *data;
> +};
> +
> +struct ath10k_tgt_pipe_cfg {
> +	__le32 pipe_num;
> +	__le32 pipe_dir;
> +	__le32 nentries;
> +	__le32 nbytes_max;
> +	__le32 flags;
> +	__le32 reserved;
> +};
> +
> +struct ath10k_svc_pipe_cfg {
> +	__le32 service_id;
> +	__le32 pipe_dir;
> +	__le32 pipe_num;
> +};
> +
> +struct ath10k_shadow_reg_cfg {
> +	__le16 ce_id;
> +	__le16 reg_offset;
> +};
> +
> +struct ath10k_qmi_wlan_enable_cfg {
> +	u32 num_ce_tgt_cfg;
> +	struct ath10k_tgt_pipe_cfg *ce_tgt_cfg;
> +	u32 num_ce_svc_pipe_cfg;
> +	struct ath10k_svc_pipe_cfg *ce_svc_cfg;
> +	u32 num_shadow_reg_cfg;
> +	struct ath10k_shadow_reg_cfg *shadow_reg_cfg;
> +};
> +
> +struct ath10k_qmi_driver_event {
> +	struct list_head list;
> +	enum ath10k_qmi_driver_event_type type;
> +	void *data;
> +};
> +
> +struct ath10k_qmi {
> +	struct ath10k *ar;
> +	struct qmi_handle qmi_hdl;
> +	struct sockaddr_qrtr sq;
> +	struct work_struct event_work;
> +	struct workqueue_struct *event_wq;
> +	struct list_head event_list;
> +	spinlock_t event_lock; /* spinlock for qmi event list */
> +	u32 nr_mem_region;
> +	struct ath10k_msa_mem_info mem_region[MAX_NUM_MEMORY_REGIONS];
> +	dma_addr_t msa_pa;
> +	u32 msa_mem_size;
> +	void *msa_va;
> +	struct ath10k_qmi_chip_info chip_info;
> +	struct ath10k_qmi_board_info board_info;
> +	struct ath10k_qmi_soc_info soc_info;
> +	char fw_build_id[MAX_BUILD_ID_LEN + 1];
> +	u32 fw_version;
> +	bool fw_ready;
> +	char fw_build_timestamp[MAX_TIMESTAMP_LEN + 1];
> +	struct ath10k_qmi_cal_data cal_data[MAX_NUM_CAL_V01];
> +};
> +
> +int ath10k_qmi_wlan_enable(struct ath10k *ar,
> +			   struct ath10k_qmi_wlan_enable_cfg *config,
> +			   enum wlfw_driver_mode_enum_v01 mode,
> +			   const char *version);
> +int ath10k_qmi_wlan_disable(struct ath10k *ar);
> +int ath10k_qmi_register_service_notifier(struct notifier_block *nb);
> +int ath10k_qmi_init(struct ath10k *ar, u32 msa_size);
> +int ath10k_qmi_deinit(struct ath10k *ar);
> +
> +#endif /* ATH10K_QMI_H */
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index fa1843a7e0fd..e9a6b3dc0c11 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -66,6 +66,72 @@ static void ath10k_snoc_htt_htc_rx_cb(struct ath10k_ce_pipe *ce_state);
>  static const struct ath10k_snoc_drv_priv drv_priv = {
>  	.hw_rev = ATH10K_HW_WCN3990,
>  	.dma_mask = DMA_BIT_MASK(37),
> +	.msa_size = 0x100000,
> +};
> +
> +#define WCN3990_SRC_WR_IDX_OFFSET 0x3C
> +#define WCN3990_DST_WR_IDX_OFFSET 0x40
> +
> +static struct ath10k_shadow_reg_cfg target_shadow_reg_cfg_map[] = {
> +		{
> +			.ce_id = __cpu_to_le16(0),
> +			.reg_offset = __cpu_to_le16(WCN3990_SRC_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(3),
> +			.reg_offset = __cpu_to_le16(WCN3990_SRC_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(4),
> +			.reg_offset = __cpu_to_le16(WCN3990_SRC_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(5),
> +			.reg_offset =  __cpu_to_le16(WCN3990_SRC_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(7),
> +			.reg_offset = __cpu_to_le16(WCN3990_SRC_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(1),
> +			.reg_offset = __cpu_to_le16(WCN3990_DST_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(2),
> +			.reg_offset =  __cpu_to_le16(WCN3990_DST_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(7),
> +			.reg_offset =  __cpu_to_le16(WCN3990_DST_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(8),
> +			.reg_offset =  __cpu_to_le16(WCN3990_DST_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(9),
> +			.reg_offset = __cpu_to_le16(WCN3990_DST_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(10),
> +			.reg_offset =  __cpu_to_le16(WCN3990_DST_WR_IDX_OFFSET),
> +		},
> +
> +		{
> +			.ce_id = __cpu_to_le16(11),
> +			.reg_offset = __cpu_to_le16(WCN3990_DST_WR_IDX_OFFSET),
> +		},
>  };
>  
>  static struct ce_attr host_ce_config_wlan[] = {
> @@ -175,6 +241,128 @@ static struct ce_attr host_ce_config_wlan[] = {
>  	},
>  };
>  
> +static struct ce_pipe_config target_ce_config_wlan[] = {
> +	/* CE0: host->target HTC control and raw streams */
> +	{
> +		.pipenum = __cpu_to_le32(0),
> +		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE1: target->host HTT + HTC control */
> +	{
> +		.pipenum = __cpu_to_le32(1),
> +		.pipedir = __cpu_to_le32(PIPEDIR_IN),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE2: target->host WMI */
> +	{
> +		.pipenum = __cpu_to_le32(2),
> +		.pipedir = __cpu_to_le32(PIPEDIR_IN),
> +		.nentries = __cpu_to_le32(64),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE3: host->target WMI */
> +	{
> +		.pipenum = __cpu_to_le32(3),
> +		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE4: host->target HTT */
> +	{
> +		.pipenum = __cpu_to_le32(4),
> +		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
> +		.nentries = __cpu_to_le32(256),
> +		.nbytes_max = __cpu_to_le32(256),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS | CE_ATTR_DIS_INTR),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE5: target->host HTT (HIF->HTT) */
> +	{
> +		.pipenum = __cpu_to_le32(5),
> +		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
> +		.nentries = __cpu_to_le32(1024),
> +		.nbytes_max = __cpu_to_le32(64),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS | CE_ATTR_DIS_INTR),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE6: Reserved for target autonomous hif_memcpy */
> +	{
> +		.pipenum = __cpu_to_le32(6),
> +		.pipedir = __cpu_to_le32(PIPEDIR_INOUT),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(16384),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE7 used only by Host */
> +	{
> +		.pipenum = __cpu_to_le32(7),
> +		.pipedir = __cpu_to_le32(4),
> +		.nentries = __cpu_to_le32(0),
> +		.nbytes_max = __cpu_to_le32(0),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS | CE_ATTR_DIS_INTR),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE8 Target to uMC */
> +	{
> +		.pipenum = __cpu_to_le32(8),
> +		.pipedir = __cpu_to_le32(PIPEDIR_IN),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(0),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE9 target->host HTT */
> +	{
> +		.pipenum = __cpu_to_le32(9),
> +		.pipedir = __cpu_to_le32(PIPEDIR_IN),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE10 target->host HTT */
> +	{
> +		.pipenum = __cpu_to_le32(10),
> +		.pipedir = __cpu_to_le32(PIPEDIR_IN),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +
> +	/* CE11 target autonomous qcache memcpy */
> +	{
> +		.pipenum = __cpu_to_le32(11),
> +		.pipedir = __cpu_to_le32(PIPEDIR_IN),
> +		.nentries = __cpu_to_le32(32),
> +		.nbytes_max = __cpu_to_le32(2048),
> +		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
> +		.reserved = __cpu_to_le32(0),
> +	},
> +};
> +
>  static struct service_to_pipe target_service_to_ce_map_wlan[] = {
>  	{
>  		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_VO),
> @@ -756,11 +944,47 @@ static int ath10k_snoc_init_pipes(struct ath10k *ar)
>  
>  static int ath10k_snoc_wlan_enable(struct ath10k *ar)
>  {
> -	return 0;
> +	struct ath10k_tgt_pipe_cfg tgt_cfg[CE_COUNT_MAX];
> +	struct ath10k_qmi_wlan_enable_cfg cfg;
> +	enum wlfw_driver_mode_enum_v01 mode;
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
> +	mode = QMI_WLFW_MISSION_V01;
> +
> +	return ath10k_qmi_wlan_enable(ar, &cfg, mode,
> +				       NULL);
>  }
>  
>  static void ath10k_snoc_wlan_disable(struct ath10k *ar)
>  {
> +	ath10k_qmi_wlan_disable(ar);
>  }
>  
>  static void ath10k_snoc_hif_power_down(struct ath10k *ar)
> @@ -948,6 +1172,30 @@ static int ath10k_snoc_resource_init(struct ath10k *ar)
>  	return ret;
>  }
>  
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
> +			ath10k_err(ar, "failed to register driver core: %d\n",
> +				   ret);
> +		}
> +		break;
> +	case ATH10K_QMI_EVENT_FW_DOWN_IND:
> +		break;
> +	default:
> +		ath10k_err(ar, "invalid fw indication: %llx\n", type);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int ath10k_snoc_setup_resource(struct ath10k *ar)
>  {
>  	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> @@ -1272,6 +1520,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>  	struct ath10k_snoc *ar_snoc;
>  	struct device *dev;
>  	struct ath10k *ar;
> +	u32 msa_size;
>  	int ret;
>  	u32 i;
>  
> @@ -1303,6 +1552,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>  	ar_snoc->ar = ar;
>  	ar_snoc->ce.bus_ops = &ath10k_snoc_bus_ops;
>  	ar->ce_priv = &ar_snoc->ce;
> +	msa_size = drv_data->msa_size;
>  
>  	ret = ath10k_snoc_resource_init(ar);
>  	if (ret) {
> @@ -1341,10 +1591,10 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>  		goto err_free_irq;
>  	}
>  
> -	ret = ath10k_core_register(ar, drv_data->hw_rev);
> +	ret = ath10k_qmi_init(ar, msa_size);
>  	if (ret) {
> -		ath10k_err(ar, "failed to register driver core: %d\n", ret);
> -		goto err_hw_power_off;
> +		ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
> +		goto err_core_destroy;
>  	}
>  
>  	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
> @@ -1352,9 +1602,6 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> -err_hw_power_off:
> -	ath10k_hw_power_off(ar);
> -
>  err_free_irq:
>  	ath10k_snoc_free_irq(ar);
>  
> @@ -1376,6 +1623,7 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
>  	ath10k_hw_power_off(ar);
>  	ath10k_snoc_free_irq(ar);
>  	ath10k_snoc_release_resource(ar);
> +	ath10k_qmi_deinit(ar);
>  	ath10k_core_destroy(ar);
>  
>  	return 0;
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
> index f9e530189d48..e1d2d6675556 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.h
> +++ b/drivers/net/wireless/ath/ath10k/snoc.h
> @@ -19,10 +19,12 @@
>  
>  #include "hw.h"
>  #include "ce.h"
> +#include "qmi.h"
>  
>  struct ath10k_snoc_drv_priv {
>  	enum ath10k_hw_rev hw_rev;
>  	u64 dma_mask;
> +	u32 msa_size;
>  };
>  
>  struct snoc_state {
> @@ -81,6 +83,7 @@ struct ath10k_snoc {
>  	struct timer_list rx_post_retry;
>  	struct ath10k_wcn3990_vreg_info *vreg;
>  	struct ath10k_wcn3990_clk_info *clk;
> +	struct ath10k_qmi *qmi;
>  };
>  
>  static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
> @@ -90,5 +93,6 @@ static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
>  
>  void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value);
>  u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset);
> +int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type);
>  
>  #endif /* _SNOC_H_ */
> -- 
> 2.17.0
> 
