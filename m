Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33968 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbeCTECN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 00:02:13 -0400
Received: by mail-ot0-f196.google.com with SMTP id m7-v6so300830otd.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 21:02:13 -0700 (PDT)
Subject: Re: [PATCH v2 10/15] rtlwifi: btcoex: new definitions introduced by
 8822be
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-11-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <add3ad9b-792a-7805-bed2-938833c47be3@lwfinger.net> (sfid-20180320_050220_889919_44E3BF57)
Date: Mon, 19 Mar 2018 23:02:10 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-11-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> New constant and variables definitions are used by btcoex of 8822b, so
> this commit add them.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index 0a7b09305bc3..049e92a8afbe 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -62,6 +62,8 @@
>   #define		BTC_ANT_PATH_WIFI			0
>   #define		BTC_ANT_PATH_BT				1
>   #define		BTC_ANT_PATH_PTA			2
> +#define		BTC_ANT_PATH_WIFI5G			3
> +#define		BTC_ANT_PATH_AUTO			4
>   /* dual Antenna definition */
>   #define		BTC_ANT_WIFI_AT_MAIN			0
>   #define		BTC_ANT_WIFI_AT_AUX			1
> @@ -205,6 +207,7 @@ enum btc_wifi_traffic_dir {
>   enum btc_wifi_pnp {
>   	BTC_WIFI_PNP_WAKE_UP = 0x0,
>   	BTC_WIFI_PNP_SLEEP = 0x1,
> +	BTC_WIFI_PNP_SLEEP_KEEP_ANT = 0x2,
>   	BTC_WIFI_PNP_MAX
>   };
>   
> @@ -387,6 +390,7 @@ enum btc_notify_type_lps {
>   enum btc_notify_type_scan {
>   	BTC_SCAN_FINISH = 0x0,
>   	BTC_SCAN_START = 0x1,
> +	BTC_SCAN_START_2G = 0x2,
>   	BTC_SCAN_MAX
>   };
>   
> @@ -561,6 +565,7 @@ struct btc_bt_info {
>   	u16 bt_hci_ver;
>   	u16 bt_real_fw_ver;
>   	u8 bt_fw_ver;
> +	u32 bt_get_fw_ver;
>   
>   	bool bt_disable_low_pwr;
>   
> @@ -632,6 +637,7 @@ struct btc_bt_link_info {
>   	bool pan_exist;
>   	bool pan_only;
>   	bool slave_role;
> +	bool acl_busy;
>   };
>   
>   enum btc_antenna_pos {
> 
