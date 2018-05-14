Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbeENMFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 08:05:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 14 May 2018 17:35:05 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/12] ath10k: Add ath10k QMI client driver
In-Reply-To: <20180511172554.GO2259@tuxbook-pro>
References: <1522042761-25716-1-git-send-email-govinds@codeaurora.org>
 <20180511172554.GO2259@tuxbook-pro>
Message-ID: <26716d4e407366fe640bcc625a703357@codeaurora.org> (sfid-20180514_140536_372664_5404402F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjorn,
Thanks for the review.

On 2018-05-11 22:55, Bjorn Andersson wrote:
> On Sun 25 Mar 22:39 PDT 2018, Govind Singh wrote:
> 
>> Add QMI client driver for Q6 integrated WLAN connectivity
>> subsystem. This module is responsible for communicating WLAN
>> control messages to FW over QUALCOMM MSM Interface (QMI).
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/Kconfig  |   2 +-
>>  drivers/net/wireless/ath/ath10k/Makefile |   4 +
>>  drivers/net/wireless/ath/ath10k/qmi.c    | 121 
>> +++++++++++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/qmi.h    |  24 ++++++
>>  4 files changed, 150 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/Kconfig 
>> b/drivers/net/wireless/ath/ath10k/Kconfig
>> index 84f071a..9978ad5e 100644
>> --- a/drivers/net/wireless/ath/ath10k/Kconfig
>> +++ b/drivers/net/wireless/ath/ath10k/Kconfig
>> @@ -42,7 +42,7 @@ config ATH10K_USB
>> 
>>  config ATH10K_SNOC
>>          tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
>> -        depends on ATH10K && ARCH_QCOM
>> +        depends on ATH10K && ARCH_QCOM && QCOM_QMI_HELPERS
> 
> QCOM_QMI_HELPERS is expected to be selected by the clients, so this
> would be:
> 
> 	select QCOM_QMI_HELPERS

Sure, will do in next version.


>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE 
>> LIABLE FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY 
>> DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN 
>> AN
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING 
>> OUT OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
> 
> SPDX headers for new files please.
> 

Sure, will do in next version.


>> +static struct ath10k_qmi *qmi;
> 
> Please design your code so that you don't depend on a global state
> pointer.
> 

Actually i thought about this, i can save this in platform drvdata and 
get this at
run time by saving the pdev in qmi_service->priv.
But qmi_service is available only in new_server/del_server, but not in 
the qmi indication callbacks.
Qmi handle also does not have the reference to the qmi_service.
Can you pls suggest something here.

>> +
>> +static int ath10k_qmi_new_server(struct qmi_handle *qmi_hdl,
>> +				 struct qmi_service *service)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
>> +				  struct qmi_service *service)
>> +{
>> +}
>> +
>> +static struct qmi_ops ath10k_qmi_ops = {
>> +	.new_server = ath10k_qmi_new_server,
>> +	.del_server = ath10k_qmi_del_server,
>> +};
>> +
>> +static int ath10k_qmi_probe(struct platform_device *pdev)
>> +{
>> +	int ret;
>> +
>> +	qmi = devm_kzalloc(&pdev->dev, sizeof(*qmi),
>> +			   GFP_KERNEL);
> 
> This doesn't need to be line wrapped.
> 

Sure, will do in next version.

>> +	if (!qmi)
>> +		return -ENOMEM;
>> +
>> +	qmi->pdev = pdev;
> 
> The only place you use this is to access pdev->dev, so carry the struct
> device * instead.
> 

Sure, will do in next version.

>> +	platform_set_drvdata(pdev, qmi);
>> +	ret = qmi_handle_init(&qmi->qmi_hdl,
>> +			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
>> +			      &ath10k_qmi_ops, NULL);
>> +	if (ret < 0)
>> +		goto err;
>> +
>> +	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
>> +			     WLFW_SERVICE_VERS_V01, 0);
>> +	if (ret < 0)
>> +		goto err;
>> +
>> +	pr_debug("qmi client driver probed successfully\n");
> 
> Rather than printing a line to indicate that your driver probed you can
> check /sys/bus/platform/drivers/ath10k_QMI_client for for devices,
> regardless of debug level.
> 

Sure, will do in next version.

>> +
>> +	return 0;
> 
> qmi_add_lookup() returns 0 on success, so you can have a common return,
> preferably after renaming "err" to "out" or something that indicates
> that it covers both cases.
> 
>> +
>> +err:
>> +	return ret;
>> +}
>> +
>> +static int ath10k_qmi_remove(struct platform_device *pdev)
>> +{
>> +	struct ath10k_qmi *qmi = platform_get_drvdata(pdev);
>> +
>> +	qmi_handle_release(&qmi->qmi_hdl);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id ath10k_qmi_dt_match[] = {
>> +	{.compatible = "qcom,ath10k-qmi"},
>> +	{}
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, ath10k_qmi_dt_match);
>> +
>> +static struct platform_driver ath10k_qmi_clinet = {
> 
> Spelling of "client".
> 

Sure, will do in next version.

>> +	.probe  = ath10k_qmi_probe,
>> +	.remove = ath10k_qmi_remove,
>> +	.driver = {
>> +		.name = "ath10k QMI client",
>> +		.owner = THIS_MODULE,
> 
> platform_driver_register() will fill out .owner for you, so skip this.
> 
>> +		.of_match_table = ath10k_qmi_dt_match,
>> +	},
>> +};
>> +
>> +static int __init ath10k_qmi_init(void)
>> +{
>> +	return platform_driver_register(&ath10k_qmi_clinet);
>> +}
>> +
>> +static void __exit ath10k_qmi_exit(void)
>> +{
>> +	platform_driver_unregister(&ath10k_qmi_clinet);
>> +}
>> +
>> +module_init(ath10k_qmi_init);
>> +module_exit(ath10k_qmi_exit);
> 
> Replace all this with:
> 

Sure, will do in next version.

> module_platform_driver(ath10k_qmi_clinet);
> 
>> +
>> +MODULE_AUTHOR("Qualcomm");
>> +MODULE_LICENSE("Dual BSD/GPL");
>> +MODULE_DESCRIPTION("ath10k QMI client driver");
>> diff --git a/drivers/net/wireless/ath/ath10k/qmi.h 
>> b/drivers/net/wireless/ath/ath10k/qmi.h
>> new file mode 100644
>> index 0000000..ad256ef
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath10k/qmi.h
>> @@ -0,0 +1,24 @@
>> +/*
>> + * Copyright (c) 2018 The Linux Foundation. All rights reserved.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software 
>> for any
>> + * purpose with or without fee is hereby granted, provided that the 
>> above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL 
>> WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE 
>> LIABLE FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY 
>> DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN 
>> AN
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING 
>> OUT OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
> 
> SPDX headers, please.
> 
>> +#ifndef _QMI_H_
>> +#define _QMI_H_
> 
> This is not a good guard name, be more specific to avoid collisions.
> 

Sure, will do in next version.

>> +
>> +struct ath10k_qmi {
> 
> Afaict ath10k_qmi is not used outside "qmi.c", so there's no reason to
> have it in a header file.
> 
>> +	struct platform_device *pdev;
>> +	struct qmi_handle qmi_hdl;
>> +	struct sockaddr_qrtr sq;
> 
> Add sq in the patch that actually uses it.
> 

Sure, will do in next version.

>> +};
>> +#endif /* _QMI_H_ */
> 
> Regards,
> Bjorn
