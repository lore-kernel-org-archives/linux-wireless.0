Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52249 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab3DWOu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 10:50:28 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC] cfg80211: Android P2P-Device workaround
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1366721149-5440-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 23 Apr 2013 07:50:38 -0700
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Message-Id: <EC4E16A7-2F9E-4E59-A561-88C85A459BCA@holtmann.org> (sfid-20130423_165033_433685_62B3D157)
References: <1366721149-5440-1-git-send-email-johannes@sipsolutions.net>
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
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> net/wireless/Kconfig   |   7 +++
> net/wireless/Makefile  |   1 +
> net/wireless/android.c | 148 +++++++++++++++++++++++++++++++++++++++++++++++++
> net/wireless/core.c    |  15 ++++-
> net/wireless/core.h    |   7 +++
> net/wireless/nl80211.c |  28 +++++++++-
> 6 files changed, 204 insertions(+), 2 deletions(-)
> create mode 100644 net/wireless/android.c
> 
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

do you really think this is a good idea? Wouldn't it be better if Android just gets its userspace fixed. This way, they never will and you carry this workaround forever.

Has anybody actually looked into what it would take to just fix Android userspace to use nl80211 to bring up P2P. I just see tons of #ifdef added to the kernel.

<snip>

> @@ -8362,7 +8383,12 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
> 		rdev = wiphy_to_dev(wdev->wiphy);
> 
> 		if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
> -			if (!dev) {
> +			if (!dev
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +			    || (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
> +				info->genlhdr->cmd != NL80211_CMD_SET_INTERFACE)
> +#endif
> +			) {
> 				mutex_unlock(&cfg80211_mutex);
> 				if (rtnl)
> 					rtnl_unlock();

And doing an #ifdef in the middle of if-clause doesn't ring any alarm bells that this might be a really bad idea ;)

When I am looking at the USB gadget handling, I see a lot of progress in establishing a standard kernel interface and changing Android userspace to work with that instead.

Regards

Marcel

