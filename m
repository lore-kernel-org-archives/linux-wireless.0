Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1LNLYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 06:24:01 -0500
Message-Id: <20111214112313.145368007@sipsolutions.net> (sfid-20111214_122409_221703_6DE1EC2D)
Date: Wed, 14 Dec 2011 12:20:30 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] mac80211: refactor station state transitions
References: <20111214112026.409514167@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Station entries can have various states, the most
important ones being auth, assoc and authorized.
This patch prepares us for telling the driver about
these states, we don't want to confuse drivers with
strange transitions, so with this we enforce that
they move in the right order between them (back and
forth); some transitions might happen before the
driver even knows about the station, but at least
runtime transitions will be ordered correctly.

As a consequence, IBSS and MESH stations will now
have the ASSOC flag set (so they can transition to
AUTHORIZED), and we can get rid of a special case
in TX processing.

When freeing a station, unwind the state so that
other parts of the code (or drivers later) can rely
on the transitions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c        |   76 ++++++++++++++++++++++++++++++++++++----------
 net/mac80211/ibss.c       |    5 ++-
 net/mac80211/iface.c      |    5 +--
 net/mac80211/mesh_plink.c |    7 +++-
 net/mac80211/mlme.c       |    6 +--
 net/mac80211/sta_info.c   |   65 +++++++++++++++++++++++++++++++++++----
 net/mac80211/sta_info.h   |   37 ++++++++++++++++++++++
 net/mac80211/tx.c         |    1 
 8 files changed, 172 insertions(+), 30 deletions(-)

--- a/net/mac80211/sta_info.c	2011-12-14 11:50:26.000000000 +0100
+++ b/net/mac80211/sta_info.c	2011-12-14 11:54:42.000000000 +0100
@@ -204,16 +204,17 @@ struct sta_info *sta_info_get_by_idx(str
 }
 
 /**
- * __sta_info_free - internal STA free helper
+ * sta_info_free - free STA
  *
  * @local: pointer to the global information
  * @sta: STA info to free
  *
  * This function must undo everything done by sta_info_alloc()
- * that may happen before sta_info_insert().
+ * that may happen before sta_info_insert(). It may only be
+ * called when sta_info_insert() has not been attempted (and
+ * if that fails, the station is freed anyway.)
  */
