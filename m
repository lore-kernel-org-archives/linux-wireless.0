Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4785013C2
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896776; cv=none; b=dgoeDAAVvmc8sDFeCOV9D8H12GglAYFdNt7DczyzXUWKuq63XnxxZv5KE+PkR91LiXWz7kCcwDlHk4yEhRqftWiMf06ArZfPMCCTMzz++8lEGszViaglNGljaH2nrAlt5R/agJFKn8HV95Bf2FasGD2ySXcSV1+zTZaeNlGGjnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896776; c=relaxed/simple;
	bh=M9L2qU1Uls+ln6YdMvRKdCTzct5476VGgwCjDJNvzWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtpPDy1sp8I9cPtGfdI705w7nTLT9GwhALa/DEAs69r4+V0ZCa/YmftmBme1eyhiGnKM750iZhPYIPvbtWnvnE1VA+ENcGDjYlAVXni/MLEgTJmk2ZvTRdGPaEwSPMEkrP+XQqx9d12tTpbXIENRoJlLE1NmhHz/Nyy78VP8vaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=SCtVj/Zv; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="SCtVj/Zv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=d/dZhNh31iyO86SKjbGjQhlU1iDn7fygZTGXQlIU8yc=;
	t=1791896774; x=1793106374; b=SCtVj/ZvEpynnUOCfNv9XtBj8MHUWAP094PHNSY09KQbee9
	prE2k2V3n42gj2I+FIN5jQbT1cLt+8tyrrLiKzEZ43T2cUFlE4Ft/vvMuI4F60HjeFG1sRPuF2Rdx
	+DQu+OtL2r3VlGJGy587F2TRhNe3EDqrblLbyd/Prviff2WaC8oTXhrp4vi1tFs5zGJy/hPXlrRtf
	8TihkcZHBtSlX2TGEtmLIjVfFP+MjvQbG2BCgxjEPVRfCo4IfsnAS57iQ81ySm0xmQD8MmJ5QwIoG
	bMe2qDE7O75IJfmgBnDRWPtKMPDT7UxACbSr2B6GRObY79IO1LtW03HWyeIRVdfg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCp-0000000HPRi-3ORo;
	Tue, 13 Oct 2026 15:06:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/11] wifi: mac80211: use per-STA GTK in client mode
Date: Tue, 13 Oct 2026 14:59:07 +0200
Message-ID: <20261013150604.fa618ff4fd1b.I848e5735dccc334d72ab917b7eb74e41db45b291@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
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

Note that I've also fixed an RCU issue here: removing
a link station previously didn't remove keys for it,
so they'd be reachable pointing to a freed link STA.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  14 ++-
 net/mac80211/ieee80211_i.h |   8 +-
 net/mac80211/key.c         | 186 +++++++++++++++++++++++++------------
 net/mac80211/key.h         |   6 ++
 net/mac80211/main.c        |   3 +-
 net/mac80211/rx.c          |  80 ++++++----------
 net/mac80211/sta_info.c    |  19 ++++
 net/mac80211/sta_info.h    |  15 +--
 8 files changed, 201 insertions(+), 130 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9608c07bcea7..b6d759f38c6c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -704,6 +704,11 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
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
@@ -786,14 +791,14 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 
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
@@ -802,9 +807,10 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
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
index 52e413a20f71..56ebe73f1bb8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1114,10 +1114,10 @@ struct ieee80211_link_data {
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
index 112060c5e2cf..d4d66d249719 100644
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
 
@@ -270,15 +276,20 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
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
 			  "failed to remove key (%d, %pM) from hardware (%d)\n",
 			  key->conf.keyidx,
-			  sta ? sta->sta.addr : bcast_addr, ret);
+			  pubsta ? pubsta->addr : bcast_addr, ret);
 }
 
 static int _ieee80211_set_tx_key(struct ieee80211_key *key, bool force)
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
@@ -555,9 +567,9 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
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
@@ -591,9 +603,9 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
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
@@ -790,7 +802,7 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	kfree_sensitive(key);
 }
 
-static void __ieee80211_key_destroy(struct ieee80211_key *key,
+static void __ieee80211_key_cleanup(struct ieee80211_key *key,
 				    bool delay_tailroom)
 {
 	if (key->local) {
@@ -808,6 +820,12 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
 			decrease_tailroom_need_count(sdata, 1);
 		}
 	}
+}
+
+static void __ieee80211_key_destroy(struct ieee80211_key *key,
+				    bool delay_tailroom)
+{
+	__ieee80211_key_cleanup(key, delay_tailroom);
 
 	ieee80211_key_free_common(key);
 }
@@ -928,14 +946,14 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
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
@@ -943,7 +961,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 			if (!old_key)
 				old_key = wiphy_dereference(sdata->local->hw.wiphy,
-							    link->gtk[idx]);
+							    link->tx_gtk[idx]);
 		}
 	}
 
@@ -975,7 +993,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	key->color = atomic_inc_return(&key_color);
 
 	/* keep this flag for easier access later */
