Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34162 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbbHEN1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 09:27:30 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [patch] mwifiex: usb: return an error if kmalloc fails
Date: Wed, 5 Aug 2015 13:27:28 +0000
Message-ID: <4204aa5c96fe44e7a6f5b6e25e6e31cd@SC-EXCH04.marvell.com> (sfid-20150805_152736_117036_BE24A121)
References: <20150804074927.GD10867@mwanda>
In-Reply-To: <20150804074927.GD10867@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, August 04, 2015 1:19 PM
> To: Amitkumar Karwar
> Cc: Nishant Sarmukadam; Kalle Valo; linux-wireless@vger.kernel.org;
> kernel-janitors@vger.kernel.org
> Subject: [patch] mwifiex: usb: return an error if kmalloc fails
> 
> The current code returns success if kmalloc fails.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/mwifiex/usb.c
> b/drivers/net/wireless/mwifiex/usb.c
> index fbad99c..f866d5d 100644
> --- a/drivers/net/wireless/mwifiex/usb.c
> +++ b/drivers/net/wireless/mwifiex/usb.c
> @@ -870,8 +870,10 @@ static int mwifiex_prog_fw_w_helper(struct
> mwifiex_adapter *adapter,
> 
>  	/* Allocate memory for transmit */
>  	fwdata = kzalloc(FW_DNLD_TX_BUF_SIZE, GFP_KERNEL);
> -	if (!fwdata)
> +	if (!fwdata) {
> +		ret = -ENOMEM;
>  		goto fw_exit;
> +	}
> 
>  	/* Allocate memory for receive */
>  	recv_buff = kzalloc(FW_DNLD_RX_BUF_SIZE, GFP_KERNEL);

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
