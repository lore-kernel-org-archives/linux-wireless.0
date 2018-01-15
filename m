Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:43233 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbeAOTTu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 14:19:50 -0500
Received: by mail-oi0-f68.google.com with SMTP id t16so8969311oif.10
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 11:19:49 -0800 (PST)
Subject: Re: [PATCH v2 07/10] rtlwifi: btcoex: Add power_on_setting routine
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: yhchuang@realtek.com, linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-8-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <c2985051-4502-5bc4-79bf-a8c1669e0504@lwfinger.net> (sfid-20180115_201954_559324_F48C5DB4)
Date: Mon, 15 Jan 2018 13:19:48 -0600
MIME-Version: 1.0
In-Reply-To: <20180111070932.9929-8-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> After mac power-on sequence, wifi will start to work so notify btcoex the
> event to configure registers especially related to antenna. This will not
> only help to assign antenna but also to yield better user experience.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c      | 6 ++++++
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h      | 1 +
>   drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
>   4 files changed, 9 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index ea12b9d63a73..bc523af7ef88 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -608,6 +608,7 @@ extern struct btc_coexist gl_bt_coexist;
>   
>   bool exhalbtc_initlize_variables(void);
>   bool exhalbtc_bind_bt_coex_withadapter(void *adapter);
> +void exhalbtc_power_on_setting(struct btc_coexist *btcoexist);
>   void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only);
>   void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist);
>   void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type);
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
> index 4d9e33078d4f..9e3623b0423c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
> @@ -32,6 +32,7 @@
>   static struct rtl_btc_ops rtl_btc_operation = {
>   	.btc_init_variables = rtl_btc_init_variables,
>   	.btc_init_hal_vars = rtl_btc_init_hal_vars,
> +	.btc_power_on_setting = rtl_btc_power_on_setting,
>   	.btc_init_hw_config = rtl_btc_init_hw_config,
>   	.btc_ips_notify = rtl_btc_ips_notify,
>   	.btc_lps_notify = rtl_btc_lps_notify,
> @@ -116,6 +117,11 @@ void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv)
>   	 */
>   }
>   
> +void rtl_btc_power_on_setting(struct rtl_priv *rtlpriv)
> +{
> +	exhalbtc_power_on_setting(&gl_bt_coexist);
> +}
> +
>   void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
>   {
>   	u8 bt_exist;
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
> index 40f1ce8c8a06..9becfa59407d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
> @@ -29,6 +29,7 @@
>   
>   void rtl_btc_init_variables(struct rtl_priv *rtlpriv);
>   void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv);
> +void rtl_btc_power_on_setting(struct rtl_priv *rtlpriv);
>   void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv);
>   void rtl_btc_ips_notify(struct rtl_priv *rtlpriv, u8 type);
>   void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type);
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 941694060f48..b27dbe10b163 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -2557,6 +2557,7 @@ struct bt_coexist_info {
>   struct rtl_btc_ops {
>   	void (*btc_init_variables) (struct rtl_priv *rtlpriv);
>   	void (*btc_init_hal_vars) (struct rtl_priv *rtlpriv);
> +	void (*btc_power_on_setting)(struct rtl_priv *rtlpriv);
>   	void (*btc_init_hw_config) (struct rtl_priv *rtlpriv);
>   	void (*btc_ips_notify) (struct rtl_priv *rtlpriv, u8 type);
>   	void (*btc_lps_notify)(struct rtl_priv *rtlpriv, u8 type);
> 

I do not see any place in the code where rtl_btc_power_on_setting() is called, 
either directly or by callback. Did I miss it?

Larry
