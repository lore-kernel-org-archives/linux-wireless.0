Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58226 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab0IOUvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 16:51:04 -0400
Received: by bwz11 with SMTP id 11so929267bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 13:51:03 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 3/3] compat-wirelsss: add carl9170
Date: Wed, 15 Sep 2010 22:50:56 +0200
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
References: <1284583415-11506-1-git-send-email-hauke@hauke-m.de> <1284583415-11506-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284583415-11506-3-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201009152250.56676.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 15 September 2010 22:43:35 Hauke Mehrtens wrote:
> This patch adds upport for carl9170.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
NACK

usb_get_from_anchor is not thread-safe on older kernel.
See details:

https://patchwork.kernel.org/patch/118946/

> ---
>  config.mk                            |    6 +++++
>  patches/25-multicast-list_head.patch |   42 ++++++++++++++++++++++++++++++++-
>  scripts/admin-update.sh              |    1 +
>  3 files changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/config.mk b/config.mk
> index b61c318..5e7ae1b 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -411,6 +411,12 @@ CONFIG_AT76C50X_USB=m
>  ifndef CONFIG_COMPAT_KERNEL_28
>  CONFIG_AR9170_USB=m
>  CONFIG_AR9170_LEDS=y
> +
> +CONFIG_CARL9170=m
> +CONFIG_CARL9170_LEDS=y
> +# CONFIG_CARL9170_DEBUGFS=y
> +# CONFIG_CARL9170_WPC=y
> +
>  endif #CONFIG_COMPAT_KERNEL_28
>  
>  CONFIG_ATH9K_HTC=m
> diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
> index 2869364..5a6bb16 100644
> --- a/patches/25-multicast-list_head.patch
> +++ b/patches/25-multicast-list_head.patch
> @@ -69,7 +69,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
>   }
>  --- a/drivers/net/b44.c
>  +++ b/drivers/net/b44.c
> -@@ -1680,7 +1680,11 @@ static int __b44_load_mcast(struct b44 *
> +@@ -1689,7 +1689,11 @@ static int __b44_load_mcast(struct b44 *
>   	netdev_for_each_mc_addr(ha, dev) {
>   		if (i == num_ents)
>   			break;
> @@ -227,6 +227,44 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
>   	}
>   
>   	return ((u64)(mfilt[1]) << 32) | mfilt[0];
> +--- a/drivers/net/wireless/ath/carl9170/main.c
> ++++ b/drivers/net/wireless/ath/carl9170/main.c
> +@@ -810,17 +810,35 @@ out:
> + 	return err;
> + }
> + 
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> + static u64 carl9170_op_prepare_multicast(struct ieee80211_hw *hw,
> + 					 struct netdev_hw_addr_list *mc_list)
> ++#else
> ++static u64 carl9170_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
> ++					 struct dev_addr_list *ha)
> ++#endif
> + {
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> + 	struct netdev_hw_addr *ha;
> ++#else
> ++	int i;
> ++#endif
> + 	u64 mchash;
> + 
> + 	/* always get broadcast frames */
> + 	mchash = 1ULL << (0xff >> 2);
> + 
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> + 	netdev_hw_addr_list_for_each(ha, mc_list)
> + 		mchash |= 1ULL << (ha->addr[5] >> 2);
> ++#else
> ++	for (i = 0; i < mc_count; i++) {
> ++		if (WARN_ON(!ha))
> ++			break;
> ++		mchash |= 1ULL << (ha->dmi_addr[5] >> 2);
> ++		ha = ha->next;
> ++	}
> ++#endif
> + 
> + 	return mchash;
> + }
>  --- a/drivers/net/wireless/libertas/main.c
>  +++ b/drivers/net/wireless/libertas/main.c
>  @@ -242,18 +242,34 @@ static int lbs_add_mcast_addrs(struct cm
> @@ -693,7 +731,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
>   	spin_unlock_bh(&local->filter_lock);
>   
>   	/* be a bit nasty */
> -@@ -521,9 +525,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
> +@@ -524,9 +528,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
>   	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
>   
>   	INIT_LIST_HEAD(&local->interfaces);
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
> index 6ef281d..ac9470d 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -192,6 +192,7 @@ fi
>  
>  # Drivers that have their own directory
>  DRIVERS="drivers/net/wireless/ath"
> +DRIVERS="$DRIVERS drivers/net/wireless/ath/carl9170"
>  DRIVERS="$DRIVERS drivers/net/wireless/ath/ar9170"
>  DRIVERS="$DRIVERS drivers/net/wireless/ath/ath5k"
>  DRIVERS="$DRIVERS drivers/net/wireless/ath/ath9k"
> 
