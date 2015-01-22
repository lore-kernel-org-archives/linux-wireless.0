Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:53254 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbbAVT17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 14:27:59 -0500
Received: by mail-oi0-f54.google.com with SMTP id v63so2997425oia.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 11:27:59 -0800 (PST)
Message-ID: <54C14F3D.30206@lwfinger.net> (sfid-20150122_202803_591830_F5BDA3B4)
Date: Thu, 22 Jan 2015 13:27:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: add support to send beacon frame.
References: <1421827099-17975-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1421827099-17975-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2015 01:58 AM, Taehee Yoo wrote:
> In AP mode, beacon frame is necessary to keep connection.
> this patch adds a sending beacon frame routine in initialization routine.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/core.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
> index eb20316..a31a127 100644
> --- a/drivers/net/wireless/rtlwifi/core.c
> +++ b/drivers/net/wireless/rtlwifi/core.c
> @@ -1010,6 +1010,16 @@ static int rtl_op_conf_tx(struct ieee80211_hw *hw,
>   	return 0;
>   }
>
> +static void send_beacon_frame(struct ieee80211_hw *hw,
> +			      struct ieee80211_vif *vif)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
> +
> +	if (skb)
> +		rtlpriv->intf_ops->adapter_tx(hw, NULL, skb, NULL);
> +}
> +
>   static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>   				    struct ieee80211_vif *vif,
>   				    struct ieee80211_bss_conf *bss_conf,
> @@ -1040,6 +1050,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>
>   				if (rtlpriv->cfg->ops->linked_set_reg)
>   					rtlpriv->cfg->ops->linked_set_reg(hw);
> +				send_beacon_frame(hw, vif);
>   			}
>   		}
>   		if ((changed & BSS_CHANGED_BEACON_ENABLED &&
>

