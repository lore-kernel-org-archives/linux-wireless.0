Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48206 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbdFYXEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 19:04:41 -0400
Date: Mon, 26 Jun 2017 01:04:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shikha Singh <shikha.singh@st.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        raunaque.quaiser@st.com, manoj.kumar@st.com,
        sylvain.fidelis@st.com, raphael.collado@st.com
Subject: Re: [[linux-nfc][PATCH v1] 2/6] NFC: nfcst: Add ST NFC Transceiver
 core framework
Message-ID: <20170625225926.GK21214@zurbaran.ger.intel.com> (sfid-20170626_010450_494701_237738CE)
References: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
 <1493705023-8710-3-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493705023-8710-3-git-send-email-shikha.singh@st.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shikha,

On Tue, May 02, 2017 at 02:03:39AM -0400, Shikha Singh wrote:
> +static int nfcst_in_send_cmd(struct nfc_digital_dev *ddev,
> +			     struct sk_buff *skb,
> +			     u16 timeout,
> +			     nfc_digital_cmd_complete_t cb,
> +			     void *arg)
> +{
> +	struct nfcst_context *context = nfc_digital_get_drvdata(ddev);
> +	int rc;
> +	int len_data_to_tag = 0;
> +
> +	if (!context->nfcst_power)
> +		return -EIO;
> +
> +	/*
> +	 * down the semaphore to indicate that last nfcst_in_send_cmd()
> +	 * call is pending, If interrupted, WARN and return !
> +	 */
> +	rc = down_killable(&context->exchange_lock);
> +	if (rc) {
> +		WARN(1, "Semaphore wait is interrupted in nfcst_in_send_cmd\n");
> +		return rc;
> +	}
> +
> +	if (context->trig_config) {
> +		context->trig_config = false;
> +		rc = nfcst_handle_config_fdt(context, false);
> +		if (rc) {
> +			dev_err(&context->nfcdev->dev, "config fdt failed from nfcst_in_send_cmd %d\n",
> +				rc);
> +			return rc;
> +		}
> +	}
> +
> +	switch (context->current_rf_tech) {
> +	case NFC_DIGITAL_RF_TECH_106A:
> +		len_data_to_tag = skb->len + 1;
> +		*skb_put(skb, 1) = context->sendrcv_trflag;
You can't dereference a void pointer. Please fix that as it will most
likely break the build.

Cheers,
Samuel.
