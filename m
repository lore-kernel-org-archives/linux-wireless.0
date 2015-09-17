Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbbIQOdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 10:33:24 -0400
From: andrei.otcheretianski@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [RFC 1/7] cfg80211: add start / stop NAN commands
Date: Thu, 17 Sep 2015 17:32:25 +0300
Message-Id: <1442500351-8780-2-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150917_163342_519314_DC3540C6)
In-Reply-To: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
References: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows user space to start/stop NAN interface.
A NAN interface is like P2P device in a few aspects: it
doesn't have a netdev associated to it.
Add the new interface type and prevent operations that
can't be executed on NAN interface like scan.
Define several attributes that may be configured by user space
when starting NAN functionality (master preference, cluster id
and dual band operation)

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
---
 include/net/cfg80211.h       | 31 +++++++++++++-
 include/uapi/linux/nl80211.h | 28 +++++++++++++
 net/mac80211/cfg.c           |  3 ++
 net/mac80211/chan.c          |  3 ++
 net/mac80211/iface.c         |  4 ++
 net/mac80211/rx.c            |  3 ++
 net/mac80211/util.c          |  1 +
 net/wireless/chan.c          |  2 +
 net/wireless/core.c          | 35 ++++++++++++++++
 net/wireless/core.h          |  3 ++
 net/wireless/mlme.c          |  1 +
 net/wireless/nl80211.c       | 97 ++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/rdev-ops.h      | 20 +++++++++
 net/wireless/trace.h         | 29 +++++++++++++
 net/wireless/util.c          |  9 +++-
 15 files changed, 262 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0f54c9e..dcf8a74 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5,6 +5,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2181,6 +2182,24 @@ struct cfg80211_qos_map {
 };
 
 /**
+ * struct cfg80211_nan_conf - nan configuration
+ *
+ * This struct defines nan configuration parameters
+ *
+ * @master_pref: master preference (2 -254)
+ * @cluster_id: optional cluster id, or 0 to let the device to generate.
+ * @dual: 0-default, 1 - 2.4Ghz Only, 2 - dual band operation.
+ *
+ * TODO: Add more parameters
+ */
+struct cfg80211_nan_conf {
+	u8 master_pref;
+	u16 cluster_id;
+	u8 dual;
+};
+
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2447,7 +2466,11 @@ struct cfg80211_qos_map {
  *	and returning to the base channel for communication with the AP.
  * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
  *	peers must be on the base channel when the call completes.
- */
+ *
+ * @start_nan: Start the NAN interface.
+ * @stop_nan: Stop the NAN interface.
+ *
+  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
 	int	(*resume)(struct wiphy *wiphy);
@@ -2711,6 +2734,9 @@ struct cfg80211_ops {
 	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      const u8 *addr);
+	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			     struct cfg80211_nan_conf *conf);
+	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev *wdev);
 };
 
 /*
@@ -3423,6 +3449,7 @@ struct cfg80211_cached_keys;
  *	beacons, 0 when not valid
  * @address: The address for this device, valid only if @netdev is %NULL
  * @p2p_started: true if this is a P2P Device that has been started
+ * @nan_started: true if this is a NAN interface that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
  * @cac_time_ms: CAC time in ms
@@ -3453,7 +3480,7 @@ struct wireless_dev {
 
 	struct mutex mtx;
 
-	bool use_4addr, p2p_started;
+	bool use_4addr, p2p_started, nan_started;
 
 	u8 address[ETH_ALEN] __aligned(sizeof(u16));
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c0ab6b0..16d9553 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -811,6 +811,16 @@
  *	as an event to indicate changes for devices with wiphy-specific regdom
  *	management.
  *
+ * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
+ *	%NL80211_ATTR_WDEV identifier. It must have been created with
+ *	%NL80211_CMD_NEW_INTERFACE previously. After it has been started, the
+ *	NAN interface will create or join a cluster. This command must have a
+ *	valid %NL80211_ATTR_NAN_MASTER_PREF attribute and optional
+ *	%NL80211_ATTR_NAN_CLUSTER_ID and %NL80211_ATTR_NAN_DUAL attributes.
+ *	After this command NAN functions can be added.
+ * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
+ *	its %NL80211_ATTR_WDEV identifier.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -997,6 +1007,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_WIPHY_REG_CHANGE,
 
+	NL80211_CMD_START_NAN,
+	NL80211_CMD_STOP_NAN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1761,6 +1774,15 @@ enum nl80211_commands {
  * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
  *      is operating in an indoor environment.
  *
+ * @NL80211_ATTR_NAN_MASTER_PREF: the master preference to be used by
+ *	&NL80211_CMD_START_NAN. Its type is u8 and it can't be 0, 1 or 255.
+ * @NL80211_ATTR_NAN_CLUSTER_ID: Optional NAN cluster id to be used for a new
+ *	cluster. If not provided, the device will generate a cluster id. This
+ *	attribute is used with &NL80211_CMD_START_NAN.
+ * @NL80211_ATTR_NAN_DUAL: Optional NaN dual band operation config
+ *	(0: device default, 1: 2.4Ghz, 2: Dual). If not provided, the device
+ *	will decide. This attribute is used with &NL80211_CMD_START_NAN.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2130,6 +2152,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_REG_INDOOR,
 
+	NL80211_ATTR_NAN_MASTER_PREF,
+	NL80211_ATTR_NAN_CLUSTER_ID,
+	NL80211_ATTR_NAN_DUAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2208,6 +2234,7 @@ enum nl80211_attrs {
  *	commands to create and destroy one
  * @NL80211_IF_TYPE_OCB: Outside Context of a BSS
  *	This mode corresponds to the MIB variable dot11OCBActivated=true
+ * @NL80211_IFTYPE_NAN: NAN device interface type (not a netdev)
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -2228,6 +2255,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_P2P_GO,
 	NL80211_IFTYPE_P2P_DEVICE,
 	NL80211_IFTYPE_OCB,
+	NL80211_IFTYPE_NAN,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 390eabf..326fe0e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -235,6 +235,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2015,6 +2016,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		     !(req->flags & NL80211_SCAN_FLAG_AP)))
 			return -EOPNOTSUPP;
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3387,6 +3389,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_IFTYPE_P2P_DEVICE:
 		need_offchan = true;
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 1d1b9b7..7fdc118 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -274,6 +274,7 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 				    ieee80211_get_max_required_bw(sdata));
 			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			continue;
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_WDS:
@@ -716,6 +717,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			continue;
 		case NL80211_IFTYPE_STATION:
 			if (!sdata->u.mgd.associated)
@@ -979,6 +981,7 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NUM_NL80211_IFTYPES:
+	case NL80211_IFTYPE_NAN:
 		WARN_ON(1);
 		break;
 	}
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 42d7f0f..b725f1e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -539,6 +539,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_OCB:
+	case NL80211_IFTYPE_NAN:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -654,6 +655,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			break;
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			break;
 		default:
 			/* not reached */
