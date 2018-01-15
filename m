Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:43450 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbeAOSxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 13:53:07 -0500
Received: by mail-ot0-f193.google.com with SMTP id p36so3425843otd.10
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 10:53:07 -0800 (PST)
Subject: Re: [PATCH v2 04/10] rtlwifi: unlink bss when un-association
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: yhchuang@realtek.com, linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-5-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <9899e626-8b3d-a2fc-b8c7-c227c66453ed@lwfinger.net> (sfid-20180115_195314_473244_505A2EAE)
Date: Mon, 15 Jan 2018 12:53:05 -0600
MIME-Version: 1.0
In-Reply-To: <20180111070932.9929-5-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
> From: Tsang-Shian Lin <thlin@realtek.com>
> 
> When AP change bandwidth setting from 20M to 40M, STA may use old 20M AP
> information to association with AP. Driver unlink bss in the
> .bss_info_changed of ieee80211_ops to make sure that later scan can get
> correct AP bandwidth capability.
> 
> Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/core.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index ec639fa8095e..6c698123ac07 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -1171,6 +1171,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
>   				 "BSS_CHANGED_ASSOC\n");
>   		} else {
> +			struct cfg80211_bss *bss = NULL;
> +
>   			mstatus = RT_MEDIA_DISCONNECT;
>   
>   			if (mac->link_state == MAC80211_LINKED)
> @@ -1178,6 +1180,22 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>   			if (ppsc->p2p_ps_info.p2p_ps_mode > P2P_PS_NONE)
>   				rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
>   			mac->link_state = MAC80211_NOLINK;
> +
> +			bss = cfg80211_get_bss(hw->wiphy, NULL,
> +					       (u8 *)mac->bssid, NULL, 0,
> +					       IEEE80211_BSS_TYPE_ESS,
> +					       IEEE80211_PRIVACY_OFF);
> +
> +			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
> +				 "bssid = %pMF\n", mac->bssid);
> +
> +			if (bss) {
> +				cfg80211_unlink_bss(hw->wiphy, bss);
> +				cfg80211_put_bss(hw->wiphy, bss);
> +				RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
> +					 "cfg80211_unlink !!\n");
> +			}
> +
>   			eth_zero_addr(mac->bssid);
>   			mac->vendor = PEER_UNKNOWN;
>   			mac->mode = 0;
> 
