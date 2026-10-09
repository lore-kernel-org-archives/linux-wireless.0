Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BCC4F55C6
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569665; cv=none; b=U4BnynEE0ID+ro441fM9UQ19SYhwvzA880rRFRUClRGW+qbpWT3YALDbMEgHmuK+gGWnQxWLe0xZNBS58tKoopdaCXBN3PmxkrSZrVRDnCEY5wgtyHc+7tTYpVKkfJddmvpgRC5fMjeJIf9rOYWBbU5B+PVbSvJyZbGX9I5nivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569665; c=relaxed/simple;
	bh=LP0I1sydY/SqqLim/lVj5UK0hjqFeywyheRTLWwIKI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApnuJ3nBBrypQOil5gklcSc9bMlV3X+K7+CoHNpsDFKytObIVVCWFlrqKUvICWuwLG3GgYIUahRt9wcDvIgCf1bMOhuUa5Vg0msk1pV6Vh1Q0RbOot2ZkSxRoDeaWgBK8QVvmZL25BLqS7MZ2n/R/nlulImmx29gX+weSabmODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=jVxhG4oV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="jVxhG4oV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Hxc/6XeKYkuD0JTT65ENV7qdAq+L9jRNNXuBOqs+09c=;
	t=1791569663; x=1792779263; b=jVxhG4oVZHrPumTDega8Sswz5xOwuRbW6w+nwDLLJogAJ2x
	4AWqMx1Wfz5kJnOJq4Q2ShsdW+SmmuiN+ziANPLo7wNlU9K3YemjJaJoLaxbbwsidbFANXcoORlv9
	mDYsBd6ZkX2tND4mV8F1uUBnI8Xvcw24rAN4FNlgVHa/QnoHyWV69SpYpIagTJwjlIdv/q8FIy+56
	IZzCGB4RhPPfKz28Q7OjiNvnFWCu4IXjUg4I5tPaURFGAViEpfBlflUDnYdVMBDAPZrgqMWICzhDB
	Na2Sf7OQ0q4SH5kOv9AjTlY8sO3UjSEZ04RWW9nkOZcwWgbMtl32Q34m9K6fmKYA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6q-0000000AtGH-2tVR;
	Fri, 09 Oct 2026 20:14:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 02/17] wifi: mac80211: protect AP template pointers with a spinlock
