Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC194908BD
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140500; cv=none; b=AKvRxo8kIvhPgl7aLwU4BzJvWBQKK7UNShkD8Du1kjFKlDainLx5nyEWTlmWGjbu84D3k+fqYMfj7QcoA3kUPkRTs0XkQsBQPeT3ouYpVe9Faxv9Aw0B9LOEqycLWML0OPc7RG8Re29yyu2jsN1BMPmKo3EM3AIW0vblxObJhu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140500; c=relaxed/simple;
	bh=H794tgkQCfulG6xKfONTiI3clnXCkjb241Xc/DXU9fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqEhirK+ufg0VyQyis4ddK4jU8gJQoWCfBpEED59YEGykigrNkX/PfK6+Aa96DP35r4t+iHeqpYPKS+9HVCX8YhsUXQZ1jvhdjizbK7XhDOKG6vocSj8oEsH9pxZwjSUiK/3WGbHr2b4ifAlYMhnSUCHsZ0tZQdAK9gTAWRO6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KtG9KQDV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KtG9KQDV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=me92KwpU/LoEttXmoBDbc9ZoiXraIAUVgWgOqGrq2vw=;
	t=1791140493; x=1792350093; b=KtG9KQDVyPGJtDXzA2Ynjs6ru5aYAxqhoP8oPDMf1KusbIv
	fKWF284FffLzmWAcFrJ4bo9QpdlSBvJRMHzO5izDeVw1/N2kQGTsXbjzFEsV9Tv/WgqOgXnyUr9ko
	TOsGLyuZEnkrlofIyBrfRTeKIuiWFsOO6lqxF2dg8pkVBnT97Bth+mk93aJe9L/QvgLbYej/dMq/d
	5GxETcbRhmblxI6TjnWuVj9J95gUDM9kui+ygKxwwQyfPKF4bCjhE53yDLzlOQ706Xd6xgqLfIAZE
	ld9o30OEmQd83gHPNiutrBae107EeN02R6ntXJDUgbF5LLrPbg01/HjMoCFaOc8Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSj-00000004Jlo-0H79;
	Sun, 04 Oct 2026 21:01:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 05/18] wifi: cfg80211: reg: update channels under wiphy mutex
Date: Sun,  4 Oct 2026 21:01:19 +0200
Message-ID: <20261004210122.061bb113e846.Id85777e278fbcf05b1ae1c42d2424acf6ed75fd6@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Regulatory code updates channels holding only RTNL. Since
I removed RTNL everywhere, most reading code doesn't take
it, so it races with the updates.

Update the relevant regulatory data under wiphy mutex to
avoid (most of?) those races.

Some drivers acquire the wiphy mutex, so don't cover the
calls to the regulatory notifiers.

For beacon hints the order of operation changes, and the
driver notifier will be called only once later, but that
seems acceptable (even better) to drivers as I see it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 55 ++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b7ef479a74f0..1a67d146bf2b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2145,31 +2145,32 @@ static void reg_call_notifier(struct wiphy *wiphy,
 		wiphy->reg_notifier(wiphy, request);
 }
 
-static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
+static bool handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 			      struct reg_beacon *reg_beacon)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	bool channel_changed = false;
 	struct ieee80211_channel chan_before;
-	struct regulatory_request *lr = get_last_request();
+
+	lockdep_assert_wiphy(wiphy);
 
 	sband = wiphy->bands[reg_beacon->chan.band];
 	chan = &sband->channels[chan_idx];
 
 	if (likely(!ieee80211_channel_equal(chan, &reg_beacon->chan)))
-		return;
+		return false;
 
 	if (chan->beacon_found)
-		return;
+		return false;
 
 	chan->beacon_found = true;
 
 	if (!reg_is_world_roaming(wiphy))
-		return;
+		return false;
 
 	if (wiphy->regulatory_flags & REGULATORY_DISABLE_BEACON_HINTS)
-		return;
+		return false;
 
 	chan_before = *chan;
 
