Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34197 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbbFERlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 13:41:00 -0400
Received: by obbir4 with SMTP id ir4so17285699obb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 10:40:59 -0700 (PDT)
Message-ID: <5571DF28.2000108@lwfinger.net> (sfid-20150605_194105_102749_E3A09E5A)
Date: Fri, 05 Jun 2015 12:40:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix performance issue.
References: <1433378862-2064-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1433378862-2064-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2015 07:47 PM, Taehee Yoo wrote:
> After physical reconnect, the rtl8192cu chipset shows low
> transmission rates.It cause is that variable "iqk_initialized"
> do not de-initialized. So I add this code.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)

I like this patch very much. Getting rid of a static variable is always good.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 1898596..6a4ef05 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -987,7 +987,6 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
>   	struct rtl_phy *rtlphy = &(rtlpriv->phy);
>   	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
>   	int err = 0;
> -	static bool iqk_initialized;
>   	unsigned long flags;
>
>   	/* As this function can take a very long time (up to 350 ms)
> @@ -1038,11 +1037,11 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
>   	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
>   	if (ppsc->rfpwr_state == ERFON) {
>   		rtl92c_phy_set_rfpath_switch(hw, 1);
> -		if (iqk_initialized) {
> +		if (rtlphy->iqk_initialized) {
>   			rtl92c_phy_iq_calibrate(hw, true);
>   		} else {
>   			rtl92c_phy_iq_calibrate(hw, false);
> -			iqk_initialized = true;
> +			rtlphy->iqk_initialized = true;
>   		}
>   		rtl92c_dm_check_txpower_tracking(hw);
>   		rtl92c_phy_lc_calibrate(hw);
> @@ -1391,6 +1390,9 @@ void rtl92cu_card_disable(struct ieee80211_hw *hw)
>   		_CardDisableHWSM(hw);
>   	else
>   		_CardDisableWithoutHWSM(hw);
> +
> +	/* after power off we should do iqk again */
> +	rtlpriv->phy.iqk_initialized = false;
>   }
>
>   void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
>

