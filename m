Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE45501F2F
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896779; cv=none; b=XSub+szD6ALkcLi2QUxP1CmrZyYZeBxWFgOFq6tbbGBQuMFiNz9KxeYczOt7dNDBwx5h6vtDXjh4ZwSuSI7DzIrvvciIlzQTtbSvm5pIVLnjjC8WVXxWqRVNgKc2m8l72epxdu0f01KTfKRrXmee3ar2dzasimWoY8dEQscTCZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896779; c=relaxed/simple;
	bh=nj+2jUf2c2cfqlLAWHA+sgod/Z7Jy2z8cDk1ViJ+Fv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b7c6X4W8sYhSVAmZGWCG7o8oa6+N0g/3UXdHCqdSdIvv7i3ru5sAzZjlDFqPKGO0YJAGUSRzAmZzmSajbJSiP58mzJrXI2LbPuCSW+8Rhc/syGdOOXEbfDm5mY6fd2NaOmCn/RK5obYIyzFEAj0U3mSi8oBByf1Rh24mG9D2KGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CzYLRCjP; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CzYLRCjP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ddxnYDMdlKL3vf0wIsDznFlOzeDs/TnKuwO77Iq1SWw=;
	t=1791896776; x=1793106376; b=CzYLRCjPuqqnWTpiHeyneKOY1KV1loDkm8qnSCpV5MLoD0U
	T7a4EzQi6H2TMe+x0Zksdwp0YJFEI2JPChgh/mzhrUha5Pi1H/BbvO92DsBbfk015tg5dKNHJ1u23
	FAewjhOSZWXrfbaoJPev4qcM/puAMOumKhcbNO3oZm8jaig4V0M1csz6SsgNTX+1PggFLyLZZxZ50
	UGTMfgHJUOFWpurNsqoYxINxEJEPPqC+6XlZ6wSV63Cg19aAP+w0CLUHivvjAWhKZqLysAnvAfbTp
	cUTGEpJX5wtbfdHdJiA7kakve2EFnXMcWhsvMNwvoNtvktReoQAGBUDpD2p7EOZg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCs-0000000HPRi-0FtK;
	Tue, 13 Oct 2026 15:06:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/11] wifi: mac80211: unify key finding/installation
Date: Tue, 13 Oct 2026 14:59:10 +0200
Message-ID: <20261013150605.5c4af7e9e784.Ic6343d1f8b0a7b11bb9723c7b1b17caa8bfdc395@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned

From: Johannes Berg <johannes.berg@intel.com>

There are multiple key lookups in the code now:
 - ieee80211_lookup_key() for get/del,
 - the old key in ieee80211_key_replace(), and
 - the new key place in ieee80211_key_link().

Introduce a new ieee80211_key_slot_lookup() function that
looks up the right place to install the key at (and get
the old key or information if needed), so that we can then
pass around that information to the functions needing it,
instead of doing the same kind of logic again and again.

There's one special case in it: if the cipher suite isn't
known (given as zero) then this is a case of looking up an
existing key for get/del, in which case it considers both
the TX GTKs and WEP keys.

Adjust all the code to use the new function throughout,
which in particular requires updates to deleting keys on
interface deletion, but at that point all keys except for
keys specific to the interface (or deflink) should already
be deleted.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 189 +++++++--------------
 net/mac80211/key.c | 404 ++++++++++++++++++++++++++-------------------
 net/mac80211/key.h |  47 +++++-
 3 files changed, 342 insertions(+), 298 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a8d6ff1af717..5ace9ee92c09 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -621,12 +621,10 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     const u8 *mac_addr, struct key_params *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-	struct ieee80211_link_data *link =
-		ieee80211_link_or_deflink(sdata, link_id, false);
 	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	bool cigtk = type == NL80211_KEYTYPE_CIGTK;
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta = NULL;
+	struct ieee80211_key_slot slot;
 	struct ieee80211_key *key;
 	int err;
 
@@ -635,9 +633,6 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
-	if (IS_ERR(link))
-		return PTR_ERR(link);
-
 	if (WARN_ON(pairwise && link_id >= 0))
 		return -EINVAL;
 
@@ -658,6 +653,27 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 		break;
 	}
 
