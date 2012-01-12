Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2ALIbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 03:31:13 -0500
Subject: [PATCH v3] mac80211: station state transition error handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1325675469.3339.30.camel@jlt3.sipsolutions.net> (sfid-20120104_121130_343975_BD512884)
References: <1325672933.3339.17.camel@jlt3.sipsolutions.net>
	 (sfid-20120104_112900_005299_0DDC4453)  <1325675469.3339.30.camel@jlt3.sipsolutions.net>
	 (sfid-20120104_121130_343975_BD512884)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 09:31:10 +0100
Message-ID: <1326357070.3463.1.camel@jlt3.sipsolutions.net> (sfid-20120112_093117_349489_7994CEA1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the future, when we start notifying drivers,
state transitions could potentially fail. To make
it easier to distinguish between programming bugs
and driver failures:
 * rename sta_info_move_state() to
   sta_info_pre_move_state() which can only be
   called before the station is inserted (and
   check this with a new station flag).
 * rename sta_info_move_state_checked() to just
   plain sta_info_move_state(), as it will be
   the regular function that can fail for more
   than just one reason (bad transition or an
   error from the driver)

This makes the programming model easier -- one of
the functions can only be called before insertion
and can't fail, the other can fail.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix deadlock in error path (Thanks Eliad!)
v3: break on sta down failure (Thanks again Eliad)

 net/mac80211/cfg.c         |   22 ++++++++--------------
 net/mac80211/debugfs_sta.c |    5 +++--
 net/mac80211/ibss.c        |    6 +++---
 net/mac80211/iface.c       |    6 +++---
 net/mac80211/mesh_plink.c  |    6 +++---
 net/mac80211/mlme.c        |   17 +++++++++++++----
 net/mac80211/sta_info.c    |   19 ++++++++++++++-----
 net/mac80211/sta_info.h    |   17 ++++++++++++-----
 8 files changed, 59 insertions(+), 39 deletions(-)

--- a/net/mac80211/debugfs_sta.c	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/debugfs_sta.c	2012-01-12 09:25:55.000000000 +0100
@@ -63,14 +63,15 @@ static ssize_t sta_flags_read(struct fil
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
 			    TEST(WME), TEST(WDS), TEST(CLEAR_PS_FILT),
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
-			    TEST(TDLS_PEER_AUTH));
+			    TEST(TDLS_PEER_AUTH), TEST(4ADDR_EVENT),
+			    TEST(INSERTED));
 #undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
--- a/net/mac80211/sta_info.h	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/sta_info.h	2012-01-12 09:25:56.000000000 +0100
@@ -52,6 +52,7 @@
  * @WLAN_STA_SP: Station is in a service period, so don't try to
  *	reply to other uAPSD trigger frames or PS-Poll.
  * @WLAN_STA_4ADDR_EVENT: 4-addr event was already sent for this frame.
+ * @WLAN_STA_INSERTED: This station is inserted into the hash table.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -71,6 +72,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_UAPSD,
 	WLAN_STA_SP,
 	WLAN_STA_4ADDR_EVENT,
+	WLAN_STA_INSERTED,
 };
 
 enum ieee80211_sta_state {
@@ -427,13 +429,17 @@ static inline int test_and_set_sta_flag(
 	return test_and_set_bit(flag, &sta->_flags);
 }
 
-int sta_info_move_state_checked(struct sta_info *sta,
-				enum ieee80211_sta_state new_state);
+int sta_info_move_state(struct sta_info *sta,
+			enum ieee80211_sta_state new_state);
 
-static inline void sta_info_move_state(struct sta_info *sta,
-				       enum ieee80211_sta_state new_state)
+static inline void sta_info_pre_move_state(struct sta_info *sta,
+					   enum ieee80211_sta_state new_state)
 {
-	int ret = sta_info_move_state_checked(sta, new_state);
+	int ret;
+
+	WARN_ON_ONCE(test_sta_flag(sta, WLAN_STA_INSERTED));
+
+	ret = sta_info_move_state(sta, new_state);
 	WARN_ON_ONCE(ret);
 }
 
@@ -544,6 +550,7 @@ int sta_info_insert(struct sta_info *sta
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
 int sta_info_reinsert(struct sta_info *sta);
 
+int __must_check __sta_info_destroy(struct sta_info *sta);
 int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
 			  const u8 *addr);
 int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/sta_info.c	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-12 09:30:39.000000000 +0100
@@ -405,6 +405,8 @@ static int sta_info_insert_finish(struct
 		sta_info_hash_add(local, sta);
 
 		list_add(&sta->list, &local->sta_list);
+
+		set_sta_flag(sta, WLAN_STA_INSERTED);
 	} else {
 		sta->dummy = false;
 	}
@@ -709,7 +711,7 @@ static bool sta_info_cleanup_expire_buff
 	return have_buffered;
 }
 
