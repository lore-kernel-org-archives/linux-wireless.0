Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbbC3OO1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:14:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 1/5] cfg80211: add start / stop NAN commands
Date: Mon, 30 Mar 2015 17:14:16 +0300
Message-Id: <1427724860-1992-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150330_161432_124835_E6689A26)
In-Reply-To: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user space to add / remove a NAN interface.
A NAN interface is like P2P device in a few aspects: it
doesn't have a netdev associated to it.
Add the new interface type and prevent operations that
can't be executed on NAN interface like scan.
The only parameter we need to start a cluster is the master
preference. The higher it is, the more likely it is that
the device will be master in its cluster.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       |  9 ++++-
 include/uapi/linux/nl80211.h | 19 ++++++++++
 net/mac80211/cfg.c           |  3 ++
 net/mac80211/chan.c          |  3 ++
 net/mac80211/iface.c         |  4 ++
 net/mac80211/util.c          |  1 +
 net/wireless/chan.c          |  2 +
 net/wireless/core.c          | 34 +++++++++++++++++
 net/wireless/core.h          |  3 ++
 net/wireless/mlme.c          |  1 +
 net/wireless/nl80211.c       | 87 ++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/rdev-ops.h      | 19 ++++++++++
 net/wireless/trace.h         | 23 ++++++++++++
 net/wireless/util.c          |  9 ++++-
 14 files changed, 211 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cb20bbb..5e9a45d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2365,6 +2365,9 @@ struct cfg80211_qos_map {
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
  *
+ * @start_nan: Start the NAN interface.
+ * @stop_nan: Stop the NAN interface.
+ *
  * @set_mac_acl: Sets MAC address control list in AP and P2P GO mode.
  *	Parameters include ACL policy, an array of MAC address of stations
  *	and the number of MAC addresses. If there is already a list in driver
@@ -2682,6 +2685,9 @@ struct cfg80211_ops {
 	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      const u8 *addr);
+	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			     u8 master_pref);
+	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev *wdev);
 };
 
 /*
@@ -3390,6 +3396,7 @@ struct cfg80211_cached_keys;
  *	beacons, 0 when not valid
  * @address: The address for this device, valid only if @netdev is %NULL
  * @p2p_started: true if this is a P2P Device that has been started
+ * @nan_started: true if this is a NAN interface that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
  * @cac_time_ms: CAC time in ms
@@ -3420,7 +3427,7 @@ struct wireless_dev {
 
 	struct mutex mtx;
 
-	bool use_4addr, p2p_started;
+	bool use_4addr, p2p_started, nan_started;
 
 	u8 address[ETH_ALEN] __aligned(sizeof(u16));
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9c64d81..b9e1758 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -798,6 +798,15 @@
  *	as an event to indicate changes for devices with wiphy-specific regdom
  *	management.
  *
+ * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
+ *	%NL80211_ATTR_WDEV identifier. It must have been created with
+ *	%NL80211_CMD_NEW_INTERFACE previously. After it has been started, the
+ *	NAN interface will create or join a cluster. This command must have a
+ *	non-zero %NL80211_ATTR_NAN_MASTER_PREF attribute. After this command,
+ *	NAN functions can be added.
+ * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
+ *	its %NL80211_ATTR_WDEV identifier.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -984,6 +993,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_WIPHY_REG_CHANGE,
 
+	NL80211_CMD_START_NAN,
+	NL80211_CMD_STOP_NAN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1742,6 +1754,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
  *	WoWLAN net-detect scan) is started, u32 in seconds.
  *
+ * @NL80211_ATTR_NAN_MASTER_PREF: the master preference to be be used by
+ *	&NL80211_CMD_START_NAN. Its type is u8 and it can't be 0, 1 or 255.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2108,6 +2123,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_NETNS_FD,
 
 	NL80211_ATTR_SCHED_SCAN_DELAY,
+
+	NL80211_ATTR_NAN_MASTER_PREF,
 	
 	NL80211_ATTR_REG_INDOOR,
 
@@ -2189,6 +2206,7 @@ enum nl80211_attrs {
  *	commands to create and destroy one
  * @NL80211_IF_TYPE_OCB: Outside Context of a BSS
  *	This mode corresponds to the MIB variable dot11OCBActivated=true
+ * @NL80211_IFTYPE_NAN: NAN device interface type (not a netdev)
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -2209,6 +2227,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_P2P_GO,
 	NL80211_IFTYPE_P2P_DEVICE,
 	NL80211_IFTYPE_OCB,
+	NL80211_IFTYPE_NAN,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5e24419..b37092f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -231,6 +231,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2003,6 +2004,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		     !(req->flags & NL80211_SCAN_FLAG_AP)))
 			return -EOPNOTSUPP;
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3378,6 +3380,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_IFTYPE_P2P_DEVICE:
 		need_offchan = true;
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 35b11e1..794ccc6 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -265,6 +265,7 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 			width = ieee80211_get_max_required_bw(sdata);
 			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			continue;
 		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_ADHOC:
@@ -691,6 +692,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			continue;
 		case NL80211_IFTYPE_STATION:
 			if (!sdata->u.mgd.associated)
@@ -954,6 +956,7 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NUM_NL80211_IFTYPES:
+	case NL80211_IFTYPE_NAN:
 		WARN_ON(1);
 		break;
 	}
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 05b7920..e033af0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -533,6 +533,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_OCB:
+	case NL80211_IFTYPE_NAN:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -648,6 +649,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			break;
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			break;
 		default:
 			/* not reached */
@@ -937,6 +939,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* relies on synchronize_rcu() below */
 		RCU_INIT_POINTER(local->p2p_sdata, NULL);
 		/* fall through */
