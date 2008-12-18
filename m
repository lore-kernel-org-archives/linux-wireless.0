Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39052 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYLRQAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 11:00:14 -0500
Date: Thu, 18 Dec 2008 10:50:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Julia Lawall <julia@diku.dk>
Cc: lrodriguez@atheros.com, jmalinen@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/11] drivers/net/wireless/ath9k: Move a dereference
	below a NULL test
Message-ID: <20081218155042.GF4121@tuxdriver.com> (sfid-20081218_170020_266461_126F017D)
References: <Pine.LNX.4.64.0812161613510.20444@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.64.0812161613510.20444@pc-004.diku.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 04:14:28PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/net/wireless/ath9k/hw.c     |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
> index 98bc25c..7d1dac6 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -5581,11 +5581,12 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
>  	struct ath9k_channel ichan;
>  	bool isCalDone;
>  	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
> -	const struct hal_percal_data *calData = currCal->calData;
> +	const struct hal_percal_data *calData;
>  	int i;
>  
>  	if (currCal == NULL)
>  		return false;
> +	calData = currCal->calData;
>  
>  	ichan.CalValid = 0;

This patch doesn't seem to apply.  I don't see this code anywhere.
Perhaps this is against some older version?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