-	if (sta && sta->sta.spp_amsdu)
+	if (pairwise && sta && sta->sta.spp_amsdu)
 		key->conf.flags |= IEEE80211_KEY_FLAG_SPP_AMSDU;
 
 	/* A CIP related key must be GCMP-256 (really GMAC-256) */
@@ -987,8 +1005,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	increment_tailroom_need_count(sdata);
 
-	ret = ieee80211_key_replace(sdata, link, sta, key->conf.flags,
-				    old_key, key);
+	ret = ieee80211_key_replace(sdata, link, sta, NULL,
+				    key->conf.flags, old_key, key);
 
 	if (!ret) {
 		ieee80211_debugfs_key_add(key);
@@ -1013,7 +1031,7 @@ void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 	 * Replace key with nothingness if it was ever used.
 	 */
 	if (key->sdata)
-		ieee80211_key_replace(key->sdata, NULL, key->sta,
+		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
 				      key->conf.flags, key, NULL);
 	ieee80211_key_destroy(key, delay_tailroom);
 }
@@ -1055,13 +1073,21 @@ ieee80211_key_iter(struct ieee80211_hw *hw,
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
@@ -1148,7 +1174,7 @@ static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_key_remove_beacon_default(sdata);
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
-		ieee80211_key_replace(key->sdata, NULL, key->sta,
+		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
 				      key->conf.flags, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
@@ -1168,7 +1194,7 @@ void ieee80211_remove_link_keys(struct ieee80211_link_data *link,
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
 		if (key->conf.link_id != link->link_id)
 			continue;
-		ieee80211_key_replace(key->sdata, link, key->sta,
+		ieee80211_key_replace(key->sdata, link, key->sta, NULL,
 				      key->conf.flags, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
@@ -1232,6 +1258,54 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
+				    struct link_sta_info *link_sta)
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
+		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
+			continue;
+		list_add(&key->list, &link_sta->key_destroy_list);
+		__ieee80211_key_cleanup(key, key->sdata->vif.type ==
+					     NL80211_IFTYPE_STATION);
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
+		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
+			continue;
+		list_add(&key->list, &link_sta->key_destroy_list);
+		__ieee80211_key_cleanup(key, key->sdata->vif.type ==
+					     NL80211_IFTYPE_STATION);
+	}
+}
+
+void ieee80211_free_link_sta_keys(struct link_sta_info *link_sta)
+{
+	struct ieee80211_key *key, *tmp;
+
+	list_for_each_entry_safe(key, tmp, &link_sta->key_destroy_list, list) {
+		list_del(&key->list);
+		ieee80211_key_free_common(key);
+	}
+}
+
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
@@ -1240,31 +1314,11 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 
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
@@ -1427,8 +1481,10 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
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
@@ -1450,29 +1506,43 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
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
 
@@ -1496,7 +1566,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 
 	key->conf.link_id = link_data->link_id;
 
-	err = ieee80211_key_link(key, link_data, NULL);
+	err = ieee80211_key_link(key, link_data, sta);
 	if (err)
 		return ERR_PTR(err);
 
@@ -1565,9 +1635,6 @@ int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 		    !(del_links_mask & BIT(key->conf.link_id)))
 			continue;
 
-		/* shouldn't happen for per-link keys */
-		WARN_ON(key->sta);
-
 		ieee80211_key_disable_hw_accel(key);
 	}
 
@@ -1576,9 +1643,6 @@ int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 		    !(add_links_mask & BIT(key->conf.link_id)))
 			continue;
 
-		/* shouldn't happen for per-link keys */
-		WARN_ON(key->sta);
-
 		ret = ieee80211_key_enable_hw_accel(key);
 		if (ret)
 			return ret;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index c8531b516c1c..db86bdc5744f 100644
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
@@ -164,6 +167,9 @@ void ieee80211_free_key_list(struct ieee80211_local *local,
 			     struct list_head *keys);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 			 bool force_synchronize);
+void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
+				    struct link_sta_info *link_sta);
+void ieee80211_free_link_sta_keys(struct link_sta_info *link_sta);
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta);
 void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2d60fe5b3f91..2084f7f554ad 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -868,7 +868,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			WIPHY_FLAG_4ADDR_AP |
 			WIPHY_FLAG_4ADDR_STATION |
 			WIPHY_FLAG_REPORTS_OBSS |
-			WIPHY_FLAG_OFFCHAN_TX;
+			WIPHY_FLAG_OFFCHAN_TX |
+			WIPHY_FLAG_CLIENT_AP_STA_GTK;
 
 	if (emulate_chanctx || ops->remain_on_channel)
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ecee9348c70d..905fd70491ce 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1969,37 +1969,34 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 } /* ieee80211_rx_h_sta_process */
 
 static struct ieee80211_key *
