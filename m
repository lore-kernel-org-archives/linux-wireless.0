Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFD13E121A
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571120; cv=none; b=iIgIyZef1GYGg0M9g78lkGe/MWERifn9v5J2n/FTKklxHuqyJyXgfvPFKitG8JKu3GCTnZrHX5NszLN/wKECMCgek9ErLOZhQY5J3scauWNwdoKgIUs2XzVuPy0fz9xHUXuiRbD82mWXIhQMySyIEuuUDHuj9v5MeLNqr70DCB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571120; c=relaxed/simple;
	bh=lwxB74NsuGedQhU7Z/bjPB7xtAWoUfgqB00TgkEG7Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5VCfCvWKX3asOVRRq14f1h2VLhDXveNz6JTEf76zGjdmn8UMa1F7a6uGKHdPPzEdYcO+HnXelzy9bUaxvREMgZnq9i+TGJfe9PmawyTmd6TMwBDcqAYg/3PUOFa/1Goz+ojoVDQ/W7gbdxI6tPvMXjlKkAhowFEpwXKFpxmwtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Gx6dPLbl; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Gx6dPLbl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=VUZPcJtEeL2PkwTrjJLA2qs7CywMSsy5xoZjv/dKyMk=;
	t=1785571118; x=1786780718; b=Gx6dPLblQ90SUn1SaP3O1jN92dKylwBEjO6TsdnRjKty6YC
	fKAonUx7OR4o5BVzF8mC+HuNvRkw64NoyxZgWunBJqgPoRN7RcPC2lxrb8bf6xKmRS2FALuqpawNR
	2HPBr+/lYOzxRyzD9zkkCXwZcuVmjpbUaArAkM2Hbgw5kHbx2DBnCEx1/PhyS8ynQezeFg5Ic8k3/
	LipM4fMMN5qUlGAQ8/2pdKvLyHEiQLpwZgdbHotXlH8HTxtYsOmR/7E1RwJQ/rmAldPsfnxH83rI8
	UfZSJYF8C3AKd+87P/ODB/Sm8D941uWDBdAK8DqK9AfWfwbdKPvrDEYT3a28W7bQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c1-0000000ErOv-3dhs;
	Sat, 01 Aug 2026 09:58:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 05/12] wifi: mac80211: use per-STA GTK in client mode
Date: Sat,  1 Aug 2026 09:58:21 +0200
Message-ID: <20260801095822.3b59520b9d73.I848e5735dccc334d72ab917b7eb74e41db45b290@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Historically, client mode installed GTKs per interface,
conflating them with AP mode where this is done, but in
that case they're for TX, while in client they're only
for RX.

Use the new WIPHY_FLAG_CLIENT_AP_STA_GTK cfg80211 flag
to indicate that we want/support per-AP-STA GTKs, and
then rename the gtk[]/cigtk[] arrays to tx_*[] (link)
and to rx_*[] (link station) accordingly, finally
clearing this up.

For now, don't tell the driver about this, though it
would simplify at least iwlwifi.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  14 +++-
 net/mac80211/ieee80211_i.h |   8 +-
 net/mac80211/key.c         | 162 +++++++++++++++++++++++--------------
 net/mac80211/key.h         |   5 ++
 net/mac80211/main.c        |   3 +-
 net/mac80211/rx.c          |  64 +++++----------
 net/mac80211/sta_info.c    |  13 +++
 net/mac80211/sta_info.h    |  12 +--
 8 files changed, 161 insertions(+), 120 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3bf81629cde3..31c3b7481204 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -699,6 +699,11 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
+		/* mostly handled by cfg80211, but make sure */
+		if (pairwise && !mac_addr) {
+			ieee80211_key_free_unused(key);
+			return -EINVAL;
+		}
 		if (sdata->u.mgd.mfp != IEEE80211_MFP_DISABLED)
 			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
 		break;
