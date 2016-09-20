Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56484 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754953AbcITObe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 10:31:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ayala.beker@intel.com,
        andrei.otcheretianski@intel.com, arend.vanspriel@broadcom.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 20 Sep 2016 17:31:13 +0300
Message-Id: <20160920143121.28247-2-luca@coelho.fi> (sfid-20160920_163139_501990_EA35E306)
In-Reply-To: <20160920143121.28247-1-luca@coelho.fi>
References: <20160920143121.28247-1-luca@coelho.fi>
Subject: [PATCH v3 1/9] cfg80211: add start / stop NAN commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

This allows user space to start/stop NAN interface.
A NAN interface is like P2P device in a few aspects: it
doesn't have a netdev associated to it.
Add the new interface type and prevent operations that
can't be executed on NAN interface like scan.

Define several attributes that may be configured by user space
when starting NAN functionality (master preference and dual
band operation)

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 21 +++++++++-
 include/uapi/linux/nl80211.h | 47 +++++++++++++++++++++++
 net/mac80211/cfg.c           |  2 +
 net/mac80211/chan.c          |  3 ++
 net/mac80211/iface.c         |  4 ++
 net/mac80211/offchannel.c    |  1 +
 net/mac80211/rx.c            |  3 ++
 net/mac80211/util.c          |  1 +
 net/wireless/chan.c          |  2 +
 net/wireless/core.c          | 34 +++++++++++++++++
 net/wireless/core.h          |  3 ++
 net/wireless/mlme.c          |  1 +
 net/wireless/nl80211.c       | 91 ++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/rdev-ops.h      | 20 ++++++++++
 net/wireless/trace.h         | 27 +++++++++++++
 net/wireless/util.c          |  6 ++-
 16 files changed, 260 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e7f69..a3ea4cc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2293,6 +2293,19 @@ struct cfg80211_qos_map {
 };
 
 /**
+ * struct cfg80211_nan_conf - NAN configuration
+ *
+ * This struct defines NAN configuration parameters
+ *
+ * @master_pref: master preference (1 - 255)
+ * @dual: dual band operation mode, see &enum nl80211_nan_dual_band_conf
+ */
+struct cfg80211_nan_conf {
+	u8 master_pref;
+	u8 dual;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2580,6 +2593,8 @@ struct cfg80211_qos_map {
  *	and returning to the base channel for communication with the AP.
  * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
  *	peers must be on the base channel when the call completes.
+ * @start_nan: Start the NAN interface.
+ * @stop_nan: Stop the NAN interface.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2845,6 +2860,9 @@ struct cfg80211_ops {
 	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      const u8 *addr);
+	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			     struct cfg80211_nan_conf *conf);
+	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev *wdev);
 };
 
 /*
@@ -3602,6 +3620,7 @@ struct cfg80211_cached_keys;
  *	beacons, 0 when not valid
  * @address: The address for this device, valid only if @netdev is %NULL
  * @p2p_started: true if this is a P2P Device that has been started
+ * @nan_started: true if this is a NAN interface that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
  * @cac_time_ms: CAC time in ms
@@ -3633,7 +3652,7 @@ struct wireless_dev {
 
 	struct mutex mtx;
 
-	bool use_4addr, p2p_started;
+	bool use_4addr, p2p_started, nan_started;
 
 	u8 address[ETH_ALEN] __aligned(sizeof(u16));
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..a34eb18 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -838,6 +838,16 @@
  *	not running. The driver indicates the status of the scan through
  *	cfg80211_scan_done().
  *
+ * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
+ *	%NL80211_ATTR_WDEV interface. This interface must have been previously
+ *	created with %NL80211_CMD_NEW_INTERFACE. After it has been started, the
+ *	NAN interface will create or join a cluster. This command must have a
+ *	valid %NL80211_ATTR_NAN_MASTER_PREF attribute and optional
+ *	%NL80211_ATTR_NAN_DUAL attributes.
+ *	After this command NAN functions can be added.
+ * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
+ *	its %NL80211_ATTR_WDEV interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1026,6 +1036,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_ABORT_SCAN,
 
+	NL80211_CMD_START_NAN,
+	NL80211_CMD_STOP_NAN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1733,6 +1746,12 @@ enum nl80211_commands {
  *	regulatory indoor configuration would be owned by the netlink socket
  *	that configured the indoor setting, and the indoor operation would be
  *	cleared when the socket is closed.
+ *	If set during NAN interface creation, the interface will be destroyed
+ *	if the socket is closed just like any other interface. Moreover, only
+ *	the netlink socket that created the interface will be allowed to add
+ *	and remove functions. NAN notifications will be sent in unicast to that
+ *	socket. Without this attribute, any socket can add functions and the
+ *	notifications will be sent to the %NL80211_MCGRP_NAN multicast group.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
@@ -1867,6 +1886,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_MESH_PEER_AID: Association ID for the mesh peer (u16). This is
  *	used to pull the stored data for mesh peer in power save state.
  *
+ * @NL80211_ATTR_NAN_MASTER_PREF: the master preference to be used by
+ *	%NL80211_CMD_START_NAN. Its type is u8 and it can't be 0.
+ *	Also, values 1 and 255 are reserved for certification purposes and
+ *	should not be used during a normal device operation.
+ * @NL80211_ATTR_NAN_DUAL: NAN dual band operation config (see
+ *	&enum nl80211_nan_dual_band_conf). This attribute is used with
+ *	%NL80211_CMD_START_NAN.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2261,6 +2288,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MESH_PEER_AID,
 
+	NL80211_ATTR_NAN_MASTER_PREF,
+	NL80211_ATTR_NAN_DUAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2339,6 +2369,7 @@ enum nl80211_attrs {
  *	commands to create and destroy one
  * @NL80211_IF_TYPE_OCB: Outside Context of a BSS
  *	This mode corresponds to the MIB variable dot11OCBActivated=true
+ * @NL80211_IFTYPE_NAN: NAN device interface type (not a netdev)
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -2359,6 +2390,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_P2P_GO,
 	NL80211_IFTYPE_P2P_DEVICE,
 	NL80211_IFTYPE_OCB,
+	NL80211_IFTYPE_NAN,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
@@ -4855,4 +4887,19 @@ enum nl80211_bss_select_attr {
 	NL80211_BSS_SELECT_ATTR_MAX = __NL80211_BSS_SELECT_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_nan_dual_band_conf - NAN dual band configuration
+ *
+ * Defines the NAN dual band mode of operation
+ *
+ * @NL80211_NAN_BAND_DEFAULT: device default mode
+ * @NL80211_NAN_BAND_2GHZ: 2.4GHz mode
+ * @NL80211_NAN_BAND_5GHZ: 5GHz mode
+  */
+enum nl80211_nan_dual_band_conf {
+	NL80211_NAN_BAND_DEFAULT	= 1 << 0,
+	NL80211_NAN_BAND_2GHZ		= 1 << 1,
+	NL80211_NAN_BAND_5GHZ		= 1 << 2,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e29ff57..a74027f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -257,6 +257,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2036,6 +2037,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		     !(req->flags & NL80211_SCAN_FLAG_AP)))
 			return -EOPNOTSUPP;
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 74142d0..d035801 100644
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
@@ -718,6 +719,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			continue;
 		case NL80211_IFTYPE_STATION:
 			if (!sdata->u.mgd.associated)
