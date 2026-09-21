Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219D49AA35;
	Mon, 21 Sep 2026 12:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994483; cv=none; b=ZXDwnAkxynoNsUZYbZl5WgOCkdAA5fUYJdkkBYOfZG5BXHCXCgxJ/WMypQxaYlaUwPQH9FfWDHs7DW/hrPmv2ux5YnlcohXmVI5iLGVKsRWtrkCNI/6jMrWt8oCq2VkoNCufVYp1DMTw9zLnZYQpS0DCTXjY4ukXcnbUZlQ4s9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994483; c=relaxed/simple;
	bh=719vK3JXJVyIlOC+BsTUGZVJL43A78B4i+HxMTMWxSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMAdGLM0xR1EgDR9zoXodA2RYWrYWwpN0YItnhCytqKCo+TGk1f93Fb62HPcuTNlNrPx2LBQKvjsxhk9sdmkuTI7UbRV7a6H7sJPPg4ls8MbltXsaH1Is9AisYNVuAuVzS6oP3HiHGXGij2Bcu5ldaaWu0E65eDWzvONbf2GlIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=H66/HKWU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="H66/HKWU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=jCEjQb5Yf+MCZS93RWwuJR45sbQRwVbfxd0kW1Pvyug=;
	t=1789994480; x=1791204080; b=H66/HKWUiIAjlmx6yZyIhdTQBfPaY0NdzxOFyMh/jvptBPq
	ZzG1mCX/2aAKqg6nqTK7f4QyMzKmNrnH3UkyutEN4RKwM1dRdbF8ppzahQRIKReSJ8C6DDvVU0Qlw
	suYB7s0d9CGd8WOVFgyNtxwRyZ6u+GXmlIO5Rh0EdKU7wiyPkURed6B64mKli9MGQ9ziDHGZcnUpY
	h9E1BcIF6PQkYS3epIVP1MutgyaNjJG6nHsBGp4Q5iWusP3SFmPZZYfL3wqfluwn0+eSxg2nxLUUb
	/J1lVq7qH/WIp6JzCVGlHNk4HddqbLM0NCKdAoIgOGp4kR3Go+SYA9Ij7bFrH8Rw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x8dKf-00000005oVO-03IX;
	Mon, 21 Sep 2026 14:41:17 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	brcm80211@lists.linux.dev,
	libertas-dev@lists.infradead.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 6/7] wifi: mac80211: add Control Integrity Protocol handling
Date: Mon, 21 Sep 2026 14:40:55 +0200
Message-ID: <20260921144048.f032c70e0bc2.I30cf9ae29629188b8674e2268a6b592c1a63128b@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921124048.4146576-9-benjamin@sipsolutions.net>
References: <20260921124048.4146576-9-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

Add the handling of CIP during association, when adding a station in AP
mode and also add some checks whether the keys are being installed
correctly.

For internal use, add a new key flag CIP that is used for both the
pairwise key and CIGTK. The CIGTK will then have the MCAST_KEY and CIP
flags set.

As the CIGTK uses key indices 0 and 1, add a new variable to track it
separately from the other GTKs.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>

---

v3:
- Store the CIP capa in the link STA as it contains multiple values now
---
 include/net/mac80211.h     |  8 ++++
 net/mac80211/cfg.c         | 22 ++++++++-
 net/mac80211/ieee80211_i.h |  2 +
 net/mac80211/key.c         | 94 +++++++++++++++++++++++++++++---------
 net/mac80211/key.h         |  3 +-
 net/mac80211/mlme.c        | 20 +++++++-
 net/mac80211/sta_info.h    |  2 +
 7 files changed, 126 insertions(+), 25 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c9d0e1203d1b..15ac95048ce5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2395,6 +2395,8 @@ static inline bool lockdep_vif_wiphy_mutex_held(struct ieee80211_vif *vif)
  *	number generation only
  * @IEEE80211_KEY_FLAG_SPP_AMSDU: SPP A-MSDUs can be used with this key
  *	(set by mac80211 from the sta->spp_amsdu flag)
+ * @IEEE80211_KEY_FLAG_CIP: This key is used for the Control Integrity
+ *	Protocol, and is either a pairwise key or a CIGTK.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(0),
@@ -2409,6 +2411,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_NO_AUTO_TX		= BIT(9),
 	IEEE80211_KEY_FLAG_GENERATE_MMIE	= BIT(10),
 	IEEE80211_KEY_FLAG_SPP_AMSDU		= BIT(11),