-static void __sta_info_free(struct ieee80211_local *local,
-			    struct sta_info *sta)
+void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 {
 	if (sta->rate_ctrl) {
 		rate_control_free_sta(sta);
@@ -598,7 +599,7 @@ int sta_info_insert_rcu(struct sta_info
 	return 0;
  out_free:
 	BUG_ON(!err);
-	__sta_info_free(local, sta);
+	sta_info_free(local, sta);
 	return err;
 }
 
@@ -904,6 +905,9 @@ static int __must_check __sta_info_destr
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
+	while (sta->sta_state > IEEE80211_STA_NONE)
+		sta_info_move_state(sta, sta->sta_state - 1);
+
 	if (sta->uploaded) {
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			sdata = container_of(sdata->bss,
@@ -949,7 +953,7 @@ static int __must_check __sta_info_destr
 	}
 #endif
 
-	__sta_info_free(local, sta);
+	sta_info_free(local, sta);
 
 	return 0;
 }
@@ -1513,3 +1517,52 @@ void ieee80211_sta_set_buffered(struct i
 	sta_info_recalc_tim(sta);
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
+
+int sta_info_move_state_checked(struct sta_info *sta,
+				enum ieee80211_sta_state new_state)
+{
+	might_sleep(); /* for driver notify later */
+
+	if (sta->sta_state == new_state)
+		return 0;
+
+	switch (new_state) {
+	case IEEE80211_STA_NONE:
+		if (sta->sta_state == IEEE80211_STA_AUTH)
+			clear_bit(WLAN_STA_AUTH, &sta->_flags);
+		else
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_AUTH:
+		if (sta->sta_state == IEEE80211_STA_NONE)
+			set_bit(WLAN_STA_AUTH, &sta->_flags);
+		else if (sta->sta_state == IEEE80211_STA_ASSOC)
+			clear_bit(WLAN_STA_ASSOC, &sta->_flags);
+		else
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_ASSOC:
+		if (sta->sta_state == IEEE80211_STA_AUTH)
+			set_bit(WLAN_STA_ASSOC, &sta->_flags);
+		else if (sta->sta_state == IEEE80211_STA_AUTHORIZED)
+			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
+		else
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_AUTHORIZED:
+		if (sta->sta_state == IEEE80211_STA_ASSOC)
+			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
+		else
+			return -EINVAL;
+		break;
+	default:
+		WARN(1, "invalid state %d", new_state);
+		return -EINVAL;
+	}
+
+	printk(KERN_DEBUG "%s: moving STA %pM to state %d\n",
+		sta->sdata->name, sta->sta.addr, new_state);
+	sta->sta_state = new_state;
+
+	return 0;
+}
--- a/net/mac80211/sta_info.h	2011-12-14 11:50:26.000000000 +0100
+++ b/net/mac80211/sta_info.h	2011-12-14 11:54:42.000000000 +0100
@@ -73,6 +73,14 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_4ADDR_EVENT,
 };
 
+enum ieee80211_sta_state {
+	/* NOTE: These need to be ordered correctly! */
+	IEEE80211_STA_NONE,
+	IEEE80211_STA_AUTH,
+	IEEE80211_STA_ASSOC,
+	IEEE80211_STA_AUTHORIZED,
+};
+
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
 #define HT_AGG_MAX_RETRIES		0x3
@@ -262,6 +270,7 @@ struct sta_ampdu_mlme {
  * @dummy: indicate a dummy station created for receiving
  *	EAP frames before association
  * @sta: station information we share with the driver
+ * @sta_state: duplicates information about station state (for debug)
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -283,6 +292,8 @@ struct sta_info {
 
 	bool uploaded;
 
+	enum ieee80211_sta_state sta_state;
+
 	/* use the accessors defined below */
 	unsigned long _flags;
 
@@ -371,12 +382,18 @@ static inline enum nl80211_plink_state s
 static inline void set_sta_flag(struct sta_info *sta,
 				enum ieee80211_sta_info_flags flag)
 {
+	WARN_ON(flag == WLAN_STA_AUTH ||
+		flag == WLAN_STA_ASSOC ||
+		flag == WLAN_STA_AUTHORIZED);
 	set_bit(flag, &sta->_flags);
 }
 
 static inline void clear_sta_flag(struct sta_info *sta,
 				  enum ieee80211_sta_info_flags flag)
 {
+	WARN_ON(flag == WLAN_STA_AUTH ||
+		flag == WLAN_STA_ASSOC ||
+		flag == WLAN_STA_AUTHORIZED);
 	clear_bit(flag, &sta->_flags);
 }
 
@@ -389,15 +406,32 @@ static inline int test_sta_flag(struct s
 static inline int test_and_clear_sta_flag(struct sta_info *sta,
 					  enum ieee80211_sta_info_flags flag)
 {
+	WARN_ON(flag == WLAN_STA_AUTH ||
+		flag == WLAN_STA_ASSOC ||
+		flag == WLAN_STA_AUTHORIZED);
 	return test_and_clear_bit(flag, &sta->_flags);
 }
 
 static inline int test_and_set_sta_flag(struct sta_info *sta,
 					enum ieee80211_sta_info_flags flag)
 {
+	WARN_ON(flag == WLAN_STA_AUTH ||
+		flag == WLAN_STA_ASSOC ||
+		flag == WLAN_STA_AUTHORIZED);
 	return test_and_set_bit(flag, &sta->_flags);
 }
 
+int sta_info_move_state_checked(struct sta_info *sta,
+				enum ieee80211_sta_state new_state);
+
+static inline void sta_info_move_state(struct sta_info *sta,
+				       enum ieee80211_sta_state new_state)
+{
+	int ret = sta_info_move_state_checked(sta, new_state);
+	WARN_ON_ONCE(ret);
+}
+
+
 void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 			     struct tid_ampdu_tx *tid_tx);
 
@@ -489,6 +523,9 @@ struct sta_info *sta_info_get_by_idx(str
  */
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				u8 *addr, gfp_t gfp);
+
+void sta_info_free(struct ieee80211_local *local, struct sta_info *sta);
+
 /*
  * Insert STA info into hash table/list, returns zero or a
  * -EEXIST if (if the same MAC address is already present).
--- a/net/mac80211/cfg.c	2011-12-14 11:51:06.000000000 +0100
+++ b/net/mac80211/cfg.c	2011-12-14 11:51:07.000000000 +0100
@@ -746,10 +746,11 @@ static void ieee80211_send_layer2_update
 	netif_rx_ni(skb);
 }
 
-static void sta_apply_parameters(struct ieee80211_local *local,
-				 struct sta_info *sta,
-				 struct station_parameters *params)
+static int sta_apply_parameters(struct ieee80211_local *local,
+				struct sta_info *sta,
+				struct station_parameters *params)
 {
+	int ret = 0;
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
@@ -761,13 +762,59 @@ static void sta_apply_parameters(struct
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
 
+	/*
+	 * In mesh mode, we can clear AUTHENTICATED flag but must
+	 * also make ASSOCIATED follow appropriately for the driver
+	 * API. See also below, after AUTHORIZED changes.
+	 */
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
+		/* cfg80211 should not allow this in non-mesh modes */
+		if (WARN_ON(!ieee80211_vif_is_mesh(&sdata->vif)))
+			return -EINVAL;
+
+		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
+		    !test_sta_flag(sta, WLAN_STA_AUTH)) {
+			ret = sta_info_move_state_checked(sta,
+					IEEE80211_STA_AUTH);
+			if (ret)
+				return ret;
+			ret = sta_info_move_state_checked(sta,
+					IEEE80211_STA_ASSOC);
+			if (ret)
+				return ret;
+		}
+	}
+
 	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
 		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
-			set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+			ret = sta_info_move_state_checked(sta,
+					IEEE80211_STA_AUTHORIZED);
 		else
-			clear_sta_flag(sta, WLAN_STA_AUTHORIZED);
+			ret = sta_info_move_state_checked(sta,
+					IEEE80211_STA_ASSOC);
+		if (ret)
+			return ret;
 	}
 
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
+		/* cfg80211 should not allow this in non-mesh modes */
+		if (WARN_ON(!ieee80211_vif_is_mesh(&sdata->vif)))
+			return -EINVAL;
+
+		if (!(set & BIT(NL80211_STA_FLAG_AUTHENTICATED)) &&
+		    test_sta_flag(sta, WLAN_STA_AUTH)) {
+			ret = sta_info_move_state_checked(sta,
+					IEEE80211_STA_AUTH);
+			if (ret)
+				return ret;
+			ret = sta_info_move_state_checked(sta,
+					IEEE80211_STA_NONE);
+			if (ret)
+				return ret;
+		}
+	}
+
+
 	if (mask & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE)) {
 		if (set & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
 			set_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE);
@@ -792,13 +839,6 @@ static void sta_apply_parameters(struct
 			clear_sta_flag(sta, WLAN_STA_MFP);
 	}
 
-	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
-		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
-			set_sta_flag(sta, WLAN_STA_AUTH);
-		else
-			clear_sta_flag(sta, WLAN_STA_AUTH);
-	}
-
 	if (mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) {
 		if (set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 			set_sta_flag(sta, WLAN_STA_TDLS_PEER);
@@ -870,6 +910,8 @@ static void sta_apply_parameters(struct
 			}
 #endif
 	}
+
+	return 0;
 }
 
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
@@ -900,10 +942,14 @@ static int ieee80211_add_station(struct
 	if (!sta)
 		return -ENOMEM;
 
-	set_sta_flag(sta, WLAN_STA_AUTH);
-	set_sta_flag(sta, WLAN_STA_ASSOC);
+	sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 
-	sta_apply_parameters(local, sta, params);
+	err = sta_apply_parameters(local, sta, params);
+	if (err) {
+		sta_info_free(local, sta);
+		return err;
+	}
 
 	/*
 	 * for TDLS, rate control should be initialized only when supported
--- a/net/mac80211/ibss.c	2011-12-14 11:50:26.000000000 +0100
+++ b/net/mac80211/ibss.c	2011-12-14 11:51:07.000000000 +0100
@@ -512,7 +512,10 @@ struct sta_info *ieee80211_ibss_add_sta(
 		return NULL;
 
 	sta->last_rx = jiffies;
-	set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+
+	sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
--- a/net/mac80211/iface.c	2011-12-14 11:50:26.000000000 +0100
+++ b/net/mac80211/iface.c	2011-12-14 11:51:07.000000000 +0100
@@ -318,8 +318,9 @@ static int ieee80211_do_open(struct net_
 			goto err_del_interface;
 		}
 
-		/* no atomic bitop required since STA is not live yet */
-		set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+		sta_info_move_state(sta, IEEE80211_STA_AUTH);
+		sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+		sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 		res = sta_info_insert(sta);
 		if (res) {
--- a/net/mac80211/mesh_plink.c	2011-12-14 11:50:26.000000000 +0100
+++ b/net/mac80211/mesh_plink.c	2011-12-14 11:51:07.000000000 +0100
@@ -96,9 +96,12 @@ static struct sta_info *mesh_plink_alloc
 	if (!sta)
 		return NULL;
 
-	set_sta_flag(sta, WLAN_STA_AUTH);
-	set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+	sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+
 	set_sta_flag(sta, WLAN_STA_WME);
+
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	if (elems->ht_cap_elem)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
--- a/net/mac80211/mlme.c	2011-12-14 11:50:26.000000000 +0100
+++ b/net/mac80211/mlme.c	2011-12-14 11:51:07.000000000 +0100
@@ -1577,10 +1577,10 @@ static bool ieee80211_assoc_success(stru
 		return false;
 	}
 
-	set_sta_flag(sta, WLAN_STA_AUTH);
-	set_sta_flag(sta, WLAN_STA_ASSOC);
+	sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 	if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
-		set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+		sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 	rates = 0;
 	basic_rates = 0;
--- a/net/mac80211/tx.c	2011-12-14 11:50:26.000000000 +0100
+++ b/net/mac80211/tx.c	2011-12-14 11:51:07.000000000 +0100
@@ -295,7 +295,6 @@ ieee80211_tx_h_check_assoc(struct ieee80
 
 	if (likely(tx->flags & IEEE80211_TX_UNICAST)) {
 		if (unlikely(!assoc &&
-			     tx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 			     ieee80211_is_data(hdr->frame_control))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			printk(KERN_DEBUG "%s: dropped data frame to not "