@@ -980,6 +982,7 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 	case NUM_NL80211_IFTYPES:
 		WARN_ON(1);
 		break;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b0abddc7..e694ca2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -545,6 +545,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_OCB:
+	case NL80211_IFTYPE_NAN:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -660,6 +661,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			break;
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			break;
 		default:
 			/* not reached */
@@ -948,6 +950,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* relies on synchronize_rcu() below */
 		RCU_INIT_POINTER(local->p2p_sdata, NULL);
 		/* fall through */
+	case NL80211_IFTYPE_NAN:
 	default:
 		cancel_work_sync(&sdata->work);
 		/*
@@ -1457,6 +1460,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 55a9c5b..75d5c96 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -838,6 +838,7 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_IFTYPE_P2P_DEVICE:
 		need_offchan = true;
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e796060..c9489a8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3586,6 +3586,9 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
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
index b6865d8..2c78541 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1975,6 +1975,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			/* nothing to do */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 0f50622..5497d022 100644
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
@@ -946,6 +947,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		/* these interface types don't really have a channel */
 		return;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4911cd9..0139872 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -225,6 +225,23 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
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
@@ -242,6 +259,9 @@ void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy)
 		case NL80211_IFTYPE_P2P_DEVICE:
 			cfg80211_stop_p2p_device(rdev, wdev);
 			break;