@@ -781,14 +786,14 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 
 		if (cigtk && key_idx < NUM_CTRL_KEYS)
 			return wiphy_dereference(local->hw.wiphy,
-						 link_sta->cigtk[key_idx]);
+						 link_sta->rx_cigtk[key_idx]);
 
 		if (!pairwise && !cigtk &&
 		    key_idx < NUM_DEFAULT_KEYS +
 			      NUM_DEFAULT_MGMT_KEYS +
 			      NUM_DEFAULT_BEACON_KEYS)
 			return wiphy_dereference(local->hw.wiphy,
-						 link_sta->gtk[key_idx]);
+						 link_sta->rx_gtk[key_idx]);
 
 		return NULL;
 	}
@@ -797,9 +802,10 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 		return wiphy_dereference(local->hw.wiphy, sdata->keys[key_idx]);
 
 	if (cigtk)
-		return wiphy_dereference(local->hw.wiphy, link->cigtk[key_idx]);
+		return wiphy_dereference(local->hw.wiphy,
+					 link->tx_cigtk[key_idx]);
 
-	key = wiphy_dereference(local->hw.wiphy, link->gtk[key_idx]);
+	key = wiphy_dereference(local->hw.wiphy, link->tx_gtk[key_idx]);
 	if (key)
 		return key;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fc85f8bf96e3..5e7d10ba4897 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1102,10 +1102,10 @@ struct ieee80211_link_data {
 	unsigned int link_id;
 
 	/* multicast keys only */
-	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS +
-					NUM_DEFAULT_MGMT_KEYS +
-					NUM_DEFAULT_BEACON_KEYS];
-	struct ieee80211_key __rcu *cigtk[NUM_CTRL_KEYS];
+	struct ieee80211_key __rcu *tx_gtk[NUM_DEFAULT_KEYS +
+					   NUM_DEFAULT_MGMT_KEYS +
+					   NUM_DEFAULT_BEACON_KEYS];
+	struct ieee80211_key __rcu *tx_cigtk[NUM_CTRL_KEYS];
 	struct ieee80211_key __rcu *default_multicast_key;
 	struct ieee80211_key __rcu *default_mgmt_key;
 	struct ieee80211_key __rcu *default_beacon_key;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ed08e011c1f2..0ce2ebfae578 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -22,6 +22,7 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 #include "debugfs_key.h"
+#include "sta_info.h"
 #include "aes_ccm.h"
 #include "aes_cmac.h"
 #include "aes_gmac.h"
@@ -165,6 +166,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 						 SUPPORTS_PER_STA_GTK)))
 				goto out_unsupported;
 			break;
+		case NL80211_IFTYPE_STATION:
+			/* install group keys w/o STA as we always did */
+			sta = NULL;
+			break;
 		default:
 			goto out_unsupported;
 		}
@@ -245,6 +250,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sta *pubsta;
 	struct sta_info *sta;
 	int ret;
 
@@ -270,9 +276,14 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 				 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
+	pubsta = sta ? &sta->sta : NULL;
+	/* for now override STA to NULL for client group keys as before */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		pubsta = NULL;
+
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
-			  sta ? &sta->sta : NULL, &key->conf);
+	ret = drv_set_key(key->local, DISABLE_KEY, sdata, pubsta, &key->conf);
 
 	if (ret)
 		sdata_err(sdata,
@@ -374,7 +385,7 @@ static void __ieee80211_set_default_key(struct ieee80211_link_data *link,
 					sdata->keys[idx]);
 		if (!key)
 			key = wiphy_dereference(sdata->local->hw.wiphy,
-						link->gtk[idx]);
+						link->tx_gtk[idx]);
 	}
 
 	if (uni) {
@@ -409,7 +420,7 @@ __ieee80211_set_default_mgmt_key(struct ieee80211_link_data *link, int idx)
 	if (idx >= NUM_DEFAULT_KEYS &&
 	    idx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
 		key = wiphy_dereference(sdata->local->hw.wiphy,
-					link->gtk[idx]);
+					link->tx_gtk[idx]);
 
 	rcu_assign_pointer(link->default_mgmt_key, key);
 
@@ -436,7 +447,7 @@ __ieee80211_set_default_beacon_key(struct ieee80211_link_data *link, int idx)
 	    idx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS +
 	    NUM_DEFAULT_BEACON_KEYS)
 		key = wiphy_dereference(sdata->local->hw.wiphy,
-					link->gtk[idx]);
+					link->tx_gtk[idx]);
 
 	rcu_assign_pointer(link->default_beacon_key, key);
 
