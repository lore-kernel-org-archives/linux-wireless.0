Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXJaMY0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 08:24:26 -0400
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
From: Dan Williams <dcbw@redhat.com>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 08:22:51 -0400
Message-Id: <1193833372.23775.42.camel@localhost.localdomain> (sfid-20071031_122431_140984_86D28D82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-29 at 18:04 -0700, Luis Carlos Cobo wrote:
> It supports:
>   Unicast forwarding using fixed path tables, with mesh ttl decrementing.
>   Path table modifiable from user space (add new paths, show table, delete all paths).
>   Mesh statistics via /proc/net/mesh.
>   User space set mesh ID.

I'm not sure where this would go (and therefore don't know if you've
done it or not), but we need to make sure that mesh devices have some
sort of differentiating attribute in sysfs.  For example, the mac80211
master device has a "type" of 803 (or something like that) and and the
STA device has a type of 1.  That probably can't be used here, because
mesh devices are the same as STA devices from the perspective of an
application trying to push data to it.  But something else needs to be
there.  More comments below...

> Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
> ---
>  include/net/mac80211.h              |    5 +
>  net/mac80211/Makefile               |    2 +
>  net/mac80211/cfg.c                  |   34 +++++++
>  net/mac80211/debugfs_netdev.c       |    2 +
>  net/mac80211/ieee80211.c            |   16 +++-
>  net/mac80211/ieee80211_i.h          |    9 ++-
>  net/mac80211/ieee80211_iface.c      |    4 +-
>  net/mac80211/ieee80211_sta.c        |   26 ++++++-
>  net/mac80211/ieee80211s.c           |   56 ++++++++++++
>  net/mac80211/ieee80211s.h           |   56 ++++++++++++
>  net/mac80211/ieee80211s_pathtable.c |  162 +++++++++++++++++++++++++++++++++++
>  net/mac80211/ieee80211s_stats.c     |   97 +++++++++++++++++++++
>  net/mac80211/rx.c                   |   63 +++++++++++++-
>  net/mac80211/tx.c                   |   37 ++++++++-
>  14 files changed, 561 insertions(+), 8 deletions(-)
>  create mode 100644 net/mac80211/ieee80211s.c
>  create mode 100644 net/mac80211/ieee80211s.h
>  create mode 100644 net/mac80211/ieee80211s_pathtable.c
>  create mode 100644 net/mac80211/ieee80211s_stats.c
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 5fcc4c1..9cec07a 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -474,6 +474,7 @@ enum ieee80211_if_types {
>  	IEEE80211_IF_TYPE_AP,
>  	IEEE80211_IF_TYPE_STA,
>  	IEEE80211_IF_TYPE_IBSS,
> +	IEEE80211_IF_TYPE_MESH,
>  	IEEE80211_IF_TYPE_MNTR,
>  	IEEE80211_IF_TYPE_WDS,
>  	IEEE80211_IF_TYPE_VLAN,
> @@ -521,6 +522,8 @@ struct ieee80211_if_init_conf {
>   *	config_interface() call, so copy the value somewhere if you need
>   *	it.
>   * @ssid_len: length of the @ssid field.
> + * @mesh_id: mesh ID of the mesh network we will be part of.
> + * @mesh_id_len: length of the @mesh_id field.
>   * @beacon: beacon template. Valid only if @host_gen_beacon_template in
>   *	&struct ieee80211_hw is set. The driver is responsible of freeing
>   *	the sk_buff.
> @@ -535,6 +538,8 @@ struct ieee80211_if_conf {
>  	u8 *bssid;
>  	u8 *ssid;
>  	size_t ssid_len;
> +	u8 *mesh_id;
> +	size_t mesh_id_len;
>  	struct sk_buff *beacon;
>  	struct ieee80211_tx_control *beacon_control;
>  };
> diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
> index 219cd9f..04d3474 100644
> --- a/net/mac80211/Makefile
> +++ b/net/mac80211/Makefile
> @@ -3,6 +3,7 @@ obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
>  mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
>  mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
>  mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
> +ieee80211s-objs = ieee80211s.o ieee80211s_stats.o ieee80211s_pathtable.o
>  
>  mac80211-objs := \
>  	ieee80211.o \
> @@ -23,4 +24,5 @@ mac80211-objs := \
>  	key.o \
>  	util.o \
>  	event.o \
> +	$(ieee80211s-objs) \
>  	$(mac80211-objs-y)
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 9e2bc1f..bc31945 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -25,6 +25,8 @@ nl80211_type_to_mac80211_type(enum nl80211_iftype type)
>  		return IEEE80211_IF_TYPE_STA;
>  	case NL80211_IFTYPE_MONITOR:
>  		return IEEE80211_IF_TYPE_MNTR;
> +	case NL80211_IFTYPE_MESH:
> +		return IEEE80211_IF_TYPE_MESH;
>  	default:
>  		return IEEE80211_IF_TYPE_INVALID;
>  	}
> @@ -99,8 +101,40 @@ static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
>  	return 0;
>  }
>  
> +static int ieee80211_if_set_mesh_cfg(struct wiphy *wiphy,
> +		struct net_device *dev, struct mesh_params *params)
> +{
> +	struct ieee80211_local *local = wiphy_priv(wiphy);
> +	struct ieee80211_if_sta *ifsta;
> +	struct ieee80211_sub_if_data *sdata = NULL;
> +	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
> +		return -ENODEV;
> +
> +	if (!dev)
> +		return 0;
> +	
> +	if (!(dev->ieee80211_ptr && dev->ieee80211_ptr->wiphy->privid 
> +				== mac80211_wiphy_privid))
> +		return -EINVAL;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->type != IEEE80211_IF_TYPE_MESH)
> +		return -EINVAL;
> +	
> +	ifsta = &sdata->u.sta;
> +	ifsta->mesh_id_len = params->mesh_id_len;
> +	if (params->mesh_id_len)
> +		memcpy(ifsta->mesh_id, params->mesh_id, params->mesh_id_len);
> +
> +	/* If the iface is down, it will be configure when it is opened */
> +	if (netif_running(dev))
> +		ieee80211_if_config(dev);
> +	return 0;
> +}
> +
>  struct cfg80211_ops mac80211_config_ops = {
>  	.add_virtual_intf = ieee80211_add_iface,
>  	.del_virtual_intf = ieee80211_del_iface,
>  	.change_virtual_intf = ieee80211_change_iface,
> +	.set_mesh_cfg = ieee80211_if_set_mesh_cfg,
>  };
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index f0e6ab7..08459c1 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -233,6 +233,7 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
>  
>  	switch (sdata->type) {
>  	case IEEE80211_IF_TYPE_STA:
> +	case IEEE80211_IF_TYPE_MESH:
>  	case IEEE80211_IF_TYPE_IBSS:
>  		add_sta_files(sdata);
>  		break;
> @@ -326,6 +327,7 @@ static void del_files(struct ieee80211_sub_if_data *sdata, int type)
>  
>  	switch (type) {
>  	case IEEE80211_IF_TYPE_STA:
> +	case IEEE80211_IF_TYPE_MESH:
>  	case IEEE80211_IF_TYPE_IBSS:
>  		del_sta_files(sdata);
>  		break;
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index f484ca7..fc7c6a8 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -26,6 +26,7 @@
>  
>  #include "ieee80211_i.h"
>  #include "ieee80211_rate.h"
> +#include "ieee80211s.h"
>  #include "wep.h"
>  #include "wme.h"
>  #include "aes_ccm.h"
> @@ -126,9 +127,15 @@ static void ieee80211_master_set_multicast_list(struct net_device *dev)
>  
>  static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
>  {
> +	int meshhdrlen;
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	meshhdrlen = (sdata->type == IEEE80211_IF_TYPE_MESH) ? 5 : 0;
> +
>  	/* FIX: what would be proper limits for MTU?
>  	 * This interface uses 802.3 frames. */
> -	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
> +	if (new_mtu < 256 ||
> +   		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
>  		printk(KERN_WARNING "%s: invalid MTU %d\n",
>  		       dev->name, new_mtu);
>  		return -EINVAL;
> @@ -202,6 +209,7 @@ static int ieee80211_open(struct net_device *dev)
>  	case IEEE80211_IF_TYPE_STA:
>  	case IEEE80211_IF_TYPE_MNTR:
>  	case IEEE80211_IF_TYPE_IBSS:
> +	case IEEE80211_IF_TYPE_MESH:
>  		/* no special treatment */
>  		break;
>  	case IEEE80211_IF_TYPE_INVALID:
> @@ -1243,11 +1251,17 @@ static int __init ieee80211_init(void)
>  	ieee80211_debugfs_netdev_init();
>  	ieee80211_regdomain_init();
>  
> +	ret = ieee80211s_start();
> +	if (ret)
> +		printk(KERN_DEBUG "ieee80211_init: failed to initialize "
> +				"ieee80211s (err=%d)\n", ret);
> +
>  	return 0;
>  }
>  
>  static void __exit ieee80211_exit(void)
>  {
> +	ieee80211s_stop();
>  	ieee80211_wme_unregister();
>  	ieee80211_debugfs_netdev_exit();
>  }
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 4b4ed2a..518c55e 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -25,6 +25,7 @@
>  #include <net/wireless.h>
>  #include "ieee80211_key.h"
>  #include "sta_info.h"
> +#include "ieee80211s.h"
>  
>  /* ieee80211.o internal definitions, etc. These are not included into
>   * low-level drivers. */
> @@ -234,13 +235,16 @@ struct ieee80211_if_sta {
>  	enum {
>  		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
>  		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
> -		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED
> +		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
> +		IEEE80211_MESH

Just "MESH" doesn't seem quite descriptive enough here...  what exactly
is this state supposed to mean, that the interface is currently in a
mesh?

>  	} state;
>  	struct timer_list timer;
>  	struct work_struct work;
>  	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
>  	u8 ssid[IEEE80211_MAX_SSID_LEN];
>  	size_t ssid_len;
> +	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
> +	size_t mesh_id_len;
>  	u16 aid;
>  	u16 ap_capab, capab;
>  	u8 *extra_ie; /* to be added to the end of AssocReq */
> @@ -300,6 +304,8 @@ struct ieee80211_sub_if_data {
>  
>  	unsigned int flags;
>  
> +	struct mesh_stats mshstats;
> +
>  	int drop_unencrypted;
>  	int eapol; /* 0 = process EAPOL frames as normal data frames,
>  		    * 1 = send EAPOL frames through wlan#ap to hostapd
> @@ -759,6 +765,7 @@ int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
>  int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
>  void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
>  void ieee80211_reset_erp_info(struct net_device *dev);
> +void ieee80211_start_mesh(struct net_device *dev);
>  
>  /* ieee80211_iface.c */
>  int ieee80211_if_add(struct net_device *dev, const char *name,
> diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
> index 43e505d..6f9d644 100644
> --- a/net/mac80211/ieee80211_iface.c
> +++ b/net/mac80211/ieee80211_iface.c
> @@ -135,7 +135,8 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
>  		INIT_LIST_HEAD(&sdata->u.ap.vlans);
>  		break;
>  	case IEEE80211_IF_TYPE_STA:
> -	case IEEE80211_IF_TYPE_IBSS: {
> +	case IEEE80211_IF_TYPE_IBSS:
> +	case IEEE80211_IF_TYPE_MESH: {
>  		struct ieee80211_sub_if_data *msdata;
>  		struct ieee80211_if_sta *ifsta;
>  
> @@ -232,6 +233,7 @@ void ieee80211_if_reinit(struct net_device *dev)
>  		break;
>  	case IEEE80211_IF_TYPE_STA:
>  	case IEEE80211_IF_TYPE_IBSS:
> +	case IEEE80211_IF_TYPE_MESH:
>  		kfree(sdata->u.sta.extra_ie);
>  		sdata->u.sta.extra_ie = NULL;
>  		kfree(sdata->u.sta.assocreq_ies);
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index fda0e06..8c5f23a 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -755,6 +755,23 @@ static void ieee80211_associate(struct net_device *dev,
>  }
>  
> 
> +static void ieee80211_mesh(struct net_device *dev,
> +			   struct ieee80211_if_sta *ifsta)
> +{
> +	mod_timer(&ifsta->timer, jiffies + IEEE80211_MONITORING_INTERVAL);
> +}
> +
> +
> +void ieee80211_start_mesh(struct net_device *dev)
> +{
> +	struct ieee80211_if_sta *ifsta;
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	ifsta = &sdata->u.sta;
> +	ifsta->state = IEEE80211_MESH; 
> +	ieee80211_sta_timer((unsigned long)sdata);
> +}
> +
> +
>  static void ieee80211_associated(struct net_device *dev,
>  				 struct ieee80211_if_sta *ifsta)
>  {
> @@ -1985,7 +2002,8 @@ void ieee80211_sta_work(struct work_struct *work)
>  		return;
>  
>  	if (sdata->type != IEEE80211_IF_TYPE_STA &&
> -	    sdata->type != IEEE80211_IF_TYPE_IBSS) {
> +	    sdata->type != IEEE80211_IF_TYPE_IBSS &&
> +	    sdata->type != IEEE80211_IF_TYPE_MESH) {
>  		printk(KERN_DEBUG "%s: ieee80211_sta_work: non-STA interface "
>  		       "(type=%d)\n", dev->name, sdata->type);
>  		return;
> @@ -2027,6 +2045,9 @@ void ieee80211_sta_work(struct work_struct *work)
>  	case IEEE80211_IBSS_JOINED:
>  		ieee80211_sta_merge_ibss(dev, ifsta);
>  		break;
> +	case IEEE80211_MESH:
> +		ieee80211_mesh(dev, ifsta);
> +		break;
>  	default:
>  		printk(KERN_DEBUG "ieee80211_sta_work: Unknown state %d\n",
>  		       ifsta->state);
> @@ -2670,6 +2691,9 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
>  			ieee80211_sta_timer((unsigned long)sdata);
>  		}
>  
> +		if (sdata->type == IEEE80211_IF_TYPE_MESH)
> +			ieee80211_sta_timer((unsigned long)sdata);
> +
>  		netif_wake_queue(sdata->dev);
>  	}
>  	rcu_read_unlock();
> diff --git a/net/mac80211/ieee80211s.c b/net/mac80211/ieee80211s.c
> new file mode 100644
> index 0000000..beae9e6
> --- /dev/null
> +++ b/net/mac80211/ieee80211s.c
> @@ -0,0 +1,56 @@
> +/*
> + * Copyright (c) 2007 open80211s Ltd.
> + * Authors :   Luis Carlos Cobo <luisca@cozybit.com>
> + * 	       Javier Cardona <javier@cozybit.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "ieee80211s.h"
> +
> +int ieee80211s_start(void)
> +{
> +	o80211s_pathtable_init();
> +	return o80211s_create_procmesh();
> +}
> +
> +void ieee80211s_stop(void)
> +{
> +	o80211s_pathtable_unregister();
> +	o80211s_remove_procmesh();
> +}
> +
> +int get_mesh_header_len(struct ieee80211s_hdr* meshhdr)
> +{
> +	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
> +	/* 7.1.3.5a.2 */
> +	switch (ae) {
> +		case 0: return 5;
> +		case 1: return 11;
> +		case 2: return 17;
> +		case 3: return 23;
> +		default: return 5;
> +
> +	}
> +}
> +
> +/**
> + * mesh_header - create a new mesh header
> + * @meshhdr:    uninitialized mesh header
> + *
> + * Return the header length.
> + */
> +int mesh_header(struct ieee80211s_hdr* meshhdr)
> +{
> +	/* TODO: create a per mesh interface atomic sequence counter */
> +	int mesh_seqnum  = 0xcccccc;
> +
> +	meshhdr->flags = 0;
> +	meshhdr->ttl = DEFAULT_IEEE80211S_TTL;
> +	meshhdr->seqnum[0] = (u8) (mesh_seqnum & 0xff);
> +	meshhdr->seqnum[1] = (u8) ((mesh_seqnum >> 8) & 0xff);
> +	meshhdr->seqnum[2] = (u8) ((mesh_seqnum >> 16) & 0xff);
> +	return 5;
> +}
> diff --git a/net/mac80211/ieee80211s.h b/net/mac80211/ieee80211s.h
> new file mode 100644
> index 0000000..9d4604c
> --- /dev/null
> +++ b/net/mac80211/ieee80211s.h
> @@ -0,0 +1,56 @@
> +/*
> + * Copyright (c) 2007 open80211s Ltd.
> + * Authors :   Luis Carlos Cobo <luisca@cozybit.com>
> + *             Javier Cardona <javier@cozybit.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef IEEE80211S_H
> +#define IEEE80211S_H
> +
> +#include <linux/types.h>
> +
> +/* Data structures */
> +struct ieee80211s_hdr {
> +	u8 flags;
> +	u8 ttl;
> +	u8 seqnum[3];
> +	u8 eaddr1[6];
> +	u8 eaddr2[6];
> +	u8 eaddr3[6];
> +} __attribute__ ((packed));
> +
> +struct mesh_stats {
> +	__u32		forwarded;	/* Mesh forwarded frames */
> +	__u32		drop_meshttl;	/* Not forwarded since mesh_ttl == 0 */
> +};
> +
> +/* Public interfaces */
> +int ieee80211s_nh_lookup(u8 *dst, u8 *next_hop);
> +int ieee80211s_start(void);
> +void ieee80211s_stop(void);
> +
> +/* Internal interfaces o80211s */
> +void o80211s_pathtable_init(void);
> +void o80211s_pathtable_unregister(void);
> +int mesh_header(struct ieee80211s_hdr* meshhdr);
> +int get_mesh_header_len(struct ieee80211s_hdr* meshhdr);
> +
> +#ifdef CONFIG_PROC_FS
> +int o80211s_create_procmesh(void);
> +void o80211s_remove_procmesh(void);
> +#else
> +#define o80211s_create_procmesh(x) 0
> +#define o80211s_remove_procmesh
> +#endif
> +
> +/* Constants */
> +#define DEFAULT_IEEE80211S_TTL 5
> +
> +/* Mesh Header Flags */
> +#define IEEE80211S_FLAGS_AE 0x3
> +
> +#endif /* IEEE80211S_H */
> diff --git a/net/mac80211/ieee80211s_pathtable.c b/net/mac80211/ieee80211s_pathtable.c
> new file mode 100644
> index 0000000..92e6516
> --- /dev/null
> +++ b/net/mac80211/ieee80211s_pathtable.c
> @@ -0,0 +1,162 @@
> +/*
> + * Copyright (c) 2007 open80211s Ltd.
> + * Authors :   Luis Carlos Cobo <luisca@cozybit.com>
> + * 	       Javier Cardona <javier@cozybit.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <net/rtnetlink.h>
> +
> +static LIST_HEAD(mesh_paths);
> +static DEFINE_RWLOCK(mesh_paths_lock);
> +
> +struct mesh_path {
> +	struct list_head list;
> +
> +	u8 dst[ETH_ALEN];
> +	u8 next_hop[ETH_ALEN];
> +	int ifa_index;
> +};
> +
> +static const struct nla_policy mpa_policy[MPA_MAX+1] = {
> +        [MPA_DST]               = { .len = ETH_ALEN },
> +        [MPA_NEXT_HOP]          = { .len = ETH_ALEN },
> +};
> +
> +/**
> + * ieee80211s_nh_lookup - Look up next hop in mesh path table
> + * @dst: destination hardware address (input)
> + * @next_hop: next hop hardware address (output)
> + *
> + * Returns: 0 if next hop was found, nonzero otherwise
> + */
> +
> +int ieee80211s_nh_lookup (u8 *dst, u8 *next_hop) {
> +	struct mesh_path *mp;
> +
> +	if (dst == NULL || next_hop == NULL)
> +		return -1;
> +
> +	read_lock(&mesh_paths_lock);
> +	list_for_each_entry(mp, &mesh_paths, list) {
> +		if (memcmp(dst, mp->dst, ETH_ALEN) == 0) {
> +			memcpy(next_hop, mp->next_hop, ETH_ALEN);
> +			read_unlock(&mesh_paths_lock);
> +			return 0;
> +		}
> +	}
> +	read_unlock(&mesh_paths_lock);
> +	return -1;
> +}
> +
> +
> +static int o80211s_newmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh, void *arg)
> +{
> +	struct mpmsg *mpm;
> +	struct nlattr *tb[MPA_MAX+1];
> +	struct mesh_path *newpath;
> +	int err;
> +
> +	err = nlmsg_parse(nlh, sizeof(*mpm), tb, MPA_MAX, mpa_policy);
> +	if (err < 0 )
> +		return err;
> +
> +        mpm = nlmsg_data(nlh);
> +	if (!tb[MPA_DST] || !tb[MPA_NEXT_HOP])
> +		return -EINVAL;
> +
> +	newpath = (struct mesh_path*) kmalloc(sizeof(struct mesh_path),GFP_KERNEL);
> +	newpath->ifa_index = mpm->ifa_index;
> +	memcpy(newpath->dst, nla_data(tb[MPA_DST]), ETH_ALEN);
> +	memcpy(newpath->next_hop, nla_data(tb[MPA_NEXT_HOP]), ETH_ALEN);
> +	write_lock(&mesh_paths_lock);
> +	list_add(&newpath->list, &mesh_paths);
> +	write_unlock(&mesh_paths_lock);
> +	return err;
> +}
> +
> +static int o80211s_delmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh, void *arg)
> +{
> +	struct list_head *p, *q;
> +	struct mesh_path *path;
> +	list_for_each_safe(p, q, &mesh_paths) {
> +		path = list_entry(p, struct mesh_path, list);
> +		list_del(p);
> +		kfree(path);
> +	}
> +	return 0;
> +}
> +
> +static int o80211s_getmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh, void *arg)
> +{
> +	return 0;
> +}
> +
> +static int o80211s_dumpmeshpaths(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	int idx;
> +	int s_idx = cb->args[0];
> +	struct mesh_path *mp;
> +	struct nlmsghdr *nlh;
> +	struct mpmsg *hdr;
> +
> +	read_lock(&mesh_paths_lock);
> +	idx = 0;
> +	list_for_each_entry(mp, &mesh_paths, list) {
> +		if (idx < s_idx)
> +			goto cont;
> +		nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).pid, cb->nlh->nlmsg_seq,
> +			       	RTM_NEWMESHPATH, sizeof (*hdr), NLM_F_MULTI);
> +		if (nlh == NULL)
> +			goto nlh_failure;
> +		hdr = nlmsg_data(nlh);
> +		hdr->ifa_index = mp->ifa_index;
> +		hdr->mpm_flags = 0;
> +		NLA_PUT(skb, MPA_DST, ETH_ALEN, mp->dst);
> +		NLA_PUT(skb, MPA_NEXT_HOP, ETH_ALEN, mp->next_hop);
> +		nlmsg_end(skb, nlh);
> +		break;
> +cont:
> +		idx++;
> +	}
> +	read_unlock(&mesh_paths_lock);
> +	cb->args[0] = idx+1;
> +	return skb->len;
> +
> +nla_put_failure:
> +	nlmsg_cancel(skb, nlh);
> +nlh_failure:
> +	read_unlock(&mesh_paths_lock);
> +	return -EMSGSIZE;
> +}
> +
> +void o80211s_pathtable_init(void)
> +{
> +	rtnl_register(PF_UNSPEC, RTM_NEWMESHPATH, o80211s_newmeshpath, NULL);
> +	rtnl_register(PF_UNSPEC, RTM_GETMESHPATH, o80211s_getmeshpath,
> +			o80211s_dumpmeshpaths);
> +	rtnl_register(PF_UNSPEC, RTM_DELMESHPATH, o80211s_delmeshpath, NULL);
> +			
> +}
> +
> +void o80211s_pathtable_unregister(void)
> +{
> +	struct list_head *p, *q;
> +	struct mesh_path *path;
> +
> +	rtnl_unregister(PF_UNSPEC, RTM_NEWMESHPATH);
> +	rtnl_unregister(PF_UNSPEC, RTM_DELMESHPATH);
> +	rtnl_unregister(PF_UNSPEC, RTM_GETMESHPATH);
> +	list_for_each_safe(p, q, &mesh_paths) {
> +		path = list_entry(p, struct mesh_path, list);
> +		list_del(p);
> +		kfree(path);
> +	}
> +}
> diff --git a/net/mac80211/ieee80211s_stats.c b/net/mac80211/ieee80211s_stats.c
> new file mode 100644
> index 0000000..1688b60
> --- /dev/null
> +++ b/net/mac80211/ieee80211s_stats.c
> @@ -0,0 +1,97 @@
> +/* + * Copyright (c) 2007 open80211s Ltd.
> + * Authors :   Luis Carlos Cobo <luisca@cozybit.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/proc_fs.h>
> +#include <linux/netdevice.h>
> +#include <linux/seq_file.h>
> +#include <net/mac80211.h>
> +#include <net/net_namespace.h>
> +#include "ieee80211_i.h"
> +#include "ieee80211s.h"
> +
> +/* Most of this is borrowed from wext /proc/net/wireless, which is borrowed from
> + * /proc/net/dev
> + */

So I'm pretty sure adding new stuff to proc is the wrong thing to do,
actually.  That's probably going to be NAK-ed.  I could be wrong though.
I think the way forward here is nl80211/sysfs and not procfs.  It looks
like, for the moment, that the values used here in /proc/net/mesh are
values that would be _perfect_ to have in sysfs, since they are pretty
discrete and lend themselves to sysfs philosophy of one-value-per-file.

/proc/net/wireless was a colossal mistake from a userspace perspective
since people started screenscraping it, and that's almost _always_ the
wrong wrong wrong thing to do.

> +#ifdef CONFIG_PROC_FS
> +
> +static struct mesh_stats *get_mesh_stats(struct net_device *dev) {
> +	struct ieee80211_sub_if_data *sdata;
> +        /* check that device is a mac80211 device */
> +        if (dev->ieee80211_ptr &&
> +            dev->ieee80211_ptr->wiphy->privid == mac80211_wiphy_privid) {
> +		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +		if (sdata->type == IEEE80211_IF_TYPE_MESH)
> +			return &sdata->mshstats;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Print one entry (line) of /proc/net/mesh
> + */
> +static void mesh_seq_printf_stats(struct seq_file *seq,
> +				      struct net_device *dev)
> +{
> +	/* Get stats from the driver */
> +	struct mesh_stats *stats = get_mesh_stats(dev);
> +
> +	if (stats) {
> +		seq_printf(seq, "%s: %5d %7d\n",
> +			   dev->name, stats->forwarded, 
> +			   stats->drop_meshttl);
> +	}
> +}
> +
> +/*
> + * Print info for /proc/net/mesh (print all entries)
> + */
> +static int mesh_seq_show(struct seq_file *seq, void *v)
> +{
> +        if (v == SEQ_START_TOKEN)
> +                seq_printf(seq, "   Interface   |Fwded|Dropped\n"
> +                                "               |     |mesh ttl\n\n");
> +        else
> +                mesh_seq_printf_stats(seq, v);
> +        return 0;
> +}
> +
> +static const struct seq_operations mesh_seq_ops = {
> +        .start = dev_seq_start,
> +        .next  = dev_seq_next,
> +        .stop  = dev_seq_stop,
> +        .show  = mesh_seq_show,
> +};
> +
> +static int mesh_seq_open(struct inode *inode, struct file *file)
> +{
> +        return seq_open(file, &mesh_seq_ops);
> +}
> +
> +static const struct file_operations mesh_seq_fops = {
> +        .owner   = THIS_MODULE,
> +        .open    = mesh_seq_open,
> +        .read    = seq_read,
> +        .llseek  = seq_lseek,
> +        .release = seq_release,
> +};
> +
> +int o80211s_create_procmesh(void)
> +{
> +        /* Create /proc/net/mesh entry */
> +        if (!proc_net_fops_create(&init_net, "mesh", S_IRUGO, &mesh_seq_fops))
> +                return -ENOMEM;
> +
> +        return 0;
> +}
> +
> +void o80211s_remove_procmesh(void)
> +{
> +	proc_net_remove(&init_net, "mesh");
> +}
> +#endif
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index ece7776..798f89a 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -19,6 +19,7 @@
>  
>  #include "ieee80211_i.h"
>  #include "ieee80211_led.h"
> +#include "ieee80211s.h"
>  #include "wep.h"
>  #include "wpa.h"
>  #include "tkip.h"
> @@ -397,6 +398,16 @@ ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
>  	 * deauth/disassoc frames when needed. In addition, hostapd is
>  	 * responsible for filtering on both auth and assoc states.
>  	 */
> +
> +	if (rx->sdata->type == IEEE80211_IF_TYPE_MESH) {
> +		if (((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
> +		     !((rx->fc & IEEE80211_FCTL_FROMDS) &&
> +		      (rx->fc & IEEE80211_FCTL_TODS)))
> +			return TXRX_DROP;
> +		else
> +			return TXRX_CONTINUE;
> +	}
> +
>  	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
>  		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
>  		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
> @@ -1031,6 +1042,14 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
>  
>  	hdrlen = ieee80211_get_hdrlen(fc);
>  
> +	if (sdata->type == IEEE80211_IF_TYPE_MESH) {
> +		int meshhdrlen = get_mesh_header_len(
> +				(struct ieee80211s_hdr*) skb->data);
> +		/* copy mesh header on cb to be use if forwarded */
> +		memcpy(skb->cb, skb->data + hdrlen, meshhdrlen);
> +		hdrlen += meshhdrlen;
> +	}
> +
>  	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
>  	 * header
>  	 * IEEE 802.11 address fields:
> @@ -1064,7 +1083,8 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
>  		memcpy(dst, hdr->addr3, ETH_ALEN);
>  		memcpy(src, hdr->addr4, ETH_ALEN);
>  
> -		if (unlikely(sdata->type != IEEE80211_IF_TYPE_WDS)) {
> +		if (unlikely(sdata->type != IEEE80211_IF_TYPE_WDS &&
> +			     sdata->type != IEEE80211_IF_TYPE_MESH)) {
>  			if (net_ratelimit())
>  				printk(KERN_DEBUG "%s: dropped FromDS&ToDS "
>  				       "frame (RA=%s TA=%s DA=%s SA=%s)\n",
> @@ -1172,6 +1192,34 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
>  		}
>  	}
>  
> +	/* Mesh forwarding */
> +	if (sdata->type == IEEE80211_IF_TYPE_MESH) {
> +		u8 *mesh_ttl = &((struct ieee80211s_hdr *)skb->cb)->ttl;
> +		(*mesh_ttl)--;
> +		if (is_multicast_ether_addr(dst)) {
> +			/*
> +			 * Disabled to avoid traffic explosion till we have
> +			 * RBT and neighbor filtering
> +			 *
> +			if (*mesh_ttl > 0)
> +				skb2 = skb_copy(skb, GFP_ATOMIC);
> +				skb2->pkt_type = PACKET_OTHERHOST;
> +			*/
> +		}
> +		else if (skb->pkt_type != PACKET_OTHERHOST &&

the } and else should be on the same line.  I think 'checkpatch.pl'
should catch this, its in the kernel sources in scripts/.

> +			compare_ether_addr(sdata->dev->dev_addr, dst) != 0) {
> +			if (*mesh_ttl == 0) {
> +				sdata->mshstats.drop_meshttl++;
> +				return TXRX_DROP;
> +			}
> +			skb2 = skb;
> +			skb2->pkt_type = PACKET_OTHERHOST;
> +			if (!(sdata->dev->flags & IFF_PROMISC))
> +				skb  = NULL;
> +			sdata->mshstats.forwarded++;
> +		} 
> +	}
> +
>  	if (skb) {
>  		/* deliver to local stack */
>  		skb->protocol = eth_type_trans(skb, dev);
> @@ -1200,7 +1248,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
>  
>  	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
>  	if ((sdata->type == IEEE80211_IF_TYPE_STA ||
> -	     sdata->type == IEEE80211_IF_TYPE_IBSS) &&
> +	     sdata->type == IEEE80211_IF_TYPE_IBSS ||
> +	     sdata->type == IEEE80211_IF_TYPE_MESH) &&
>  	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
>  		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
>  	else
> @@ -1387,6 +1436,16 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
>  			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
>  							 bssid, hdr->addr2);
>  		break;
> +	
> +	case IEEE80211_IF_TYPE_MESH:
> +		if (!multicast &&
> +		   compare_ether_addr(sdata->dev->dev_addr,
> +				      hdr->addr1) != 0) {
> +			if (!(sdata->dev->flags & IFF_PROMISC))
> +				return 0;
> +			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
> +		}
> +		break;
>  	case IEEE80211_IF_TYPE_VLAN:
>  	case IEEE80211_IF_TYPE_AP:
>  		if (!bssid) {
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 1a53154..4bb3f1d 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -26,6 +26,7 @@
>  
>  #include "ieee80211_i.h"
>  #include "ieee80211_led.h"
> +#include "ieee80211s.h"
>  #include "wep.h"
>  #include "wpa.h"
>  #include "wme.h"
> @@ -230,6 +231,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
>  	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
>  		return TXRX_DROP;
>  
> +	if (tx->sdata->type == IEEE80211_IF_TYPE_MESH) {
> +		return TXRX_CONTINUE;}
> +

Don't need the { and } here.

Dan

>  	if (tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED)
>  		return TXRX_CONTINUE;
>  
> @@ -1342,8 +1346,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	struct ieee80211_tx_packet_data *pkt_data;
>  	struct ieee80211_sub_if_data *sdata;
>  	int ret = 1, head_need;
> -	u16 ethertype, hdrlen, fc;
> +	u16 ethertype, hdrlen,  meshhdrlen = 0, fc;
>  	struct ieee80211_hdr hdr;
> +	struct ieee80211s_hdr mesh_hdr;
>  	const u8 *encaps_data;
>  	int encaps_len, skip_header_bytes;
>  	int nh_pos, h_pos;
> @@ -1385,6 +1390,28 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
>  		hdrlen = 30;
>  		break;
> +	case IEEE80211_IF_TYPE_MESH:
> +		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
> +		/* RA TA DA SA */
> +		if (is_multicast_ether_addr(skb->data))
> +			memcpy(hdr.addr1, skb->data, ETH_ALEN);
> +		else if (ieee80211s_nh_lookup(skb->data, hdr.addr1)) {
> +			ret = 0;
> +			goto fail;
> +		}
> +		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
> +		memcpy(hdr.addr3, skb->data, ETH_ALEN);
> +		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
> +		if (skb->pkt_type == PACKET_OTHERHOST) {
> +			/* Forwarded frame, keep mesh ttl and seqnum */
> +			struct ieee80211s_hdr* prev_meshhdr;
> +			prev_meshhdr = ((struct ieee80211s_hdr*)skb->cb);
> +			meshhdrlen = get_mesh_header_len(prev_meshhdr);
> +			memcpy(&mesh_hdr, prev_meshhdr, meshhdrlen);
> +		} else
> +			meshhdrlen = mesh_header(&mesh_hdr);
> +		hdrlen = 30;
> +		break;
>  	case IEEE80211_IF_TYPE_STA:
>  		fc |= IEEE80211_FCTL_TODS;
>  		/* BSSID SA DA */
> @@ -1450,7 +1477,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	 * build in headroom in __dev_alloc_skb() (linux/skbuff.h) and
>  	 * alloc_skb() (net/core/skbuff.c)
>  	 */
> -	head_need = hdrlen + encaps_len + local->tx_headroom;
> +	head_need = hdrlen + encaps_len + meshhdrlen + local->tx_headroom;
>  	head_need -= skb_headroom(skb);
>  
>  	/* We are going to modify skb data, so make a copy of it if happens to
> @@ -1484,6 +1511,12 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  		h_pos += encaps_len;
>  	}
>  
> +	if (meshhdrlen > 0) {
> +		memcpy(skb_push(skb, meshhdrlen), &mesh_hdr, meshhdrlen);
> +		nh_pos += meshhdrlen;
> +		h_pos += meshhdrlen;
> +	}
> +
>  	if (fc & IEEE80211_STYPE_QOS_DATA) {
>  		__le16 *qos_control;
>  

