Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42124 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbeEKTHb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 15:07:31 -0400
Received: by mail-pl0-f67.google.com with SMTP id u6-v6so3782915pls.9
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 12:07:31 -0700 (PDT)
Date: Fri, 11 May 2018 12:08:52 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/12] ath10k: add bdf/cal indication support
Message-ID: <20180511190852.GU2259@tuxbook-pro> (sfid-20180511_210735_709877_09D6E327)
References: <1522042886-26343-1-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522042886-26343-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 25 Mar 22:41 PDT 2018, Govind Singh wrote:

> Add support for bdf download and cold boot
> calibration trigger qmi message support.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/qmi.c | 195 ++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/qmi.h |  10 ++
>  2 files changed, 205 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index a33681d..f23d0fe 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -28,6 +28,7 @@
>  #include <linux/soc/qcom/qmi.h>
>  #include <linux/qcom_scm.h>
>  #include <linux/of.h>
> +#include <linux/firmware.h>
>  #include "qmi.h"
>  #include "qmi_svc_v01.h"
>  
> @@ -270,6 +271,179 @@ static int ath10k_qmi_msa_ready_send_sync_msg(struct ath10k_qmi *qmi)
>  	return ret;
>  }
>  
> +int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_bdf_download_resp_msg_v01 *resp;

4 bytes, use stack.

> +	struct wlfw_bdf_download_req_msg_v01 *req;

And this is approx 7kB, so that makes sense to allocate on the heap.

> +	const struct firmware *fw_entry;
> +	unsigned int remaining;
> +	struct qmi_txn txn;
> +	const u8 *temp;
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
> +	ret = request_firmware(&fw_entry, BDF_FILE_NAME, &qmi->pdev->dev);
> +	if (ret < 0) {
> +		pr_err("fail to load bdf: %s\n", BDF_FILE_NAME);
> +		goto err_req_fw;
> +	}
> +
> +	temp = fw_entry->data;
> +	remaining = fw_entry->size;
> +
> +	pr_debug("downloading bdf: %s, size: %u\n",
> +		 BDF_FILE_NAME, remaining);
> +
> +	while (remaining) {
> +		req->valid = 1;
> +		req->file_id_valid = 1;
> +		req->file_id = 0;
> +		req->total_size_valid = 1;
> +		req->total_size = fw_entry->size;
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
> +				   resp);
> +		if (ret < 0) {
> +			pr_err("fail to init txn for bdf download %d\n", ret);
> +			goto out;
> +		}
> +
> +		ret =

Don't indent wrapped lines like that.

> +		qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
> +				 QMI_WLFW_BDF_DOWNLOAD_REQ_V01,
> +				 WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
> +				 wlfw_bdf_download_req_msg_v01_ei, req);
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
> +		if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
> +			pr_err("bdf download failed, res:%d, err:%d\n",
> +			       resp->resp.result, resp->resp.error);
> +			ret = resp->resp.result;
> +			goto err_send;
> +		}
> +
> +		remaining -= req->data_len;
> +		temp += req->data_len;
> +		req->seg_id++;
> +	}
> +
> +	pr_debug("bdf download request completed\n");

You're leaking fw_entry, consider merging the two exit paths.

> +
> +	kfree(resp);
> +	kfree(req);
> +	return 0;
> +
> +err_send:
> +	release_firmware(fw_entry);
> +
> +err_req_fw:
> +	kfree(req);
> +	kfree(resp);
> +
> +out:
> +	return ret;
> +}
> +
> +int ath10k_qmi_send_cal_report_req(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_cal_report_resp_msg_v01 *resp;

4 bytes

> +	struct wlfw_cal_report_req_msg_v01 *req;

26 bytes, use the stack for both

> +	struct qmi_txn txn;
> +	int i, j = 0;
> +	int ret;
> +
[..]
>  static struct qmi_msg_handler qmi_msg_handler[] = {
> @@ -599,6 +774,24 @@ static void ath10k_qmi_event_server_exit(struct work_struct *work)
>  	pr_info("wlan fw service disconnected\n");
>  }
>  
> +static void ath10k_qmi_event_msa_ready(struct work_struct *work)
> +{
> +	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
> +					      work_msa_ready);
> +	int ret;
> +
> +	ret = ath10k_qmi_bdf_dnld_send_sync(qmi);
> +	if (ret)
> +		goto out;
> +
> +	ret = ath10k_qmi_send_cal_report_req(qmi);
> +	if (ret)
> +		goto out;
> +
> +out:
> +	return;

If this is your exit then just use return instead of goto above.

> +}
> +

Regards,
Bjorn
