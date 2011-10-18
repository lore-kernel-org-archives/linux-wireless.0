Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:42428 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab1JRSC2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 14:02:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 18 Oct 2011 10:59:48 -0700
Subject: RE: [patch 2/4] mwifiex: remove an unneeded NULL check
Message-ID: <477F20668A386D41ADCC57781B1F70430817F5975B@SC-VEXCH1.marvell.com> (sfid-20111018_200233_154249_DDDEDF4D)
References: <20111018061409.GH27732@elgon.mountain>
In-Reply-To: <20111018061409.GH27732@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, October 17, 2011 11:14 PM
> To: Bing Zhao
> Cc: John W. Linville; linux-wireless@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 2/4] mwifiex: remove an unneeded NULL check
> 
> We dereference adapter in the error handling code so this needed to
> be fixed.  This function is always called like:
> 	adapter->if_ops.host_to_card(adapter, ...);
> so adapter can never be NULL and I've removed the NULL check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index 4466976..d12d440 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -1671,9 +1671,8 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
>  				     struct sk_buff *skb,
>  				     struct mwifiex_tx_param *tx_param)
>  {
> -	if (!adapter || !skb) {
> -		dev_err(adapter->dev, "Invalid parameter in %s <%p, %p>\n",
> -				__func__, adapter, skb);
> +	if (!skb) {
> +		dev_err(adapter->dev, "Passed NULL skb to %s\n", __func__);
>  		return -1;
>  	}
> 
