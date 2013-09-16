Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:58180 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3IPTCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 15:02:43 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so3446290lab.7
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 12:02:42 -0700 (PDT)
Message-ID: <523755D1.2010003@cogentembedded.com> (sfid-20130916_210248_621499_0686025C)
Date: Mon, 16 Sep 2013 23:02:41 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 4/8 V2] rtlwifi: rtl8192_common: Fix smatch errors and
 warnings in rtl8192c/dm_common.c
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net> <1379357722-17687-5-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1379357722-17687-5-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 09/16/2013 10:55 PM, Larry Finger wrote:

> Smatch lists the following:
>    CHECK   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:551 rtl92c_dm_pwdb_monitor() info: ignoring unreachable code.
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:551 rtl92c_dm_pwdb_monitor() info: ignoring unreachable code.
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:870 rtl92c_dm_txpower_tracking_callback_thermalmeter() error: buffer overflow 'txpwr_level' 2 <= 2
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:870 rtl92c_dm_txpower_tracking_callback_thermalmeter() error: buffer overflow 'txpwr_level' 2 <= 2
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:882 rtl92c_dm_txpower_tracking_callback_thermalmeter() error: buffer overflow 'txpwr_level' 2 <= 2
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:883 rtl92c_dm_txpower_tracking_callback_thermalmeter() error: buffer overflow 'txpwr_level' 2 <= 2
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:891 rtl92c_dm_txpower_tracking_callback_thermalmeter() error: buffer overflow 'txpwr_level' 2 <= 2
> drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:892 rtl92c_dm_txpower_tracking_callback_thermalmeter() error: buffer overflow 'txpwr_level' 2 <= 2

> The unreachable code message is fixed by commenting out the code that follows a return.

    You've commented out the whole function body, where is the *return* you're 
talking about?

> The code is not deleted in case it is needed later.

> The errors are fixed by increasing the size of txpwr_level.

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> index d2d57a2..0721756 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> @@ -541,6 +541,7 @@ EXPORT_SYMBOL(rtl92c_dm_write_dig);
>
>   static void rtl92c_dm_pwdb_monitor(struct ieee80211_hw *hw)
>   {
> +/*
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	long tmpentry_max_pwdb = 0, tmpentry_min_pwdb = 0xff;
>
> @@ -564,6 +565,7 @@ static void rtl92c_dm_pwdb_monitor(struct ieee80211_hw *hw)
>   	h2c_parameter[0] = 0;
>
>   	rtl92c_fill_h2c_cmd(hw, H2C_RSSI_REPORT, 3, h2c_parameter);
> + */
>   }

WBR, Sergei