@@ -939,6 +941,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* relies on synchronize_rcu() below */
 		RCU_INIT_POINTER(local->p2p_sdata, NULL);
 		/* fall through */
+	case NL80211_IFTYPE_NAN:
 	default:
 		cancel_work_sync(&sdata->work);
 		/*
@@ -1431,6 +1434,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5bc0b88..abdfba3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3376,6 +3376,9 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		       ieee80211_is_probe_req(hdr->frame_control) ||
 		       ieee80211_is_probe_resp(hdr->frame_control) ||
 		       ieee80211_is_beacon(hdr->frame_control);
+	case NL80211_IFTYPE_NAN:
+		/* Currently no frames on NAN interface are allowed */
+		return false;
 	default:
 		break;
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9cabf07..8f560cc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1940,6 +1940,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			/* nothing to do */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 59cabc9..723316f 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -372,6 +372,7 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
@@ -945,6 +946,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		/* these interface types don't really have a channel */
 		return;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3893409..1e83790 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -223,6 +224,23 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	}
 }
 
+void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
+		       struct wireless_dev *wdev)
+{
+	ASSERT_RTNL();
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_NAN))
+		return;
+
+	if (!wdev->nan_started)
+		return;
+
+	rdev_stop_nan(rdev, wdev);
+	wdev->nan_started = false;
+
+	rdev->opencount--;
+}
+
 void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -240,6 +258,9 @@ void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy)
 		case NL80211_IFTYPE_P2P_DEVICE:
 			cfg80211_stop_p2p_device(rdev, wdev);
 			break;
