Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:45465 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427Ab1BORHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 12:07:03 -0500
Message-ID: <20110215190657.75006zvz1q691rk8@naisho.dyndns.info>
Date: Tue, 15 Feb 2011 19:06:57 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] mac80211: make tx() operation return void
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Johannes Berg <johannes@sipsolutions.net>:

> From: Johannes Berg <johannes.berg@intel.com>
>
> The return value of the tx operation is commonly
> misused by drivers, leading to errors. All drivers
> will drop frames if they fail to TX the frame, and
> they must also properly manage the queues (if they
> didn't, mac80211 would already warn).
>
> Removing the ability for drivers to return a BUSY
> value also allows significant cleanups of the TX
> TX handling code in mac80211.
>
> NB: Also fixes a bug in ath9k_htc.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/adm8211.c                |    4
>  drivers/net/wireless/at76c50x-usb.c           |    7 -
>  drivers/net/wireless/ath/ar9170/ar9170.h      |    2
>  drivers/net/wireless/ath/ar9170/main.c        |    5
>  drivers/net/wireless/ath/ath5k/base.c         |    5
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |   10 -
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    7 -
>  drivers/net/wireless/ath/ath9k/main.c         |    6
>  drivers/net/wireless/ath/carl9170/carl9170.h  |    2
>  drivers/net/wireless/ath/carl9170/tx.c        |    5
>  drivers/net/wireless/b43/main.c               |    5
>  drivers/net/wireless/b43legacy/main.c         |    5
>  drivers/net/wireless/iwlwifi/iwl-agn.c        |    3
>  drivers/net/wireless/iwlwifi/iwl-agn.h        |    2
>  drivers/net/wireless/iwlwifi/iwl3945-base.c   |    3
>  drivers/net/wireless/libertas_tf/main.c       |    3
>  drivers/net/wireless/mac80211_hwsim.c         |    5
>  drivers/net/wireless/mwl8k.c                  |   15 --
>  drivers/net/wireless/p54/lmac.h               |    2
>  drivers/net/wireless/p54/main.c               |    2
>  drivers/net/wireless/p54/txrx.c               |   11 -
>  drivers/net/wireless/rt2x00/rt2x00.h          |    2
>  drivers/net/wireless/rt2x00/rt2x00mac.c       |    5
>  drivers/net/wireless/rtl818x/rtl8180/dev.c    |    8 -
>  drivers/net/wireless/rtl818x/rtl8187/dev.c    |    6
>  drivers/net/wireless/rtlwifi/core.c           |    5
>  drivers/net/wireless/wl1251/main.c            |    4
>  drivers/net/wireless/wl12xx/main.c            |    4
>  drivers/net/wireless/zd1211rw/zd_mac.c        |    5
>  include/net/mac80211.h                        |    2
>  net/mac80211/driver-ops.h                     |    4
>  net/mac80211/tx.c                             |  164  
> ++++++++------------------
>  32 files changed, 113 insertions(+), 205 deletions(-)
>

...

> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2011-02-15  
> 13:53:37.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2011-02-15  
> 13:55:02.000000000 +0100
> @@ -3203,7 +3203,7 @@ static void b43_tx_work(struct work_stru
>  	mutex_unlock(&wl->mutex);
>  }
>
> -static int b43_op_tx(struct ieee80211_hw *hw,
> +static void b43_op_tx(struct ieee80211_hw *hw,
>  		     struct sk_buff *skb)
>  {
>  	struct b43_wl *wl = hw_to_b43_wl(hw);
> @@ -3211,14 +3211,11 @@ static int b43_op_tx(struct ieee80211_hw
>  	if (unlikely(skb->len < 2 + 2 + 6)) {
>  		/* Too short, this can't be a valid frame. */
>  		dev_kfree_skb_any(skb);
> -		return NETDEV_TX_OK;
>  	}

Return missing.

>  	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
>
>  	skb_queue_tail(&wl->tx_queue, skb);
>  	ieee80211_queue_work(wl->hw, &wl->tx_work);
> -
> -	return NETDEV_TX_OK;
>  }
>

