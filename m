Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54218 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab2HXGBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 02:01:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 23 Aug 2012 23:00:56 -0700
Subject: RE: [PATCH v2] mwifiex: use is_zero_ether_addr() instead of memcmp()
Message-ID: <477F20668A386D41ADCC57781B1F7043083B0BBBB4@SC-VEXCH1.marvell.com> (sfid-20120824_080148_616196_C96A7479)
References: <CAPgLHd8+H415tRqvyM1SXQCSC6savCakuFLdjM1ebWvjikd5NQ@mail.gmail.com>
In-Reply-To: <CAPgLHd8+H415tRqvyM1SXQCSC6savCakuFLdjM1ebWvjikd5NQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using is_zero_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is all
> zeros.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/sta_cmdresp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
> index 0b09004..62223ab 100644
> --- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
> @@ -736,7 +736,6 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
>  {
>  	struct host_cmd_ds_802_11_ibss_status *ibss_coal_resp =
>  					&(resp->params.ibss_coalescing);
> -	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
> 
>  	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
>  		return 0;
> @@ -745,7 +744,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
>  		"info: new BSSID %pM\n", ibss_coal_resp->bssid);
> 
>  	/* If rsp has NULL BSSID, Just return..... No Action */
> -	if (!memcmp(ibss_coal_resp->bssid, zero_mac, ETH_ALEN)) {
> +	if (is_zero_ether_addr(ibss_coal_resp->bssid)) {
>  		dev_warn(priv->adapter->dev, "new BSSID is NULL\n");
>  		return 0;
>  	}
> 

