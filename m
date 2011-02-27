Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1B0V6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 16:58:10 -0500
Message-ID: <4D6AC8EC.1040104@lwfinger.net>
Date: Sun, 27 Feb 2011 15:58:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] rtlwifi: make gcc happy
References: <1298841390-1194-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1298841390-1194-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2011 03:16 PM, Alessio Igor Bogani wrote:
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c: In function ‘rtl92ce_rx_query_desc’:
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:255:5: warning: ‘rf_rx_num’ may be used uninitialized in this function
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:257:12: warning: ‘total_rssi’ may be used uninitialized in this function
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:466:6: warning: ‘weighting’ may be used uninitialized in this function
>
> Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> index bf5852f..593eb8e 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> @@ -252,9 +252,9 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct phy_sts_cck_8192s_t *cck_buf;
>   	s8 rx_pwr_all, rx_pwr[4];
> -	u8 rf_rx_num, evm, pwdb_all;
> +	u8 evm, pwdb_all, rf_rx_num = 0;
>   	u8 i, max_spatial_stream;
> -	u32 rssi, total_rssi;
> +	u32 rssi, total_rssi = 0;
>   	bool is_cck_rate;
>
>   	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
> @@ -463,7 +463,7 @@ static void _rtl92ce_update_rxsignalstatistics(struct ieee80211_hw *hw,
>   					       struct rtl_stats *pstats)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	int weighting;
> +	int weighting = 0;
>
>   	if (rtlpriv->stats.recv_signal_power == 0)
>   		rtlpriv->stats.recv_signal_power = pstats->recvsignalpower;


ACK. What architecture and compiler version are you using? On x86_64, gcc 4.5.1 
does not show these warnings.

Larry

