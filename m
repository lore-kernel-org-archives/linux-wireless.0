Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51823 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab1IUSFd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 14:05:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 21 Sep 2011 11:05:14 -0700
Subject: RE: [patch 1/2] mwifiex: add a kfree() to an error path
Message-ID: <477F20668A386D41ADCC57781B1F704308153E17A2@SC-VEXCH1.marvell.com> (sfid-20110921_200538_275245_58B2DA19)
References: <20110921071329.GF4999@elgon.mountain>
In-Reply-To: <20110921071329.GF4999@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the patch.

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Wednesday, September 21, 2011 12:13 AM
> To: Bing Zhao
> Cc: John W. Linville; linux-wireless@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 1/2] mwifiex: add a kfree() to an error path
> 
> We're not likely to hit this small memory leak, but lets fix it
> anyway to keep the static checkers happy.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index eb569fa..215c65a 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -203,6 +203,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
>  		beacon_ie = kmemdup(bss->information_elements,
>  					bss->len_beacon_ies, GFP_KERNEL);
>  		if (!beacon_ie) {
> +			kfree(bss_desc);
>  			dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
>  			return -ENOMEM;
>  		}
