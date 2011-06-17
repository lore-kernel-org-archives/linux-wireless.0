Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62488 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab1FQPZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 11:25:23 -0400
Received: by vws1 with SMTP id 1so2018886vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 08:25:22 -0700 (PDT)
Message-ID: <4DFB71DF.4040409@lwfinger.net> (sfid-20110617_172526_776377_F5E1F1E7)
Date: Fri, 17 Jun 2011 10:25:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] rtlwifi: Fix typo in variable name
References: <4DF93EC7.7050102@ring3k.org>
In-Reply-To: <4DF93EC7.7050102@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2011 06:22 PM, Mike McCormack wrote:
> offchan_deley should be offchan_delay
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/core.c |    4 ++--
>   drivers/net/wireless/rtlwifi/pci.c  |    3 +--
>   drivers/net/wireless/rtlwifi/wifi.h |    2 +-
>   3 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
> index 605514b..3313ce6 100644
> --- a/drivers/net/wireless/rtlwifi/core.c
> +++ b/drivers/net/wireless/rtlwifi/core.c
> @@ -335,8 +335,8 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
>   		 * before going offchannel, or dis-association or delete BA will
>   		 * happen by AP
>   		 */
> -		if (rtlpriv->mac80211.offchan_deley) {
> -			rtlpriv->mac80211.offchan_deley = false;
> +		if (rtlpriv->mac80211.offchan_delay) {
> +			rtlpriv->mac80211.offchan_delay = false;
>   			mdelay(50);
>   		}
>   		rtlphy->current_channel = wide_chan;
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index d4c2da8..4195b01 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -581,7 +581,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
>   		fc = rtl_get_fc(skb);
>   		if (ieee80211_is_nullfunc(fc)) {
>   			if (ieee80211_has_pm(fc)) {
> -				rtlpriv->mac80211.offchan_deley = true;
> +				rtlpriv->mac80211.offchan_delay = true;
>   				rtlpriv->psc.state_inap = 1;
>   			} else {
>   				rtlpriv->psc.state_inap = 0;
> @@ -788,7 +788,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
>   {
>   	struct ieee80211_hw *hw = dev_id;
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
>   	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
>   	unsigned long flags;
>   	u32 inta = 0;
> diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
> index fcf2c9f..c54cda5 100644
> --- a/drivers/net/wireless/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/rtlwifi/wifi.h
> @@ -938,7 +938,7 @@ struct rtl_mac {
>   	int n_channels;
>   	int n_bitrates;
>
> -	bool offchan_deley;
> +	bool offchan_delay;
>
>   	/*filters */
>   	u32 rx_conf;

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

