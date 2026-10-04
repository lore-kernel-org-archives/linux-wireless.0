Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C684AA03D
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150316; cv=none; b=KQwdhh2OVrjPDic/hNINsBw80euDe4INtnWVHsE8rRRiz0RV7gyC8Uu7zpOVyPcMDu9viG2Poo2FlNNx+OBu9HLllUMfjr765tMOV3tTFyhI2VZmMABqdqVvcAw6n5S+gjg7+y04Jeh02hNlB/wmISkZVWcx8zrpCCuO/gKybxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150316; c=relaxed/simple;
	bh=HjPjM58cMsTyxN/LDyVNiKXec4Rxh4h/sHokI2iYYsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0XZyEjnEqDMojQcvVJTjPkhkHrH40zD8P8QDtYZPsFjnO4uQ5s7whkyUAbF/oOebYfZYCBuH3c+Sbq7+oJG7dJTjahFi+BiLNTyakUMayB7t4HdjvYOX/CJXmvh9hyDwt4hjUp/CDI7i0PTqTyrYhQ+ECoBUkmcXIunv8eWw4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nKPmNu5u; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nKPmNu5u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=saFmDNBV6feZOU7zGAYMwgaPanOK/kW2FaSX6vQjeDk=;
	t=1791150313; x=1792359913; b=nKPmNu5u1vjLw3DDuU5Ee9wb9ljrdMGeYPMk4d7Njhc33PF
	R511osLuzaE8N8fyhWHZl04mt1GvIBG8sDfk3omq7pgo6jhdPjvc/h9IGIUjkyUkxvT3nDSObhORa
	eYIsh6vNF6L3gyUKJOsOVJohWPrdeCzGUg+AHY1otGXU50mSvXgBbN34iXULi2kNurVTJHOuPlKDG
	2TUE7GWsqosnOlkdXxngKCxixt1i+CCqWpeLt4p2JX+0HZ8NVTZk6NBNe+YCV5w9ijUgXOzp6fFm1
	yeyLgPR+atT0wJpC+uGTo9yYQgcLKZu3+tJxowxMaT5YmPckZb7vQ4128Zj2moSw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU18-00000004OqT-0Y9t;
	Sun, 04 Oct 2026 23:45:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 03/12] wifi: mac80211: implement lockless beacon updates
Date: Sun,  4 Oct 2026 23:40:49 +0200
Message-ID: <20261004234504.dc783ba26923.Icfbcd157ac2bdeccfcc74a9f4c3997d3010ec0a9@changeid>
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

Implement the new update_beacon() method to update beacon
and related templates without the wiphy mutex. If anything
else were to change return -EAGAIN, same if there are any
active countdowns, and during HW restart.

This doesn't enable it for any drivers since it depends on
the driver behaviour, if it fetches each beacon and doesn't
use the other templates it can just set the feature flag
(NL80211_EXT_FEATURE_UPDATE_BEACON), otherwise it must
implement the new update_beacon() mac80211 method.

The regular beacon update can no longer reliably access
the old beacon across the allocation (or we'd have to do
all those atomically), so if userspace does both at the
same time, we may send a corrupt beacon due to min() in
the copy. This won't happen with hostapd even if it were
to race, since it always sends both head and tail.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |   7 +
 net/mac80211/cfg.c        | 316 +++++++++++++++++++++++++++++++-------
 net/mac80211/driver-ops.h |  16 ++
 net/mac80211/trace.h      |  28 ++++
 4 files changed, 310 insertions(+), 57 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cb9f8e14b3b6..c64478dc7c53 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4586,6 +4586,9 @@ struct ieee80211_prep_tx_info {
  *	just "paused" for scanning/ROC, which is indicated by the beacon being
  *	disabled/enabled via @bss_info_changed.
  * @stop_ap: Stop operation on the AP interface.
+ * @update_beacon: Update the templates indicated by @changed (beacon, probe
+ *	response, FILS discovery and/or unsolicitated bcast probe response)
+ *	without the wiphy mutex held. This callback must not sleep.
  *
  * @reconfig_complete: Called after a call to ieee80211_restart_hw() and
  *	during resume, when the reconfiguration has completed.
@@ -4783,6 +4786,10 @@ struct ieee80211_ops {
 			struct ieee80211_bss_conf *link_conf);
 	void (*stop_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *link_conf);
+	void (*update_beacon)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_bss_conf *link_conf,
+			      u64 changed);
 
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 41d62e199851..aff9b1023d80 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1466,68 +1466,37 @@ static void ieee80211_update_ap_bandwidth(struct ieee80211_link_data *link,
 	ieee80211_recalc_chanctx_min_def(local, chanctx);
 }
 
