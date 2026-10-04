Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296484AA01B
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150314; cv=none; b=L/1da/6YVwubANqDazn/+v6Obfv08JfILtG24RPFN5C03lPTohtpcIklfVeLFPbJ8DGXEUWf6s72EGJS3pWjZxXYFPbThETjYQ7yyGezxPcavBQDswOxN690I6Wgt0JtcWiVX78Nj4UjnZ+RIZNCYSjCciuzaU1J2MigKYKLG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150314; c=relaxed/simple;
	bh=HMaz55tF6nhlshnzK9Ju8D/b9b9C+f+EJatPOuHhaR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWI4xOhxXeUARvuplA1X0ZQUJPM8hBN9h2iMNvZEKwyqtagqLiaCdyxAKVANKf3VY0MZgKwjo96ZIh7Fhx0Pgn1RcW33QWCyl6QZakQRcKt1eTF/TWKE0Ki2WYIwaLnpGqrL+m4JocXvvZoMWpfuJak6MmwUTITaqGp+Ue//JrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=I9x+YgJt; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="I9x+YgJt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=lCAi0BeeihgyGgSF93cdFe6ohN0pveoVmyNWalePF9Y=;
	t=1791150312; x=1792359912; b=I9x+YgJt1PYbIex7uGSDfTUu5mvvOH1HA1z4OIGkPRKbLf2
	4dabT7Itbk+/WKAo/0dH7iXx7tuLf1H8j+OZswdrPVsnoCOmu4TbRFVeJJkKuH2Yi6f1o/1b3/FtD
	WVvncbHvbDibkeH/pwyHfgE8Htum9rkcJtJidvQyW5I+3gbHwNQt3oOxHCH4A96yfN9YC84ULHOGK
	XwzQMq5EA1pd/CzVIsQknYLdrYD33mUCrNV34xVSjeHbmtdm3LyFvB5cOF34OEuwigxrLoLDhg0zh
	Yp+Myy2cAQP/sOor6G3VqsAQ0p0Ztx4r7fGSgxxl6jZUVfVLlUCjK7EL9wtqgvFA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU16-00000004OqT-39dv;
	Sun, 04 Oct 2026 23:45:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 01/12] wifi: mac80211: protect AP template pointers with a spinlock
Date: Sun,  4 Oct 2026 23:40:47 +0200
Message-ID: <20261004234504.2fa820f54486.Iba8a15c4d37e441642b6df68c33ef8c97340e9a9@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
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
index bd1a857c812d..41d62e199851 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1122,13 +1122,11 @@ ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
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
@@ -1143,9 +1141,7 @@ ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	else if (cca)
 		new->cntdwn_counter_offsets[0] = cca->counter_offset_presp;
 
-	rcu_assign_pointer(link->u.ap.probe_resp, new);
-	if (old)
-		kfree_rcu(old, rcu_head);
+	ap_tmpl_replace(link, link->u.ap.probe_resp, new);
 
 	return 0;
 }
@@ -1156,7 +1152,7 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_bss_conf *link_conf,
 					u64 *changed)
 {
-	struct fils_discovery_data *new, *old = NULL;
+	struct fils_discovery_data *new = NULL;
 	struct ieee80211_fils_discovery *fd;
 
 	if (!params->update)
@@ -1166,20 +1162,15 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
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
@@ -1192,28 +1183,22 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_bss_conf *link_conf,
 				     u64 *changed)
 {
-	struct unsol_bcast_probe_resp_data *new, *old = NULL;
+	struct unsol_bcast_probe_resp_data *new = NULL;
 
 	if (!params->update)
 		return 0;
 
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
@@ -1613,12 +1598,9 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
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
@@ -1920,11 +1902,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
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
@@ -2052,16 +2030,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 
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
 
@@ -2082,10 +2052,20 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
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
index 1430527d216c..02e50dcef27e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1151,6 +1151,9 @@ struct ieee80211_link_data {
 		struct ieee80211_link_data_ap ap;
 	} u;
 
+	/* protects replacing the u.ap template pointers, also without wiphy mutex */
+	spinlock_t ap_tmpl_lock;
+
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
 	struct ieee80211_bss_conf *conf;
@@ -1165,6 +1168,21 @@ struct ieee80211_link_data {
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
2.55.0