@@ -454,11 +465,11 @@ void ieee80211_set_default_beacon_key(struct ieee80211_link_data *link,
 static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_link_data *link,
 				 struct sta_info *sta,
+				 struct link_sta_info *link_sta,
 				 enum ieee80211_key_flags flags,
 				 struct ieee80211_key *old,
 				 struct ieee80211_key *new)
 {
-	struct link_sta_info *link_sta = sta ? &sta->deflink : NULL;
 	bool pairwise = flags & IEEE80211_KEY_FLAG_PAIRWISE;
 	bool cip = flags & IEEE80211_KEY_FLAG_CIP;
 	int link_id;
@@ -497,7 +508,7 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				return -ENOLINK;
 		}
 
-		if (sta) {
+		if (sta && !link_sta) {
 			link_sta = rcu_dereference_protected(sta->link[link_id],
 							     lockdep_is_held(&sta->local->hw.wiphy->mtx));
 			if (!link_sta)
@@ -505,6 +516,7 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		}
 	} else {
 		link = &sdata->deflink;
+		link_sta = sta ? &sta->deflink : NULL;
 	}
 
 	if ((is_wep || pairwise) && idx >= NUM_DEFAULT_KEYS)
@@ -552,9 +564,9 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 			    !(new->conf.flags & IEEE80211_KEY_FLAG_NO_AUTO_TX))
 				_ieee80211_set_tx_key(new, true);
 		} else if (cip) {
-			rcu_assign_pointer(link_sta->cigtk[idx], new);
+			rcu_assign_pointer(link_sta->rx_cigtk[idx], new);
 		} else {
-			rcu_assign_pointer(link_sta->gtk[idx], new);
+			rcu_assign_pointer(link_sta->rx_gtk[idx], new);
 		}
 		/* Only needed for transition from no key -> key.
 		 * Still triggers unnecessary when using Extended Key ID
@@ -588,9 +600,9 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		if (is_wep || pairwise)
 			rcu_assign_pointer(sdata->keys[idx], new);
 		else if (cip)
-			rcu_assign_pointer(link->cigtk[idx], new);
+			rcu_assign_pointer(link->tx_cigtk[idx], new);
 		else
-			rcu_assign_pointer(link->gtk[idx], new);
+			rcu_assign_pointer(link->tx_gtk[idx], new);
 
 		if (defunikey && new)
 			__ieee80211_set_default_key(link, new->conf.keyidx,
@@ -922,14 +934,14 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 		if (key->conf.flags & IEEE80211_KEY_FLAG_CIP)
 			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    link_sta->cigtk[idx]);
+						    link_sta->rx_cigtk[idx]);
 		else
 			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    link_sta->gtk[idx]);
+						    link_sta->rx_gtk[idx]);
 	} else {
 		if (key->conf.flags & IEEE80211_KEY_FLAG_CIP) {
 			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    link->cigtk[idx]);
+						    link->tx_cigtk[idx]);
 		} else {
 			if (idx < NUM_DEFAULT_KEYS)
 				old_key = wiphy_dereference(sdata->local->hw.wiphy,
@@ -937,7 +949,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 			if (!old_key)
 				old_key = wiphy_dereference(sdata->local->hw.wiphy,
-							    link->gtk[idx]);
+							    link->tx_gtk[idx]);
 		}
 	}
 
@@ -969,7 +981,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	key->color = atomic_inc_return(&key_color);
 
 	/* keep this flag for easier access later */
-	if (sta && sta->sta.spp_amsdu)
+	if (pairwise && sta && sta->sta.spp_amsdu)
 		key->conf.flags |= IEEE80211_KEY_FLAG_SPP_AMSDU;
 
 	/* A CIP related key must be GCMP-256 (really GMAC-256) */
