Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2278 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2GNKKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 06:10:35 -0400
Message-ID: <50014580.7060702@broadcom.com> (sfid-20120714_121116_678570_6175AC80)
Date: Sat, 14 Jul 2012 12:10:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Thomas Huehn" <thomas@net.t-labs.tu-berlin.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	coelho@ti.com, johannes.berg@intel.com
Subject: Re: [PATCH 2/2] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
References: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2012 08:52 PM, Thomas Huehn wrote:
> The pointer control.sta is removed from ieee80211_tx_info to free up sufficient
> memory in SKB_CB on the tx-path to enable new annotations per data packet e.g.
> support of upcoming Transmit Power Control (TPC).
> Now the control.sta pointer is put on the stack where it is passed as function
> parameter to the .tx equivalent (ieee80211_ops) of each affected wireless
> driver. Therefore a new structure ieee80211_tx_control is added to mac80211.h
> which holds the sta structure instead.
> 
> ---
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  6 +++--
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 9e79d47..a7be68d 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -264,7 +264,9 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
>  	}
>  }
>  
> -static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> +static void brcms_ops_tx(struct ieee80211_hw *hw,
> +			 struct ieee80211_tx_control *control,
> +			 struct sk_buff *skb)

Fix indent here (if it is not a mailer issue).

>  {
>  	struct brcms_info *wl = hw->priv;
>  	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
> @@ -276,7 +278,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  		goto done;
>  	}
>  	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
> -	tx_info->rate_driver_data[0] = tx_info->control.sta;
> +	tx_info->rate_driver_data[0] = control->sta;
>   done:
>  	spin_unlock_bh(&wl->lock);
>  }

Gr. AvS

