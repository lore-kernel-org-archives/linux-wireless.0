Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAFC4F7CCF
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569667; cv=none; b=AKwI68ePM83BbfoV3ybCrMlY2gifAg4toPRNkhSC+ynwPMiqnw2ZGss5WFXntmhmpb8OD5hDKdXjqQCrl42h0ZWG3MkX06gh87brvM2DIGbHZn9QX/pzSA6r4Zdu77dUEfpKVlSsKxo8xN4NaTbr4g7LgzcYcXMoMQQkEPPaY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569667; c=relaxed/simple;
	bh=v3B+xXQ0ZdI0bXyT+R5UBKrhQpoWXen+jj5ngoGQvsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5XMKw/n8ja+GYElSPFh0uB4JETrLQ9yC2CYQdNlUvg7U+bcp8Ycme51LidQ8SREBCA5T7Rz0EXKLGEYs2Qq4kt06nUV58TrA6vmd7zYV4FMShZe6S91zmO5LH2Koqw/2vw77JkAIgXMKpUKfLeuaCixkIkfA5PQC5Idy7KnyzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=D3uUSNKj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="D3uUSNKj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KSVhEP+YMzrrQ6ybM9jL1lWkfe1XfMnx6AjTIelDeZw=;
	t=1791569665; x=1792779265; b=D3uUSNKjpDEmdve2fjiAMdfBGgNGKRMyd56LeqopCyM8zi6
	j6Hjm1f5Ytz29RGfbRf+oo7GQ8RZ920hde9IS+Xj9vNrDSvi5wo2bV41ON93S+C66bT9X806k6mvN
	x6hrCiLev2yN2nb3C1Ssg3GzvYftGFZFqK/cfzzBid/54lqtp0d4L6mESI3t7Rq4u7Mfn5505MY8u
	bB2/w3KEfdqC1r8hYWRTza+IIXD/tcSq0humnbq5tAJD42aGSVnOotobbWRrXqI68ySmy7Z4Ddp1S
	BvJv4JI4R2KkStab/oiulVGubzPxCuj4F47quuNp0V7QqcUmx2jieHlaq48Vwuqg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6s-0000000AtGH-0TZO;
	Fri, 09 Oct 2026 20:14:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 04/17] wifi: mac80211: implement lockless beacon updates
Date: Fri,  9 Oct 2026 20:10:03 +0200
Message-ID: <20261009201417.a9433ea65d8e.Icfbcd157ac2bdeccfcc74a9f4c3997d3010ec0a9@changeid>
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

Implement the new update_beacon() method to update beacon
and related templates without the wiphy mutex. If anything
else were to change return -EAGAIN, same if there are any
active countdowns, and during HW restart. Eventually, the
idea is to replace countdowns by beacon update requests so
hostapd can handle everything instead.

This doesn't enable it for any drivers since it depends on
the driver behaviour, if it fetches each beacon and doesn't
use the other templates it can just set the feature flag
(NL80211_EXT_FEATURE_UPDATE_BEACON), otherwise it must
implement the new update_beacon() mac80211 method.

The regular beacon update may need to take head, tail and
MBSSID/RNR elements from the old beacon, so while that's
going on mark "bss_update_in_progress" and make lockless
updates return -EAGAIN during that time, so that the old
data remains valid/identical.

For MBSSID, the lockless path also can't copy old data,
so that also has to return -EAGAIN.

All those -EAGAIN cases fall back to cfg80211 and do the
update with the lock held, where it can then be handled.
Userspace should ideally ensure it doesn't hit that path.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2:
 - split
 - handle concurrent locked/unlocked updates differently to
   avoid mbssid problems
