Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43923 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751333AbdF3Esv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 00:48:51 -0400
From: Shikha SINGH <shikha.singh@st.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        Raunaque Mujeeb QUAISER <raunaque.quaiser@st.com>,
        Manoj KUMAR <manoj.kumar@st.com>,
        Sylvain FIDELIS <sylvain.fidelis@st.com>,
        Raphael COLLADO <Raphael.COLLADO@st.com>
Subject: RE: [[linux-nfc][PATCH v1] 2/6] NFC: nfcst: Add ST NFC Transceiver
 core framework
Date: Fri, 30 Jun 2017 04:46:41 +0000
Message-ID: <d46103b672f14bd9a14918c1d2369ebd@SFHDAG2NODE3.st.com> (sfid-20170630_064924_896931_47835AB0)
References: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
 <1493705023-8710-3-git-send-email-shikha.singh@st.com>
 <20170625225926.GK21214@zurbaran.ger.intel.com>
In-Reply-To: <20170625225926.GK21214@zurbaran.ger.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Samuel,
            Skb_put()  returns pointer of type unsigned char  (unsigned char *).
 So here we are dereferencing unsigned char pointer not a void pointer. It should not create any issue.

Let me know your view.
Thanks & Regards,
Shikha
 

>-----Original Message-----
>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>Sent: Monday, June 26, 2017 4:35 AM
>To: Shikha SINGH <shikha.singh@st.com>
>Cc: linux-wireless@vger.kernel.org; linux-nfc@lists.01.org; Raunaque Mujeeb
>QUAISER <raunaque.quaiser@st.com>; Manoj KUMAR
><manoj.kumar@st.com>; Sylvain FIDELIS <sylvain.fidelis@st.com>; Raphael
>COLLADO <Raphael.COLLADO@st.com>
>Subject: Re: [[linux-nfc][PATCH v1] 2/6] NFC: nfcst: Add ST NFC Transceiver
>core framework
>
>Hi Shikha,
>
>On Tue, May 02, 2017 at 02:03:39AM -0400, Shikha Singh wrote:
>> +static int nfcst_in_send_cmd(struct nfc_digital_dev *ddev,
>> +			     struct sk_buff *skb,
>> +			     u16 timeout,
>> +			     nfc_digital_cmd_complete_t cb,
>> +			     void *arg)
>> +{
>> +	struct nfcst_context *context = nfc_digital_get_drvdata(ddev);
>> +	int rc;
>> +	int len_data_to_tag = 0;
>> +
>> +	if (!context->nfcst_power)
>> +		return -EIO;
>> +
>> +	/*
>> +	 * down the semaphore to indicate that last nfcst_in_send_cmd()
>> +	 * call is pending, If interrupted, WARN and return !
>> +	 */
>> +	rc = down_killable(&context->exchange_lock);
>> +	if (rc) {
>> +		WARN(1, "Semaphore wait is interrupted in
>nfcst_in_send_cmd\n");
>> +		return rc;
>> +	}
>> +
>> +	if (context->trig_config) {
>> +		context->trig_config = false;
>> +		rc = nfcst_handle_config_fdt(context, false);
>> +		if (rc) {
>> +			dev_err(&context->nfcdev->dev, "config fdt failed
>from nfcst_in_send_cmd %d\n",
>> +				rc);
>> +			return rc;
>> +		}
>> +	}
>> +
>> +	switch (context->current_rf_tech) {
>> +	case NFC_DIGITAL_RF_TECH_106A:
>> +		len_data_to_tag = skb->len + 1;
>> +		*skb_put(skb, 1) = context->sendrcv_trflag;
>You can't dereference a void pointer. Please fix that as it will most likely break
>the build.
>
>Cheers,
>Samuel.