+	IEEE80211_KEY_FLAG_CIP			= BIT(12),
 };
 
 /**
@@ -2629,6 +2632,7 @@ struct ieee80211_sta_aggregates {
  * @eht_cap: EHT capabilities of this STA
  * @uhr_cap: UHR capabilities of this STA
  * @s1g_cap: S1G capabilities of this STA
+ * @cip_cap: the CIP capabilities of this STA (or zero)
  * @agg: per-link data for multi-link aggregation
  * @bandwidth: current bandwidth the station can receive with.
  *	This is the minimum between the peer's capabilities and our own
@@ -2657,6 +2661,7 @@ struct ieee80211_link_sta {
 	struct ieee80211_sta_eht_cap eht_cap;
 	struct ieee80211_sta_uhr_cap uhr_cap;
 	struct ieee80211_sta_s1g_cap s1g_cap;
+	u8 cip_cap;
 
 	struct ieee80211_sta_aggregates agg;
 
@@ -2720,6 +2725,7 @@ struct ieee80211_link_sta {
  * @valid_links: bitmap of valid links, or 0 for non-MLO
  * @spp_amsdu: indicates whether the STA uses SPP A-MSDU or not.
  * @epp_peer: indicates that the peer is an EPP peer.
+ * @cip: indicates whether the STA uses control frame protection or not.
  * @nmi: For NDI stations, pointer to the NMI station of the peer.
  * @nan_sched: NAN peer schedule for this station. Valid only for NMI stations.
  * @ext_mld_capa_ops: the MLD's extended MLD capabilities and operations
@@ -2741,6 +2747,8 @@ struct ieee80211_sta {
 	u8 max_amsdu_subframes;
 	u16 eml_cap;
 
+	bool cip;
+
 	struct ieee80211_sta_aggregates *cur;
 
 	bool support_p2p_ps;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index eaafb45ff11f..3714f8ccdf82 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -619,6 +619,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct ieee80211_link_data *link =
 		ieee80211_link_or_deflink(sdata, link_id, false);
 	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
+	bool cigtk = type == NL80211_KEYTYPE_CIGTK;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta = NULL;
 	struct ieee80211_key *key;
@@ -662,6 +663,9 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 		key->conf.link_id = -1;
 	} else {
 		key->conf.link_id = link->link_id;
+
+		if (cigtk)
+			key->conf.flags |= IEEE80211_KEY_FLAG_CIP;
 	}
 
 	if (params->mode == NL80211_KEY_NO_TX)
@@ -745,6 +749,7 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 	struct ieee80211_local *local __maybe_unused = sdata->local;
 	struct ieee80211_link_data *link = &sdata->deflink;
 	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
+	bool cigtk = type == NL80211_KEYTYPE_CIGTK;
 	struct ieee80211_key *key;
 
 	if (link_id >= 0) {
@@ -774,7 +779,11 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 			return wiphy_dereference(local->hw.wiphy,
 						 sta->ptk[key_idx]);
 
-		if (!pairwise &&
+		if (cigtk && key_idx < NUM_CTRL_KEYS)
+			return wiphy_dereference(local->hw.wiphy,
+						 link_sta->cigtk[key_idx]);
+
+		if (!pairwise && !cigtk &&
 		    key_idx < NUM_DEFAULT_KEYS +
 			      NUM_DEFAULT_MGMT_KEYS +
 			      NUM_DEFAULT_BEACON_KEYS)
@@ -787,6 +796,9 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 	if (pairwise && key_idx < NUM_DEFAULT_KEYS)
 		return wiphy_dereference(local->hw.wiphy, sdata->keys[key_idx]);
 
+	if (cigtk)
+		return wiphy_dereference(local->hw.wiphy, link->cigtk[key_idx]);
+
 	key = wiphy_dereference(local->hw.wiphy, link->gtk[key_idx]);
 	if (key)
 		return key;
@@ -2294,6 +2306,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	case STA_LINK_MODE_NEW:
 		if (!params->link_mac)
 			return -EINVAL;
+		if (sta->sta.cip && !params->cip_cap_set)
+			return -EINVAL;
 		break;
 	case STA_LINK_MODE_LINK_MODIFY:
 		break;
@@ -2416,6 +2430,9 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 		ieee80211_s1g_cap_to_sta_s1g_cap(sdata, params->s1g_capa,
 						 link_sta);
 
+	if (params->cip_cap_set)
+		link_sta->pub->cip_cap = params->cip_cap;
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_NAN_DATA:
@@ -2578,6 +2595,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (params->eml_cap_present)
 		sta->sta.eml_cap = params->eml_cap;
 
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_CIP))
+		sta->sta.cip = true;
+
 	ret = sta_link_apply_parameters(local, sta, STA_LINK_MODE_STA_MODIFY,
 					&params->link_sta_params);
 	if (ret)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 674a4676a972..66231ea8a985 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -486,6 +486,7 @@ struct ieee80211_mgd_assoc_data {
 	bool comeback; /* whether the AP has requested association comeback */
 	bool s1g;
 	bool spp_amsdu;