+	err = ieee80211_key_slot_lookup(sdata, link_id, key_idx, params->cipher,
+					type, mac_addr, &slot);
+	if (err)
+		return err;
+	if (WARN_ON(!slot.key))
+		return -EINVAL;
+
+	/*
+	 * The ASSOC test makes sure the driver is ready to receive the key.
+	 * When wpa_supplicant has roamed using FT, it attempts to set the
+	 * key before association has completed, this rejects that attempt
+	 * so it will set the key again after association.
+	 *
+	 * With (re)association frame encryption enabled, wpa_supplicant may
+	 * deliver keys to mac80211 before the station has associated. Accept
+	 * that if the station is an Enhanced Privacy Protection (EPP) peer.
+	 */
+	if (slot.sta && !slot.sta->sta.epp_peer &&
+	    !test_sta_flag(slot.sta, WLAN_STA_ASSOC))
+		return -EINVAL;
+
 	key = ieee80211_key_alloc(params->cipher, key_idx, params->key_len,
 				  params->key, params->seq_len, params->seq);
 	if (IS_ERR(key))
@@ -666,42 +682,26 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (pairwise) {
 		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
 		key->conf.link_id = -1;
-	} else {
-		key->conf.link_id = link->link_id;
+	} else if (slot.link_sta) {
+		key->conf.link_id = slot.link_sta->link_id;
 
 		if (cigtk)
 			key->conf.flags |= IEEE80211_KEY_FLAG_CIP;
+	} else if (slot.link) {
+		key->conf.link_id = slot.link->link_id;
+
+		if (cigtk)
+			key->conf.flags |= IEEE80211_KEY_FLAG_CIP;
+	} else {
+		/* not reached - slot.link is set even for WEP/WPA-NONE */
+		WARN_ON(1);
+		ieee80211_key_free_unused(key);
+		return -EINVAL;
 	}
 
 	if (params->mode == NL80211_KEY_NO_TX)
 		key->conf.flags |= IEEE80211_KEY_FLAG_NO_AUTO_TX;
 
-	if (mac_addr) {
-		sta = sta_info_get_bss(sdata, mac_addr);
-		/*
-		 * The ASSOC test makes sure the driver is ready to
-		 * receive the key. When wpa_supplicant has roamed
-		 * using FT, it attempts to set the key before
-		 * association has completed, this rejects that attempt
-		 * so it will set the key again after association.
-		 *
-		 * With (re)association frame encryption enabled, cfg80211
-		 * may deliver keys to mac80211 before the station has
-		 * associated. In that case, accept the key if the station
-		 * is an Enhanced Privacy Protection (EPP) peer.
-		 * If (re)association frame encryption support is not present,
-		 * cfg80211 will not allow key installation in non‑AP STA mode.
-		 *
-		 * TODO: accept the key if we have a station entry and
-		 *	 add it to the device after the station associates.
-		 */
-		if (!sta || (!sta->sta.epp_peer &&
-			     !test_sta_flag(sta, WLAN_STA_ASSOC))) {
-			ieee80211_key_free_unused(key);
-			return -ENOENT;
-		}
-	}
-
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
 		/* mostly handled by cfg80211, but make sure */
@@ -717,7 +717,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_NAN_DATA:
 		/* Keys without a station are used for TX only */
-		if (sta && test_sta_flag(sta, WLAN_STA_MFP))
+		if (slot.sta && test_sta_flag(slot.sta, WLAN_STA_MFP))
 			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
 		break;
 	case NL80211_IFTYPE_ADHOC:
@@ -740,10 +740,11 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_IFTYPE_OCB:
 		/* shouldn't happen */
 		WARN_ON_ONCE(1);
-		break;
+		ieee80211_key_free_unused(key);
+		return -EINVAL;
 	}
 
-	err = ieee80211_key_link(key, link, sta);
+	err = ieee80211_key_link(sdata, &slot, key);
 	/* KRACK protection, shouldn't happen but just silently accept key */
 	if (err == -EALREADY)
 		err = 0;
@@ -751,88 +752,28 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	return err;
 }
 
