Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:54462 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965024AbZLGVf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 16:35:29 -0500
Message-ID: <4B1D7525.6070506@gmail.com>
Date: Mon, 07 Dec 2009 22:35:33 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: remove struct ieee80211_if_init_conf
References: <1260177774.13866.27.camel@johannes.local>
In-Reply-To: <1260177774.13866.27.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/09 10:22, Johannes Berg wrote:
> All its members (vif, mac_addr, type) are now available
> in the vif struct directly, so we can pass that instead
> of the conf struct. I generated this patch (except the
> mac80211 and header file changes) with this semantic
> patch:
> 
> @@
> identifier conf, fn, hw;
> type tp;
> @@
> tp fn(struct ieee80211_hw *hw,
> -struct ieee80211_if_init_conf *conf)
> +struct ieee80211_vif *vif)
> {
> <...
> (
> -conf->type
> +vif->type
> |
> -conf->mac_addr
> +vif->addr
> |
> -conf->vif
> +vif
> )
> ...>
> }
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

For the rt2x00 part:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/adm8211.c             |   12 +++---
>  drivers/net/wireless/at76c50x-usb.c        |    6 +--
>  drivers/net/wireless/ath/ar9170/main.c     |    8 ++--
>  drivers/net/wireless/ath/ath5k/base.c      |   18 ++++-----
>  drivers/net/wireless/ath/ath9k/main.c      |   28 +++++++-------
>  drivers/net/wireless/b43/main.c            |   26 ++++++-------
>  drivers/net/wireless/b43legacy/main.c      |   24 ++++++------
>  drivers/net/wireless/iwlwifi/iwl-core.c    |   20 +++++-----
>  drivers/net/wireless/iwlwifi/iwl-core.h    |    4 +-
>  drivers/net/wireless/libertas_tf/main.c    |   10 ++---
>  drivers/net/wireless/mac80211_hwsim.c      |   18 ++++-----
>  drivers/net/wireless/mwl8k.c               |   14 +++----
>  drivers/net/wireless/p54/main.c            |   12 +++---
>  drivers/net/wireless/rt2x00/rt2x00.h       |    4 +-
>  drivers/net/wireless/rt2x00/rt2x00mac.c    |   26 ++++++-------
>  drivers/net/wireless/rtl818x/rtl8180_dev.c |   14 +++----
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |   12 +++---
>  drivers/net/wireless/wl12xx/wl1251_main.c  |   14 +++----
>  drivers/net/wireless/wl12xx/wl1271_main.c  |   10 ++---
>  drivers/net/wireless/zd1211rw/zd_mac.c     |   10 ++---
>  include/net/mac80211.h                     |   57 +++++++----------------------
>  net/mac80211/driver-ops.h                  |   12 +++---
>  net/mac80211/iface.c                       |   14 +------
>  net/mac80211/pm.c                          |    6 ---
>  net/mac80211/util.c                        |    9 +---
>  25 files changed, 172 insertions(+), 216 deletions(-)
> 
