Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:38630 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802Ab2IXGWb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 02:22:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Avinash Patil <patila@marvell.com>,
	Stone Piao <piaoyun@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Sun, 23 Sep 2012 23:20:37 -0700
Subject: RE: [patch] mwifiex: potential corruption in
 mwifiex_update_uap_custom_ie()
Message-ID: <477F20668A386D41ADCC57781B1F7043083B4C036E@SC-VEXCH1.marvell.com> (sfid-20120924_082236_035573_ADBEFFA4)
References: <20120923163300.GB21396@elgon.mountain>
In-Reply-To: <20120923163300.GB21396@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the patch.

> ap_custom_ie is a struct mwifiex_ie_list which is quite different and
> also larger than struct mwifiex_ie.  It's a difference between 4196
> bytes and 262.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Tested-by: Stone Piao <piaoyun@marvell.com>
Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
> This is a static checker fix and I don't have the hardware to test it.
> Please review it carefully.
> 
> diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
> index 1d8dd00..fa3a80f 100644
> --- a/drivers/net/wireless/mwifiex/ie.c
> +++ b/drivers/net/wireless/mwifiex/ie.c
> @@ -160,7 +160,7 @@ mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
>  	u16 len;
>  	int ret;
> 
> -	ap_custom_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
> +	ap_custom_ie = kzalloc(sizeof(*ap_custom_ie), GFP_KERNEL);
>  	if (!ap_custom_ie)
>  		return -ENOMEM;
> 
