Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40068 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902Ab1JRSVP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 14:21:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 18 Oct 2011 11:19:12 -0700
Subject: RE: [patch 3/4] mwifiex: prevent corruption instead of just warning
Message-ID: <477F20668A386D41ADCC57781B1F70430817F59764@SC-VEXCH1.marvell.com> (sfid-20111018_202134_304312_48DE1FDF)
References: <20111018061514.GI27732@elgon.mountain>
In-Reply-To: <20111018061514.GI27732@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, October 17, 2011 11:15 PM
> To: Bing Zhao
> Cc: John W. Linville; linux-wireless@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 3/4] mwifiex: prevent corruption instead of just warning
> 
> We may as well put a return here instead of just printing a warning
> message and then corrupting memory.  The caller doesn't check the
> return code.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index d12d440..40b154d 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -1228,9 +1228,11 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
>  	if (!skb)
>  		return 0;
> 
> -	if (rdptr >= MWIFIEX_MAX_EVT_BD)
> +	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
>  		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
>  					rdptr);
> +		return -EINVAL;

Instead of returning directly, we should set the error code and go through the error handling:
		ret = -EINVAL;
		goto done;

Could you please resend v2?

Thanks,
Bing

> +	}
> 
>  	/* Read the event ring write pointer set by firmware */
>  	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
