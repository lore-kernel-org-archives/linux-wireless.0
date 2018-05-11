Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39907 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbeEKSyP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 14:54:15 -0400
Received: by mail-pf0-f196.google.com with SMTP id a22-v6so3126145pfn.6
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 11:54:15 -0700 (PDT)
Date: Fri, 11 May 2018 11:55:36 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/12] ath10k: Add QMI HOST CAP request support
Message-ID: <20180511185536.GT2259@tuxbook-pro> (sfid-20180511_205419_568576_CDE855E2)
References: <1522042866-26304-1-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522042866-26304-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 25 Mar 22:41 PDT 2018, Govind Singh wrote:

> Add support for host capablity request
> qmi message for wcn3990 target.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/qmi.c | 65 +++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index 65a43af..a33681d 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -357,6 +357,67 @@ static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
>  	return ret;
>  }
>  
> +static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
> +{
> +	struct wlfw_host_cap_resp_msg_v01 *resp;

This is 4 bytes,

> +	struct wlfw_host_cap_req_msg_v01 *req;

and this is 2 bytes, use the stack.

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
> +	req->daemon_support_valid = 1;
> +	req->daemon_support = 0;
> +
> +	pr_debug("daemon_support is %d\n", req->daemon_support);

This print seems unnecessary.

> +
> +	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
> +			   wlfw_host_cap_resp_msg_v01_ei, resp);
> +	if (ret < 0) {
> +		pr_err("Fail to init txn for Capability resp %d\n", ret);

Same comments the rest of the function as given on previous patches.

> +		goto out;
> +	}

Regards,
Bjorn
