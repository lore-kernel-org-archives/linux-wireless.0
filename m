Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:41668 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765300Ab3DDWdq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 18:33:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 4 Apr 2013 15:33:36 -0700
Subject: RE: [PATCH 2/4] mwifiex: remove unused tid_tbl_lock from
 mwifiex_tid_tbl.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAB6CD@SC-VEXCH1.marvell.com> (sfid-20130405_003350_079467_5DC5E0DE)
References: <20130404205706.GA29851@blumentopf>
 <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <1365109286-5075-2-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1365109286-5075-2-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

> ra_list_spinlock is used to protect struct mwifiex_wmm_desc and embedded
> structures such as ra_list. tid_tbl_lock while more fine grained, is not
> used but in one function. That function is not called reentrantly. To
> protect ra_list from concurrent modification ra_list_spinlock must be held.
> 
> Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
> ---
>  drivers/net/wireless/mwifiex/init.c |    1 -
>  drivers/net/wireless/mwifiex/main.h |    2 --
>  drivers/net/wireless/mwifiex/wmm.c  |    8 ++++----
>  3 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
> index e38aa9b..ba9c5a5 100644
> --- a/drivers/net/wireless/mwifiex/init.c
> +++ b/drivers/net/wireless/mwifiex/init.c
> @@ -535,7 +535,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
>  		priv = adapter->priv[i];
>  		for (j = 0; j < MAX_NUM_TID; ++j) {
>  			INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j].ra_list);
> -			spin_lock_init(&priv->wmm.tid_tbl_ptr[j].tid_tbl_lock);
>  		}

Could you remove the braces {} too?

  		for (j = 0; j < MAX_NUM_TID; ++j)
  			INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j].ra_list);

Thanks,
Bing

>  		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
>  		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
> diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
> index 553adfb..d94406a 100644
> --- a/drivers/net/wireless/mwifiex/main.h
> +++ b/drivers/net/wireless/mwifiex/main.h
> @@ -210,8 +210,6 @@ struct mwifiex_ra_list_tbl {
> 
>  struct mwifiex_tid_tbl {
>  	struct list_head ra_list;
> -	/* spin lock for tid table */
> -	spinlock_t tid_tbl_lock;
>  	struct mwifiex_ra_list_tbl *ra_list_curr;
>  };
> 
> diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
> index b132c42..96eed2f 100644
> --- a/drivers/net/wireless/mwifiex/wmm.c
> +++ b/drivers/net/wireless/mwifiex/wmm.c
> @@ -930,12 +930,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
>  				if (!tid_ptr->ra_list_curr)
>  					continue;
> 
> -				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
> -						  flags);
> +				spin_lock_irqsave(&priv_tmp->wmm.
> +						  ra_list_spinlock, flags);
>  				is_list_empty =
>  					list_empty(&tid_ptr->ra_list);
> -				spin_unlock_irqrestore(&tid_ptr->tid_tbl_lock,
> -						       flags);
> +				spin_unlock_irqrestore(&priv_tmp->wmm.
> +						       ra_list_spinlock, flags);
>  				if (is_list_empty)
>  					continue;
> 
> --
> 1.7.10.4

