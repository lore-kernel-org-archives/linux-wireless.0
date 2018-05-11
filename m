Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46978 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbeEKSmL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 14:42:11 -0400
Received: by mail-pg0-f65.google.com with SMTP id z4-v6so2771799pgu.13
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 11:42:11 -0700 (PDT)
Date: Fri, 11 May 2018 11:43:31 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 07/12] ath10k: Add MSA handshake QMI mgs support
Message-ID: <20180511184331.GR2259@tuxbook-pro> (sfid-20180511_204215_926425_498E251F)
References: <1522042832-25975-1-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522042832-25975-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 25 Mar 22:40 PDT 2018, Govind Singh wrote:

> HOST allocates 2mb of region for modem and WCN3990
> secure access and provides the address and access
> control to target for secure access.
> Add MSA handshake request/response messages.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/qmi.c | 288 +++++++++++++++++++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/qmi.h |  14 ++
>  2 files changed, 300 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index bc80b8f..763b812 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -26,6 +26,8 @@
>  #include <linux/string.h>
>  #include <net/sock.h>
>  #include <linux/soc/qcom/qmi.h>
> +#include <linux/qcom_scm.h>
> +#include <linux/of.h>
>  #include "qmi.h"
>  #include "qmi_svc_v01.h"
>  
> @@ -35,6 +37,240 @@
>  static struct ath10k_qmi *qmi;
>  
>  static int
> +ath10k_qmi_map_msa_permissions(struct ath10k_msa_mem_region_info *mem_region)
> +{
> +	struct qcom_scm_vmperm dst_perms[3];
> +	unsigned int src_perms;
> +	phys_addr_t addr;
> +	u32 perm_count;
> +	u32 size;
> +	int ret;
> +
> +	addr = mem_region->reg_addr;
> +	size = mem_region->size;

Skip the local variables.

> +
> +	src_perms = BIT(QCOM_SCM_VMID_HLOS);
> +
> +	dst_perms[0].vmid = QCOM_SCM_VMID_MSS_MSA;
> +	dst_perms[0].perm = QCOM_SCM_PERM_RW;
> +	dst_perms[1].vmid = QCOM_SCM_VMID_WLAN;
> +	dst_perms[1].perm = QCOM_SCM_PERM_RW;
> +
> +	if (!mem_region->secure_flag) {

So with secure_flag equal to 0 we give less subsystems access to the
data? Is this logic inverted?

> +		dst_perms[2].vmid = QCOM_SCM_VMID_WLAN_CE;
> +		dst_perms[2].perm = QCOM_SCM_PERM_RW;
> +		perm_count = 3;
> +	} else {
> +		dst_perms[2].vmid = 0;
> +		dst_perms[2].perm = 0;
> +		perm_count = 2;

If you set perm_count to 2 you don't need to clear vmid and perm of
dst_perms[2].

> +	}
> +
> +	ret = qcom_scm_assign_mem(addr, size, &src_perms,
> +				  dst_perms, perm_count);
> +	if (ret < 0)
> +		pr_err("msa map permission failed=%d\n", ret);

Use dev_err()

> +
> +	return ret;
> +}
> +
> +static int
> +ath10k_qmi_unmap_msa_permissions(struct ath10k_msa_mem_region_info *mem_region)
> +{
> +	struct qcom_scm_vmperm dst_perms;
> +	unsigned int src_perms;
> +	phys_addr_t addr;
> +	u32 size;
> +	int ret;
> +
> +	addr = mem_region->reg_addr;
> +	size = mem_region->size;

Skip the local variables.

> +
> +	src_perms = BIT(QCOM_SCM_VMID_MSS_MSA) | BIT(QCOM_SCM_VMID_WLAN);
> +
> +	if (!mem_region->secure_flag)
> +		src_perms |= BIT(QCOM_SCM_VMID_WLAN_CE);
> +
> +	dst_perms.vmid = QCOM_SCM_VMID_HLOS;
> +	dst_perms.perm = QCOM_SCM_PERM_RW;
> +
> +	ret = qcom_scm_assign_mem(addr, size, &src_perms, &dst_perms, 1);
> +	if (ret < 0)
> +		pr_err("msa unmap permission failed=%d\n", ret);
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
> +		ret = ath10k_qmi_map_msa_permissions(&qmi->mem_region[i]);
> +		if (ret)
> +			goto err_unmap;
> +	}
> +
> +	return 0;
> +
> +err_unmap:
> +	for (i--; i >= 0; i--)
> +		ath10k_qmi_unmap_msa_permissions(&qmi->mem_region[i]);
> +	return ret;
> +}
> +
> +static void ath10k_qmi_remove_msa_permissions(struct ath10k_qmi *qmi)
> +{
> +	int i;
> +
> +	for (i = 0; i < qmi->nr_mem_region; i++)
> +		ath10k_qmi_unmap_msa_permissions(&qmi->mem_region[i]);
> +}
> +
> +static int
> +	ath10k_qmi_msa_mem_info_send_sync_msg(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_msa_info_resp_msg_v01 *resp;

This is 40 bytes,

> +	struct wlfw_msa_info_req_msg_v01 *req;

This is 6 bytes.

So just put them on the stack and skip the memory management.

> +	struct qmi_txn txn;
> +	int ret;
> +	int i;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
> +	if (!resp) {
> +		kfree(req);
> +		return -ENOMEM;
> +	}
> +
> +	req->msa_addr = qmi->msa_pa;
> +	req->size = qmi->msa_mem_size;
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_msa_info_resp_msg_v01_ei, resp);
> +	if (ret < 0) {
> +		pr_err("fail to init txn for MSA mem info resp %d\n",
> +		       ret);

Unless we have 2 billion outstanding transactions "ret" is going to be
ENOMEM here, in which case there is already a printout telling you about
the problem.

> +		goto out;
> +	}
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_MSA_INFO_REQ_V01,
> +			       WLFW_MSA_INFO_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_msa_info_req_msg_v01_ei, req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		pr_err("fail to send MSA mem info req %d\n", ret);