@@ -981,8 +993,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	increment_tailroom_need_count(sdata);
 
-	ret = ieee80211_key_replace(sdata, link, sta, key->conf.flags,
-				    old_key, key);
+	ret = ieee80211_key_replace(sdata, link, sta, NULL,
+				    key->conf.flags, old_key, key);
 
 	if (!ret) {
 		ieee80211_debugfs_key_add(key);
@@ -1007,7 +1019,7 @@ void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 	 * Replace key with nothingness if it was ever used.
 	 */
 	if (key->sdata)
-		ieee80211_key_replace(key->sdata, NULL, key->sta,
+		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
 				      key->conf.flags, key, NULL);
 	ieee80211_key_destroy(key, delay_tailroom);
 }
@@ -1049,13 +1061,21 @@ ieee80211_key_iter(struct ieee80211_hw *hw,
 				void *data),
 		   void *iter_data)
 {
-	/* skip keys of station in removal process */
-	if (key->sta && key->sta->removed)
-		return;
+	struct sta_info *sta = key->sta;
+
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		return;
-	iter(hw, vif, key->sta ? &key->sta->sta : NULL,
-	     &key->conf, iter_data);
+
+	/* for now override STA to NULL for client group keys as before */
+	if (vif->type == NL80211_IFTYPE_STATION &&
+	    !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		sta = NULL;
+
+	/* skip keys of station in removal process (if driver knew about STA) */
+	if (sta && sta->removed)
+		return;
+
+	iter(hw, vif, sta ? &sta->sta : NULL, &key->conf, iter_data);
 }
 
 void ieee80211_iter_keys(struct ieee80211_hw *hw,
@@ -1138,7 +1158,7 @@ static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_key_remove_beacon_default(sdata);
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
-		ieee80211_key_replace(key->sdata, NULL, key->sta,
+		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
 				      key->conf.flags, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
@@ -1158,7 +1178,7 @@ void ieee80211_remove_link_keys(struct ieee80211_link_data *link,
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
 		if (key->conf.link_id != link->link_id)
 			continue;
-		ieee80211_key_replace(key->sdata, link, key->sta,
+		ieee80211_key_replace(key->sdata, link, key->sta, NULL,
 				      key->conf.flags, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
@@ -1222,6 +1242,40 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+void ieee80211_free_sta_link_keys(struct ieee80211_local *local,
+				  struct link_sta_info *link_sta)
+{
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	for (int i = 0; i < ARRAY_SIZE(link_sta->rx_gtk); i++) {
+		struct ieee80211_key *key;
+		int ret;
+
+		key = wiphy_dereference(local->hw.wiphy, link_sta->rx_gtk[i]);
+		if (!key)
+			continue;
+		ret = ieee80211_key_replace(key->sdata, NULL, key->sta, link_sta,
+					    key->conf.flags, key, NULL);
+		WARN(ret, "failed to remove STA link key (%d)\n", ret);
+		__ieee80211_key_destroy(key, key->sdata->vif.type ==
+					NL80211_IFTYPE_STATION);
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(link_sta->rx_cigtk); i++) {
+		struct ieee80211_key *key;
+		int ret;
+
+		key = wiphy_dereference(local->hw.wiphy, link_sta->rx_cigtk[i]);
+		if (!key)
+			continue;
+		ret = ieee80211_key_replace(key->sdata, NULL, key->sta, link_sta,
+					    key->conf.flags, key, NULL);
+		WARN(ret, "failed to remove STA link key (%d)\n", ret);
+		__ieee80211_key_destroy(key, key->sdata->vif.type ==
+					NL80211_IFTYPE_STATION);
+	}
+}
+
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
@@ -1230,31 +1284,11 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	for (i = 0; i < ARRAY_SIZE(sta->deflink.gtk); i++) {
-		key = wiphy_dereference(local->hw.wiphy, sta->deflink.gtk[i]);
-		if (!key)
-			continue;
-		ieee80211_key_replace(key->sdata, NULL, key->sta,
-				      key->conf.flags, key, NULL);
-		__ieee80211_key_destroy(key, key->sdata->vif.type ==
-					NL80211_IFTYPE_STATION);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(sta->deflink.cigtk); i++) {
-		key = wiphy_dereference(local->hw.wiphy, sta->deflink.cigtk[i]);
-		if (!key)
-			continue;
-		ieee80211_key_replace(key->sdata, NULL, key->sta,
-				      key->conf.flags, key, NULL);
-		__ieee80211_key_destroy(key, key->sdata->vif.type ==
-					NL80211_IFTYPE_STATION);
-	}
-
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
 		key = wiphy_dereference(local->hw.wiphy, sta->ptk[i]);
 		if (!key)
 			continue;
-		ieee80211_key_replace(key->sdata, NULL, key->sta,
+		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
 				      key->conf.flags, key, NULL);
 		__ieee80211_key_destroy(key, key->sdata->vif.type ==
 					NL80211_IFTYPE_STATION);
@@ -1417,8 +1451,10 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
+	struct link_sta_info *link_sta;
 	struct ieee80211_key *prev_key;
 	struct ieee80211_key *key;
+	struct sta_info *sta;
 	int err;
 	struct ieee80211_link_data *link_data =
 		link_id < 0 ? &sdata->deflink :
@@ -1440,29 +1476,43 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 	if (WARN_ON(cigtk && idx >= NUM_CTRL_KEYS))
 		return ERR_PTR(-EINVAL);
 
+	sta = sta_info_get(sdata, sdata->vif.cfg.ap_addr);
+	if (WARN_ON(!sta))
+		return ERR_PTR(-ENOENT);
+
+	if (link_id < 0) {
+		link_sta = &sta->deflink;
+	} else {
+		link_sta = wiphy_dereference(local->hw.wiphy,
+					     sta->link[link_id]);
+		if (WARN_ON(!link_sta))
+			return ERR_PTR(-ENOLINK);
+	}
+
 	if (cigtk)
 		prev_key = wiphy_dereference(local->hw.wiphy,
-					     link_data->cigtk[idx]);
+					     link_sta->rx_cigtk[idx]);
 	else
 		prev_key = wiphy_dereference(local->hw.wiphy,
-					     link_data->gtk[idx]);
+					     link_sta->rx_gtk[idx]);
+
 	if (!prev_key) {
 		if (cigtk) {
 			prev_key = wiphy_dereference(local->hw.wiphy,
-						     link_data->cigtk[idx ^ 1]);
+						     link_sta->rx_cigtk[idx ^ 1]);
 		} else if (idx < NUM_DEFAULT_KEYS) {
 			for (int i = 0; i < NUM_DEFAULT_KEYS; i++) {
 				if (i == idx)
 					continue;
 				prev_key = wiphy_dereference(local->hw.wiphy,
-							     link_data->gtk[i]);
+							     link_sta->rx_gtk[i]);
 				if (prev_key)
 					break;
 			}
 		} else {
 			/* For IGTK we have 4 and 5 and for BIGTK - 6 and 7 */
 			prev_key = wiphy_dereference(local->hw.wiphy,
-						     link_data->gtk[idx ^ 1]);
+						     link_sta->rx_gtk[idx ^ 1]);
 		}
 	}
 
@@ -1486,7 +1536,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 
 	key->conf.link_id = link_data->link_id;
 
-	err = ieee80211_key_link(key, link_data, NULL);
+	err = ieee80211_key_link(key, link_data, sta);
 	if (err)
 		return ERR_PTR(err);
 
@@ -1555,9 +1605,6 @@ int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 		    !(del_links_mask & BIT(key->conf.link_id)))
 			continue;
 
