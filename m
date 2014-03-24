Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:25542 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaCXOct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 10:32:49 -0400
Message-ID: <5330420E.7020204@broadcom.com> (sfid-20140324_153255_540468_DA89F9B2)
Date: Mon, 24 Mar 2014 15:32:46 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	<linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 3/4] cfg80211: export interface stopping function
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com> <1395408675-26013-1-git-send-email-michal.kazior@tieto.com> <1395408675-26013-4-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1395408675-26013-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21/03/14 14:31, Michal Kazior wrote:
> This exports a new cfg80211_stop_iface() function.
>
> This is intended for driver internal interface
> combination management and channel switching.
>
> Due to locking issues (it re-enters driver) the
> call is asynchronous and uses cfg80211 event
> list/worker.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>   include/net/cfg80211.h | 15 +++++++++++++++
>   net/wireless/ap.c      |  4 ++--
>   net/wireless/core.c    | 44 +++++++++++++++++++++++++++++++++++++-------
>   net/wireless/core.h    |  7 +++++++
>   net/wireless/mesh.c    |  4 ++--
>   net/wireless/trace.h   | 15 +++++++++++++++
>   net/wireless/util.c    |  5 +++++
>   7 files changed, 83 insertions(+), 11 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 2f28ac4..7f0cbfb 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -4705,6 +4705,21 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
>   				const u8 radar_detect,
>   				const int iftype_num[NUM_NL80211_IFTYPES]);
>
> +/*
> + * cfg80211_stop_iface - stop given interface
> + *
> + * @wiphy: the wiphy
> + * @wdev: wireless device
> + *
> + * Stop interface as if AP was stopped, IBSS/mesh left, STA disconnected.
> + *
> + * This is intended for channel switching and internal driver interface
> + * combination management.
> + *
> + * Note: This doesn't need any locks and is asynchronous.
> + */
> +void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev);
> +
>   /* Logging, debugging and troubleshooting/diagnostic helpers. */
>
>   /* wiphy_printk helpers, similar to dev_printk */
> diff --git a/net/wireless/ap.c b/net/wireless/ap.c
> index 3e02ade..bdad1f9 100644
> --- a/net/wireless/ap.c
> +++ b/net/wireless/ap.c
> @@ -6,8 +6,8 @@
>   #include "rdev-ops.h"
>
>
> -static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
> -			      struct net_device *dev, bool notify)
> +int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
> +		       struct net_device *dev, bool notify)
>   {
>   	struct wireless_dev *wdev = dev->ieee80211_ptr;
>   	int err;
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 7fca03e..b2f064f 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -748,23 +748,23 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
>   		rdev->num_running_monitor_ifaces += num;
>   }
>
> -void cfg80211_leave(struct cfg80211_registered_device *rdev,
> -		    struct wireless_dev *wdev)
> +void __cfg80211_leave(struct cfg80211_registered_device *rdev,
> +		      struct wireless_dev *wdev)
>   {
>   	struct net_device *dev = wdev->netdev;
>
>   	ASSERT_RTNL();

If you have the assert check here do you need to do it from the call 
sites as well?

> +	ASSERT_WDEV_LOCK(wdev);

So you are changing behaviour here by requiring the wdev to be locked.

>   	switch (wdev->iftype) {
>   	case NL80211_IFTYPE_ADHOC:
> -		cfg80211_leave_ibss(rdev, dev, true);
> +		__cfg80211_leave_ibss(rdev, dev, true);
>   		break;
>   	case NL80211_IFTYPE_P2P_CLIENT:
>   	case NL80211_IFTYPE_STATION:
>   		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
>   			__cfg80211_stop_sched_scan(rdev, false);
>
> -		wdev_lock(wdev);
>   #ifdef CONFIG_CFG80211_WEXT
>   		kfree(wdev->wext.ie);
>   		wdev->wext.ie = NULL;
> @@ -773,14 +773,13 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
>   #endif
>   		cfg80211_disconnect(rdev, dev,
>   				    WLAN_REASON_DEAUTH_LEAVING, true);
> -		wdev_unlock(wdev);
>   		break;
>   	case NL80211_IFTYPE_MESH_POINT:
> -		cfg80211_leave_mesh(rdev, dev);
> +		__cfg80211_leave_mesh(rdev, dev);
>   		break;
>   	case NL80211_IFTYPE_AP:
>   	case NL80211_IFTYPE_P2P_GO:
> -		cfg80211_stop_ap(rdev, dev, true);
> +		__cfg80211_stop_ap(rdev, dev, true);
>   		break;
>   	default:
>   		break;
> @@ -789,6 +788,37 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
>   	wdev->beacon_interval = 0;
>   }
>
> +void cfg80211_leave(struct cfg80211_registered_device *rdev,
> +		    struct wireless_dev *wdev)
> +{
> +	ASSERT_RTNL();

This assert if also in __cfg80211_leave()

> +	wdev_lock(wdev);
> +	__cfg80211_leave(rdev, wdev);
> +	wdev_unlock(wdev);
> +}
> +
> +void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
> +{
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +	struct cfg80211_event *ev;
> +	unsigned long flags;
> +
> +	trace_cfg80211_stop_iface(wiphy, wdev);
> +
> +	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
> +	if (!ev)
> +		return;
> +
> +	ev->type = EVENT_STOPPED;
> +
> +	spin_lock_irqsave(&wdev->event_lock, flags);
> +	list_add_tail(&ev->list, &wdev->event_list);
> +	spin_unlock_irqrestore(&wdev->event_lock, flags);
> +	queue_work(cfg80211_wq, &rdev->event_work);
> +}
> +EXPORT_SYMBOL(cfg80211_stop_iface);
> +
>   static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>   					 unsigned long state, void *ptr)
>   {
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 85340a9..bffb36c 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -181,6 +181,7 @@ enum cfg80211_event_type {
>   	EVENT_ROAMED,
>   	EVENT_DISCONNECTED,
>   	EVENT_IBSS_JOINED,
> +	EVENT_STOPPED,
>   };
>
>   struct cfg80211_event {
> @@ -270,6 +271,8 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
>   		       struct net_device *dev,
>   		       struct mesh_setup *setup,
>   		       const struct mesh_config *conf);
> +int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
> +			  struct net_device *dev);
>   int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
>   			struct net_device *dev);
>   int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
> @@ -277,6 +280,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
>   			      struct cfg80211_chan_def *chandef);
>
>   /* AP */
> +int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
> +		       struct net_device *dev, bool notify);
>   int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
>   		     struct net_device *dev, bool notify);
>
> @@ -430,6 +435,8 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
>   void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
>   			       enum nl80211_iftype iftype, int num);
>
> +void __cfg80211_leave(struct cfg80211_registered_device *rdev,
> +		      struct wireless_dev *wdev);
>   void cfg80211_leave(struct cfg80211_registered_device *rdev,
>   		    struct wireless_dev *wdev);
>
> diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
> index b8a7a35..e02301b 100644
> --- a/net/wireless/mesh.c
> +++ b/net/wireless/mesh.c
> @@ -237,8 +237,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
>   	return 0;
>   }
>
> -static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
> -				 struct net_device *dev)
> +int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
> +			  struct net_device *dev)
>   {
>   	struct wireless_dev *wdev = dev->ieee80211_ptr;
>   	int err;
> diff --git a/net/wireless/trace.h b/net/wireless/trace.h
> index aabccf1..24acf96 100644
> --- a/net/wireless/trace.h
> +++ b/net/wireless/trace.h
> @@ -2615,6 +2615,21 @@ TRACE_EVENT(cfg80211_ft_event,
>   		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(target_ap))
>   );
>
> +TRACE_EVENT(cfg80211_stop_iface,
> +	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
> +	TP_ARGS(wiphy, wdev),
> +	TP_STRUCT__entry(
> +		WIPHY_ENTRY
> +		WDEV_ENTRY
> +	),
> +	TP_fast_assign(
> +		WIPHY_ASSIGN;
> +		WDEV_ASSIGN;
> +	),
> +	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT,
> +		  WIPHY_PR_ARG, WDEV_PR_ARG)
> +);
> +
>   #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
>
>   #undef TRACE_INCLUDE_PATH
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 2984aff..241f0ad 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -789,6 +789,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
>   	unsigned long flags;
>   	const u8 *bssid = NULL;
>
> +	ASSERT_RTNL();

Also checked in __cfg80211_leave()

>   	spin_lock_irqsave(&wdev->event_lock, flags);
>   	while (!list_empty(&wdev->event_list)) {
>   		ev = list_first_entry(&wdev->event_list,
> @@ -823,6 +825,9 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
>   			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid,
>   					       ev->ij.channel);
>   			break;
> +		case EVENT_STOPPED:
> +			__cfg80211_leave(wiphy_to_dev(wdev->wiphy), wdev);
> +			break;
>   		}
>   		wdev_unlock(wdev);
>
>

Regards,
Arend