-static struct ieee80211_key *
-ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
-		     u8 key_idx, enum nl80211_key_type type,
-		     const u8 *mac_addr)
-{
-	struct ieee80211_local *local __maybe_unused = sdata->local;
-	struct ieee80211_link_data *link = &sdata->deflink;
-	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
-	bool cigtk = type == NL80211_KEYTYPE_CIGTK;
-	struct ieee80211_key *key;
-
-	if (link_id >= 0) {
-		link = sdata_dereference(sdata->link[link_id], sdata);
-		if (!link)
-			return NULL;
-	}
-
-	if (mac_addr) {
-		struct sta_info *sta;
-		struct link_sta_info *link_sta;
-
-		sta = sta_info_get_bss(sdata, mac_addr);
-		if (!sta)
-			return NULL;
-
-		if (link_id >= 0) {
-			link_sta = rcu_dereference_check(sta->link[link_id],
-							 lockdep_is_held(&local->hw.wiphy->mtx));
-			if (!link_sta)
-				return NULL;
-		} else {
-			link_sta = &sta->deflink;
-		}
-
-		if (pairwise && key_idx < NUM_DEFAULT_KEYS)
-			return wiphy_dereference(local->hw.wiphy,
-						 sta->ptk[key_idx]);
-
-		if (cigtk && key_idx < NUM_CTRL_KEYS)
-			return wiphy_dereference(local->hw.wiphy,
-						 link_sta->rx_cigtk[key_idx]);
-
-		if (!pairwise && !cigtk &&
-		    key_idx < NUM_DEFAULT_KEYS +
-			      NUM_DEFAULT_MGMT_KEYS +
-			      NUM_DEFAULT_BEACON_KEYS)
-			return wiphy_dereference(local->hw.wiphy,
-						 link_sta->rx_gtk[key_idx]);
-
-		return NULL;
-	}
-
-	if (cigtk)
-		return wiphy_dereference(local->hw.wiphy,
-					 link->tx_cigtk[key_idx]);
-
-	key = wiphy_dereference(local->hw.wiphy, link->tx_gtk[key_idx]);
-	if (key)
-		return key;
-
-	/* or maybe it was a WEP key */
-	if (key_idx < NUM_DEFAULT_KEYS)
-		return wiphy_dereference(local->hw.wiphy, sdata->keys[key_idx]);
-
-	return NULL;
-}
-
 static int ieee80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     int link_id, u8 key_idx,
 			     enum nl80211_key_type type, const u8 *mac_addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_key *key;
+	struct ieee80211_key_slot slot;
+	int err;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	key = ieee80211_lookup_key(sdata, link_id, key_idx, type, mac_addr);
-	if (!key)
+	err = ieee80211_key_slot_lookup(sdata, link_id, key_idx, 0,
+					type, mac_addr, &slot);
+	if (err)
+		return err;
+	if (WARN_ON(!slot.key))
 		return -ENOENT;
 
-	ieee80211_key_free(key, sdata->vif.type == NL80211_IFTYPE_STATION);
+	if (!rcu_access_pointer(*slot.key))
+		return -ENOENT;
+
+	ieee80211_key_free(sdata, &slot, sdata->vif.type == NL80211_IFTYPE_STATION);
 
 	return 0;
 }
