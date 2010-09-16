Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0IPNAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 09:00:31 -0400
Message-Id: <20100916125927.163519598@sipsolutions.net>
Date: Thu, 16 Sep 2010 14:58:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: add p2p device type support
References: <20100916125821.369545798@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a driver advertises p2p device support,
mac80211 will handle it, but internally it will
rewrite the interface type to STA/AP rather than
P2P-STA/GO since otherwise a lot of paths need
to be touched that are otherwise identical. A
p2p boolean tells drivers whether or not a given
interface will be used for p2p or not.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   15 +++++++++++----
 include/net/mac80211.h                |   27 ++++++++++++++++++++++++++-
 net/mac80211/cfg.c                    |   25 ++++++++++++++++++-------
 net/mac80211/driver-ops.h             |    6 +++---
 net/mac80211/driver-trace.h           |   21 +++++++++++++--------
 net/mac80211/iface.c                  |   29 ++++++++++++++++++++++++++---
 net/mac80211/main.c                   |   15 +++++++++++++++
 net/mac80211/rx.c                     |    4 +---
 net/mac80211/util.c                   |   18 ++++--------------
 9 files changed, 117 insertions(+), 43 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-09-16 14:47:02.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-09-16 14:47:16.000000000 +0200
@@ -188,6 +188,8 @@ static int ieee80211_do_open(struct net_
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
 		/* cannot happen */
 		WARN_ON(1);
 		break;
@@ -843,6 +845,7 @@ static void ieee80211_setup_sdata(struct
 
 	/* and set some type-dependent values */
 	sdata->vif.type = type;
+	sdata->vif.p2p = false;
 	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
 	sdata->wdev.iftype = type;
 
@@ -856,10 +859,20 @@ static void ieee80211_setup_sdata(struct
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 
 	switch (type) {
+	case NL80211_IFTYPE_P2P_GO:
+		type = NL80211_IFTYPE_AP;
+		sdata->vif.type = type;
+		sdata->vif.p2p = true;
+		/* fall through */
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		type = NL80211_IFTYPE_STATION;
+		sdata->vif.type = type;
+		sdata->vif.p2p = true;
+		/* fall through */
 	case NL80211_IFTYPE_STATION:
 		ieee80211_sta_setup_sdata(sdata);
 		break;
@@ -893,6 +906,8 @@ static int ieee80211_runtime_change_ifty
 {
 	struct ieee80211_local *local = sdata->local;
 	int ret, err;
+	enum nl80211_iftype internal_type = type;
+	bool p2p = false;
 
 	ASSERT_RTNL();
 
@@ -925,11 +940,19 @@ static int ieee80211_runtime_change_ifty
 		 * code isn't prepared to handle).
 		 */
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		p2p = true;
+		internal_type = NL80211_IFTYPE_STATION;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		p2p = true;
+		internal_type = NL80211_IFTYPE_AP;
+		break;
 	default:
 		return -EBUSY;
 	}
 
-	ret = ieee80211_check_concurrent_iface(sdata, type);
+	ret = ieee80211_check_concurrent_iface(sdata, internal_type);
 	if (ret)
 		return ret;
 
@@ -937,7 +960,7 @@ static int ieee80211_runtime_change_ifty
 
 	ieee80211_teardown_sdata(sdata->dev);
 
-	ret = drv_change_interface(local, sdata, type);
+	ret = drv_change_interface(local, sdata, internal_type, p2p);
 	if (ret)
 		type = sdata->vif.type;
 
@@ -956,7 +979,7 @@ int ieee80211_if_change_type(struct ieee
 
 	ASSERT_RTNL();
 
-	if (type == sdata->vif.type)
+	if (type == ieee80211_vif_type_p2p(&sdata->vif))
 		return 0;
 
 	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
--- wireless-testing.orig/net/mac80211/rx.c	2010-09-16 14:47:06.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-09-16 14:47:16.000000000 +0200
@@ -2588,9 +2588,7 @@ static int prepare_for_handlers(struct i
 		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
 		break;
-	case NL80211_IFTYPE_MONITOR:
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NUM_NL80211_IFTYPES:
+	default:
 		/* should never get here */
 		WARN_ON(1);
 		break;
--- wireless-testing.orig/net/mac80211/util.c	2010-09-16 14:47:02.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-09-16 14:47:16.000000000 +0200
@@ -474,16 +474,10 @@ void ieee80211_iterate_active_interfaces
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
-		case NUM_NL80211_IFTYPES:
-		case NL80211_IFTYPE_UNSPECIFIED:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_AP_VLAN:
 			continue;
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_WDS:
-		case NL80211_IFTYPE_MESH_POINT:
+		default:
 			break;
 		}
 		if (ieee80211_sdata_running(sdata))
@@ -508,16 +502,10 @@ void ieee80211_iterate_active_interfaces
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
-		case NUM_NL80211_IFTYPES:
-		case NL80211_IFTYPE_UNSPECIFIED:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_AP_VLAN:
 			continue;
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_WDS:
-		case NL80211_IFTYPE_MESH_POINT:
+		default:
 			break;
 		}
 		if (ieee80211_sdata_running(sdata))
@@ -1193,6 +1181,8 @@ int ieee80211_reconfig(struct ieee80211_
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NUM_NL80211_IFTYPES:
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
 			WARN_ON(1);
 			break;
 		}
--- wireless-testing.orig/net/mac80211/cfg.c	2010-09-16 14:47:06.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-09-16 14:47:16.000000000 +0200
@@ -1151,15 +1151,26 @@ static int ieee80211_scan(struct wiphy *
 			  struct net_device *dev,
 			  struct cfg80211_scan_request *req)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
-	    (sdata->vif.type != NL80211_IFTYPE_AP || sdata->u.ap.beacon))
+	switch (ieee80211_vif_type_p2p(&sdata->vif)) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		if (sdata->local->ops->hw_scan)
+			break;
+		/* FIXME: implement NoA while scanning in software */
+		return -EOPNOTSUPP;
+	case NL80211_IFTYPE_AP:
+		if (sdata->u.ap.beacon)
+			return -EOPNOTSUPP;
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
 	return ieee80211_request_scan(sdata, req);
 }
--- wireless-testing.orig/include/net/mac80211.h	2010-09-16 14:47:06.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-09-16 14:47:16.000000000 +0200
@@ -769,6 +769,8 @@ struct ieee80211_channel_switch {
  * @bss_conf: BSS configuration for this interface, either our own
  *	or the BSS we're associated to
  * @addr: address of this interface
+ * @p2p: indicates whether this AP or STA interface is a p2p
+ *	interface, i.e. a GO or p2p-sta respectively
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -776,6 +778,7 @@ struct ieee80211_vif {
 	enum nl80211_iftype type;
 	struct ieee80211_bss_conf bss_conf;
 	u8 addr[ETH_ALEN];
+	bool p2p;
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
@@ -1701,7 +1704,7 @@ struct ieee80211_ops {
 			     struct ieee80211_vif *vif);
 	int (*change_interface)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
-				enum nl80211_iftype new_type);
+				enum nl80211_iftype new_type, bool p2p);
 	void (*remove_interface)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif);
 	int (*config)(struct ieee80211_hw *hw, u32 changed);
@@ -2721,4 +2724,26 @@ conf_is_ht(struct ieee80211_conf *conf)
 	return conf->channel_type != NL80211_CHAN_NO_HT;
 }
 
