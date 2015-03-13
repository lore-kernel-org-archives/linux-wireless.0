Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:46465 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbCMH3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 03:29:34 -0400
Date: Fri, 13 Mar 2015 18:20:10 +1100
From: James Cameron <quozl@laptop.org>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, liuzy@marvell.com, crlo@marvell.com,
	pchen@marvell.com, szli@marvell.com, nishants@marvell.com
Subject: Re: [PATCHv2 9/9] mwifiex: delay skb allocation for RX until cmd53
 over
Message-ID: <20150313072010.GU17299@us.netrek.org> (sfid-20150313_083038_087623_A0333706)
References: <1426248479-28451-1-git-send-email-patila@marvell.com>
 <1426248479-28451-10-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426248479-28451-10-git-send-email-patila@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2015 at 05:37:59PM +0530, Avinash Patil wrote:
> From: Zhaoyang Liu <liuzy@marvell.com>
> 
> This patch moves SKB allocation for RX packets from current
> place i.e. after reading MP regs to place where we already
> have read data from SDIO bus ie after cmd53.
> 
> mp_rx_aggr_setup has been modified accordingly to set
> skb_arr to NULL.
> 
> Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Reviewed-by: Amitkumar Karwar <akarwar@marvell.com>
> Reviewed-by: Cathy Luo <cluo@marvell.com>
> Reviewed-by: Avinash Patil <patila@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/sdio.c | 59 ++++++++++++++++++-------------------
>  drivers/net/wireless/mwifiex/sdio.h |  8 ++---
>  2 files changed, 33 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index fdeeb67..330e9d0 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c

[snip]

> @@ -1538,24 +1550,11 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
>  					rx_len);
>  				return -1;
>  			}
> -			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
>  
> -			skb = mwifiex_alloc_dma_align_buf(rx_len,
> -							  GFP_KERNEL |
> -							  GFP_DMA);
> -
> -			if (!skb) {
> -				dev_err(adapter->dev, "%s: failed to alloc skb",
> -					__func__);
> -				return -1;
> -			}

I like it.

Because I continue to have problems with dev_alloc_skb failing, and
the "return -1;" that you are removing doesn't seem to leave the card
and driver in a useful state.

Your patch is hopefully an improvement.

Have you done any testing of response after skb allocation failure
before and after your patch?

-- 
James Cameron
http://quozl.linux.org.au/