+	bool cip;
 
 	s8 assoc_link_id;
 
@@ -1113,6 +1114,7 @@ struct ieee80211_link_data {
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS +
 					NUM_DEFAULT_MGMT_KEYS +
 					NUM_DEFAULT_BEACON_KEYS];
+	struct ieee80211_key __rcu *cigtk[NUM_CTRL_KEYS];
 	struct ieee80211_key __rcu *default_multicast_key;
 	struct ieee80211_key __rcu *default_mgmt_key;
 	struct ieee80211_key __rcu *default_beacon_key;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 9ac7a5c4b861..4c9788ec0b74 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -205,6 +205,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 			  sta ? sta->sta.addr : bcast_addr, ret);
 
  out_unsupported:
+	/* Control Integrity Protocol can only be done in hardware */
+	if (key->conf.flags & IEEE80211_KEY_FLAG_CIP)
+		return -EINVAL;
+
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -440,11 +444,13 @@ void ieee80211_set_default_beacon_key(struct ieee80211_link_data *link,
 static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_link_data *link,
 				 struct sta_info *sta,
-				 bool pairwise,
+				 enum ieee80211_key_flags flags,
 				 struct ieee80211_key *old,
 				 struct ieee80211_key *new)
 {
 	struct link_sta_info *link_sta = sta ? &sta->deflink : NULL;
+	bool pairwise = flags & IEEE80211_KEY_FLAG_PAIRWISE;
+	bool cip = flags & IEEE80211_KEY_FLAG_CIP;
 	int link_id;
 	int idx;
 	int ret = 0;
@@ -535,6 +541,8 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 			if (new &&
 			    !(new->conf.flags & IEEE80211_KEY_FLAG_NO_AUTO_TX))
 				_ieee80211_set_tx_key(new, true);
+		} else if (cip) {
+			rcu_assign_pointer(link_sta->cigtk[idx], new);
 		} else {
 			rcu_assign_pointer(link_sta->gtk[idx], new);
 		}
@@ -569,6 +577,8 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 		if (is_wep || pairwise)
 			rcu_assign_pointer(sdata->keys[idx], new);
+		else if (cip)
+			rcu_assign_pointer(link->cigtk[idx], new);
 		else
 			rcu_assign_pointer(link->gtk[idx], new);
 
@@ -883,6 +893,10 @@ int ieee80211_key_link(struct ieee80211_key *key,
 			ret = -EOPNOTSUPP;
 			goto out;
 		}
+
+		/* Set CIP flag if enabled for the station */
+		if (sta->sta.cip)
+			key->conf.flags |= IEEE80211_KEY_FLAG_CIP;
 	} else if (sta) {
 		struct link_sta_info *link_sta = &sta->deflink;
 		int link_id = key->conf.link_id;
@@ -896,15 +910,25 @@ int ieee80211_key_link(struct ieee80211_key *key,
 			}
 		}
 
-		old_key = wiphy_dereference(sdata->local->hw.wiphy,
-					    link_sta->gtk[idx]);
-	} else {
-		if (idx < NUM_DEFAULT_KEYS)
+		if (key->conf.flags & IEEE80211_KEY_FLAG_CIP)
 			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    sdata->keys[idx]);
-		if (!old_key)
+						    link_sta->cigtk[idx]);
+		else
 			old_key = wiphy_dereference(sdata->local->hw.wiphy,
-						    link->gtk[idx]);
+						    link_sta->gtk[idx]);
+	} else {
+		if (key->conf.flags & IEEE80211_KEY_FLAG_CIP) {
+			old_key = wiphy_dereference(sdata->local->hw.wiphy,
+						    link->cigtk[idx]);
+		} else {
+			if (idx < NUM_DEFAULT_KEYS)
+				old_key = wiphy_dereference(sdata->local->hw.wiphy,
+							    sdata->keys[idx]);
+
+			if (!old_key)
+				old_key = wiphy_dereference(sdata->local->hw.wiphy,
+							    link->gtk[idx]);
+		}
 	}
 
 	/* Non-pairwise keys must also not switch the cipher on rekey */