+static inline enum nl80211_iftype
+ieee80211_iftype_p2p(enum nl80211_iftype type, bool p2p)
+{
+	if (p2p) {
+		switch (type) {
+		case NL80211_IFTYPE_STATION:
+			return NL80211_IFTYPE_P2P_CLIENT;
+		case NL80211_IFTYPE_AP:
+			return NL80211_IFTYPE_P2P_GO;
+		default:
+			break;
+		}
+	}
+	return type;
+}
+
+static inline enum nl80211_iftype
+ieee80211_vif_type_p2p(struct ieee80211_vif *vif)
+{
+	return ieee80211_iftype_p2p(vif->type, vif->p2p);
+}
+
 #endif /* MAC80211_H */
--- wireless-testing.orig/net/mac80211/main.c	2010-09-16 14:47:02.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-09-16 14:47:16.000000000 +0200
@@ -459,6 +459,21 @@ ieee80211_default_mgmt_stypes[NUM_NL8021
 			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
 			BIT(IEEE80211_STYPE_ACTION >> 4),
 	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+	},
+	[NL80211_IFTYPE_P2P_GO] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+			BIT(IEEE80211_STYPE_ACTION >> 4),
+	},
 };
 
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-09-16 14:47:02.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.h	2010-09-16 14:47:16.000000000 +0200
@@ -25,12 +25,14 @@ static inline void trace_ ## name(proto)
 #define STA_PR_FMT	" sta:%pM"
 #define STA_PR_ARG	__entry->sta_addr
 