@@ -2178,11 +2179,10 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 		channel_changed = true;
 	}
 
-	if (channel_changed) {
+	if (channel_changed)
 		nl80211_send_beacon_hint_event(wiphy, &chan_before, chan);
-		if (wiphy->flags & WIPHY_FLAG_CHANNEL_CHANGE_ON_BEACON)
-			reg_call_notifier(wiphy, lr);
-	}
+
+	return channel_changed;
 }
 
 /*
@@ -2194,14 +2194,20 @@ static void wiphy_update_new_beacon(struct wiphy *wiphy,
 {
 	unsigned int i;
 	struct ieee80211_supported_band *sband;
+	bool changed = false;
 
 	if (!wiphy->bands[reg_beacon->chan.band])
 		return;
 
 	sband = wiphy->bands[reg_beacon->chan.band];
 
-	for (i = 0; i < sband->n_channels; i++)
-		handle_reg_beacon(wiphy, i, reg_beacon);
+	scoped_guard(wiphy, wiphy) {
+		for (i = 0; i < sband->n_channels; i++)
+			changed |= handle_reg_beacon(wiphy, i, reg_beacon);
+	}
+
+	if (changed && wiphy->flags & WIPHY_FLAG_CHANNEL_CHANGE_ON_BEACON)
+		reg_call_notifier(wiphy, get_last_request());
 }
 
 /*
@@ -2546,11 +2552,15 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 
 	lr->dfs_region = get_cfg80211_regdom()->dfs_region;
 
-	for (band = 0; band < NUM_NL80211_BANDS; band++)
-		handle_band(wiphy, initiator, wiphy->bands[band]);
+	/* the notifier is called below, so ignore beacon hint changes */
+	scoped_guard(wiphy, wiphy) {
+		for (band = 0; band < NUM_NL80211_BANDS; band++)
+			handle_band(wiphy, initiator, wiphy->bands[band]);
+
+		reg_process_beacons(wiphy);
+		reg_process_ht_flags(wiphy);
+	}
 
-	reg_process_beacons(wiphy);
-	reg_process_ht_flags(wiphy);
 	reg_call_notifier(wiphy, lr);
 }
 
@@ -3166,12 +3176,14 @@ static void reg_process_pending_beacon_hints(void)
 {
 	struct cfg80211_registered_device *rdev;
 	struct reg_beacon *pending_beacon, *tmp;
+	LIST_HEAD(pending);
 
 	/* This goes through the _pending_ beacon list */
 	spin_lock_bh(&reg_pending_beacons_lock);
+	list_splice_tail_init(&reg_pending_beacons, &pending);
+	spin_unlock_bh(&reg_pending_beacons_lock);
 
-	list_for_each_entry_safe(pending_beacon, tmp,
-				 &reg_pending_beacons, list) {
+	list_for_each_entry_safe(pending_beacon, tmp, &pending, list) {
 		list_del_init(&pending_beacon->list);
 
 		/* Applies the beacon hint to current wiphys */
@@ -3181,8 +3193,6 @@ static void reg_process_pending_beacon_hints(void)
 		/* Remembers the beacon hint for new wiphys or reg changes */
 		list_add_tail(&pending_beacon->list, &reg_beacon_list);
 	}
-
-	spin_unlock_bh(&reg_pending_beacons_lock);
 }
 
 static void reg_process_self_managed_hint(struct wiphy *wiphy)
@@ -3571,8 +3581,11 @@ static void restore_regulatory_settings(bool reset_user, bool cached)
 	for_each_rdev(rdev) {
 		if (rdev->wiphy.regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
 			continue;
-		if (rdev->wiphy.regulatory_flags & REGULATORY_CUSTOM_REG)
+		if (rdev->wiphy.regulatory_flags & REGULATORY_CUSTOM_REG) {
+			guard(wiphy)(&rdev->wiphy);
+
 			restore_custom_reg_settings(&rdev->wiphy);
+		}
 	}
 
 	if (cached && (!is_an_alpha2(alpha2) ||
-- 
2.55.0

