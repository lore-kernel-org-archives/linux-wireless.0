Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56237 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbBRVYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 16:24:10 -0500
Received: by mail-ob0-f176.google.com with SMTP id wo20so7294333obc.7
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2015 13:24:10 -0800 (PST)
Message-ID: <54E502F8.9010306@lwfinger.net> (sfid-20150218_222414_173796_6CD05DD4)
Date: Wed, 18 Feb 2015 15:24:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jon Hunter <jgchunter@gmail.com>, linux-wireless@vger.kernel.org
CC: coekbe@gmail.com
Subject: Re: [RFC PATCH] rtl8192cu: Fix beacon support in AP mode
References: <1424289074-27489-1-git-send-email-jgchunter@gmail.com>
In-Reply-To: <1424289074-27489-1-git-send-email-jgchunter@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2015 01:51 PM, Jon Hunter wrote:
> When using the rtl8192cu in AP mode a few devices (an android phone,
> iphone and ipad) were unable to associate, where as the laptops I tried
> could. Using wireshark to sniff the wlan traffic, it appears that the
> rtl8192cu is not beaconing, however, it is responding to broadcast
> probe requests and so devices are able to detect the AP.
>
> Searching the archives the same issue was reported for this WLAN device
> and a fix to send an initial beacon frame was proposed [1]. This was
> rejected as it was modifying the rtlwifi core. This change does the
> same but from within the rtl8192cu driver and appears to fix the problem.
>
> Please note that although this does fix the problem, I don't know if this
> is the best way or correct way to fix the problem, hence the request for
> comment.
>
> [1] http://permalink.gmane.org/gmane.linux.kernel.wireless.general/96770
>
> Signed-off-by: Jon Hunter <jgchunter@gmail.com>
>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> Cc: coekbe@gmail.com
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index fe4b699..4fbca80 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1520,6 +1520,22 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
>   	_beacon_function_enable(hw, true, true);
>   }
>
> +static void _beacon_send_frame(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
> +	struct ieee80211_sta *sta;
> +	struct rtl_tcb_desc tcb_desc;
> +	struct sk_buff *skb;
> +	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
> +
> +	skb = ieee80211_beacon_get(hw, mac->vif);
> +	sta = rtl_find_sta(hw, mac->bssid);
> +
> +	if (!rtlpriv->intf_ops->waitq_insert(hw, sta, skb))
> +		rtlpriv->intf_ops->adapter_tx(hw, sta, skb, &tcb_desc);
> +}
> +
>   void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> @@ -1529,6 +1545,9 @@ void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw)
>   	RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG, "beacon_interval:%d\n",
>   		 bcn_interval);
>   	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
> +
> +        /* Send initial beacon frame to start beaconing */
> +	_beacon_send_frame(hw);
>   }
>
>   void rtl92cu_update_interrupt_mask(struct ieee80211_hw *hw,
>

In the current mainline merge between 3.19 and 3.20-rc1, there is code that 
implements the initial beacon start in the core. The main commit is 
33511b157bbc. A second commit, which fixes a problem in mesh beacons, is found 
in 0b70dc273c13. These were much less intrusive than the one that was rejected, 
thus they were accepted into the core. I just tested creating an AP using 
NetworkManager and I was able to connect to a Kindle Fire HD, which is an 
Android device.

Do these patches not fix the problem for you? There is a report that the beacon 
startup is unreliable. Perhaps it may be necessary to change the static 
send_beacon_frame() in the core into rtl_send_beacon_frame(), make it be 
exported, and call it from rtl92cu_set_beacon_interval().

Larry


Larry