-static int __must_check __sta_info_destroy(struct sta_info *sta)
+int __must_check __sta_info_destroy(struct sta_info *sta)
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -724,6 +726,8 @@ static int __must_check __sta_info_destr
 	local = sta->local;
 	sdata = sta->sdata;
 
+	lockdep_assert_held(&local->sta_mtx);
+
 	/*
 	 * Before removing the station from the driver and
 	 * rate control, it might still start new aggregation
@@ -765,8 +769,13 @@ static int __must_check __sta_info_destr
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
-	while (sta->sta_state > IEEE80211_STA_NONE)
-		sta_info_move_state(sta, sta->sta_state - 1);
+	while (sta->sta_state > IEEE80211_STA_NONE) {
+		int err = sta_info_move_state(sta, sta->sta_state - 1);
+		if (err) {
+			WARN_ON_ONCE(1);
+			break;
+		}
+	}
 
 	if (sta->uploaded) {
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -1408,8 +1417,8 @@ void ieee80211_sta_set_buffered(struct i
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
 
-int sta_info_move_state_checked(struct sta_info *sta,
-				enum ieee80211_sta_state new_state)
+int sta_info_move_state(struct sta_info *sta,
+			enum ieee80211_sta_state new_state)
 {
 	might_sleep();
 
--- a/net/mac80211/cfg.c	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-01-12 09:25:55.000000000 +0100
@@ -776,12 +776,10 @@ static int sta_apply_parameters(struct i
 
 		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
 		    !test_sta_flag(sta, WLAN_STA_AUTH)) {
-			ret = sta_info_move_state_checked(sta,
-					IEEE80211_STA_AUTH);
+			ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
 			if (ret)
 				return ret;
-			ret = sta_info_move_state_checked(sta,
-					IEEE80211_STA_ASSOC);
+			ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 			if (ret)
 				return ret;
 		}
@@ -789,11 +787,9 @@ static int sta_apply_parameters(struct i
 
 	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
 		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
-			ret = sta_info_move_state_checked(sta,
-					IEEE80211_STA_AUTHORIZED);
+			ret = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
 		else
-			ret = sta_info_move_state_checked(sta,
-					IEEE80211_STA_ASSOC);
+			ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 		if (ret)
 			return ret;
 	}
@@ -805,12 +801,10 @@ static int sta_apply_parameters(struct i
 
 		if (!(set & BIT(NL80211_STA_FLAG_AUTHENTICATED)) &&
 		    test_sta_flag(sta, WLAN_STA_AUTH)) {
-			ret = sta_info_move_state_checked(sta,
-					IEEE80211_STA_AUTH);
+			ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
 			if (ret)
 				return ret;
-			ret = sta_info_move_state_checked(sta,
-					IEEE80211_STA_NONE);
+			ret = sta_info_move_state(sta, IEEE80211_STA_NONE);
 			if (ret)
 				return ret;
 		}
@@ -944,8 +938,8 @@ static int ieee80211_add_station(struct
 	if (!sta)
 		return -ENOMEM;
 
-	sta_info_move_state(sta, IEEE80211_STA_AUTH);
-	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
 
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
--- a/net/mac80211/ibss.c	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/ibss.c	2012-01-12 09:25:55.000000000 +0100
@@ -289,9 +289,9 @@ static struct sta_info *ieee80211_ibss_f
 		    addr, sdata->name);
 #endif
 
-	sta_info_move_state(sta, IEEE80211_STA_AUTH);
-	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 	rate_control_rate_init(sta);
 
--- a/net/mac80211/iface.c	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/iface.c	2012-01-12 09:25:55.000000000 +0100
@@ -318,9 +318,9 @@ static int ieee80211_do_open(struct net_
 			goto err_del_interface;
 		}
 
-		sta_info_move_state(sta, IEEE80211_STA_AUTH);
-		sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-		sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+		sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+		sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
+		sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 		res = sta_info_insert(sta);
 		if (res) {
--- a/net/mac80211/mesh_plink.c	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/mesh_plink.c	2012-01-12 09:17:53.000000000 +0100
@@ -96,9 +96,9 @@ static struct sta_info *mesh_plink_alloc
 	if (!sta)
 		return NULL;
 
-	sta_info_move_state(sta, IEEE80211_STA_AUTH);
-	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 	set_sta_flag(sta, WLAN_STA_WME);
 
--- a/net/mac80211/mlme.c	2012-01-12 09:17:52.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-12 09:25:56.000000000 +0100
@@ -1587,10 +1587,19 @@ static bool ieee80211_assoc_success(stru
 		return false;
 	}
 
-	sta_info_move_state(sta, IEEE80211_STA_AUTH);
-	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-	if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
-		sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+	err = sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	if (!err)
+		err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
+		err = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+	if (err) {
+		printk(KERN_DEBUG
+		       "%s: failed to move station %pM to desired state\n",
+		       sdata->name, sta->sta.addr);
+		WARN_ON(__sta_info_destroy(sta));
+		mutex_unlock(&sdata->local->sta_mtx);
+		return false;
+	}
 
 	rates = 0;
 	basic_rates = 0;