-		/* shouldn't happen for per-link keys */
-		WARN_ON(key->sta);
-
 		ieee80211_key_disable_hw_accel(key);
 	}
 
@@ -1566,9 +1613,6 @@ int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 		    !(add_links_mask & BIT(key->conf.link_id)))
 			continue;
 
-		/* shouldn't happen for per-link keys */
-		WARN_ON(key->sta);
-
 		ret = ieee80211_key_enable_hw_accel(key);
 		if (ret)
 			return ret;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index c85992493afd..33063cabbce0 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -138,6 +138,9 @@ struct ieee80211_key {
 	struct ieee80211_key_conf conf;
 };
 
+/* from sta_info.h, but cannot include that */
+struct link_sta_info;
+
 struct ieee80211_key *
 ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		    const u8 *key_data,
@@ -164,6 +167,8 @@ void ieee80211_free_key_list(struct ieee80211_local *local,
 			     struct list_head *keys);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 			 bool force_synchronize);
+void ieee80211_free_sta_link_keys(struct ieee80211_local *local,
+				  struct link_sta_info *link_sta);
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta);
 void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a59837b9f480..067990f9c055 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -863,7 +863,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			WIPHY_FLAG_4ADDR_AP |
 			WIPHY_FLAG_4ADDR_STATION |
 			WIPHY_FLAG_REPORTS_OBSS |
