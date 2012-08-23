Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:50224 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932555Ab2HWS3V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 14:29:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 23 Aug 2012 11:28:14 -0700
Subject: RE: [PATCH] mwifiex: use is_zero_ether_addr() instead of memcmp()
Message-ID: <477F20668A386D41ADCC57781B1F7043083B0BB9B4@SC-VEXCH1.marvell.com> (sfid-20120823_202931_731503_315BC1D6)
References: <CAPgLHd9iXQf3_W5b4kO1Mv68udqnmfFO8n+R-0ZqzCrhg1Z_WQ@mail.gmail.com>
In-Reply-To: <CAPgLHd9iXQf3_W5b4kO1Mv68udqnmfFO8n+R-0ZqzCrhg1Z_WQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

Thanks for the patch.

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using is_zero_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is all
> zeros.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)

Apparently there are two more occurrences of zero_mac (scan.c:843) and bc_mac (sta_cmd.c:596).
But I can fix them when I get the chance.

> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/sta_cmdresp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
> index 0b09004..a2a33dc 100644
> --- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
> @@ -17,6 +17,8 @@
>   * this warranty disclaimer.
>   */
> 
> +#include <linux/etherdevice.h>
> +
>  #include "decl.h"
>  #include "ioctl.h"
>  #include "util.h"
> @@ -736,7 +738,6 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
>  {
>  	struct host_cmd_ds_802_11_ibss_status *ibss_coal_resp =
>  					&(resp->params.ibss_coalescing);
> -	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
> 
>  	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
>  		return 0;
> @@ -745,7 +746,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
>  		"info: new BSSID %pM\n", ibss_coal_resp->bssid);
> 
>  	/* If rsp has NULL BSSID, Just return..... No Action */
> -	if (!memcmp(ibss_coal_resp->bssid, zero_mac, ETH_ALEN)) {
> +	if (is_zero_ether_addr(ibss_coal_resp->bssid)) {
>  		dev_warn(priv->adapter->dev, "new BSSID is NULL\n");
>  		return 0;
>  	}
> 