@@ -938,9 +962,17 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	if (sta && sta->sta.spp_amsdu)
 		key->conf.flags |= IEEE80211_KEY_FLAG_SPP_AMSDU;
 
+	/* A CIP related key must be GCMP-256 (really GMAC-256) */
+	if ((key->conf.flags & IEEE80211_KEY_FLAG_CIP) &&
+	    key->conf.cipher != WLAN_CIPHER_SUITE_GCMP_256) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	increment_tailroom_need_count(sdata);
 
-	ret = ieee80211_key_replace(sdata, link, sta, pairwise, old_key, key);
+	ret = ieee80211_key_replace(sdata, link, sta, key->conf.flags,
+				    old_key, key);
 
 	if (!ret) {
 		ieee80211_debugfs_key_add(key);
@@ -966,8 +998,7 @@ void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 	 */
 	if (key->sdata)
 		ieee80211_key_replace(key->sdata, NULL, key->sta,
-				      key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
-				      key, NULL);
+				      key->conf.flags, key, NULL);
 	ieee80211_key_destroy(key, delay_tailroom);
 }
 
@@ -1098,8 +1129,7 @@ static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
 		ieee80211_key_replace(key->sdata, NULL, key->sta,
-				      key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
-				      key, NULL);
+				      key->conf.flags, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
 
@@ -1119,8 +1149,7 @@ void ieee80211_remove_link_keys(struct ieee80211_link_data *link,
 		if (key->conf.link_id != link->link_id)
 			continue;
 		ieee80211_key_replace(key->sdata, link, key->sta,
-				      key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
-				      key, NULL);
+				      key->conf.flags, key, NULL);
 		list_add_tail(&key->list, keys);
 	}
 }
@@ -1196,8 +1225,17 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		if (!key)
 			continue;
 		ieee80211_key_replace(key->sdata, NULL, key->sta,
-				      key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
-				      key, NULL);
+				      key->conf.flags, key, NULL);
+		__ieee80211_key_destroy(key, key->sdata->vif.type ==
+					NL80211_IFTYPE_STATION);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sta->deflink.cigtk); i++) {
+		key = wiphy_dereference(local->hw.wiphy, sta->deflink.cigtk[i]);
+		if (!key)
+			continue;
+		ieee80211_key_replace(key->sdata, NULL, key->sta,
+				      key->conf.flags, key, NULL);
 		__ieee80211_key_destroy(key, key->sdata->vif.type ==
 					NL80211_IFTYPE_STATION);
 	}
@@ -1207,8 +1245,7 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		if (!key)
 			continue;
 		ieee80211_key_replace(key->sdata, NULL, key->sta,
-				      key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
-				      key, NULL);
+				      key->conf.flags, key, NULL);
 		__ieee80211_key_destroy(key, key->sdata->vif.type ==
 					NL80211_IFTYPE_STATION);
 	}
@@ -1390,10 +1427,20 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 		    NUM_DEFAULT_BEACON_KEYS))
 		return ERR_PTR(-EINVAL);
 