+		case NL80211_IFTYPE_NAN:
+			cfg80211_stop_nan(rdev, wdev);
+			break;
 		default:
 			break;
 		}
@@ -537,6 +557,11 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
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
@@ -579,6 +604,10 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->tdls_cancel_channel_switch)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN)) &&
+		    (!rdev->ops->start_nan || !rdev->ops->stop_nan)))
+		return -EINVAL;
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
@@ -589,6 +618,7 @@ int wiphy_register(struct wiphy *wiphy)
 				       BIT(NL80211_IFTYPE_P2P_GO) |
 				       BIT(NL80211_IFTYPE_ADHOC) |
 				       BIT(NL80211_IFTYPE_P2P_DEVICE) |
+				       BIT(NL80211_IFTYPE_NAN) |
 				       BIT(NL80211_IFTYPE_AP_VLAN) |
 				       BIT(NL80211_IFTYPE_MONITOR)))
 		wiphy->regulatory_flags |= REGULATORY_IGNORE_STALE_KICKOFF;
@@ -916,6 +946,9 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		cfg80211_mlme_purge_registrations(wdev);
 		cfg80211_stop_p2p_device(rdev, wdev);
 		break;
+	case NL80211_IFTYPE_NAN:
+		cfg80211_stop_nan(rdev, wdev);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -979,6 +1012,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		/* must be handled by mac80211/driver, has no APIs */
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		/* cannot happen, has no netdev */
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5555e3c..9cdca5e 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -488,6 +488,9 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 
+void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
+		       struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index d6abb07..cbb48e2 100644
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
index 887c4c1..0f3bef6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -409,6 +409,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		.len = VHT_MUMIMO_GROUPS_DATA_LEN
 	},
 	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
+	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
+	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -934,6 +936,7 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_WDS:
 	case NUM_NL80211_IFTYPES:
@@ -2819,7 +2822,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	    !(rdev->wiphy.interface_modes & (1 << type)))
 		return -EOPNOTSUPP;
 
-	if ((type == NL80211_IFTYPE_P2P_DEVICE ||
+	if ((type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN ||
 	     rdev->wiphy.features & NL80211_FEATURE_MAC_ON_CREATE) &&
 	    info->attrs[NL80211_ATTR_MAC]) {
 		nla_memcpy(params.macaddr, info->attrs[NL80211_ATTR_MAC],
@@ -2875,9 +2878,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
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
@@ -6138,6 +6142,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	wiphy = &rdev->wiphy;
 
+	if (wdev->iftype == NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
 	if (!rdev->ops->scan)
 		return -EOPNOTSUPP;
 
@@ -8898,6 +8905,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -8943,6 +8951,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -9059,6 +9068,7 @@ static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *in
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
+	case NL80211_IFTYPE_NAN:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -10414,6 +10424,58 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
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
+	if (!info->attrs[NL80211_ATTR_NAN_DUAL])
+		return -EINVAL;
+
+	conf.master_pref =
+		nla_get_u8(info->attrs[NL80211_ATTR_NAN_MASTER_PREF]);
+	if (!conf.master_pref)
+		return -EINVAL;
+
+	conf.dual = nla_get_u8(info->attrs[NL80211_ATTR_NAN_DUAL]);
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
@@ -11115,7 +11177,14 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 
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
@@ -11749,6 +11818,22 @@ static const struct genl_ops nl80211_ops[] = {
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
index 85ff30b..afb68a8 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -887,6 +887,26 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
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
index 72b5255..5f3370f 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1889,6 +1889,33 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_p2p_device,
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
+		__field(u8, dual);
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->master_pref = conf->master_pref;
+		__entry->dual = conf->dual;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
+		  ", master preference: %u, dual: %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref,
+		  __entry->dual)
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
index 9e6e2aa..91868e0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1008,8 +1008,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	if (otype == NL80211_IFTYPE_AP_VLAN)
 		return -EOPNOTSUPP;
 
-	/* cannot change into P2P device type */
-	if (ntype == NL80211_IFTYPE_P2P_DEVICE)
+	/* cannot change into P2P device or NAN */
+	if (ntype == NL80211_IFTYPE_P2P_DEVICE ||
+	    ntype == NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
 	if (!rdev->ops->change_virtual_intf ||
@@ -1088,6 +1089,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			/* not happening */
 			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_NAN:
 			WARN_ON(1);
 			break;
 		}
-- 
2.9.3