-ieee80211_rx_get_bigtk(struct ieee80211_rx_data *rx, int idx)
+ieee80211_rx_get_igtk_bigtk(struct ieee80211_rx_data *rx, bool beacon, int idx)
 {
-	struct ieee80211_key *key = NULL;
+	struct ieee80211_key *key;
 	int idx2;
 
-	/* Make sure key gets set if either BIGTK key index is set so that
+	/* Make sure key gets set if either (B)IGTK key index is set so that
 	 * ieee80211_drop_unencrypted_mgmt() can properly drop both unprotected
-	 * Beacon frames and Beacon frames that claim to use another BIGTK key
+	 * mgmt/beacon frames and frames that claim to use another (B)IGTK key
 	 * index (i.e., a key that we do not have).
 	 */
 
 	if (idx < 0) {
-		idx = NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS;
+		idx = NUM_DEFAULT_KEYS + beacon * NUM_DEFAULT_MGMT_KEYS;
 		idx2 = idx + 1;
 	} else {
-		if (idx == NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
+		if (idx == NUM_DEFAULT_KEYS + beacon * NUM_DEFAULT_MGMT_KEYS)
 			idx2 = idx + 1;
 		else
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
@@ -2092,7 +2089,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 			return RX_DROP_U_BAD_BCN_KEYIDX;
 		}
 
-		rx->key = ieee80211_rx_get_bigtk(rx, mmie_keyidx);
+		rx->key = ieee80211_rx_get_igtk_bigtk(rx, true, mmie_keyidx);
 		if (!rx->key)
 			return RX_CONTINUE; /* Beacon protection not in use */
 	} else if (mmie_keyidx >= 0) {
@@ -2109,10 +2106,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
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
@@ -2124,24 +2119,15 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		int i;
 
 		if (ieee80211_is_beacon(fc)) {
-			key = ieee80211_rx_get_bigtk(rx, -1);
+			key = ieee80211_rx_get_igtk_bigtk(rx, true, -1);
 		} else if (ieee80211_is_mgmt(fc) &&
 			   is_multicast_ether_addr(hdr->addr1)) {
-			key = rcu_dereference(rx->link->default_mgmt_key);
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
+			key = ieee80211_rx_get_igtk_bigtk(rx, false, -1);
+		} else if (rx->link_sta) {
+			for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+				key = rcu_dereference(rx->link_sta->rx_gtk[i]);
+				if (key)
+					break;
 			}
 		}
 		if (key)
@@ -2168,26 +2154,11 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
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
@@ -4854,6 +4825,7 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 
 	rcu_read_lock();
 	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	/* check WEP key to not erroneously consider it as no encryption */
 	if (!key)
 		key = rcu_dereference(sdata->default_unicast_key);
 	if (key) {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5c95ffee257d..790997592d8c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -353,6 +353,7 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 static void sta_info_free_link(struct link_sta_info *link_sta)
 {
 	free_percpu(link_sta->pcpu_rx_stats);
+	ieee80211_free_link_sta_keys(link_sta);
 }
 
 static void sta_link_free_rcu(struct rcu_head *head)
@@ -560,6 +561,8 @@ static int sta_info_alloc_link(struct ieee80211_local *local,
 	struct ieee80211_hw *hw = &local->hw;
 	int i;
 
+	INIT_LIST_HEAD(&link_info->key_destroy_list);
+
 	if (ieee80211_hw_check(hw, USES_RSS)) {
 		link_info->pcpu_rx_stats =
 			alloc_percpu_gfp(struct ieee80211_sta_rx_stats, gfp);
@@ -1575,6 +1578,17 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 	}
 
 	/* now keys can no longer be reached */
+	for (int i = 0; i < ARRAY_SIZE(sta->link); i++) {
+		struct link_sta_info *link_sta;
+
+		link_sta = wiphy_dereference(local->hw.wiphy, sta->link[i]);
+		if (!link_sta)
+			continue;
+
+		ieee80211_unlink_link_sta_keys(local, link_sta);
+		ieee80211_free_link_sta_keys(link_sta);
+	}
+
 	ieee80211_free_sta_keys(local, sta);
 
 	/* disable TIM bit - last chance to tell driver */
@@ -3513,11 +3527,16 @@ int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id)
 
 void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id)
 {
+	struct link_sta_info *link_sta = wiphy_dereference(sta->local->hw.wiphy,
+							   sta->link[link_id]);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u16 old_links = sta->sta.valid_links;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
+	if (!WARN_ON(!link_sta))
+		ieee80211_unlink_link_sta_keys(sta->local, link_sta);
+
 	sta->sta.valid_links &= ~BIT(link_id);
 
 	if (!WARN_ON(!test_sta_flag(sta, WLAN_STA_INSERTED)))
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8942541375b2..27f31fd7258e 100644
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
@@ -522,6 +522,7 @@ struct ieee80211_fragment_cache {
  * @uhr_dbe_enabled: for STAs as clients to an AP interface indicates
  *	DBE is enabled by the STA
  * @debugfs_dir: debug filesystem directory dentry
+ * @key_destroy_list: used during removal, keys to destroy
  * @pub: public (driver visible) link STA data
  */
 struct link_sta_info {
@@ -533,10 +534,10 @@ struct link_sta_info {
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
@@ -581,6 +582,8 @@ struct link_sta_info {
 	struct dentry *debugfs_dir;
 #endif
 
+	struct list_head key_destroy_list;
+
 	struct ieee80211_link_sta *pub;
 };
 
-- 
2.56.0