-	prev_key = wiphy_dereference(local->hw.wiphy,
-				     link_data->gtk[idx]);
+	if (WARN_ON(cigtk && idx >= NUM_CTRL_KEYS))
+		return ERR_PTR(-EINVAL);
+
+	if (cigtk)
+		prev_key = wiphy_dereference(local->hw.wiphy,
+					     link_data->cigtk[idx]);
+	else
+		prev_key = wiphy_dereference(local->hw.wiphy,
+					     link_data->gtk[idx]);
 	if (!prev_key) {
-		if (idx < NUM_DEFAULT_KEYS) {
+		if (cigtk) {
+			prev_key = wiphy_dereference(local->hw.wiphy,
+						     link_data->cigtk[idx ^ 1]);
+		} else if (idx < NUM_DEFAULT_KEYS) {
 			for (int i = 0; i < NUM_DEFAULT_KEYS; i++) {
 				if (i == idx)
 					continue;
@@ -1424,6 +1471,9 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 	if (sdata->u.mgd.mfp != IEEE80211_MFP_DISABLED)
 		key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
 
+	if (prev_key->conf.flags & IEEE80211_KEY_FLAG_CIP)
+		key->conf.flags |= IEEE80211_KEY_FLAG_CIP;
+
 	key->conf.link_id = link_data->link_id;
 
 	err = ieee80211_key_link(key, link_data, NULL);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 826e4e9387c5..c85992493afd 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -2,7 +2,7 @@
 /*
  * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
- * Copyright (C) 2019, 2022-2023 Intel Corporation
+ * Copyright (C) 2019, 2022-2023, 2026 Intel Corporation
  */
 
 #ifndef IEEE80211_KEY_H
@@ -19,6 +19,7 @@
 #define NUM_DEFAULT_KEYS 4
 #define NUM_DEFAULT_MGMT_KEYS 2
 #define NUM_DEFAULT_BEACON_KEYS 2
+#define NUM_CTRL_KEYS 2
 #define INVALID_PTK_KEYIDX 2 /* Keyidx always pointing to a NULL key for PTK */
 
 struct ieee80211_local;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cf3873d8855b..76c45a0eea62 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2337,6 +2337,10 @@ ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
 		ieee80211_put_eht_cap(skb, sdata, sband,
 				      &assoc_data->link[link_id].conn);
 
+	/* Insert CIP only on the assoc link (it will be inherited) */
+	if (link_id == assoc_data->assoc_link_id && assoc_data->cip)
+		ieee80211_put_cip_cap(skb, sdata);
+
 	if (assoc_data->link[link_id].conn.mode >= IEEE80211_CONN_MODE_UHR)
 		ieee80211_put_uhr_cap(skb, sdata, sband);
 
@@ -2613,7 +2617,8 @@ static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	       assoc_data->ie_len + /* extra IEs */
 	       (assoc_data->fils_kek_len ? 16 /* AES-SIV */ : 0) +
 	       9 /* WMM */ +
-	       4 /* regulatory connectivity, if 6 GHz is supported */;
+	       4 /* regulatory connectivity, if 6 GHz is supported */ +
+	       (assoc_data->cip ? 4 /* CIP capabilities */ : 0);
 
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
 		struct cfg80211_bss *cbss = assoc_data->link[link_id].bss;
@@ -6274,6 +6279,17 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 		/* TODO: OPEN: what happens if BSS color disable is set? */
 	}
 
+	if (assoc_data->cip) {
+		if (elems->cip_cap) {
+			link_sta->pub->cip_cap = elems->cip_cap->v;
+		} else {
+			sdata_info(sdata,
+				   "CIP Capabilities not included in association response\n");
+			ret = false;
+			goto out;
+		}
+	}
+
 	if (cbss->transmitted_bss) {
 		bss_conf->nontransmitted = true;
 		ether_addr_copy(bss_conf->transmitter_bssid,
@@ -6999,6 +7015,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		goto out_err;
 
 	sta->sta.spp_amsdu = assoc_data->spp_amsdu;
+	sta->sta.cip = assoc_data->cip;
 
 	if (ieee80211_vif_is_mld(&sdata->vif)) {
 		if (!elems->ml_basic)
@@ -10536,6 +10553,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	assoc_data->spp_amsdu = req->flags & ASSOC_REQ_SPP_AMSDU;
+	assoc_data->cip = req->flags & ASSOC_REQ_CIP;
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
 		err = -EBUSY;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ee0d32877c5b..f409f6a3afa1 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -485,6 +485,7 @@ struct ieee80211_fragment_cache {
  * @link_hash_node: hash node for rhashtable
  * @sta: Points to the STA info
  * @gtk: group keys negotiated with this station, if any
+ * @cigtk: control integrity group keys negotiated with this station, if any
  * @tx_stats: TX statistics
  * @tx_stats.packets: # of packets transmitted
  * @tx_stats.bytes: # of bytes in all packets transmitted
@@ -535,6 +536,7 @@ struct link_sta_info {
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS +
 					NUM_DEFAULT_MGMT_KEYS +
 					NUM_DEFAULT_BEACON_KEYS];
+	struct ieee80211_key __rcu *cigtk[NUM_CTRL_KEYS];
 	struct ieee80211_sta_rx_stats __percpu *pcpu_rx_stats;
 
 	/* Updated from RX path only, no locking requirements */
-- 
2.55.0

