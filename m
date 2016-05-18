Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35498 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbcERMMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 08:12:10 -0400
Subject: Re: [PATCH 1/1] rtlwifi: rtl8723be: avoid undefined behavior
To: Heinrich Schuchardt <xypron.glpk@gmx.de>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1463525183-11483-1-git-send-email-xypron.glpk@gmx.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <573C5C18.8030300@lwfinger.net> (sfid-20160518_141233_963318_424DEB67)
Date: Wed, 18 May 2016 07:12:08 -0500
MIME-Version: 1.0
In-Reply-To: <1463525183-11483-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2016 05:46 PM, Heinrich Schuchardt wrote:
> Do not return undefined value for transmission power
> if the rate is invalid.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
> index 445f681..c5ca9df 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
> @@ -1019,7 +1019,7 @@ static u8 _rtl8723be_get_txpower_index(struct ieee80211_hw *hw, u8 path,
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
>   	u8 index = (channel - 1);
> -	u8 txpower;
> +	u8 txpower = 0;
>   	u8 power_diff_byrate = 0;
>
>   	if (channel > 14 || channel < 1) {

Did gcc give you a warning about this variable not being initialized? Mine does 
not. In any case, this change is appropriate.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