---
 include/net/mac80211.h     |   7 ++
 net/mac80211/cfg.c         | 225 ++++++++++++++++++++++++++++++++++---
 net/mac80211/driver-ops.h  |  16 +++
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/trace.h       |  28 +++++
 5 files changed, 263 insertions(+), 15 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a24d849b8f9c..2a61079e3975 100644
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
index 0b124b04003e..30fe29f25928 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1561,17 +1561,23 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 {
 	struct cfg80211_mbssid_elems *mbssid = params->mbssid_ies;
 	struct cfg80211_rnr_elems *rnr = mbssid ? params->rnr_ies : NULL;
-	struct beacon_data *new, *old;
+	struct beacon_data *new = NULL, *old;
 	int new_head_len, new_tail_len;
 	int err;
 	u64 _changed = BSS_CHANGED_BEACON;
 	struct ieee80211_bss_conf *link_conf = link->conf;
 
-	old = sdata_dereference(link->u.ap.beacon, sdata);
+	/* grab old and make lockless updates return -EAGAIN */
+	spin_lock(&link->ap_tmpl_lock);
+	old = ap_tmpl_dereference(link, link->u.ap.beacon);
+	link->u.ap.bss_update_in_progress = true;
+	spin_unlock(&link->ap_tmpl_lock);
 
 	/* Need to have a beacon head if we don't have one yet */
-	if (!params->head && !old)
-		return -EINVAL;
+	if (!params->head && !old) {
+		err = -EINVAL;
+		goto error;
+	}
 
 	/* new or old head? */
 	if (params->head)
@@ -1593,8 +1599,10 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	new = ieee80211_alloc_beacon(mbssid, rnr, new_head_len, new_tail_len);
-	if (!new)
-		return -ENOMEM;
+	if (!new) {
+		err = -ENOMEM;
+		goto error;
+	}
 
 	if (new->mbssid_ies)
 		link_conf->bssid_indicator =
@@ -1625,10 +1633,8 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	err = ieee80211_set_probe_resp(sdata, params->probe_resp,
 				       params->probe_resp_len, csa, cca, link);
-	if (err < 0) {
-		kfree(new);
-		return err;
-	}
+	if (err < 0)
+		goto error;
 	if (err == 0)
 		_changed |= BSS_CHANGED_AP_PROBE_RESP;
 
@@ -1641,21 +1647,31 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 							 params->civicloc_len,
 							 link_conf);
 
-		if (err < 0) {
-			kfree(new);
-			return err;
-		}
+		if (err < 0)
+			goto error;
 
 		_changed |= BSS_CHANGED_FTM_RESPONDER;
 	}
 
-	ap_tmpl_replace(link, link->u.ap.beacon, new);
+	spin_lock(&link->ap_tmpl_lock);
+	rcu_assign_pointer(link->u.ap.beacon, new);
+	link->u.ap.bss_update_in_progress = false;
+	spin_unlock(&link->ap_tmpl_lock);
 	sdata->u.ap.active = true;
 
+	if (old)
+		kfree_rcu(old, rcu_head);
+
 	ieee80211_update_ap_bandwidth(link, params);
 
 	*changed |= _changed;
 	return 0;
+error:
+	spin_lock(&link->ap_tmpl_lock);
+	link->u.ap.bss_update_in_progress = false;
+	spin_unlock(&link->ap_tmpl_lock);
+	kfree(new);
+	return err;
 }
 
 static u8 ieee80211_num_beaconing_links(struct ieee80211_sub_if_data *sdata)
@@ -2050,6 +2066,184 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
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
+	new = ieee80211_alloc_beacon(beacon->mbssid_ies,
+				     beacon->mbssid_ies ? beacon->rnr_ies : NULL,
+				     beacon->head_len, beacon->tail_len);
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
+	} else if (link->u.ap.bss_update_in_progress) {
+		/* a locked update is in progress */
+		old = NULL;
+	} else if (READ_ONCE(old->cntdwn_current_counter)) {
+		/* a countdown just started, must keep the offsets */
+		old = NULL;
+	} else if (old->mbssid_ies && !new->mbssid_ies) {
+		/* only locked path copies old MBSSID data */
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
@@ -6071,6 +6265,7 @@ const struct cfg80211_ops mac80211_config_ops = {
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
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b16ff6a4aacf..16c1e0337f3a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1103,6 +1103,8 @@ struct ieee80211_link_data_ap {
 	struct unsol_bcast_probe_resp_data __rcu *unsol_bcast_probe_resp;
 	struct s1g_short_beacon_data __rcu *s1g_short_beacon;
 
+	bool bss_update_in_progress;
+
 	/* to be used after channel switch. */
 	struct cfg80211_beacon_data *next_beacon;
 };
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
2.56.0

