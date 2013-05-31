Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:34720 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3EaWIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 18:08:50 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz10so1542913veb.5
        for <linux-wireless@vger.kernel.org>; Fri, 31 May 2013 15:08:49 -0700 (PDT)
Message-ID: <51A91F6E.2060702@lwfinger.net> (sfid-20130601_000853_827363_363DEEBE)
Date: Fri, 31 May 2013 17:08:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Yunlian Jiang <yunlian@google.com>
CC: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com, davem@davemloft.net
Subject: Re: [PATCH] rtlwifi: initialize local array and set value.
References: <1370036721-18164-1-git-send-email-yunlian@google.com>
In-Reply-To: <1370036721-18164-1-git-send-email-yunlian@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2013 04:45 PM, Yunlian Jiang wrote:
> GCC 4.8 is spitting out uninitialized-variable warnings against
> "drivers/net/wireless/rtlwifi/rtl8192de/dm.c".
>
> drivers/net/wireless/rtlwifi/rtl8192de/dm.c:941:31:
> error: 'ofdm_index_old[1]' may be used uninitialized in this
> function [-Werror=maybe-uninitialized]
>       rtlpriv->dm.ofdm_index[i] = ofdm_index_old[i];
>
> This patch adds initialization to the variable and properly sets its value.
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/dm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

I thought this had already been fixed, but apparently not.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> index 19a7655..47875ba 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> @@ -842,7 +842,7 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
>   	long val_y, ele_c = 0;
>   	u8 ofdm_index[2];
>   	s8 cck_index = 0;
> -	u8 ofdm_index_old[2];
> +	u8 ofdm_index_old[2] = {0, 0};
>   	s8 cck_index_old = 0;
>   	u8 index;
>   	int i;
>

