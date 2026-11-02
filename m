Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663773;
	b=cDe7TVPMu8k3EuMWZR/Ak/wo7k/InvIOPo3wLmkLuIHLrMOW9EHBYWHXqkNzzaI6rAgW
	 xn9rbv8xChPggSLIEP+aFu67VfVCASnauvmNtK0yxoDHdnyMJZhJPNRl4jA/ByLVG05bw
	 mmN3sSO9YhHP69RGNNBavDnbcQykxJmHXsP4WkKSinzZwSzoVjwPvUQhvw1nots3Y9w47
	 Owk01JSqYTMTt23ylsG3w3KxIunlpQ7jPQK3+oFuq57z2vFqpmt4va34Q3I7US8AQ7nsJ
	 /u4cL30N6PNXZUNZxKB9CqqjHsZ1+YAgPFPXQx8U+bO8Hby9y6+QElqoBMDYru0YVBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663773;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jYXvgtAfAX2h4ZhQpN/DtwHGxlww24IO11XWuqOASI8=;
	b=GeKNVX378KOfQWpGDTrLADy3a7KLkdYklhOdyXjAg6RHZ/YD2OgQwJfkh7Cb5qH54yML
	 lw6kCVRWmnCMtM8Kf6BjM4jahbYaaDlki9HMegUUuOg3jLKg6EaBcPMwFA8P9fnrKoNZ0
	 UEjTtvIbgUFxOllCR/BxCFb1bD8WC379uipvaWV6P2grHKMNUWK1Fsd7Tm0XBgMrs3zqU
	 0jjVj0qQzEzxkZR5MY0DPDWeo7PN3O4eTWoZ6EvJhDGdynE7dhSwS+1nVxHAjYtEzhSqg
	 j2QH0Wlx5UKZJ2XkGPN4Jz1Gi3RkvKloludMnYVjCeUHcmTnLXW3c1ONav+CpQazaIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GL6MsZuQ;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5BC606A334
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GL6MsZuQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=jYXvgtAfAX2h4ZhQpN/DtwHGxlww24IO11XWuqOASI8=;
	t=1793663772; x=1794873372; b=GL6MsZuQ+dNAf9khHH0ro4wxvYO6lYHMQFZXs6XSTSIGWfm
	7n1/MLMAfxslgtlaW0Hn18XGIIxNq/o8BcfL7ESgknuhYI5qcCkZUjSs5C/hb1ZunYowSNXNQ1xkf
	SbLFi5IytU50nG4FC8odbMIQooQxG8KYgmyvg11Xb1DnYxL5J9XuWJ51b6r768BcAxp2v/9vZcT4m
	YXNUXzQ0koFj0ew21V3r3JjHMUneU3LpP+EQvVdDP/UVLcmsJLkKwX5tB/oyUKCQI/o6X4Pk3Wq7q
	p0tby4+aqL9y3EiN+VrAX5oybY/hTYyJp1xWbv6gkcIA85g0KYB4x2sD2nxgOMGQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1so-00000002AZf-2pJ6;
	Tue, 03 Nov 2026 00:56:10 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 7/7] wifi: mac80211: destroy AP stations asynchronously
Date: Tue,  3 Nov 2026 00:54:04 +0100
Message-ID: <20261102235603.1181883-16-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102235603.1181883-9-johannes@sipsolutions.net>
References: <20261102235603.1181883-9-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When hostapd removes a station, the station destruction
needs to wait for an RCU grace period, all while holding
the wiphy mutex and blocking hostapd.

For AP stations, use a wiphy_rcu_work to finish the
cleanup after an RCU grace period, without holding the
wiphy mutex while waiting.