+		case NL80211_IFTYPE_NAN:
+			cfg80211_stop_nan(rdev, wdev);
+			break;
 		default:
 			break;
 		}
@@ -522,6 +543,11 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				    c->limits[j].max > 1))
 				return -EINVAL;
 
+			/* Only a single NAN can be allowed */
+			if (WARN_ON(types & BIT(NL80211_IFTYPE_NAN) &&
+				    c->limits[j].max > 1))
+				return -EINVAL;
+
 			cnt += c->limits[j].max;
 			/*
 			 * Don't advertise an unsupported type
@@ -564,6 +590,10 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->tdls_cancel_channel_switch)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN)) &&
+		    (!rdev->ops->start_nan || !rdev->ops->stop_nan)))
+		return -EINVAL;
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
@@ -574,6 +604,7 @@ int wiphy_register(struct wiphy *wiphy)
 				       BIT(NL80211_IFTYPE_P2P_GO) |
 				       BIT(NL80211_IFTYPE_ADHOC) |
 				       BIT(NL80211_IFTYPE_P2P_DEVICE) |
+				       BIT(NL80211_IFTYPE_NAN) |
 				       BIT(NL80211_IFTYPE_AP_VLAN) |
 				       BIT(NL80211_IFTYPE_MONITOR)))
 		wiphy->regulatory_flags |= REGULATORY_IGNORE_STALE_KICKOFF;
@@ -862,6 +893,9 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		cfg80211_mlme_purge_registrations(wdev);
 		cfg80211_stop_p2p_device(rdev, wdev);
 		break;
+	case NL80211_IFTYPE_NAN:
+		cfg80211_stop_nan(rdev, wdev);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -925,6 +959,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		/* must be handled by mac80211/driver, has no APIs */
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		/* cannot happen, has no netdev */
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b9d5bc8..9745952 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -482,6 +482,9 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 
+void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
+		       struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index fb44fa3..c466f90 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -634,6 +634,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			 * fall through, P2P device only supports
 			 * public action frames
 			 */
+		case NL80211_IFTYPE_NAN:
 		default:
 			err = -EOPNOTSUPP;
 			break;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 50cd770..51bfeb0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -401,6 +401,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
+	[NL80211_ATTR_NAN_CLUSTER_ID] = { .type = NLA_U16 },
+	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -894,6 +897,7 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_WDS:
 	case NUM_NL80211_IFTYPES:
@@ -2650,7 +2654,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	    !(rdev->wiphy.interface_modes & (1 << type)))
 		return -EOPNOTSUPP;
 
