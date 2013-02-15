Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42668 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3BOTaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 14:30:10 -0500
Date: Fri, 15 Feb 2013 14:26:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwl4965: fix 'phys_addr' may be used uninitialized
Message-ID: <20130215192627.GE4981@tuxdriver.com> (sfid-20130215_203016_271629_FB147B93)
References: <20130215095221.GE4392@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130215095221.GE4392@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I still get the warning when building wireless-next on my F17 box
with this patch applied...

On Fri, Feb 15, 2013 at 10:52:21AM +0100, Stanislaw Gruszka wrote:
> This should fix:
> 
> drivers/net/wireless/iwlegacy/4965-mac.c:1847:33: warning: 'phys_addr' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
> index 7941eb3..d2ab1cf 100644
> --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> @@ -1843,7 +1843,7 @@ il4965_tx_skb(struct il_priv *il,
>  	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
>  	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
>  	dma_unmap_len_set(out_meta, len, firstlen);
> -	if (secondlen)
> +	if (secondlen > 0)
>  		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen,
>  					       0, 0);
>  
> -- 
> 1.7.11.7
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
