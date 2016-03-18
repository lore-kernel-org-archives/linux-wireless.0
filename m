Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17133 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbcCRJD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 05:03:57 -0400
Date: Fri, 18 Mar 2016 12:03:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/9] rtlwifi: rtl8723ae: Fix Smatch warning
Message-ID: <20160318090335.GC30221@mwanda> (sfid-20160318_100402_007744_E942D41E)
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
 <1458240064-31422-8-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458240064-31422-8-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2016 at 01:41:02PM -0500, Larry Finger wrote:
> Smatch reports the following:
> 
>   CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c:137 rtl8723e_dm_bt_need_to_dec_bt_pwr() warn: inconsistent indenting
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
> index 00a0531..44de695 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
> @@ -134,9 +134,9 @@ static bool rtl8723e_dm_bt_need_to_dec_bt_pwr(struct ieee80211_hw *hw)
>  	if (mgnt_link_status_query(hw) == RT_MEDIA_CONNECT) {
>  		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
>  			"Need to decrease bt power\n");
> -			rtlpriv->btcoexist.cstate |=
> -			BT_COEX_STATE_DEC_BT_POWER;
> -			return true;
> +		rtlpriv->btcoexist.cstate |=
> +		BT_COEX_STATE_DEC_BT_POWER;

Now that we have removed the tab, this can fit on one line.

regards,
dan carpenter