To avoid confusion in drivers, destroy stations that are
waiting for destruction synchronously before adding new
(link) stations, as well as suspend/restart.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  7 +++
 net/mac80211/main.c        |  4 ++
 net/mac80211/pm.c          |  2 +
 net/mac80211/sta_info.c    | 87 +++++++++++++++++++++++++++++++++++---
 net/mac80211/sta_info.h    |  1 +
 5 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 933336c9c838..dc2105b4829b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1623,6 +1623,13 @@ struct ieee80211_local {
 	struct rhltable link_sta_hash;
 	struct timer_list sta_cleanup;
 	int sta_generation;
+	/*
+	 * stations waiting to be destroyed: the first list is covered by
+	 * the grace period of the pending sta_destroy_work, the second has
+	 * those removed while the work was already pending
+	 */
+	struct list_head sta_destroy_list, sta_destroy_new;
+	struct wiphy_rcu_work sta_destroy_work;
 
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6e31076bcc10..c2628e10b0f8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -522,6 +522,9 @@ static void ieee80211_restart_work(struct work_struct *work)
 	/* wait for all packet processing to be done */
 	synchronize_net();
 
+	/* finish removing stations before the driver is reconfigured */
+	sta_info_destroy_flush(local);
+
 	ret = ieee80211_reconfig(local);
 	wiphy_unlock(local->hw.wiphy);
 
@@ -1728,6 +1731,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	wiphy_lock(local->hw.wiphy);
 	wiphy_delayed_work_cancel(local->hw.wiphy, &local->roc_work);
+	wiphy_rcu_work_cancel(local->hw.wiphy, &local->sta_destroy_work);
 	wiphy_work_cancel(local->hw.wiphy, &local->reconfig_filter);
 	wiphy_work_cancel(local->hw.wiphy, &local->sched_scan_stopped_work);
 	wiphy_work_cancel(local->hw.wiphy, &local->radar_detected_work);
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 6a27f8f35c8e..e41d0fa09d1e 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -39,6 +39,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan,
 
 	ieee80211_del_virtual_monitor(local);
 
+	sta_info_destroy_flush(local);
+
 	if (ieee80211_hw_check(hw, AMPDU_AGGREGATION) &&
 	    !(wowlan && wowlan->any)) {
 		lockdep_assert_wiphy(local->hw.wiphy);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 17247ba3209f..0908374dbdf7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1042,6 +1042,9 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 	might_sleep();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	/* the driver must not see the new station before old ones are gone */
+	sta_info_destroy_flush(local);
+
 	err = sta_info_insert_check(sta);
 	if (err) {
 		sta_info_free(local, sta);
@@ -1384,6 +1387,11 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
+	local->num_sta--;
+	local->sta_generation++;
+
+	ieee80211_sta_debugfs_remove(sta);
+
 	if (sta->uploaded)
 		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
@@ -1596,9 +1604,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 
 	cancel_work_sync(&sta->drv_deliver_wk);
 
-	local->num_sta--;
-	local->sta_generation++;
-
 	while (sta->sta_state > IEEE80211_STA_NONE) {
 		ret = _sta_info_move_state(sta, sta->sta_state - 1, recalc);
 		if (ret) {
@@ -1622,8 +1627,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 	cfg80211_del_sta_sinfo(&sdata->wdev, sta->sta.addr, sinfo, GFP_KERNEL);
 	kfree(sinfo);
 
-	ieee80211_sta_debugfs_remove(sta);
-
 	ieee80211_destroy_frag_cache(&sta->frags);
 
 	cleanup_single_sta(sta);
@@ -1653,15 +1656,78 @@ int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	return __sta_info_destroy(sta);
 }
 
+static void sta_info_destroy_queue(struct ieee80211_local *local)
+{
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (list_empty(&local->sta_destroy_new))
+		return;
+
+	/*
+	 * If the work was actually queued now, its grace period covers all
+	 * stations removed so far, otherwise it's already pending and will
+	 * requeue itself for the new ones when it runs.
+	 */
+	if (wiphy_rcu_work_queue(local->hw.wiphy, &local->sta_destroy_work))
+		list_splice_tail_init(&local->sta_destroy_new,
+				      &local->sta_destroy_list);
+}
+
 int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	int err;
 
-	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+	lockdep_assert_wiphy(local->hw.wiphy);
 
 	sta = sta_info_get_bss(sdata, addr);
-	return __sta_info_destroy(sta);
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		return __sta_info_destroy(sta);
+
+	err = __sta_info_destroy_part1(sta);
+	if (err)
+		return err;
+
+	/* finish later, after an RCU grace period */
+	list_add_tail(&sta->free_list, &local->sta_destroy_new);
+	sta_info_destroy_queue(local);
+
+	return 0;
+}
+
+static void sta_info_destroy_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local,
+			     sta_destroy_work.work);
+	struct sta_info *sta, *tmp;
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	list_for_each_entry_safe(sta, tmp, &local->sta_destroy_list, free_list) {
+		list_del(&sta->free_list);
+		__sta_info_destroy_part2(sta, true);
+	}
+
+	/* requeue for stations removed after the work was queued */
+	sta_info_destroy_queue(local);
+}
+
+/* finish destroying all stations that are pending, waiting if needed */
+void sta_info_destroy_flush(struct ieee80211_local *local)
+{
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	/* the work might requeue itself, flush it twice */
+	wiphy_rcu_work_flush(local->hw.wiphy, &local->sta_destroy_work);
+	wiphy_rcu_work_flush(local->hw.wiphy, &local->sta_destroy_work);
+
+	WARN_ON(!list_empty(&local->sta_destroy_list) ||
+		!list_empty(&local->sta_destroy_new));
 }
 
 static void sta_info_cleanup(struct timer_list *t)
@@ -1703,6 +1769,9 @@ int sta_info_init(struct ieee80211_local *local)
 
 	spin_lock_init(&local->tim_lock);
 	INIT_LIST_HEAD(&local->sta_list);
+	INIT_LIST_HEAD(&local->sta_destroy_list);
+	INIT_LIST_HEAD(&local->sta_destroy_new);
+	wiphy_rcu_work_init(&local->sta_destroy_work, sta_info_destroy_work);
 
 	timer_setup(&local->sta_cleanup, sta_info_cleanup, 0);
 	return 0;
@@ -1730,6 +1799,8 @@ int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool vlans,
 	WARN_ON(vlans && sdata->vif.type != NL80211_IFTYPE_AP);
 	WARN_ON(vlans && !sdata->bss);
 
+	sta_info_destroy_flush(local);
+
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    (!vlans || sdata->bss != sta->sdata->bss))
@@ -3489,6 +3560,8 @@ int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id)
 	if (WARN_ON(old_links == new_links || !link_sta))
 		return -EINVAL;
 
+	sta_info_destroy_flush(sdata->local);
+
 	rcu_read_lock();
 	if (link_sta_info_hash_lookup(sdata->local, link_sta->addr)) {
 		rcu_read_unlock();
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index fdb4820755f2..aef3eea9e942 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -956,6 +956,7 @@ int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
 			  const u8 *addr);
 int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr);
+void sta_info_destroy_flush(struct ieee80211_local *local);
 
 void sta_info_recalc_tim(struct sta_info *sta);
 
-- 
2.56.0

