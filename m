Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:52567 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784Ab1JRSAA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 14:00:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 18 Oct 2011 10:57:50 -0700
Subject: RE: [patch 1/4] mwifiex: remove unneeded kfree(NULL);
Message-ID: <477F20668A386D41ADCC57781B1F70430817F59758@SC-VEXCH1.marvell.com> (sfid-20111018_200007_061087_A3C598B3)
References: <20111018061306.GG27732@elgon.mountain>
In-Reply-To: <20111018061306.GG27732@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for your patch series.

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, October 17, 2011 11:13 PM
> To: Bing Zhao
> Cc: John W. Linville; linux-wireless@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 1/4] mwifiex: remove unneeded kfree(NULL);
> 
> The previous if statement means this that pointer is NULL so there
> is no need to free it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index d34acf0..4466976 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -386,7 +386,6 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
>  	card->txbd_ring_vbase = kzalloc(card->txbd_ring_size, GFP_KERNEL);
>  	if (!card->txbd_ring_vbase) {
>  		dev_err(adapter->dev, "Unable to allocate buffer for txbd ring.\n");
> -		kfree(card->txbd_ring_vbase);
>  		return -1;
>  	}
>  	card->txbd_ring_pbase = virt_to_phys(card->txbd_ring_vbase);