+	case NL80211_IFTYPE_NAN:
 	default:
 		cancel_work_sync(&sdata->work);
 		/*
@@ -1416,6 +1419,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3278867..11d515f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1953,6 +1953,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			/* nothing to do */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a74ce38..87db715 100644
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
@@ -922,6 +923,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		/* these interface types don't really have a channel */
 		return;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2e7ddb1..1a1fae0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -229,6 +229,23 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
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
@@ -246,6 +263,9 @@ void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy)
 		case NL80211_IFTYPE_P2P_DEVICE:
 			cfg80211_stop_p2p_device(rdev, wdev);
 			break;
+		case NL80211_IFTYPE_NAN:
+			cfg80211_stop_nan(rdev, wdev);
+			break;
 		default:
 			break;
 		}
@@ -532,6 +552,11 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
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
@@ -574,6 +599,10 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->tdls_cancel_channel_switch)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN)) &&
+		    (!rdev->ops->start_nan || !rdev->ops->stop_nan)))
+		return -EINVAL;
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
@@ -584,6 +613,7 @@ int wiphy_register(struct wiphy *wiphy)
 				       BIT(NL80211_IFTYPE_P2P_GO) |
 				       BIT(NL80211_IFTYPE_ADHOC) |
 				       BIT(NL80211_IFTYPE_P2P_DEVICE) |
+				       BIT(NL80211_IFTYPE_NAN) |
 				       BIT(NL80211_IFTYPE_AP_VLAN) |
 				       BIT(NL80211_IFTYPE_MONITOR)))
 		wiphy->regulatory_flags |= REGULATORY_IGNORE_STALE_KICKOFF;
@@ -873,6 +903,9 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		cfg80211_android_destroy_p2p_device(wdev);
 #endif
 		break;
+	case NL80211_IFTYPE_NAN:
+		cfg80211_stop_nan(rdev, wdev);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -936,6 +969,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		/* must be handled by mac80211/driver, has no APIs */
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		/* cannot happen, has no netdev */
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index d6d6530..0d64fa6 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -476,6 +476,9 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 
+void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
+		       struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CPTCFG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 9b18d93..3f8068d 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -587,6 +587,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			 * fall through, P2P device only supports
 			 * public action frames
 			 */
+		case NL80211_IFTYPE_NAN:
 		default:
 			err = -EOPNOTSUPP;
 			break;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8d04d3e..6992694 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -407,6 +407,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -900,6 +901,7 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_WDS:
 	case NUM_NL80211_IFTYPES:
@@ -2654,7 +2656,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	    !(rdev->wiphy.interface_modes & (1 << type)))
 		return -EOPNOTSUPP;
 
-	if ((type == NL80211_IFTYPE_P2P_DEVICE ||
+	if ((type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN ||
 	     rdev->wiphy.features & NL80211_FEATURE_MAC_ON_CREATE) &&
 	    info->attrs[NL80211_ATTR_MAC]) {
 		nla_memcpy(params.macaddr, info->attrs[NL80211_ATTR_MAC],
@@ -2709,9 +2711,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
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
@@ -2725,6 +2728,9 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		rdev->devlist_generation++;
 
 #ifdef CPTCFG_CFG80211_ANDROID_P2P_HACK
+		if (type == NL80211_IFTYPE_NAN)
+			break;
+
 		err = cfg80211_android_create_p2p_device(wdev,
 				nla_data(info->attrs[NL80211_ATTR_IFNAME]));
 		if (err) {
@@ -5759,6 +5765,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	wiphy = &rdev->wiphy;
 
+	if (wdev->iftype == NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
 	if (!rdev->ops->scan)
 		return -EOPNOTSUPP;
 
@@ -8289,6 +8298,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -8335,6 +8345,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -8452,6 +8463,7 @@ static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *in
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -9783,6 +9795,52 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	u8 master_pref;
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
+	master_pref = nla_get_u8(info->attrs[NL80211_ATTR_NAN_MASTER_PREF]);
+	if (master_pref <= 1 || master_pref == 255)
+		return -EINVAL;
+
+	err = rdev_start_nan(rdev, wdev, master_pref);
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
@@ -10300,7 +10358,14 @@ static int nl80211_pre_doit(__genl_const struct genl_ops *ops, struct sk_buff *s
 
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
@@ -10924,6 +10989,22 @@ static __genl_const struct genl_ops nl80211_ops[] = {
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
index 0336264..593fbb7 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -876,6 +876,25 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int rdev_start_nan(struct cfg80211_registered_device *rdev,
+				 struct wireless_dev *wdev, u8 master_pref)
+{
+	int ret;
+
+	trace_rdev_start_nan(&rdev->wiphy, wdev, master_pref);
+	ret = rdev->ops->start_nan(&rdev->wiphy, wdev, master_pref);
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
index 4dedf11..3718563 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1854,6 +1854,29 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_p2p_device,
 	TP_ARGS(wiphy, wdev)
 );
 
+TRACE_EVENT(rdev_start_nan,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u8 master_pref),
+	TP_ARGS(wiphy, wdev, master_pref),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u8, master_pref)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->master_pref = master_pref;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", master preference: %u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref)
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
index b25aa65..3990c8b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -929,8 +929,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	if (otype == NL80211_IFTYPE_AP_VLAN)
 		return -EOPNOTSUPP;
 
-	/* cannot change into P2P device type */
-	if (ntype == NL80211_IFTYPE_P2P_DEVICE)
+	/* cannot change into P2P device or nan */
+	if (ntype == NL80211_IFTYPE_P2P_DEVICE ||
+	    ntype == NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
 	if (!rdev->ops->change_virtual_intf ||
@@ -1009,6 +1010,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			/* not happening */
 			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			WARN_ON(1);
 			break;
 		}
@@ -1510,6 +1512,9 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
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
1.9.1