@@ -844,25 +785,27 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
 {
-	struct ieee80211_sub_if_data *sdata;
-	u8 seq[6] = {0};
-	struct key_params params;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_key_seq kseq = {};
+	struct ieee80211_key_slot slot;
+	struct key_params params = {};
 	struct ieee80211_key *key;
+	u8 seq[6] = {0};
 	u64 pn64;
 	u32 iv32;
 	u16 iv16;
-	int err = -ENOENT;
-	struct ieee80211_key_seq kseq = {};
+	int err;
 
-	sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	err = ieee80211_key_slot_lookup(sdata, link_id, key_idx, 0,
+					type, mac_addr, &slot);
+	if (err)
+		return err;
+	if (WARN_ON(!slot.key))
+		return -ENOENT;
 
-	rcu_read_lock();
-
-	key = ieee80211_lookup_key(sdata, link_id, key_idx, type, mac_addr);
+	key = wiphy_dereference(wiphy, *slot.key);
 	if (!key)
-		goto out;
-
-	memset(&params, 0, sizeof(params));
+		return -ENOENT;
 
 	params.cipher = key->conf.cipher;
 
@@ -933,11 +876,7 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	callback(cookie, &params);
-	err = 0;
-
- out:
-	rcu_read_unlock();
-	return err;
+	return 0;
 }
 
 static int ieee80211_config_default_key(struct wiphy *wiphy,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 35f44a856bd3..66bc8b1a4cbf 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -468,69 +468,131 @@ void ieee80211_set_default_beacon_key(struct ieee80211_link_data *link,
 	__ieee80211_set_default_beacon_key(link, idx);
 }
 
+int ieee80211_key_slot_lookup(struct ieee80211_sub_if_data *sdata,
+			      int link_id, u8 key_idx, u32 cipher,
+			      enum nl80211_key_type type,
+			      const u8 *mac_addr,
+			      struct ieee80211_key_slot *slot)
+{
+	struct ieee80211_local *local __maybe_unused = sdata->local;
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
+	bool cigtk = type == NL80211_KEYTYPE_CIGTK;
+	bool is_wep = cipher == WLAN_CIPHER_SUITE_WEP40 ||
+		      cipher == WLAN_CIPHER_SUITE_WEP104;
+	int err;
+
+	memset(slot, 0, sizeof(*slot));
+
+	if (mac_addr) {
+		slot->sta = sta_info_get_bss(sdata, mac_addr);
+		if (!slot->sta) {
+			err = -ENOENT;
+			goto fail;
+		}
+
+		if (pairwise && key_idx < NUM_DEFAULT_KEYS) {
+			slot->key = &slot->sta->ptk[key_idx];
+			return 0;
+		}
+
+		if (link_id >= 0) {
+			slot->link_sta = wiphy_dereference(local->hw.wiphy,
+							   slot->sta->link[link_id]);
+			if (!slot->link_sta) {
+				err = -ENOENT;
+				goto fail;
+			}
+		} else if (!ieee80211_vif_is_mld(&sdata->vif)) {
+			slot->link_sta = &slot->sta->deflink;
+		} else {
+			err = -EINVAL;
+			goto fail;
+		}
+
+		if (cigtk) {
+			slot->key = &slot->link_sta->rx_cigtk[key_idx];
+			return 0;
+		}
+
+		if (!pairwise &&
+		    key_idx < NUM_DEFAULT_KEYS +
+			      NUM_DEFAULT_MGMT_KEYS +
+			      NUM_DEFAULT_BEACON_KEYS) {
+			slot->key = &slot->link_sta->rx_gtk[key_idx];
+			return 0;
+		}
+
+		err = -EINVAL;
+		goto fail;
+	}
+
+	if (is_wep && key_idx < NUM_DEFAULT_KEYS) {
+		/* WEP keys can also be default/deflink TX keys */
+		slot->link = &sdata->deflink;
+		slot->key = &sdata->keys[key_idx];
+		return 0;
+	}
+
+	if (link_id >= 0) {
+		slot->link = sdata_dereference(sdata->link[link_id], sdata);
+		if (!slot->link) {
+			err = -ENOLINK;
+			goto fail;
+		}
+	} else {
+		slot->link = &sdata->deflink;
+	}
+
+	if (cigtk) {
+		slot->key = &slot->link->tx_cigtk[key_idx];
+		return 0;
+	}
+
+	slot->key = &slot->link->tx_gtk[key_idx];
+	if (cipher != 0)
+		return 0;
+
+	/* handle the special case for key lookup with cipher==0 */
+	if (rcu_access_pointer(*slot->key))
+		return 0;
+	if (key_idx < NUM_DEFAULT_KEYS) {
+		slot->key = &sdata->keys[key_idx];
+		return 0;
+	}
+
+	err = -EINVAL;
+fail:
+	memset(slot, 0, sizeof(*slot));
+	return err;
+}
+
 static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_link_data *link,
-				 struct sta_info *sta,
-				 struct link_sta_info *link_sta,
-				 enum ieee80211_key_flags flags,
+				 struct ieee80211_key_slot *slot,
 				 struct ieee80211_key *old,
 				 struct ieee80211_key *new)
 {
-	bool pairwise = flags & IEEE80211_KEY_FLAG_PAIRWISE;
-	bool cip = flags & IEEE80211_KEY_FLAG_CIP;
-	int link_id;
-	int idx;
-	int ret = 0;
 	bool defunikey, defmultikey, defmgmtkey, defbeaconkey;
-	bool is_wep;
+	struct ieee80211_local *local = sdata->local;
+	bool pairwise;
+	int ret = 0;
+	u32 flags;
 
-	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	/* the old key is passed in for convenience, but validate it */
+	WARN_ON(old != rcu_access_pointer(*slot->key));
 
 	/* caller must provide at least one old/new */
 	if (WARN_ON(!new && !old))
 		return 0;
 
-	if (new) {
-		idx = new->conf.keyidx;
-		is_wep = new->conf.cipher == WLAN_CIPHER_SUITE_WEP40 ||
-			 new->conf.cipher == WLAN_CIPHER_SUITE_WEP104;
-		link_id = new->conf.link_id;
-	} else {
-		idx = old->conf.keyidx;
-		is_wep = old->conf.cipher == WLAN_CIPHER_SUITE_WEP40 ||
-			 old->conf.cipher == WLAN_CIPHER_SUITE_WEP104;
-		link_id = old->conf.link_id;
-	}
-
-	if (WARN(old && old->conf.link_id != link_id,
-		 "old link ID %d doesn't match new link ID %d\n",
-		 old->conf.link_id, link_id))
-		return -EINVAL;
-
-	if (link_id >= 0) {
-		if (!link) {
-			link = sdata_dereference(sdata->link[link_id], sdata);
-			if (!link)
-				return -ENOLINK;
-		}
-
-		if (sta && !link_sta) {
-			link_sta = rcu_dereference_protected(sta->link[link_id],
-							     lockdep_is_held(&sta->local->hw.wiphy->mtx));
-			if (!link_sta)
-				return -ENOLINK;
-		}
-	} else {
-		link = &sdata->deflink;
-		link_sta = sta ? &sta->deflink : NULL;
-	}
-
-	if ((is_wep || pairwise) && idx >= NUM_DEFAULT_KEYS)
-		return -EINVAL;
+	flags = old ? old->conf.flags : new->conf.flags;
+	pairwise = flags & IEEE80211_KEY_FLAG_PAIRWISE;
 
 	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
+	WARN_ON(new && old && new->conf.link_id != old->conf.link_id);
 
-	if (new && sta && pairwise) {
+	if (new && slot->sta && pairwise) {
 		/* Unicast rekey needs special handling. With Extended Key ID
 		 * old is still NULL for the first rekey.
 		 */
@@ -545,10 +607,10 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				ret = ieee80211_key_enable_hw_accel(new);
 		}
 	} else {
-		if (!new->local->wowlan) {
+		if (!local->wowlan) {
 			ret = ieee80211_key_enable_hw_accel(new);
-		} else if (link_id < 0 || !sdata->vif.active_links ||
-			 BIT(link_id) & sdata->vif.active_links) {
+		} else if (new->conf.link_id < 0 || !sdata->vif.active_links ||
+			 BIT(new->conf.link_id) & sdata->vif.active_links) {
 			new->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 			if (!(new->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
 						 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
@@ -566,35 +628,36 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		spin_unlock_bh(&sdata->local->key_lock);
 	}
 
-	if (sta) {
+	rcu_assign_pointer(*slot->key, new);
+
+	if (slot->sta) {
 		if (pairwise) {
-			rcu_assign_pointer(sta->ptk[idx], new);
 			if (new &&
 			    !(new->conf.flags & IEEE80211_KEY_FLAG_NO_AUTO_TX))
 				_ieee80211_set_tx_key(new, true);
-		} else if (cip) {
-			rcu_assign_pointer(link_sta->rx_cigtk[idx], new);
-		} else {
-			rcu_assign_pointer(link_sta->rx_gtk[idx], new);
+
+			/*
+			 * Only needed for transition from no key -> key.
+			 * Still triggers unnecessary when using Extended Key ID
+			 * and installing the second key ID the first time.
+			 */
+			if (new && !old)
+				ieee80211_check_fast_rx(slot->sta);
 		}
-		/* Only needed for transition from no key -> key.
-		 * Still triggers unnecessary when using Extended Key ID
-		 * and installing the second key ID the first time.
-		 */
-		if (new && !old)
-			ieee80211_check_fast_rx(sta);
-	} else {
+	} else if (slot->link) {
+		struct ieee80211_link_data *link = slot->link;
+
 		defunikey = old &&
-			old == wiphy_dereference(sdata->local->hw.wiphy,
+			old == wiphy_dereference(local->hw.wiphy,
 						 sdata->default_unicast_key);
 		defmultikey = old &&
-			old == wiphy_dereference(sdata->local->hw.wiphy,
+			old == wiphy_dereference(local->hw.wiphy,
 						 link->default_multicast_key);
 		defmgmtkey = old &&
-			old == wiphy_dereference(sdata->local->hw.wiphy,
+			old == wiphy_dereference(local->hw.wiphy,
 						 link->default_mgmt_key);
 		defbeaconkey = old &&
-			old == wiphy_dereference(sdata->local->hw.wiphy,
+			old == wiphy_dereference(local->hw.wiphy,
 						 link->default_beacon_key);
 
 		if (defunikey && !new)
@@ -606,13 +669,6 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		if (defbeaconkey && !new)
 			__ieee80211_set_default_beacon_key(link, -1);
 
-		if (is_wep || pairwise)
-			rcu_assign_pointer(sdata->keys[idx], new);
-		else if (cip)
-			rcu_assign_pointer(link->tx_cigtk[idx], new);
-		else
-			rcu_assign_pointer(link->tx_gtk[idx], new);
-
 		if (defunikey && new)
 			__ieee80211_set_default_key(link, new->conf.keyidx,
 						    true, false);
@@ -893,32 +949,31 @@ static bool ieee80211_key_identical(struct ieee80211_sub_if_data *sdata,
 	return !crypto_memneq(tk_old, tk_new, new->conf.keylen);
 }
 
-int ieee80211_key_link(struct ieee80211_key *key,
-		       struct ieee80211_link_data *link,
-		       struct sta_info *sta)
+int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_key_slot *slot,
+		       struct ieee80211_key *key)
 {
-	struct ieee80211_sub_if_data *sdata = link->sdata;
-	static atomic_t key_color = ATOMIC_INIT(0);
-	struct ieee80211_key *old_key = NULL;
-	int idx = key->conf.keyidx;
-	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
 	/*
 	 * We want to delay tailroom updates only for station - in that
 	 * case it helps roaming speed, but in other cases it hurts and
 	 * can cause warnings to appear.
 	 */
 	bool delay_tailroom = sdata->vif.type == NL80211_IFTYPE_STATION;
+	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
+	static atomic_t key_color = ATOMIC_INIT(0);
+	struct ieee80211_key *old_key = NULL;
+	int idx = key->conf.keyidx;
 	int ret;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	if (sta && pairwise) {
+	old_key = wiphy_dereference(sdata->local->hw.wiphy, *slot->key);
+
+	if (pairwise) {
 		struct ieee80211_key *alt_key;
 
-		old_key = wiphy_dereference(sdata->local->hw.wiphy,
-					    sta->ptk[idx]);
 		alt_key = wiphy_dereference(sdata->local->hw.wiphy,
-					    sta->ptk[idx ^ 1]);
+					    slot->sta->ptk[idx ^ 1]);
 
 		/*
 		 * The rekey code assumes that the old and new key are using
@@ -935,44 +990,10 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		}
 
 		/* Set CIP flag if enabled for the station */
-		if (sta->sta.cip)
+		if (slot->sta->sta.cip)
 			key->conf.flags |= IEEE80211_KEY_FLAG_CIP;
-	} else if (sta) {
-		struct link_sta_info *link_sta = &sta->deflink;
-		int link_id = key->conf.link_id;
-
-		if (link_id >= 0) {
-			link_sta = rcu_dereference_protected(sta->link[link_id],
-							     lockdep_is_held(&sta->local->hw.wiphy->mtx));
-			if (!link_sta) {
-				ret = -ENOLINK;
-				goto out;
-			}
-		}
-
-		if (key->conf.flags & IEEE80211_KEY_FLAG_CIP)
-			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    link_sta->rx_cigtk[idx]);
-		else
-			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    link_sta->rx_gtk[idx]);
 	} else {
-		if (key->conf.flags & IEEE80211_KEY_FLAG_CIP) {
-			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    link->tx_cigtk[idx]);
-		} else {
-			if (idx < NUM_DEFAULT_KEYS)
-				old_key = wiphy_dereference(sdata->local->hw.wiphy,
-							    sdata->keys[idx]);
-
-			if (!old_key)
-				old_key = wiphy_dereference(sdata->local->hw.wiphy,
-							    link->tx_gtk[idx]);
-		}
-	}
-
-	/* Non-pairwise keys must also not switch the cipher on rekey */
-	if (!pairwise) {
+		/* Non-pairwise keys must also not switch the cipher on rekey */
 		if (old_key && old_key->conf.cipher != key->conf.cipher) {
 			ret = -EOPNOTSUPP;
 			goto out;
@@ -990,7 +1011,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	key->local = sdata->local;
 	key->sdata = sdata;
-	key->sta = sta;
+	key->sta = slot->sta;
 
 	/*
 	 * Assign a unique ID to every key so we can easily prevent mixed
@@ -999,7 +1020,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	key->color = atomic_inc_return(&key_color);
 
 	/* keep this flag for easier access later */
-	if (pairwise && sta && sta->sta.spp_amsdu)
+	if (pairwise && slot->sta->sta.spp_amsdu)
 		key->conf.flags |= IEEE80211_KEY_FLAG_SPP_AMSDU;
 
 	/* A CIP related key must be GCMP-256 (really GMAC-256) */
@@ -1011,34 +1032,36 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	increment_tailroom_need_count(sdata);
 
-	ret = ieee80211_key_replace(sdata, link, sta, NULL,
-				    key->conf.flags, old_key, key);
-
-	if (!ret) {
-		ieee80211_debugfs_key_add(key);
-		ieee80211_key_destroy(old_key, delay_tailroom);
-	} else {
-		ieee80211_key_free(key, delay_tailroom);
+	ret = ieee80211_key_replace(sdata, slot, old_key, key);
+	if (ret) {
+		decrease_tailroom_need_count(sdata, 1);
+		key->local = NULL;
+		key->sdata = NULL;
+		goto out;
 	}
 
-	key = NULL;
+	ieee80211_debugfs_key_add(key);
+	ieee80211_key_destroy(old_key, delay_tailroom);
 
+	return 0;
  out:
 	ieee80211_key_free_unused(key);
 	return ret;
 }
 
-void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
+void ieee80211_key_free(struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_key_slot *slot,
+			bool delay_tailroom)
 {
+	struct ieee80211_key *key;
+
+	key = sdata_dereference(*slot->key, sdata);
 	if (!key)
 		return;
 
-	/*
-	 * Replace key with nothingness if it was ever used.
-	 */
+	/* replace key with nothing if it was ever used */
 	if (key->sdata)
-		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
-				      key->conf.flags, key, NULL);
+		ieee80211_key_replace(key->sdata, slot, key, NULL);
 	ieee80211_key_destroy(key, delay_tailroom);
 }
 
@@ -1171,8 +1194,6 @@ EXPORT_SYMBOL(ieee80211_iter_keys_atomic);
 static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 				      struct list_head *keys)
 {
-	struct ieee80211_key *key, *tmp;
-
 	decrease_tailroom_need_count(sdata,
 				     sdata->crypto_tx_tailroom_pending_dec);
 	sdata->crypto_tx_tailroom_pending_dec = 0;
@@ -1180,9 +1201,19 @@ static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 	ieee80211_debugfs_key_remove_beacon_default(sdata);
 
-	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
-		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
-				      key->conf.flags, key, NULL);
+	for (int i = 0; i < ARRAY_SIZE(sdata->keys); i++) {
+		struct ieee80211_key_slot slot = {
+			/* WEP keys can also be default/deflink TX keys */
+			.link = &sdata->deflink,
+			.key = &sdata->keys[i],
+		};
+		struct ieee80211_key *key;
+
+		key = sdata_dereference(*slot.key, sdata);
+		if (!key)
+			continue;
+
+		ieee80211_key_replace(sdata, &slot, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
 
@@ -1194,15 +1225,33 @@ void ieee80211_remove_link_keys(struct ieee80211_link_data *link,
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_key *key, *tmp;
+	struct ieee80211_key_slot slot = {
+		.link = link,
+	};
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
-		if (key->conf.link_id != link->link_id)
+	for (int i = 0; i < ARRAY_SIZE(link->tx_gtk); i++) {
+		struct ieee80211_key *key;
+
+		slot.key = &link->tx_gtk[i];
+		key = sdata_dereference(*slot.key, sdata);
+		if (!key)
 			continue;
-		ieee80211_key_replace(key->sdata, link, key->sta, NULL,
-				      key->conf.flags, key, NULL);
+
+		ieee80211_key_replace(sdata, &slot, key, NULL);
+		list_add_tail(&key->list, keys);
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(link->tx_cigtk); i++) {
+		struct ieee80211_key *key;
+
+		slot.key = &link->tx_cigtk[i];
+		key = sdata_dereference(*slot.key, sdata);
+		if (!key)
+			continue;
+
+		ieee80211_key_replace(sdata, &slot, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
 }
@@ -1232,13 +1281,18 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	ieee80211_remove_link_keys(&sdata->deflink, &keys);
 	ieee80211_free_keys_iface(sdata, &keys);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
+			ieee80211_remove_link_keys(&vlan->deflink, &keys);
 			ieee80211_free_keys_iface(vlan, &keys);
+		}
 	}
 
+	WARN_ON(!list_empty(&sdata->key_list));
+
 	if (!list_empty(&keys) || force_synchronize)
 		synchronize_net();
 	list_for_each_entry_safe(key, tmp, &keys, list)
@@ -1268,17 +1322,22 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 				    struct link_sta_info *link_sta)
 {
+	struct ieee80211_key_slot slot = {
+		.sta = link_sta->sta,
+		.link_sta = link_sta,
+	};
+
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	for (int i = 0; i < ARRAY_SIZE(link_sta->rx_gtk); i++) {
 		struct ieee80211_key *key;
 		int ret;
 
-		key = wiphy_dereference(local->hw.wiphy, link_sta->rx_gtk[i]);
+		slot.key = &link_sta->rx_gtk[i];
+		key = wiphy_dereference(local->hw.wiphy, *slot.key);
 		if (!key)
 			continue;
-		ret = ieee80211_key_replace(key->sdata, NULL, key->sta, link_sta,
-					    key->conf.flags, key, NULL);
+		ret = ieee80211_key_replace(key->sdata, &slot, key, NULL);
 		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
 			continue;
 		list_add(&key->list, &link_sta->key_destroy_list);
@@ -1290,11 +1349,11 @@ void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 		struct ieee80211_key *key;
 		int ret;
 
-		key = wiphy_dereference(local->hw.wiphy, link_sta->rx_cigtk[i]);
+		slot.key = &link_sta->rx_cigtk[i];
+		key = wiphy_dereference(local->hw.wiphy, *slot.key);
 		if (!key)
 			continue;
-		ret = ieee80211_key_replace(key->sdata, NULL, key->sta, link_sta,
-					    key->conf.flags, key, NULL);
+		ret = ieee80211_key_replace(key->sdata, &slot, key, NULL);
 		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
 			continue;
 		list_add(&key->list, &link_sta->key_destroy_list);
@@ -1316,17 +1375,20 @@ void ieee80211_free_link_sta_keys(struct link_sta_info *link_sta)
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
-	struct ieee80211_key *key;
-	int i;
+	struct ieee80211_key_slot slot = {
+		.sta = sta,
+	};
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-		key = wiphy_dereference(local->hw.wiphy, sta->ptk[i]);
+	for (int i = 0; i < ARRAY_SIZE(sta->ptk); i++) {
+		struct ieee80211_key *key;
+
+		slot.key = &sta->ptk[i];
+		key = wiphy_dereference(local->hw.wiphy, *slot.key);
 		if (!key)
 			continue;
-		ieee80211_key_replace(key->sdata, NULL, key->sta, NULL,
-				      key->conf.flags, key, NULL);
+		ieee80211_key_replace(key->sdata, &slot, key, NULL);
 		__ieee80211_key_destroy(key, key->sdata->vif.type ==
 					NL80211_IFTYPE_STATION);
 	}
@@ -1488,6 +1550,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_key_slot slot = {};
 	struct link_sta_info *link_sta;
 	struct ieee80211_key *prev_key;
 	struct ieee80211_key *key;
@@ -1526,12 +1589,15 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 			return ERR_PTR(-ENOLINK);
 	}
 
+	slot.sta = sta;
+	slot.link_sta = link_sta;
+
 	if (cigtk)
-		prev_key = wiphy_dereference(local->hw.wiphy,
-					     link_sta->rx_cigtk[idx]);
+		slot.key = &link_sta->rx_cigtk[idx];
 	else
-		prev_key = wiphy_dereference(local->hw.wiphy,
-					     link_sta->rx_gtk[idx]);
+		slot.key = &link_sta->rx_gtk[idx];
+
+	prev_key = wiphy_dereference(local->hw.wiphy, *slot.key);
 
 	if (!prev_key) {
 		if (cigtk) {
@@ -1573,7 +1639,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 
 	key->conf.link_id = link_data->link_id;
 
-	err = ieee80211_key_link(key, link_data, sta);
+	err = ieee80211_key_link(sdata, &slot, key);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index db86bdc5744f..2fc985d41e8f 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -141,6 +141,43 @@ struct ieee80211_key {
 /* from sta_info.h, but cannot include that */
 struct link_sta_info;
 
+struct ieee80211_key_slot {
+	struct ieee80211_key __rcu **key;
+
+	struct sta_info *sta;
+	struct link_sta_info *link_sta;
+
+	struct ieee80211_link_data *link;
+};
+
+/**
+ * ieee80211_key_slot_lookup - look up a key installation slot
+ * @sdata: the interface
+ * @link_id: The link ID, or -1.
+ * @key_idx: The key ID.
+ * @cipher: The cipher suite, may be 0 if not known, which implies
+ *	the lookup is for getting key information or deleting a key,
+ *	which in turn implies the function should return a used slot.
+ *	Note this is all only relevant for distinguishing AP-side
+ *	group keys (TX only) and WEP/WPA-NONE keys.
+ * @type: the key type (from nl80211)
+ * @mac_addr: the station's MAC address, if any
+ * @slot: the output data filled by the function
+ *
+ * Return: an error code, or zero on success, in which case
+ *	the slot information is filled:
+ *	- the key pointer is always given
+ *	- the sta for keys related to a station
+ *	  (pairwise, RX group keys)
+ *	- the link_sta for RX group keys
+ *	- the link for TX group keys (and WEP)
+ */
+int ieee80211_key_slot_lookup(struct ieee80211_sub_if_data *sdata,
+			      int link_id, u8 key_idx, u32 cipher,
+			      enum nl80211_key_type type,
+			      const u8 *mac_addr,
+			      struct ieee80211_key_slot *slot);
+
 struct ieee80211_key *
 ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		    const u8 *key_data,
@@ -149,11 +186,13 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
  * Insert a key into data structures (sdata, sta if necessary)
  * to make it used, free old key. On failure, also free the new key.
  */
-int ieee80211_key_link(struct ieee80211_key *key,
-		       struct ieee80211_link_data *link,
-		       struct sta_info *sta);
+int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_key_slot *slot,
+		       struct ieee80211_key *key);
 int ieee80211_set_tx_key(struct ieee80211_key *key);
-void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
+void ieee80211_key_free(struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_key_slot *slot,
+			bool delay_tailroom);
 void ieee80211_key_free_unused(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_link_data *link, int idx,
 			       bool uni, bool multi);
-- 
2.56.0

