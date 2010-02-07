Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:63332 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843Ab0BGLwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 06:52:50 -0500
Message-ID: <4B6EA990.30801@gmail.com>
Date: Sun, 07 Feb 2010 12:52:48 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH 09/10] rt2x00: remove get_tx_stats() mac80211 op
References: <20100207082044.31474.48583.stgit@tikku> <20100207082153.31474.76058.stgit@tikku>
In-Reply-To: <20100207082153.31474.76058.stgit@tikku>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/10 09:21, Kalle Valo wrote:
> get_tx_stats() will be removed from mac80211.
> 
> Compile-tested only.
> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Although I seem to be missing the actual removal of the
get_tx_stats from mac80211.

---
Gertjan.

>  drivers/net/wireless/rt2x00/rt2400pci.c |    1 -
>  drivers/net/wireless/rt2x00/rt2500pci.c |    1 -
>  drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
>  drivers/net/wireless/rt2x00/rt2800lib.c |    1 -
>  drivers/net/wireless/rt2x00/rt2x00.h    |    2 --
>  drivers/net/wireless/rt2x00/rt2x00mac.c |   16 ----------------
>  drivers/net/wireless/rt2x00/rt61pci.c   |    1 -
>  drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
>  8 files changed, 0 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index d86d233..1843359 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -1561,7 +1561,6 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
>  	.get_stats		= rt2x00mac_get_stats,
>  	.bss_info_changed	= rt2x00mac_bss_info_changed,
>  	.conf_tx		= rt2400pci_conf_tx,
> -	.get_tx_stats		= rt2x00mac_get_tx_stats,
>  	.get_tsf		= rt2400pci_get_tsf,
>  	.tx_last_beacon		= rt2400pci_tx_last_beacon,
>  	.rfkill_poll		= rt2x00mac_rfkill_poll,
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 46cbc6e..7dfcffa 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1859,7 +1859,6 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
>  	.get_stats		= rt2x00mac_get_stats,
>  	.bss_info_changed	= rt2x00mac_bss_info_changed,
>  	.conf_tx		= rt2x00mac_conf_tx,
> -	.get_tx_stats		= rt2x00mac_get_tx_stats,
>  	.get_tsf		= rt2500pci_get_tsf,
>  	.tx_last_beacon		= rt2500pci_tx_last_beacon,
>  	.rfkill_poll		= rt2x00mac_rfkill_poll,
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 9e6f865..81ca4ec 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1761,7 +1761,6 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
>  	.get_stats		= rt2x00mac_get_stats,
>  	.bss_info_changed	= rt2x00mac_bss_info_changed,
>  	.conf_tx		= rt2x00mac_conf_tx,
> -	.get_tx_stats		= rt2x00mac_get_tx_stats,
>  	.rfkill_poll		= rt2x00mac_rfkill_poll,
>  };
>  
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 529a373..a45e027 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2297,7 +2297,6 @@ const struct ieee80211_ops rt2800_mac80211_ops = {
>  	.set_rts_threshold	= rt2800_set_rts_threshold,
>  	.bss_info_changed	= rt2x00mac_bss_info_changed,
>  	.conf_tx		= rt2800_conf_tx,
> -	.get_tx_stats		= rt2x00mac_get_tx_stats,
>  	.get_tsf		= rt2800_get_tsf,
>  	.rfkill_poll		= rt2x00mac_rfkill_poll,
>  };
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 096da85..43b70c6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -1044,8 +1044,6 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  #endif /* CONFIG_RT2X00_LIB_CRYPTO */
>  int rt2x00mac_get_stats(struct ieee80211_hw *hw,
>  			struct ieee80211_low_level_stats *stats);
> -int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
> -			   struct ieee80211_tx_queue_stats *stats);
>  void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
>  				struct ieee80211_vif *vif,
>  				struct ieee80211_bss_conf *bss_conf,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 00f1f93..abbd857 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -555,22 +555,6 @@ int rt2x00mac_get_stats(struct ieee80211_hw *hw,
>  }
>  EXPORT_SYMBOL_GPL(rt2x00mac_get_stats);
>  
> -int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
> -			   struct ieee80211_tx_queue_stats *stats)
> -{
> -	struct rt2x00_dev *rt2x00dev = hw->priv;
> -	unsigned int i;
> -
> -	for (i = 0; i < rt2x00dev->ops->tx_queues; i++) {
> -		stats[i].len = rt2x00dev->tx[i].length;
> -		stats[i].limit = rt2x00dev->tx[i].limit;
> -		stats[i].count = rt2x00dev->tx[i].count;
> -	}
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(rt2x00mac_get_tx_stats);
> -
>  void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
>  				struct ieee80211_vif *vif,
>  				struct ieee80211_bss_conf *bss_conf,
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index c353b49..8813400 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2730,7 +2730,6 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
>  	.get_stats		= rt2x00mac_get_stats,
>  	.bss_info_changed	= rt2x00mac_bss_info_changed,
>  	.conf_tx		= rt61pci_conf_tx,
> -	.get_tx_stats		= rt2x00mac_get_tx_stats,
>  	.get_tsf		= rt61pci_get_tsf,
>  	.rfkill_poll		= rt2x00mac_rfkill_poll,
>  };
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index a026912..3781eb7 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2245,7 +2245,6 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
>  	.get_stats		= rt2x00mac_get_stats,
>  	.bss_info_changed	= rt2x00mac_bss_info_changed,
>  	.conf_tx		= rt73usb_conf_tx,
> -	.get_tx_stats		= rt2x00mac_get_tx_stats,
>  	.get_tsf		= rt73usb_get_tsf,
>  	.rfkill_poll		= rt2x00mac_rfkill_poll,
>  };
> 
> 