Date: Fri,  9 Oct 2026 20:10:01 +0200
Message-ID: <20261009201417.f9414c150e5d.Iba8a15c4d37e441642b6df68c33ef8c97340e9a9@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The AP's beacon, presp etc. templates are only updated under
wiphy mutex right now. Prepare for being able to update them
without the wiphy mutex by using a (per-link) spinlock for
them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 66 +++++++++++++-------------------------
 net/mac80211/ieee80211_i.h | 18 +++++++++++
 net/mac80211/link.c        |  1 +
 3 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d0d14f621588..08088a2656c7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1123,13 +1123,11 @@ ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 			 const struct ieee80211_color_change_settings *cca,
 			 struct ieee80211_link_data *link)
 {
-	struct probe_resp *new, *old;
+	struct probe_resp *new;
 
 	if (!resp || !resp_len)
 		return 1;
 
-	old = sdata_dereference(link->u.ap.probe_resp, sdata);
-
 	new = kzalloc(sizeof(struct probe_resp) + resp_len, GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
@@ -1144,9 +1142,7 @@ ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	else if (cca)
 		new->cntdwn_counter_offsets[0] = cca->counter_offset_presp;
 
-	rcu_assign_pointer(link->u.ap.probe_resp, new);
-	if (old)
-		kfree_rcu(old, rcu_head);
+	ap_tmpl_replace(link, link->u.ap.probe_resp, new);
 
 	return 0;
 }
@@ -1157,7 +1153,7 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_bss_conf *link_conf,
 					u64 *changed)
 {
-	struct fils_discovery_data *new, *old = NULL;
+	struct fils_discovery_data *new = NULL;
 	struct ieee80211_fils_discovery *fd;
 
 	/*
@@ -1175,20 +1171,15 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 	fd->min_interval = params->min_interval;
 	fd->max_interval = params->max_interval;
 
-	old = sdata_dereference(link->u.ap.fils_discovery, sdata);
 	if (params->tmpl && params->tmpl_len) {
 		new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
 		if (!new)
 			return -ENOMEM;
 		new->len = params->tmpl_len;
 		memcpy(new->data, params->tmpl, params->tmpl_len);
-		rcu_assign_pointer(link->u.ap.fils_discovery, new);
-	} else {
-		RCU_INIT_POINTER(link->u.ap.fils_discovery, NULL);
 	}
 
-	if (old)
-		kfree_rcu(old, rcu_head);
+	ap_tmpl_replace(link, link->u.ap.fils_discovery, new);
 
 	*changed |= BSS_CHANGED_FILS_DISCOVERY;
 	return 0;
@@ -1201,7 +1192,7 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_bss_conf *link_conf,
 				     u64 *changed)
 {
-	struct unsol_bcast_probe_resp_data *new, *old = NULL;
+	struct unsol_bcast_probe_resp_data *new = NULL;
 
 	/*
 	 * This configuration is only applicable to transmitting BSSes.
@@ -1216,21 +1207,15 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 
 	link_conf->unsol_bcast_probe_resp_interval = params->interval;
 
-	old = sdata_dereference(link->u.ap.unsol_bcast_probe_resp, sdata);
-
 	if (params->tmpl && params->tmpl_len) {
 		new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
 		if (!new)
 			return -ENOMEM;
 		new->len = params->tmpl_len;
 		memcpy(new->data, params->tmpl, params->tmpl_len);
-		rcu_assign_pointer(link->u.ap.unsol_bcast_probe_resp, new);
-	} else {
-		RCU_INIT_POINTER(link->u.ap.unsol_bcast_probe_resp, NULL);
 	}
 
-	if (old)
-		kfree_rcu(old, rcu_head);
+	ap_tmpl_replace(link, link->u.ap.unsol_bcast_probe_resp, new);
 
 	*changed |= BSS_CHANGED_UNSOL_BCAST_PROBE_RESP;
 	return 0;
@@ -1649,12 +1634,9 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 		_changed |= BSS_CHANGED_FTM_RESPONDER;
 	}
 
-	rcu_assign_pointer(link->u.ap.beacon, new);
+	ap_tmpl_replace(link, link->u.ap.beacon, new);
 	sdata->u.ap.active = true;
 
-	if (old)
-		kfree_rcu(old, rcu_head);
-
 	ieee80211_update_ap_bandwidth(link, params);
 
 	*changed |= _changed;
@@ -1956,11 +1938,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	err = drv_start_ap(sdata->local, sdata, link_conf);
 	if (err) {
-		old = sdata_dereference(link->u.ap.beacon, sdata);
-
-		if (old)
-			kfree_rcu(old, rcu_head);
-		RCU_INIT_POINTER(link->u.ap.beacon, NULL);
+		ap_tmpl_replace(link, link->u.ap.beacon, NULL);
 
 		if (ieee80211_num_beaconing_links(sdata) == 0)
 			sdata->u.ap.active = false;
@@ -2088,16 +2066,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	old_beacon = sdata_dereference(link->u.ap.beacon, sdata);
-	if (!old_beacon)
+	if (!sdata_dereference(link->u.ap.beacon, sdata))
 		return -ENOENT;
-	old_probe_resp = sdata_dereference(link->u.ap.probe_resp,
-					   sdata);
-	old_fils_discovery = sdata_dereference(link->u.ap.fils_discovery,
-					       sdata);
-	old_unsol_bcast_probe_resp =
-		sdata_dereference(link->u.ap.unsol_bcast_probe_resp,
-				  sdata);
 	old_s1g_short_beacon =
 		sdata_dereference(link->u.ap.s1g_short_beacon, sdata);
 
@@ -2118,10 +2088,20 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* remove beacon and probe response */
-	RCU_INIT_POINTER(link->u.ap.beacon, NULL);
-	RCU_INIT_POINTER(link->u.ap.probe_resp, NULL);
-	RCU_INIT_POINTER(link->u.ap.fils_discovery, NULL);
-	RCU_INIT_POINTER(link->u.ap.unsol_bcast_probe_resp, NULL);
+	scoped_guard(spinlock, &link->ap_tmpl_lock) {
+		old_beacon = ap_tmpl_dereference(link, link->u.ap.beacon);
+		old_probe_resp = ap_tmpl_dereference(link,
+						     link->u.ap.probe_resp);
+		old_fils_discovery =
+			ap_tmpl_dereference(link, link->u.ap.fils_discovery);
+		old_unsol_bcast_probe_resp =
+			ap_tmpl_dereference(link,
+					    link->u.ap.unsol_bcast_probe_resp);
+		RCU_INIT_POINTER(link->u.ap.beacon, NULL);
+		RCU_INIT_POINTER(link->u.ap.probe_resp, NULL);
+		RCU_INIT_POINTER(link->u.ap.fils_discovery, NULL);
+		RCU_INIT_POINTER(link->u.ap.unsol_bcast_probe_resp, NULL);
+	}
 	RCU_INIT_POINTER(link->u.ap.s1g_short_beacon, NULL);
 	kfree_rcu(old_beacon, rcu_head);
 	if (old_probe_resp)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b571019bd05a..b16ff6a4aacf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1152,6 +1152,9 @@ struct ieee80211_link_data {
 		struct ieee80211_link_data_ap ap;
 	} u;
 
+	/* protects replacing the u.ap template pointers, also without wiphy mutex */
+	spinlock_t ap_tmpl_lock;
+
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
 	struct ieee80211_bss_conf *conf;
@@ -1166,6 +1169,21 @@ struct ieee80211_link_data {
 #endif
 };
 
+#define ap_tmpl_dereference(link, p)					\
+	rcu_dereference_protected(p, lockdep_is_held(&(link)->ap_tmpl_lock))
+
+#define ap_tmpl_replace(link, p, new)					\
+do {									\
+	typeof(ap_tmpl_dereference(link, p)) __old;			\
+									\
+	spin_lock(&(link)->ap_tmpl_lock);				\
+	__old = rcu_replace_pointer(p, new,				\
+				    lockdep_is_held(&(link)->ap_tmpl_lock));\
+	spin_unlock(&(link)->ap_tmpl_lock);				\
+	if (__old)							\
+		kfree_rcu(__old, rcu_head);				\
+} while (0)
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 931950a10508..ce1c95b40cd9 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -126,6 +126,7 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 	link->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
 	link->user_power_level = sdata->local->user_power_level;
 	link_conf->txpower = INT_MIN;
+	spin_lock_init(&link->ap_tmpl_lock);
 
 	wiphy_work_init(&link->csa.finalize_work,
 			ieee80211_csa_finalize_work);
-- 
2.56.0