-#define VIF_ENTRY	__field(enum nl80211_iftype, vif_type) __field(void *, sdata) \
+#define VIF_ENTRY	__field(enum nl80211_iftype, vif_type) __field(void *, sdata)	\
+			__field(bool, p2p)						\
 			__string(vif_name, sdata->dev ? sdata->dev->name : "<nodev>")
-#define VIF_ASSIGN	__entry->vif_type = sdata->vif.type; __entry->sdata = sdata; \
+#define VIF_ASSIGN	__entry->vif_type = sdata->vif.type; __entry->sdata = sdata;	\
+			__entry->p2p = sdata->vif.p2p;					\
 			__assign_str(vif_name, sdata->dev ? sdata->dev->name : "<nodev>")
-#define VIF_PR_FMT	" vif:%s(%d)"
-#define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type
+#define VIF_PR_FMT	" vif:%s(%d%s)"
+#define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
 /*
  * Tracing for driver callbacks.
@@ -139,25 +141,28 @@ TRACE_EVENT(drv_add_interface,
 TRACE_EVENT(drv_change_interface,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 enum nl80211_iftype type),
+		 enum nl80211_iftype type, bool p2p),
 
-	TP_ARGS(local, sdata, type),
+	TP_ARGS(local, sdata, type, p2p),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
 		__field(u32, new_type)
+		__field(bool, new_p2p)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		__entry->new_type = type;
+		__entry->new_p2p = p2p;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT " new type:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->new_type
+		LOCAL_PR_FMT  VIF_PR_FMT " new type:%d%s",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->new_type,
+		__entry->new_p2p ? "/p2p" : ""
 	)
 );
 
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-09-16 14:47:02.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2010-09-16 14:47:16.000000000 +0200
@@ -56,14 +56,14 @@ static inline int drv_add_interface(stru
 
 static inline int drv_change_interface(struct ieee80211_local *local,
 				       struct ieee80211_sub_if_data *sdata,
-				       enum nl80211_iftype type)
+				       enum nl80211_iftype type, bool p2p)
 {
 	int ret;
 
 	might_sleep();
 
-	trace_drv_change_interface(local, sdata, type);
-	ret = local->ops->change_interface(&local->hw, &sdata->vif, type);
+	trace_drv_change_interface(local, sdata, type, p2p);
+	ret = local->ops->change_interface(&local->hw, &sdata->vif, type, p2p);
 	trace_drv_return_int(local, ret);
 	return ret;
 }
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-09-16 14:47:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-09-16 14:47:16.000000000 +0200
@@ -595,7 +595,8 @@ static int mac80211_hwsim_add_interface(
 					struct ieee80211_vif *vif)
 {
 	wiphy_debug(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
-		    __func__, vif->type, vif->addr);
+		    __func__, ieee80211_vif_type_p2p(vif),
+		    vif->addr);
 	hwsim_set_magic(vif);
 	return 0;
 }
@@ -603,11 +604,14 @@ static int mac80211_hwsim_add_interface(
 
 static int mac80211_hwsim_change_interface(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif,
-					   enum nl80211_iftype newtype)
+					   enum nl80211_iftype newtype,
+					   bool newp2p)
 {
+	newtype = ieee80211_iftype_p2p(newtype, newp2p);
 	wiphy_debug(hw->wiphy,
 		    "%s (old type=%d, new type=%d, mac_addr=%pM)\n",
-		    __func__, vif->type, newtype, vif->addr);
+		    __func__, ieee80211_vif_type_p2p(vif),
+		    newtype, vif->addr);
 	hwsim_check_magic(vif);
 
 	return 0;
@@ -617,7 +621,8 @@ static void mac80211_hwsim_remove_interf
 	struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	wiphy_debug(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
-		    __func__, vif->type, vif->addr);
+		    __func__, ieee80211_vif_type_p2p(vif),
+		    vif->addr);
 	hwsim_check_magic(vif);
 	hwsim_clear_magic(vif);
 }
@@ -1310,6 +1315,8 @@ static int __init init_mac80211_hwsim(vo
 		hw->wiphy->interface_modes =
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
 


