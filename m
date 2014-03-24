Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:62748 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaCXRfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 13:35:10 -0400
Message-ID: <53306CC7.2010709@broadcom.com> (sfid-20140324_183515_688146_417B638F)
Date: Mon, 24 Mar 2014 18:35:03 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] cfg80211: allow userspace to take ownership of interfaces
References: <1395680275-11657-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1395680275-11657-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/14 17:57, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> When dynamically creating interfaces from userspace, e.g. for P2P usage,
> such interfaces are usually owned by the process that created them, i.e.
> wpa_supplicant. Should wpa_supplicant crash, such interfaces will often
> cease operating properly and cause problems on restarting the process.
>
> To avoid this problem, introduce an ownership concept for interfaces. If
> an interface is owned by a netlink socket, then it will be destroyed if
> the netlink socket is closed for any reason, including if the process it
> belongs to crashed. This gives us a race-free way to get rid of any such
> interfaces.

Excellent idea.

> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---
>   include/net/cfg80211.h       |  3 +++
>   include/uapi/linux/nl80211.h |  6 ++++++
>   net/wireless/core.c          | 44 ++++++++++++++++++++++++++++++++++++++++++++
>   net/wireless/core.h          | 11 +++++++++++
>   net/wireless/nl80211.c       | 28 +++++++++++++++++++++++++++-
>   5 files changed, 91 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f3539a15c411..6510ccf53a54 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3194,6 +3194,7 @@ struct cfg80211_cached_keys;
>    * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
>    * @event_list: (private) list for internal event processing
>    * @event_lock: (private) lock for event list
> + * @owner_nlportid: (private) owner socket port ID
>    */
>   struct wireless_dev {
>   	struct wiphy *wiphy;
> @@ -3241,6 +3242,8 @@ struct wireless_dev {
>   	unsigned long cac_start_time;
>   	unsigned int cac_time_ms;
>
> +	u32 owner_nlportid;
> +
>   #ifdef CONFIG_CFG80211_WEXT
>   	/* wext data */
>   	struct {
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 1ba9d626aa83..5e405fd55a71 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1579,6 +1579,10 @@ enum nl80211_commands {
>    * @NL80211_ATTR_TDLS_PEER_CAPABILITY: flags for TDLS peer capabilities, u32.
>    *	As specified in the&enum nl80211_tdls_peer_capability.
>    *
> + * @NL80211_ATTR_IFACE_SOCKET_OWNER: flag attribute, if set during interface
> + *	creation then the new interface will be owned by the netlink socket
> + *	that created it and will be destroyed when the socket is closed
> + *

Guess you want explicit flag so apps like iw can still create 
interfaces, right?

>    * @NL80211_ATTR_MAX: highest attribute number currently defined
>    * @__NL80211_ATTR_AFTER_LAST: internal use
>    */
> @@ -1914,6 +1918,8 @@ enum nl80211_attrs {
>
>   	NL80211_ATTR_TDLS_PEER_CAPABILITY,
>
> +	NL80211_ATTR_IFACE_SOCKET_OWNER,
> +
>   	/* add attributes here, update the policy in nl80211.c */
>
>   	__NL80211_ATTR_AFTER_LAST,
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 276cf938f764..87ea858fb471 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -260,6 +260,45 @@ static void cfg80211_event_work(struct work_struct *work)
>   	rtnl_unlock();
>   }
>
> +void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev)
> +{
> +	struct cfg80211_iface_destroy *item;
> +
> +	ASSERT_RTNL();
> +
> +	spin_lock_irq(&rdev->destroy_list_lock);
> +	while ((item = list_first_entry_or_null(&rdev->destroy_list,
> +						struct cfg80211_iface_destroy,
> +						list))) {
> +		struct wireless_dev *wdev, *tmp;
> +		u32 nlportid = item->nlportid;
> +
> +		list_del(&item->list);
> +		kfree(item);
> +		spin_unlock_irq(&rdev->destroy_list_lock);
> +
> +		list_for_each_entry_safe(wdev, tmp,&rdev->wdev_list, list) {
> +			if (nlportid == wdev->owner_nlportid)
> +				rdev_del_virtual_intf(rdev, wdev);
> +		}
> +
> +		spin_lock_irq(&rdev->destroy_list_lock);
> +	}
> +	spin_unlock_irq(&rdev->destroy_list_lock);
> +}
> +
> +static void cfg80211_destroy_iface_wk(struct work_struct *work)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	rdev = container_of(work, struct cfg80211_registered_device,
> +			    destroy_work);
> +
> +	rtnl_lock();
> +	cfg80211_destroy_ifaces(rdev);
> +	rtnl_unlock();
> +}
> +
>   /* exported functions */
>
>   struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
> @@ -318,6 +357,10 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
>   	rdev->wiphy.dev.class =&ieee80211_class;
>   	rdev->wiphy.dev.platform_data = rdev;
>
> +	INIT_LIST_HEAD(&rdev->destroy_list);
> +	spin_lock_init(&rdev->destroy_list_lock);
> +	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
> +
>   #ifdef CONFIG_CFG80211_DEFAULT_PS
>   	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
>   #endif
> @@ -675,6 +718,7 @@ void wiphy_unregister(struct wiphy *wiphy)
>   	cancel_work_sync(&rdev->conn_work);
>   	flush_work(&rdev->event_work);
>   	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
> +	flush_work(&rdev->destroy_work);
>
>   #ifdef CONFIG_PM
>   	if (rdev->wiphy.wowlan_config&&  rdev->ops->set_wakeup)
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 5b1fdcadd469..6f6f75609852 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -80,6 +80,10 @@ struct cfg80211_registered_device {
>
>   	struct cfg80211_coalesce *coalesce;
>
> +	spinlock_t destroy_list_lock;
> +	struct list_head destroy_list;
> +	struct work_struct destroy_work;
> +
>   	/* must be last because of the way we do wiphy_priv(),
>   	 * and it should at least be aligned to NETDEV_ALIGN */
>   	struct wiphy wiphy __aligned(NETDEV_ALIGN);
> @@ -232,6 +236,13 @@ struct cfg80211_beacon_registration {
>   	u32 nlportid;
>   };
>
> +struct cfg80211_iface_destroy {
> +	struct list_head list;
> +	u32 nlportid;
> +};
> +
> +void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev);
> +
>   /* free object */
>   void cfg80211_dev_free(struct cfg80211_registered_device *rdev);
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 052c1bf8ffac..b25b5ce4076d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -385,6 +385,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
>   	[NL80211_ATTR_MAC_HINT] = { .len = ETH_ALEN },
>   	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
>   	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
> +	[NL80211_ATTR_IFACE_SOCKET_OWNER] = { .type = NLA_FLAG },
>   };
>
>   /* policy for the key attributes */
> @@ -2514,6 +2515,9 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>   	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
>   	u32 flags;
>
> +	/* to avoid failing a new interface creation due to pending removal */
> +	cfg80211_destroy_ifaces(rdev);
> +
>   	memset(&params, 0, sizeof(params));
>
>   	if (!info->attrs[NL80211_ATTR_IFNAME])
> @@ -2563,6 +2567,9 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>   		return PTR_ERR(wdev);
>   	}
>
> +	if (info->attrs[NL80211_ATTR_IFACE_SOCKET_OWNER])
> +		wdev->owner_nlportid = info->snd_portid;
> +
>   	switch (type) {
>   	case NL80211_IFTYPE_MESH_POINT:
>   		if (!info->attrs[NL80211_ATTR_MESH_ID])
> @@ -11649,9 +11656,15 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
>   	rcu_read_lock();
>
>   	list_for_each_entry_rcu(rdev,&cfg80211_rdev_list, list) {
> -		list_for_each_entry_rcu(wdev,&rdev->wdev_list, list)
> +		bool schedule_destroy_work = false;
> +
> +		list_for_each_entry_rcu(wdev,&rdev->wdev_list, list) {
>   			cfg80211_mlme_unregister_socket(wdev, notify->portid);
>
> +			if (wdev->owner_nlportid == notify->portid)
> +				schedule_destroy_work = true;
> +		}
> +
>   		spin_lock_bh(&rdev->beacon_registrations_lock);
>   		list_for_each_entry_safe(reg, tmp,&rdev->beacon_registrations,
>   					 list) {
> @@ -11662,6 +11675,19 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
>   			}
>   		}
>   		spin_unlock_bh(&rdev->beacon_registrations_lock);
> +
> +		if (schedule_destroy_work) {
> +			struct cfg80211_iface_destroy *destroy;
> +
> +			destroy = kzalloc(sizeof(*destroy), GFP_ATOMIC);

Probably overlooking it, because it is not part of the patch but: what 
lock requires this to be atomic? rcu_read_lock?

> +			if (destroy) {
> +				destroy->nlportid = notify->portid;
> +				spin_lock(&rdev->destroy_list_lock);
> +				list_add(&destroy->list,&rdev->destroy_list);
> +				spin_unlock(&rdev->destroy_list_lock);
> +				schedule_work(&rdev->destroy_work);
> +			}
> +		}
>   	}
>
>   	rcu_read_unlock();

Regards,
Arend