-			WIPHY_FLAG_OFFCHAN_TX;
+			WIPHY_FLAG_OFFCHAN_TX |
+			WIPHY_FLAG_CLIENT_AP_STA_GTK;
 
 	if (emulate_chanctx || ops->remain_on_channel)
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e26be8e27d8..dc58f2d1a733 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1996,7 +1996,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 static struct ieee80211_key *
 ieee80211_rx_get_bigtk(struct ieee80211_rx_data *rx, int idx)
 {
-	struct ieee80211_key *key = NULL;
+	struct ieee80211_key *key;
 	int idx2;
 
 	/* Make sure key gets set if either BIGTK key index is set so that
@@ -2015,16 +2015,13 @@ ieee80211_rx_get_bigtk(struct ieee80211_rx_data *rx, int idx)
 			idx2 = idx - 1;
 	}
 
-	if (rx->link_sta)
-		key = rcu_dereference(rx->link_sta->gtk[idx]);
-	if (!key)
-		key = rcu_dereference(rx->link->gtk[idx]);
-	if (!key && rx->link_sta)
-		key = rcu_dereference(rx->link_sta->gtk[idx2]);
-	if (!key)
-		key = rcu_dereference(rx->link->gtk[idx2]);
+	if (!rx->link_sta)
+		return NULL;
 
-	return key;
+	key = rcu_dereference(rx->link_sta->rx_gtk[idx]);
+	if (key)
+		return key;
+	return rcu_dereference(rx->link_sta->rx_gtk[idx2]);
 }
 
 static ieee80211_rx_result debug_noinline
@@ -2134,10 +2131,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 			    test_sta_flag(rx->sta, WLAN_STA_MFP))
 				return RX_DROP_U_UNPROTECTED;
 
-			rx->key = rcu_dereference(rx->link_sta->gtk[mmie_keyidx]);
+			rx->key = rcu_dereference(rx->link_sta->rx_gtk[mmie_keyidx]);
 		}
-		if (!rx->key)
-			rx->key = rcu_dereference(rx->link->gtk[mmie_keyidx]);
 	} else if (!ieee80211_has_protected(fc)) {
 		/*
 		 * The frame was not protected, so skip decryption. However, we
@@ -2153,20 +2148,11 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		} else if (ieee80211_is_mgmt(fc) &&
 			   is_multicast_ether_addr(hdr->addr1)) {
 			key = rcu_dereference(rx->link->default_mgmt_key);
-		} else {
-			if (rx->link_sta) {
-				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-					key = rcu_dereference(rx->link_sta->gtk[i]);
-					if (key)
-						break;
-				}
-			}
-			if (!key) {
-				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-					key = rcu_dereference(rx->link->gtk[i]);
-					if (key)
-						break;
-				}
+		} else if (rx->link_sta) {
+			for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+				key = rcu_dereference(rx->link_sta->rx_gtk[i]);
+				if (key)
+					break;
 			}
 		}
 		if (key)
@@ -2193,26 +2179,11 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 		/* check per-station GTK first, if multicast packet */
 		if (is_multicast_ether_addr(hdr->addr1) && rx->link_sta)
-			rx->key = rcu_dereference(rx->link_sta->gtk[keyidx]);
+			rx->key = rcu_dereference(rx->link_sta->rx_gtk[keyidx]);
 
-		/* if not found, try default key */
-		if (!rx->key) {
-			if (is_multicast_ether_addr(hdr->addr1))
-				rx->key = rcu_dereference(rx->link->gtk[keyidx]);
-			if (!rx->key)
-				rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
-
-			/*
-			 * RSNA-protected unicast frames should always be
-			 * sent with pairwise or station-to-station keys,
-			 * but for WEP we allow using a key index as well.
-			 */
-			if (rx->key &&
-			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
-			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
-			    !is_multicast_ether_addr(hdr->addr1))
-				rx->key = NULL;
-		}
+		/* if not found, try WEP/WPA-NONE */
+		if (!rx->key)
+			rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
 	}
 
 	if (rx->key) {
@@ -4819,6 +4790,7 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 
 	rcu_read_lock();
 	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	/* check WEP key to not erroneously consider it as no encryption */
 	if (!key)
 		key = rcu_dereference(sdata->default_unicast_key);
 	if (key) {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d12aed9c1756..a1759eba7b01 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -432,6 +432,8 @@ static void sta_remove_link(struct sta_info *sta, unsigned int link_id,
 	if (WARN_ON(!link_sta))
 		return;
 
+	ieee80211_free_sta_link_keys(sta->local, link_sta);
+
 	if (unhash)
 		link_sta_info_hash_del(sta->local, link_sta);
 
@@ -1575,6 +1577,17 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 	}
 
 	/* now keys can no longer be reached */
+	for (int i = 0; i < ARRAY_SIZE(sta->link); i++) {
+		struct link_sta_info *link_sta;
+
+		link_sta = rcu_dereference_protected(sta->link[i],
+						     lockdep_is_held(&local->hw.wiphy->mtx));
+		if (!link_sta)
+			continue;
+
+		ieee80211_free_sta_link_keys(local, link_sta);
+	}
+
 	ieee80211_free_sta_keys(local, sta);
 
 	/* disable TIM bit - last chance to tell driver */
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f409f6a3afa1..0158920e1d81 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -484,8 +484,8 @@ struct ieee80211_fragment_cache {
  * @capa_nss: NSS limit as determined by local and peer capabilities
  * @link_hash_node: hash node for rhashtable
  * @sta: Points to the STA info
- * @gtk: group keys negotiated with this station, if any
- * @cigtk: control integrity group keys negotiated with this station, if any
+ * @rx_gtk: group keys negotiated with this station, if any
+ * @rx_cigtk: control integrity group keys negotiated with this station, if any
  * @tx_stats: TX statistics
  * @tx_stats.packets: # of packets transmitted
  * @tx_stats.bytes: # of bytes in all packets transmitted
@@ -533,10 +533,10 @@ struct link_sta_info {
 	struct rhlist_head link_hash_node;
 
 	struct sta_info *sta;
-	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS +
-					NUM_DEFAULT_MGMT_KEYS +
-					NUM_DEFAULT_BEACON_KEYS];
-	struct ieee80211_key __rcu *cigtk[NUM_CTRL_KEYS];
+	struct ieee80211_key __rcu *rx_gtk[NUM_DEFAULT_KEYS +
+					   NUM_DEFAULT_MGMT_KEYS +
+					   NUM_DEFAULT_BEACON_KEYS];
+	struct ieee80211_key __rcu *rx_cigtk[NUM_CTRL_KEYS];
 	struct ieee80211_sta_rx_stats __percpu *pcpu_rx_stats;
 
 	/* Updated from RX path only, no locking requirements */
-- 
2.55.0