-static int
-ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_link_data *link,
-			struct cfg80211_beacon_data *params,
-			const struct ieee80211_csa_settings *csa,
-			const struct ieee80211_color_change_settings *cca,
-			u64 *changed)
+static struct beacon_data *
+ieee80211_alloc_beacon(struct cfg80211_beacon_data *params,
+		       int head_len, int tail_len)
 {
-	struct cfg80211_mbssid_elems *mbssid = NULL;
-	struct cfg80211_rnr_elems *rnr = NULL;
-	struct beacon_data *new, *old;
-	int new_head_len, new_tail_len;
-	int size, err;
-	u64 _changed = BSS_CHANGED_BEACON;
-	struct ieee80211_bss_conf *link_conf = link->conf;
+	struct cfg80211_mbssid_elems *mbssid = params->mbssid_ies;
+	struct cfg80211_rnr_elems *rnr = mbssid ? params->rnr_ies : NULL;
+	struct beacon_data *new;
+	int size;
 
-	old = sdata_dereference(link->u.ap.beacon, sdata);
+	size = sizeof(*new) + head_len + tail_len;
 
-	/* Need to have a beacon head if we don't have one yet */
-	if (!params->head && !old)
-		return -EINVAL;
-
-	/* new or old head? */
-	if (params->head)
-		new_head_len = params->head_len;
-	else
-		new_head_len = old->head_len;
-
-	/* new or old tail? */
-	if (params->tail || !old)
-		/* params->tail_len will be zero for !params->tail */
-		new_tail_len = params->tail_len;
-	else
-		new_tail_len = old->tail_len;
-
-	size = sizeof(*new) + new_head_len + new_tail_len;
-
-	if (params->mbssid_ies) {
-		mbssid = params->mbssid_ies;
+	if (mbssid) {
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (params->rnr_ies) {
-			rnr = params->rnr_ies;
+		if (rnr)
 			size += struct_size(new->rnr_ies, elem, rnr->cnt);
-		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
 	}
 
 	new = kzalloc(size, GFP_KERNEL);
 	if (!new)
-		return -ENOMEM;
-
-	/* start filling the new info now */
+		return NULL;
 
 	/*
 	 * pointers go into the block we allocated,
 	 * memory is | beacon_data | head | tail | mbssid_ies | rnr_ies
 	 */
 	new->head = ((u8 *) new) + sizeof(*new);
-	new->tail = new->head + new_head_len;
-	new->head_len = new_head_len;
-	new->tail_len = new_tail_len;
+	new->tail = new->head + head_len;
+	new->head_len = head_len;
+	new->tail_len = tail_len;
 	/* copy in optional mbssid_ies */
 	if (mbssid) {
 		u8 *pos = new->tail + new->tail_len;
@@ -1541,14 +1510,61 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 			pos += struct_size(new->rnr_ies, elem, rnr->cnt);
 			ieee80211_copy_rnr_beacon(pos, new->rnr_ies, rnr);
 		}
-		/* update bssid_indicator */
-		if (new->mbssid_ies->cnt && new->mbssid_ies->elem[0].len > 2)
-			link_conf->bssid_indicator =
-					*(new->mbssid_ies->elem[0].data + 2);
-		else
-			link_conf->bssid_indicator = 0;
 	}
 
+	return new;
+}
+
+static u8 ieee80211_beacon_bssid_indicator(struct beacon_data *beacon)
+{
+	if (beacon->mbssid_ies->cnt && beacon->mbssid_ies->elem[0].len > 2)
+		return *(beacon->mbssid_ies->elem[0].data + 2);
+	return 0;
+}
+
+static int
+ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_link_data *link,
+			struct cfg80211_beacon_data *params,
+			const struct ieee80211_csa_settings *csa,
+			const struct ieee80211_color_change_settings *cca,
+			u64 *changed)
+{
+	struct beacon_data *new, *old;
+	int new_head_len, new_tail_len;
+	int err;
+	u64 _changed = BSS_CHANGED_BEACON;
+	struct ieee80211_bss_conf *link_conf = link->conf;
+
+	scoped_guard(spinlock, &link->ap_tmpl_lock) {
+		old = ap_tmpl_dereference(link, link->u.ap.beacon);
+
+		/* Need to have a beacon head if we don't have one yet */
+		if (!params->head && !old)
+			return -EINVAL;
+
+		/* new or old head? */
+		if (params->head)
+			new_head_len = params->head_len;
+		else
+			new_head_len = old->head_len;
+
+		/* new or old tail? */
+		if (params->tail || !old)
+			/* params->tail_len will be zero for !params->tail */
+			new_tail_len = params->tail_len;
+		else
+			new_tail_len = old->tail_len;
+	}
+
+	new = ieee80211_alloc_beacon(params, new_head_len, new_tail_len);
+	if (!new)
+		return -ENOMEM;
+
+	if (new->mbssid_ies)
+		link_conf->bssid_indicator =
+			ieee80211_beacon_bssid_indicator(new);
+
 	if (csa) {
 		new->cntdwn_current_counter = csa->count;
 		memcpy(new->cntdwn_counter_offsets, csa->counter_offsets_beacon,
@@ -1562,15 +1578,10 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	/* copy in head */
 	if (params->head)
 		memcpy(new->head, params->head, new_head_len);
-	else
-		memcpy(new->head, old->head, new_head_len);
 
 	/* copy in optional tail */
 	if (params->tail)
 		memcpy(new->tail, params->tail, new_tail_len);
-	else
-		if (old)
-			memcpy(new->tail, old->tail, new_tail_len);
 
 	err = ieee80211_set_probe_resp(sdata, params->probe_resp,
 				       params->probe_resp_len, csa, cca, link);
@@ -1598,9 +1609,28 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 		_changed |= BSS_CHANGED_FTM_RESPONDER;
 	}
 
-	ap_tmpl_replace(link, link->u.ap.beacon, new);
+	scoped_guard(spinlock, &link->ap_tmpl_lock) {
+		old = ap_tmpl_dereference(link, link->u.ap.beacon);
+
+		/*
+		 * A lockless update (which always has head and tail) may have
+		 * replaced the old beacon since the lengths were taken, so it
+		 * might not match; the result is then wrong, but at least safe.
+		 */
+		if (!params->head)
+			memcpy(new->head, old->head,
+			       min(new_head_len, old->head_len));
+		if (!params->tail && old)
+			memcpy(new->tail, old->tail,
+			       min(new_tail_len, old->tail_len));
+
+		rcu_assign_pointer(link->u.ap.beacon, new);
+	}
 	sdata->u.ap.active = true;
 
+	if (old)
+		kfree_rcu(old, rcu_head);
+
 	ieee80211_update_ap_bandwidth(link, params);
 
 	*changed |= _changed;
@@ -1999,6 +2029,177 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_update_beacon(struct wiphy *wiphy, struct net_device *dev,
+				   struct cfg80211_ap_update *params)
+{
+	struct cfg80211_unsol_bcast_probe_resp *ubpr =
+		&params->unsol_bcast_probe_resp;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct cfg80211_fils_discovery *fd = &params->fils_discovery;
+	struct unsol_bcast_probe_resp_data *new_ubpr = NULL, *old_ubpr = NULL;
+	struct cfg80211_beacon_data *beacon = &params->beacon;
+	struct fils_discovery_data *new_fd = NULL, *old_fd = NULL;
+	struct probe_resp *new_presp = NULL, *old_presp = NULL;
+	struct ieee80211_local *local = sdata->local;
+	struct beacon_data *new, *old = NULL;
+	struct ieee80211_bss_conf *link_conf;
+	struct ieee80211_link_data *link;
+	struct ieee80211_channel *chan;
+	u64 changed = BSS_CHANGED_BEACON;
+	int err = 0;
+
+	if (READ_ONCE(local->in_reconfig) || READ_ONCE(local->quiescing))
+		return -EAGAIN;
+
+	new = ieee80211_alloc_beacon(beacon, beacon->head_len,
+				     beacon->tail_len);
+	if (!new)
+		return -ENOMEM;
+	memcpy(new->head, beacon->head, beacon->head_len);
+	memcpy(new->tail, beacon->tail, beacon->tail_len);
+
+	if (beacon->probe_resp && beacon->probe_resp_len) {
+		new_presp = kzalloc(sizeof(*new_presp) + beacon->probe_resp_len,
+				    GFP_KERNEL);
+		if (!new_presp) {
+			err = -ENOMEM;
+			goto free;
+		}
+		new_presp->len = beacon->probe_resp_len;
+		memcpy(new_presp->data, beacon->probe_resp,
+		       beacon->probe_resp_len);
+		changed |= BSS_CHANGED_AP_PROBE_RESP;
+	}
+
+	if (fd->update && fd->tmpl && fd->tmpl_len) {
+		new_fd = kzalloc(sizeof(*new_fd) + fd->tmpl_len, GFP_KERNEL);
+		if (!new_fd) {
+			err = -ENOMEM;
+			goto free;
+		}
+		new_fd->len = fd->tmpl_len;
+		memcpy(new_fd->data, fd->tmpl, fd->tmpl_len);
+	}
+
+	if (ubpr->update && ubpr->tmpl && ubpr->tmpl_len) {
+		new_ubpr = kzalloc(sizeof(*new_ubpr) + ubpr->tmpl_len,
+				   GFP_KERNEL);
+		if (!new_ubpr) {
+			err = -ENOMEM;
+			goto free;
+		}
+		new_ubpr->len = ubpr->tmpl_len;
+		memcpy(new_ubpr->data, ubpr->tmpl, ubpr->tmpl_len);
+	}
+
+	rcu_read_lock();
+
+	/* do_stop() synchronizes RCU before the interface type can change */
+	if (!ieee80211_sdata_running(sdata) ||
+	    (sdata->vif.type != NL80211_IFTYPE_AP &&
+	     sdata->vif.type != NL80211_IFTYPE_P2P_GO)) {
+		err = -ENETDOWN;
+		goto unlock;
+	}
+
+	link = rcu_dereference(sdata->link[beacon->link_id]);
+	if (!link) {
+		err = -ENOLINK;
+		goto unlock;
+	}
+	link_conf = link->conf;
+
+	/* configuration changes need the wiphy mutex, let cfg80211 retry */
+	err = -EAGAIN;
+
+	if (READ_ONCE(link_conf->csa_active) ||
+	    READ_ONCE(link_conf->color_change_active))
+		goto unlock;
+
+	if (new->mbssid_ies &&
+	    ieee80211_beacon_bssid_indicator(new) !=
+			READ_ONCE(link_conf->bssid_indicator))
+		goto unlock;
+
+	if (fd->update &&
+	    (fd->min_interval != READ_ONCE(link_conf->fils_discovery.min_interval) ||
+	     fd->max_interval != READ_ONCE(link_conf->fils_discovery.max_interval)))
+		goto unlock;
+
+	if (ubpr->update &&
+	    ubpr->interval !=
+			READ_ONCE(link_conf->unsol_bcast_probe_resp_interval))
+		goto unlock;
+
+	chan = READ_ONCE(link_conf->chanreq.oper.chan);
+	if (!chan)
+		goto unlock;
+
+	if (chan->band != NL80211_BAND_S1GHZ) {
+		enum ieee80211_sta_rx_bandwidth he_and_lower;
+
+		he_and_lower = ieee80211_calc_ap_he_and_lower(beacon);
+		if (he_and_lower != READ_ONCE(link->bss_bw.he_and_lower) ||
+		    ieee80211_calc_ap_eht_bw(beacon, he_and_lower) !=
+				READ_ONCE(link->bss_bw.eht))
+			goto unlock;
+	}
+
+	spin_lock(&link->ap_tmpl_lock);
+	old = ap_tmpl_dereference(link, link->u.ap.beacon);
+	if (!old) {
+		err = -ENOENT;
+	} else if (READ_ONCE(old->cntdwn_current_counter)) {
+		/* a countdown just started, keep the offsets */
+		old = NULL;
+	} else {
+		rcu_assign_pointer(link->u.ap.beacon, new);
+		new = NULL;
+
+		if (new_presp)
+			old_presp = rcu_replace_pointer(link->u.ap.probe_resp,
+							new_presp,
+							lockdep_is_held(&link->ap_tmpl_lock));
+		new_presp = NULL;
+
+		if (fd->update) {
+			old_fd = rcu_replace_pointer(link->u.ap.fils_discovery,
+						     new_fd,
+						     lockdep_is_held(&link->ap_tmpl_lock));
+			changed |= BSS_CHANGED_FILS_DISCOVERY;
+		}
+		new_fd = NULL;
+
+		if (ubpr->update) {
+			old_ubpr = rcu_replace_pointer(link->u.ap.unsol_bcast_probe_resp,
+						       new_ubpr,
+						       lockdep_is_held(&link->ap_tmpl_lock));
+			changed |= BSS_CHANGED_UNSOL_BCAST_PROBE_RESP;
+		}
+		new_ubpr = NULL;
+
+		drv_update_beacon(local, sdata, link_conf, changed);
+		err = 0;
+	}
+	spin_unlock(&link->ap_tmpl_lock);
+unlock:
+	rcu_read_unlock();
+free:
+	kfree(new);
+	kfree(new_presp);
+	kfree(new_fd);
+	kfree(new_ubpr);
+	if (old)
+		kfree_rcu(old, rcu_head);
+	if (old_presp)
+		kfree_rcu(old_presp, rcu_head);
+	if (old_fd)
+		kfree_rcu(old_fd, rcu_head);
+	if (old_ubpr)
+		kfree_rcu(old_ubpr, rcu_head);
+	return err;
+}
+
 static void ieee80211_free_next_beacon(struct ieee80211_link_data *link)
 {
 	if (!link->u.ap.next_beacon)
@@ -6018,6 +6219,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_default_beacon_key = ieee80211_config_default_beacon_key,
 	.start_ap = ieee80211_start_ap,
 	.change_beacon = ieee80211_change_beacon,
+	.update_beacon = ieee80211_update_beacon,
 	.stop_ap = ieee80211_stop_ap,
 	.add_station = ieee80211_add_station,
 	.del_station = ieee80211_del_station,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f1c0b87fddd5..accd89bbc1fb 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1107,6 +1107,22 @@ static inline void drv_stop_ap(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_update_beacon(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_bss_conf *link_conf,
+				     u64 changed)
+{
+	/* can race with HW restart, so don't warn */
+	if (!(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+		return;
+
+	trace_drv_update_beacon(local, sdata, link_conf, changed);
+	if (local->ops->update_beacon)
+		local->ops->update_beacon(&local->hw, &sdata->vif, link_conf,
+					  changed);
+	trace_drv_return_void(local);
+}
+
 static inline void
 drv_reconfig_complete(struct ieee80211_local *local,
 		      enum ieee80211_reconfig_type reconfig_type)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 562a4964afa3..ea46c3cca21a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1924,6 +1924,34 @@ TRACE_EVENT(drv_stop_ap,
 	)
 );
 
+TRACE_EVENT(drv_update_beacon,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_bss_conf *link_conf,
+		 u64 changed),
+
+	TP_ARGS(local, sdata, link_conf, changed),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u32, link_id)
+		__field(u64, changed)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->link_id = link_conf->link_id;
+		__entry->changed = changed;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " link id %u changed:%#llx",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->link_id, __entry->changed
+	)
+);
+
 TRACE_EVENT(drv_reconfig_complete,
 	TP_PROTO(struct ieee80211_local *local,
 		 enum ieee80211_reconfig_type reconfig_type),
-- 
2.55.0