-	if ((type == NL80211_IFTYPE_P2P_DEVICE ||
+	if ((type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN ||
 	     rdev->wiphy.features & NL80211_FEATURE_MAC_ON_CREATE) &&
 	    info->attrs[NL80211_ATTR_MAC]) {
 		nla_memcpy(params.macaddr, info->attrs[NL80211_ATTR_MAC],
@@ -2706,9 +2710,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		       wdev->mesh_id_up_len);
 		wdev_unlock(wdev);
 		break;
+	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/*
-		 * P2P Device doesn't have a netdev, so doesn't go
+		 * P2P Device and NAN do not have a netdev, so don't go
 		 * through the netdev notifier and must be added here
 		 */
 		mutex_init(&wdev->mtx);
@@ -5764,6 +5769,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	wiphy = &rdev->wiphy;
 
+	if (wdev->iftype == NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
 	if (!rdev->ops->scan)
 		return -EOPNOTSUPP;
 
@@ -8310,6 +8318,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -8355,6 +8364,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -8471,6 +8481,7 @@ static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *in
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -9792,6 +9803,63 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct cfg80211_nan_conf conf = {};
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (wdev->nan_started)
+		return -EEXIST;
+
+	if (rfkill_blocked(rdev->rfkill))
+		return -ERFKILL;
+
+	if (!info->attrs[NL80211_ATTR_NAN_MASTER_PREF])
+		return -EINVAL;
+
+	conf.master_pref =
+		nla_get_u8(info->attrs[NL80211_ATTR_NAN_MASTER_PREF]);
+	if (conf.master_pref <= 1 || conf.master_pref == 255)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_NAN_CLUSTER_ID])
+		conf.cluster_id =
+			nla_get_u16(info->attrs[NL80211_ATTR_NAN_CLUSTER_ID]);
+
+	if (info->attrs[NL80211_ATTR_NAN_DUAL]) {
+		u8 dual = nla_get_u8(info->attrs[NL80211_ATTR_NAN_DUAL]);
+		if (dual > 2)
+			return -EINVAL;
+	}
+
+	err = rdev_start_nan(rdev, wdev, &conf);
+	if (err)
+		return err;
+
+	wdev->nan_started = true;
+	rdev->opencount++;
+
+	return 0;
+}
+
+static int nl80211_stop_nan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	cfg80211_stop_nan(rdev, wdev);
+
+	return 0;
+}
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
@@ -10493,7 +10561,14 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 
 			dev_hold(dev);
 		} else if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP) {
-			if (!wdev->p2p_started) {
+			if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
+			    !wdev->p2p_started) {
+				if (rtnl)
+					rtnl_unlock();
+				return -ENETDOWN;
+			}
+			if (wdev->iftype == NL80211_IFTYPE_NAN &&
+			    !wdev->nan_started) {
 				if (rtnl)
 					rtnl_unlock();
 				return -ENETDOWN;
@@ -11117,6 +11192,22 @@ static const struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_START_NAN,
+		.doit = nl80211_start_nan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_NAN,
+		.doit = nl80211_stop_nan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_SET_MCAST_RATE,
 		.doit = nl80211_set_mcast_rate,
 		.policy = nl80211_policy,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index c23516d..b0eb221 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -879,6 +879,26 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int rdev_start_nan(struct cfg80211_registered_device *rdev,
+				 struct wireless_dev *wdev,
+				 struct cfg80211_nan_conf *conf)
+{
+	int ret;
+
+	trace_rdev_start_nan(&rdev->wiphy, wdev, conf);
+	ret = rdev->ops->start_nan(&rdev->wiphy, wdev, conf);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void rdev_stop_nan(struct cfg80211_registered_device *rdev,
+				 struct wireless_dev *wdev)
+{
+	trace_rdev_stop_nan(&rdev->wiphy, wdev);
+	rdev->ops->stop_nan(&rdev->wiphy, wdev);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index a808279..1e1fa34 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1849,6 +1849,35 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_p2p_device,
 	TP_ARGS(wiphy, wdev)
 );
 
+TRACE_EVENT(rdev_start_nan,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_nan_conf *conf),
+	TP_ARGS(wiphy, wdev, conf),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u8, master_pref)
+		__field(u16, cluster_id)
+		__field(u8, dual);
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->master_pref = conf->master_pref;
+		__entry->cluster_id = conf->cluster_id;
+		__entry->dual = conf->dual;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
+		  ", master preference: %u, cluster_id: %04x, dual: %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref,
+		  __entry->cluster_id, __entry->dual)
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_nan,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
diff --git a/net/wireless/util.c b/net/wireless/util.c
index baf7218..8026c54 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -930,8 +930,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	if (otype == NL80211_IFTYPE_AP_VLAN)
 		return -EOPNOTSUPP;
 
-	/* cannot change into P2P device type */
-	if (ntype == NL80211_IFTYPE_P2P_DEVICE)
+	/* cannot change into P2P device or nan */
+	if (ntype == NL80211_IFTYPE_P2P_DEVICE ||
+	    ntype == NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
 	if (!rdev->ops->change_virtual_intf ||
@@ -1010,6 +1011,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			/* not happening */
 			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			WARN_ON(1);
 			break;
 		}
@@ -1681,6 +1683,9 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
 			if (!wdev_iter->p2p_started)
 				continue;
+		} else if (wdev_iter->iftype == NL80211_IFTYPE_NAN) {
+			if (!wdev_iter->nan_started)
+				continue;
 		} else if (wdev_iter->netdev) {
 			if (!netif_running(wdev_iter->netdev))
 				continue;
-- 
1.8.3

