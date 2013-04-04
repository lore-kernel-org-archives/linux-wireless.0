Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:41813 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765281Ab3DDWa0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 18:30:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 4 Apr 2013 15:29:14 -0700
Subject: RE: [PATCH 1/4] mwifiex: bug: wrong list in list_empty check.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAB6C1@SC-VEXCH1.marvell.com> (sfid-20130405_003030_468695_7DBAB1A2)
References: <20130404205706.GA29851@blumentopf>
 <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

Thanks for the v2 patch series.

> adapter->bss_prio_tbl list has already been checked in outer loop. The
> inner loop works with priv_tmp->wmm.tid_tbl_ptr list. Also the lock taken,
> gives hint that this is likely a copy-paste error.
> 
> Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/wmm.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
> index 32adc87..b132c42 100644
> --- a/drivers/net/wireless/mwifiex/wmm.c
> +++ b/drivers/net/wireless/mwifiex/wmm.c
> @@ -933,8 +933,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
>  				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
>  						  flags);
>  				is_list_empty =
> -					list_empty(&adapter->bss_prio_tbl[j]
> -						   .bss_prio_head);
> +					list_empty(&tid_ptr->ra_list);
>  				spin_unlock_irqrestore(&tid_ptr->tid_tbl_lock,
>  						       flags);
>  				if (is_list_empty)
> --
> 1.7.10.4

