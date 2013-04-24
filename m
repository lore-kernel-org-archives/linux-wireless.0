Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53035 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3DXOZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 10:25:04 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC v3] cfg80211: Android P2P-Device workaround
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1366804016-1720-1-git-send-email-johannes@sipsolutions.net>
Date: Wed, 24 Apr 2013 07:25:02 -0700
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Message-Id: <AEC9F350-DB10-4786-B934-9DF77988E74C@holtmann.org> (sfid-20130424_162510_214719_3988D30B)
References: <1366804016-1720-1-git-send-email-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Android requires a "p2p0" netdev to exist for P2P Device
> functionality, and will even set it "UP" to start the P2P
> Device functionality.
> 
> This is a hack to provide it so not only is Android happy
> but also the current version of wpa_supplicant can work
> with P2P-Device functionality without needing changes to
> support the P2P-Device commands, just a little bit to not
> attempt to change the interface type to station.

personally I still think this sends the wrong message. It should be a perfect fine patch to carry out-of-tree. I am worried that it just gets enabled everywhere and we have to deal with yet another netdev showing up on non-Android devices.

I still remember the the stupid IrDA netdev crazy that was essentially also only there for turning some chips on/off. It is an extremely bad idea. My point is that if you can not send IP packets over it, it should not be a netdev in the first place. We need less fake netdev and not more.

> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> include/net/cfg80211.h |   4 ++
> net/wireless/Kconfig   |   7 +++
> net/wireless/Makefile  |   1 +
> net/wireless/android.c | 146 +++++++++++++++++++++++++++++++++++++++++++++++++
> net/wireless/core.c    |  14 +++++
> net/wireless/core.h    |   6 ++
> net/wireless/nl80211.c |  34 ++++++++++++
> 7 files changed, 212 insertions(+)
> create mode 100644 net/wireless/android.c
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 87f7e1d..6e312ef 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2924,6 +2924,10 @@ struct wireless_dev {
> 		bool prev_bssid_valid;
> 	} wext;
> #endif
> +
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	struct net_device *p2pdev;
> +#endif
> };
> 
> static inline u8 *wdev_address(struct wireless_dev *wdev)
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 16d08b3..7c2981c 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -139,6 +139,13 @@ config CFG80211_WEXT
> 	  Enable this option if you need old userspace for wireless
> 	  extensions with cfg80211-based drivers.
> 
> +config CFG80211_ANDROID_P2P_HACK
> +	bool "Android P2P netdevice hack"
> +	depends on CFG80211
> +	depends on !CFG80211_WEXT
> +	help
> +	  Enable this option for Android P2P w/ P2P Device.
> +

This kernel option help section is useless. It needs a proper explanation what this patch is doing and big fat warning to NOT enable it if you have no clue what you are doing.

Regards

Marcel

