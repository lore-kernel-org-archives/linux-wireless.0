Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51076 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3FCTpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 15:45:14 -0400
Date: Mon, 3 Jun 2013 15:39:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Yunlian Jiang <yunlian@google.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn, davem@davemloft.net
Subject: Re: [PATCH] rtlwifi: initialize local array and set value.
Message-ID: <20130603193947.GH2727@tuxdriver.com> (sfid-20130603_214518_003714_41A89291)
References: <1370036721-18164-1-git-send-email-yunlian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370036721-18164-1-git-send-email-yunlian@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is missing a Signed-off-by line...

On Fri, May 31, 2013 at 02:45:21PM -0700, Yunlian Jiang wrote:
> GCC 4.8 is spitting out uninitialized-variable warnings against
> "drivers/net/wireless/rtlwifi/rtl8192de/dm.c".  
> 
> drivers/net/wireless/rtlwifi/rtl8192de/dm.c:941:31: 
> error: 'ofdm_index_old[1]' may be used uninitialized in this
> function [-Werror=maybe-uninitialized]
>      rtlpriv->dm.ofdm_index[i] = ofdm_index_old[i];
> 
> This patch adds initialization to the variable and properly sets its value.
> ---
>  drivers/net/wireless/rtlwifi/rtl8192de/dm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> index 19a7655..47875ba 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> @@ -842,7 +842,7 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
>  	long val_y, ele_c = 0;
>  	u8 ofdm_index[2];
>  	s8 cck_index = 0;
> -	u8 ofdm_index_old[2];
> +	u8 ofdm_index_old[2] = {0, 0};
>  	s8 cck_index_old = 0;
>  	u8 index;
>  	int i;
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
