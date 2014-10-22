Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41160 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaJVQa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:30:27 -0400
Received: by mail-pd0-f176.google.com with SMTP id fp1so3817908pdb.21
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 09:30:27 -0700 (PDT)
Message-ID: <5447DBA0.5080608@lwfinger.net> (sfid-20141022_183037_925525_1FF73CFE)
Date: Wed, 22 Oct 2014 11:30:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Karsten Wiese <fzuuzf@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] rtl8192cu: Fix for rtlwifi's bluetooth coexist functionality
References: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com> <1413985654-25070-2-git-send-email-fzuuzf@googlemail.com>
In-Reply-To: <1413985654-25070-2-git-send-email-fzuuzf@googlemail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2014 08:47 AM, Karsten Wiese wrote:
> Initialize function pointer with a function indicating bt coexist is not there.
> Prevents Ooops.
>
> Signed-off-by: Karsten Wiese <fzuuzf@googlemail.com>
> ---

I have been working on a better fix; however, I am traveling and unable to 
finish testing it. As a result, this one should be applied.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 7c5fbaf..e06bafe 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -101,6 +101,12 @@ static void rtl92cu_deinit_sw_vars(struct ieee80211_hw *hw)
>   	}
>   }
>
> +/* get bt coexist status */
> +static bool rtl92cu_get_btc_status(void)
> +{
> +	return false;
> +}
> +
>   static struct rtl_hal_ops rtl8192cu_hal_ops = {
>   	.init_sw_vars = rtl92cu_init_sw_vars,
>   	.deinit_sw_vars = rtl92cu_deinit_sw_vars,
> @@ -148,6 +154,7 @@ static struct rtl_hal_ops rtl8192cu_hal_ops = {
>   	.phy_set_bw_mode_callback = rtl92cu_phy_set_bw_mode_callback,
>   	.dm_dynamic_txpower = rtl92cu_dm_dynamic_txpower,
>   	.fill_h2c_cmd = rtl92c_fill_h2c_cmd,
> +	.get_btc_status = rtl92cu_get_btc_status,
>   };
>
>   static struct rtl_mod_params rtl92cu_mod_params = {
>

