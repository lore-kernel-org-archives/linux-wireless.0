Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2178 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760520Ab3D3NlC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 09:41:02 -0400
Message-ID: <517FC953.3010206@broadcom.com> (sfid-20130430_154110_890405_EBC844C4)
Date: Tue, 30 Apr 2013 19:08:27 +0530
From: Sreenath <sreenats@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

As per this patch, the dummy 'p2p0' interface will be created only if 
new interface creation request is for interface type - 
NL80211_IFTYPE_P2P_DEVICE. Does that mean that this P2P hack will work 
only with wpa_supplicant patches submitted by David Spinadel or similar 
changes have to be done in wpa_supplicant? Because with current version 
of wpa_supplicant there won't be any interface creation request for 
NL80211_IFTYPE_P2P_DEVICE as the interface type.

Moreover with David Spinadel's wpa_supplicant patches, the dummy 
interface name will be 'p2p-dev-<WLAN_PRIMARY_IF_NAME>' not 'p2p0'. So 
please provide more clarity on how this patch can be tested.

Regards,
Sreenath

On 04/29/2013 05:56 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
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
>   include/net/cfg80211.h |   4 ++
>   net/wireless/Kconfig   |   7 +++
>   net/wireless/Makefile  |   1 +
>   net/wireless/android.c | 147 +++++++++++++++++++++++++++++++++++++++++++++++++
>   net/wireless/core.c    |  14 +++++
>   net/wireless/core.h    |   6 ++
>   net/wireless/nl80211.c |  63 +++++++++++++++++++++
>   7 files changed, 242 insertions(+)
>   create mode 100644 net/wireless/android.c
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 87f7e1d..6e312ef 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2924,6 +2924,10 @@ struct wireless_dev {
>   		bool prev_bssid_valid;
>   	} wext;
>   #endif
> +
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	struct net_device *p2pdev;
> +#endif
>   };
>   
>   static inline u8 *wdev_address(struct wireless_dev *wdev)
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 16d08b3..7c2981c 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -139,6 +139,13 @@ config CFG80211_WEXT
>   	  Enable this option if you need old userspace for wireless
>   	  extensions with cfg80211-based drivers.
>   
> +config CFG80211_ANDROID_P2P_HACK
> +	bool "Android P2P netdevice hack"
> +	depends on CFG80211
> +	depends on !CFG80211_WEXT
> +	help
> +	  Enable this option for Android P2P w/ P2P Device.
> +
>   config LIB80211
>   	tristate
>   	default n
> diff --git a/net/wireless/Makefile b/net/wireless/Makefile
> index a761670..2800e67 100644
> --- a/net/wireless/Makefile
> +++ b/net/wireless/Makefile
> @@ -14,6 +14,7 @@ cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o
>   cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
>   cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
>   cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
> +cfg80211-$(CONFIG_CFG80211_ANDROID_P2P_HACK) += android.o
>   
>   CFLAGS_trace.o := -I$(src)
>   
> diff --git a/net/wireless/android.c b/net/wireless/android.c
> new file mode 100644
> index 0000000..e24c764
> --- /dev/null
> +++ b/net/wireless/android.c
> @@ -0,0 +1,147 @@
> +/******************************************************************************
> + *
> + * This file is provided under the GPLv2 license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * Copyright(c) 2013 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
> + * USA
> + *
> + * The full GNU General Public License is included in this distribution
> + * in the file called COPYING.
> + *
> + * Contact Information:
> + *  Intel Linux Wireless <ilw@linux.intel.com>
> + * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
> + *
> + * Author: Johannes Berg <johannes.berg@intel.com>
> + *
> + *****************************************************************************/
> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/rtnetlink.h>
> +#include <net/cfg80211.h>
> +#include "core.h"
> +#include "rdev-ops.h"
> +
> +static int cfg80211_android_p2pdev_open(struct net_device *dev)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +	int err;
> +
> +	if (!rdev->ops->start_p2p_device)
> +		return -EOPNOTSUPP;
> +
> +	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
> +		return -EOPNOTSUPP;
> +
> +	if (wdev->p2p_started)
> +		return 0;
> +
> +	mutex_lock(&rdev->devlist_mtx);
> +	err = cfg80211_can_add_interface(rdev, wdev->iftype);
> +	mutex_unlock(&rdev->devlist_mtx);
> +	if (err)
> +		return err;
> +
> +	err = rdev_start_p2p_device(rdev, wdev);
> +	if (err)
> +		return err;
> +
> +	wdev->p2p_started = true;
> +	mutex_lock(&rdev->devlist_mtx);
> +	rdev->opencount++;
> +	mutex_unlock(&rdev->devlist_mtx);
> +
> +	return 0;
> +}
> +
> +static int cfg80211_android_p2pdev_stop(struct net_device *dev)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +
> +	if (!wdev->p2p_started)
> +		return 0;
> +
> +	mutex_lock(&rdev->devlist_mtx);
> +	mutex_lock(&rdev->sched_scan_mtx);
> +	cfg80211_stop_p2p_device(rdev, wdev);
> +	mutex_unlock(&rdev->sched_scan_mtx);
> +	mutex_unlock(&rdev->devlist_mtx);
> +
> +	return 0;
> +}
> +
> +static netdev_tx_t cfg80211_android_p2pdev_start_xmit(struct sk_buff *skb,
> +						      struct net_device *dev)
> +{
> +	dev_kfree_skb(skb);
> +	return NETDEV_TX_OK;
> +}
> +
> +static const struct net_device_ops cfg80211_android_p2pdev_ops = {
> +	.ndo_open = cfg80211_android_p2pdev_open,
> +	.ndo_stop = cfg80211_android_p2pdev_stop,
> +	.ndo_start_xmit = cfg80211_android_p2pdev_start_xmit,
> +};
> +
> +static void cfg80211_android_p2pdev_setup(struct net_device *dev)
> +{
> +	ether_setup(dev);
> +	dev->features |= NETIF_F_NETNS_LOCAL;
> +	dev->netdev_ops = &cfg80211_android_p2pdev_ops;
> +	dev->destructor = free_netdev;
> +}
> +
> +void cfg80211_android_create_p2p_device(struct wireless_dev *wdev,
> +					const char *name)
> +{
> +	if (WARN_ON(wdev->p2pdev))
> +		return;
> +
> +	wdev->p2pdev = alloc_netdev(0, name, cfg80211_android_p2pdev_setup);
> +	if (WARN(!wdev->p2pdev,
> +		 "Failed to allocate P2P-Device netdev, things will fail!\n"))
> +		return;
> +
> +	memcpy(wdev->p2pdev->dev_addr, wdev->address, ETH_ALEN);
> +	wdev->p2pdev->ieee80211_ptr = wdev;
> +
> +	if (WARN(register_netdevice(wdev->p2pdev),
> +		 "Failed to register P2P-Device netdev, things will fail!\n")) {
> +		free_netdev(wdev->p2pdev);
> +		return;
> +	}
> +
> +	if (sysfs_create_link(&wdev->p2pdev->dev.kobj, &wdev->wiphy->dev.kobj,
> +			      "phy80211"))
> +		pr_err("failed to add phy80211 symlink to netdev!\n");
> +}
> +
> +void cfg80211_android_destroy_p2p_device(struct wireless_dev *wdev)
> +{
> +	ASSERT_RTNL();
> +
> +	if (!wdev->p2pdev)
> +		return;
> +
> +	dev_close(wdev->p2pdev);
> +	wdev->p2pdev->ieee80211_ptr = NULL;
> +	unregister_netdevice(wdev->p2pdev);
> +	wdev->p2pdev = NULL;
> +}
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 84c9ad7..59da6df 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -170,6 +170,12 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>   		return -EOPNOTSUPP;
>   
>   	list_for_each_entry(wdev, &rdev->wdev_list, list) {
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +		if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE) {
> +			err = -EBUSY;
> +			break;
> +		}
> +#endif
>   		if (!wdev->netdev)
>   			continue;
>   		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
> @@ -818,6 +824,9 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
>   	switch (wdev->iftype) {
>   	case NL80211_IFTYPE_P2P_DEVICE:
>   		cfg80211_stop_p2p_device(rdev, wdev);
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +		cfg80211_android_destroy_p2p_device(wdev);
> +#endif
>   		break;
>   	default:
>   		WARN_ON_ONCE(1);
> @@ -898,6 +907,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>   
>   	WARN_ON(wdev->iftype == NL80211_IFTYPE_UNSPECIFIED);
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE)
> +		return NOTIFY_DONE;
> +#endif
> +
>   	switch (state) {
>   	case NETDEV_POST_INIT:
>   		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index fd35dae..0cc74d5 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -522,4 +522,10 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
>   #define CFG80211_DEV_WARN_ON(cond)	({bool __r = (cond); __r; })
>   #endif
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +void cfg80211_android_create_p2p_device(struct wireless_dev *wdev,
> +					const char *name);
> +void cfg80211_android_destroy_p2p_device(struct wireless_dev *wdev);
> +#endif
> +
>   #endif /* __NET_WIRELESS_CORE_H */
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index f687a8d..732a29b 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -87,6 +87,13 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
>   				result = wdev;
>   				break;
>   			}
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +			if (have_ifidx && wdev->p2pdev &&
> +			    wdev->p2pdev->ifindex == ifidx) {
> +				result = wdev;
> +				break;
> +			}
> +#endif
>   			if (have_wdev_id && wdev->identifier == (u32)wdev_id) {
>   				result = wdev;
>   				break;
> @@ -2350,6 +2357,14 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
>   			return -EINVAL;
>   	}
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	if (otype == NL80211_IFTYPE_P2P_DEVICE) {
> +		if (ntype == NL80211_IFTYPE_P2P_DEVICE)
> +			return 0;
> +		return -EINVAL;
> +	}
> +#endif
> +
>   	if (info->attrs[NL80211_ATTR_MESH_ID]) {
>   		struct wireless_dev *wdev = dev->ieee80211_ptr;
>   
> @@ -2479,6 +2494,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>   		INIT_LIST_HEAD(&wdev->mgmt_registrations);
>   		spin_lock_init(&wdev->mgmt_registrations_lock);
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +		cfg80211_android_create_p2p_device(wdev,
> +			nla_data(info->attrs[NL80211_ATTR_IFNAME]));
> +#endif
>   		mutex_lock(&rdev->devlist_mtx);
>   		wdev->identifier = ++rdev->wdev_id;
>   		list_add_rcu(&wdev->list, &rdev->wdev_list);
> @@ -5624,6 +5643,11 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
>   	if (wdev->netdev &&
>   	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex))
>   		goto nla_put_failure;
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	if (wdev->p2pdev &&
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->p2pdev->ifindex))
> +		goto nla_put_failure;
> +#endif
>   	if (nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
>   		goto nla_put_failure;
>   
> @@ -8183,6 +8207,11 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
>   		return err;
>   
>   	wdev->p2p_started = true;
> +
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	WARN_ON(wdev->p2pdev && dev_open(wdev->p2pdev));
> +#endif
> +
>   	mutex_lock(&rdev->devlist_mtx);
>   	rdev->opencount++;
>   	mutex_unlock(&rdev->devlist_mtx);
> @@ -8207,6 +8236,10 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
>   	mutex_unlock(&rdev->sched_scan_mtx);
>   	mutex_unlock(&rdev->devlist_mtx);
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	WARN_ON(wdev->p2pdev && dev_close(wdev->p2pdev));
> +#endif
> +
>   	return 0;
>   }
>   
> @@ -8361,6 +8394,12 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
>   		dev = wdev->netdev;
>   		rdev = wiphy_to_dev(wdev->wiphy);
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +		if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
> +		    info->genlhdr->cmd == NL80211_CMD_SET_INTERFACE)
> +			dev = wdev->p2pdev;
> +#endif
> +
>   		if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
>   			if (!dev) {
>   				mutex_unlock(&cfg80211_mutex);
> @@ -9118,6 +9157,12 @@ static int nl80211_send_scan_msg(struct sk_buff *msg,
>   	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
>   		goto nla_put_failure;
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	if (wdev->p2pdev &&
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->p2pdev->ifindex))
> +		goto nla_put_failure;
> +#endif
> +
>   	/* ignore errors and send incomplete event anyway */
>   	nl80211_add_scan_req(msg, rdev);
>   
> @@ -9764,6 +9809,12 @@ static void nl80211_send_remain_on_chan_event(
>   	    nla_put_u64(msg, NL80211_ATTR_COOKIE, cookie))
>   		goto nla_put_failure;
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	if (wdev->p2pdev &&
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->p2pdev->ifindex))
> +		goto nla_put_failure;
> +#endif
> +
>   	if (cmd == NL80211_CMD_REMAIN_ON_CHANNEL &&
>   	    nla_put_u32(msg, NL80211_ATTR_DURATION, duration))
>   		goto nla_put_failure;
> @@ -10014,6 +10065,12 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
>   	    nla_put(msg, NL80211_ATTR_FRAME, len, buf))
>   		goto nla_put_failure;
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	if (wdev->p2pdev &&
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->p2pdev->ifindex))
> +		goto nla_put_failure;
> +#endif
> +
>   	genlmsg_end(msg, hdr);
>   
>   	return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);
> @@ -10053,6 +10110,12 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
>   	    (ack && nla_put_flag(msg, NL80211_ATTR_ACK)))
>   		goto nla_put_failure;
>   
> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> +	if (wdev->p2pdev &&
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->p2pdev->ifindex))
> +		goto nla_put_failure;
> +#endif
> +
>   	genlmsg_end(msg, hdr);
>   
>   	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);


