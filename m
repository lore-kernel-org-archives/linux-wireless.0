Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57224 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbATSdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 13:33:25 -0500
Received: by mail-ob0-f179.google.com with SMTP id vb8so9426886obc.10
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 10:33:25 -0800 (PST)
Message-ID: <54BE9F73.9070702@lwfinger.net> (sfid-20150120_193342_682475_B2AF89E2)
Date: Tue, 20 Jan 2015 12:33:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8192cu : add support to send beacon frame.
References: <1421736594-28262-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1421736594-28262-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2015 12:49 AM, Taehee Yoo wrote:
> In AP mode, beacon frame is necessary to keep connection.
> this patch adds a sending beacon frame routine in initialize routine.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/core.c          |  3 +++
>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c  |  1 +
>   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c | 11 +++++++++++
>   drivers/net/wireless/rtlwifi/rtl8192cu/trx.h |  1 +
>   drivers/net/wireless/rtlwifi/wifi.h          |  2 ++
>   5 files changed, 18 insertions(+)

This patch has a couple of issues reported by checkpatch.pl. These are noted 
inline. It will also have a conflict with "[PATCH V2 for 3.19 2/7] rtlwifi: 
rtl8192ee: Fix handling of new style descriptors" that I submitted today. As I 
note later, this conflict can be avoided and the patch should be made more general.

>
> diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
> index eb20316..2ebd1fd 100644
> --- a/drivers/net/wireless/rtlwifi/core.c
> +++ b/drivers/net/wireless/rtlwifi/core.c
> @@ -1040,6 +1040,9 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>
>   				if (rtlpriv->cfg->ops->linked_set_reg)
>   					rtlpriv->cfg->ops->linked_set_reg(hw);
> +				if (rtlpriv->cfg->ops->set_bcn_frame)
> +					rtlpriv->cfg->ops->set_bcn_frame(hw,
> +							vif);
>   			}
>   		}
>   		if ((changed & BSS_CHANGED_BEACON_ENABLED &&
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 90a714c..d88ee35 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -155,6 +155,7 @@ static struct rtl_hal_ops rtl8192cu_hal_ops = {
>   	.dm_dynamic_txpower = rtl92cu_dm_dynamic_txpower,
>   	.fill_h2c_cmd = rtl92c_fill_h2c_cmd,
>   	.get_btc_status = rtl92cu_get_btc_status,
> +	.set_bcn_frame = rtl92cu_set_bcn_frame,
>   };
>
>   static struct rtl_mod_params rtl92cu_mod_params = {
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> index cbead00..e27da8f 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> @@ -684,3 +684,14 @@ bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
>   {
>   	return true;
>   }
> +
> +void rtl92cu_set_bcn_frame(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
> +
> +	if (skb == NULL)
> +		return;

Checkpatch wants this to be "if (!skb)".

> +
> +	rtlpriv->intf_ops->adapter_tx(hw, NULL, skb, NULL);
> +}
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
> index fd8051d..0d57431 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
> @@ -431,5 +431,6 @@ void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
>   			     u8 *pdesc, bool b_firstseg,
>   			     bool b_lastseg, struct sk_buff *skb);
>   bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
> +void rtl92cu_set_bcn_frame(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>
>   #endif
> diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
> index b53d9dd..daf8142 100644
> --- a/drivers/net/wireless/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/rtlwifi/wifi.h
> @@ -2182,6 +2182,8 @@ struct rtl_hal_ops {
>   	void (*add_wowlan_pattern)(struct ieee80211_hw *hw,
>   				   struct rtl_wow_pattern *rtl_pattern,
>   				   u8 index);
> +	void (*set_bcn_frame) (struct ieee80211_hw *hw,

Checkpatch warns about the space before the function pointer arguments.

> +			       struct ieee80211_vif *vif);
>   };
>
>   struct rtl_intf_ops {
>

As all of the drivers that use rtlwifi will be helped by this routine, I suggest 
that you rename your new routine rtl92cu_set_bcn_frame() to send_bcn_frame(), 
make it static, and add it to core.c just before rtl_op_bss_info_changed(). It 
can then be called directly, none of the device-specific drivers need be 
modified, yet all will use it.

Thanks,

Larry