Use dev_err().

> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);

The timeout is in jiffies, but I doubt you intended to the timeout to be
500 seconds either.

> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
> +		pr_err("MSA mem info request rejected, result:%d error:%d\n",
> +		       resp->resp.result, resp->resp.error);
> +		ret = -resp->resp.result;

Future readers will expect this to be a errno, in particular as most
other exit paths return errnos.

> +		goto out;
> +	}
> +
> +	pr_debug("receive mem_region_info_len: %d\n",
> +		 resp->mem_region_info_len);
> +
> +	if (resp->mem_region_info_len > QMI_WLFW_MAX_NUM_MEMORY_REGIONS_V01) {
> +		pr_err("invalid memory region length received: %d\n",
> +		       resp->mem_region_info_len);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	qmi->nr_mem_region = resp->mem_region_info_len;
> +	for (i = 0; i < resp->mem_region_info_len; i++) {
> +		qmi->mem_region[i].reg_addr =
> +			resp->mem_region_info[i].region_addr;

With the use of a local variable you should be able to avoid the line
breaks here.

> +		qmi->mem_region[i].size =
> +			resp->mem_region_info[i].size;
> +		qmi->mem_region[i].secure_flag =
> +			resp->mem_region_info[i].secure_flag;
> +		pr_debug("mem region: %d Addr: 0x%llx Size: 0x%x Flag: 0x%08x\n",
> +			 i, qmi->mem_region[i].reg_addr,
> +			 qmi->mem_region[i].size,
> +			 qmi->mem_region[i].secure_flag);
> +	}
> +
> +	pr_debug("MSA mem info request completed\n");
> +	kfree(resp);
> +	kfree(req);
> +	return 0;
> +
> +out:
> +	kfree(resp);
> +	kfree(req);
> +	return ret;
> +}
> +
> +static int ath10k_qmi_msa_ready_send_sync_msg(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_msa_ready_resp_msg_v01 *resp;

This is 4 bytes,

> +	struct wlfw_msa_ready_req_msg_v01 *req;

and this is 1 byte, use the stack.

> +	struct qmi_txn txn;
> +	int ret;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
> +	if (!resp) {
> +		kfree(req);
> +		return -ENOMEM;
> +	}
> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_msa_ready_resp_msg_v01_ei, resp);
> +	if (ret < 0) {
> +		pr_err("fail to init txn for MSA mem ready resp %d\n",
> +		       ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +			       QMI_WLFW_MSA_READY_REQ_V01,
> +			       WLFW_MSA_READY_REQ_MSG_V01_MAX_MSG_LEN,
> +			       wlfw_msa_ready_req_msg_v01_ei, req);
> +	if (ret < 0) {
> +		qmi_txn_cancel(&txn);
> +		pr_err("fail to send MSA mem ready req %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = qmi_txn_wait(&txn, WLFW_TIMEOUT * HZ);

As above.

> +	if (ret < 0)
> +		goto out;
> +
> +	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
> +		pr_err("qmi MSA mem ready request rejected, result:%d error:%d\n",
> +		       resp->resp.result, resp->resp.error);

Clean up the print statement, there's no reason to print
resp->resp.result, it is 1. And use dev_err().

> +		ret = -resp->resp.result;

This will be interpreted by future readers as an errno.

> +	}
> +
> +	pr_debug("MSA mem ready request completed\n");

dev_dbg().

> +	kfree(resp);
> +	kfree(req);
> +	return 0;
> +
> +out:
> +	kfree(resp);
> +	kfree(req);
> +	return ret;
> +}
> +
> +static int
>  ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
>  {
>  	struct wlfw_ind_register_resp_msg_v01 *resp;
> @@ -173,7 +409,27 @@ static void ath10k_qmi_event_server_arrive(struct work_struct *work)
>  	if (ret)
>  		return;
>  
> -	ath10k_qmi_ind_register_send_sync_msg(qmi);
> +	ret = ath10k_qmi_ind_register_send_sync_msg(qmi);
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
> +	return;
> +
> +err_setup_msa:
> +	ath10k_qmi_remove_msa_permissions(qmi);
> +	return;
>  }
>  
>  static void ath10k_qmi_event_server_exit(struct work_struct *work)
> @@ -252,6 +508,34 @@ static int ath10k_alloc_qmi_resources(struct ath10k_qmi *qmi)
>  	return ret;
>  }
>  
> +static int ath10k_qmi_setup_msa_resources(struct device *dev,
> +					  struct ath10k_qmi *qmi)
> +{
> +	int ret;
> +
> +	ret = of_property_read_u32(dev->of_node, "qcom,wlan-msa-memory",
> +				   &qmi->msa_mem_size);
> +
> +	if (ret || qmi->msa_mem_size == 0) {
> +		pr_err("fail to get MSA memory size: %u, ret: %d\n",
> +		       qmi->msa_mem_size, ret);

Use dev_err() and drop the msa_mem_size and ret from the printout, it
doesn't add any value.

> +		return -ENOMEM;
> +	}
> +
> +	qmi->msa_va = dmam_alloc_coherent(dev, qmi->msa_mem_size,
> +					  &qmi->msa_pa, GFP_KERNEL);

The third parameter is supposed to be a dma_addr_t, not a phys_addr_t.
But it looks like you can just change the type.

> +	if (!qmi->msa_va) {
> +		pr_err("dma alloc failed for MSA\n");
> +		return -ENOMEM;
> +	}
> +
> +	pr_debug("MSA pa: %pa, MSA va: 0x%p\n",
> +		 &qmi->msa_pa,
> +		 qmi->msa_va);

dev_dbg() and the appropriate types are %pad and %pK.

> +
> +	return 0;
> +}
> +
>  static void ath10k_remove_qmi_resources(struct ath10k_qmi *qmi)
>  {
>  	cancel_work_sync(&qmi->work_svc_arrive);
> @@ -272,7 +556,7 @@ static int ath10k_qmi_probe(struct platform_device *pdev)
>  
>  	qmi->pdev = pdev;
>  	platform_set_drvdata(pdev, qmi);
> -

This newline was a nice divider between the "chunks" of statements, like
paragraphs in a book...

> +	ath10k_qmi_setup_msa_resources(&pdev->dev, qmi);
>  	ret = ath10k_alloc_qmi_resources(qmi);
>  	if (ret < 0)
>  		goto err;
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
> index 7697d24..47af020 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.h
> +++ b/drivers/net/wireless/ath/ath10k/qmi.h
> @@ -16,6 +16,8 @@
>  #ifndef _QMI_H_
>  #define _QMI_H_
>  
> +#define MAX_NUM_MEMORY_REGIONS			2
> +
>  enum ath10k_qmi_driver_event_type {
>  	ATH10K_QMI_EVENT_SERVER_ARRIVE,
>  	ATH10K_QMI_EVENT_SERVER_EXIT,
> @@ -23,6 +25,12 @@ enum ath10k_qmi_driver_event_type {
>  	ATH10K_QMI_EVENT_MAX,
>  };
>  
> +struct ath10k_msa_mem_region_info {

Afaict this struct is only used in qmi.c, so move it there.

> +	u64 reg_addr;

This is your driver-local copy of the data being received in a
wlfw_msa_info_resp_msg_v01, use kernel native types instead.

I.e. make this phys_addr_t,

> +	u32 size;

this is a size_t

> +	u8 secure_flag;

And based on how you use this, just make it bool secure (and invert the
logic?)

> +};
> +
>  struct ath10k_qmi {
>  	struct platform_device *pdev;
>  	struct qmi_handle qmi_hdl;
> @@ -33,5 +41,11 @@ struct ath10k_qmi {
>  	struct work_struct work_svc_exit;
>  	struct workqueue_struct *event_wq;
>  	spinlock_t event_lock; /* spinlock for fw ready status*/
> +	u32 nr_mem_region;
> +	struct ath10k_msa_mem_region_info
> +		mem_region[MAX_NUM_MEMORY_REGIONS];
> +	phys_addr_t msa_pa;
> +	u32 msa_mem_size;
> +	void *msa_va;
>  };

Regards,
Bjorn
