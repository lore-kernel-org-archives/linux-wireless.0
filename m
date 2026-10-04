Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FC1490BE3
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140501; cv=none; b=qTZ96pbfPy10cpnWqH3bUEY8/0dQbRec4PIgXI1OCumRPVhXcI1HJoy6TechEKeGG+eR9G4w+S1dV/XLdwrn5BRBWD8J3Iqowk1UxDecE79M5WlbISXTY5Dah32j9maLTDQIHaA4N6oPYaKrg1B4ZOwTHMiUwqQLX5Rynn4/0nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140501; c=relaxed/simple;
	bh=N/H2YuHs1qnGnJTqFNBz7gTRBTP8ipVzG/2vJ+62ipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u92hUCVWsmnyaC8CmZyaxXtUV2i/hn3Xj56nzHph4Ig+S9bDuYYTV9aFvIm5Xm5kWIUkr5BgvXN4x65+Dd/C7I2IwYvkMzlkzNCn7BV4/6gvPUHJSvsUxl3HJxHypwQS5+g4JRORoH9gjxwr2Zc6k+3BpFY4kjvdXpBzYJDzvY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=THCevI1Y; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="THCevI1Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=uAcKcoWhQtJMOSganu+2M9aO5zhGJQYwfINEAqzFi5I=;
	t=1791140496; x=1792350096; b=THCevI1Yl//PUGr9tDvVzBlQEQYL8BmPNu6v9jdA5inkG65
	I9IFc8nNGqsDpcAOXU/ITZUoZubSFffJa6S8WQUsmTTAo8fguh1SLSGQyl/G4YUJF8Z/Wlj6ZV69l
	eYWtmUOYqYU2ruIPcX3oOcf1DsgwlBovWHJzdf/IDXtG5L+DTl+fwZz2kd6M6aYEr9RTt5jdU4tXF
	UI2cB6ydrk35z6oVny+Q6KcAfSbOKbM7jJtqODU8hO891stO7y4j41jekZqZve6dY+APEHmZxgni5
	CUd/2+hZk9JHuzPGQQjYXBEJGvveW3J6xd+XBUDulTdn3kTQ4xpA7mgpq/H0IEng==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSk-00000004Jlo-147e;
	Sun, 04 Oct 2026 21:01:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 07/18] wifi: cfg80211: update channel DFS data under wiphy mutex
Date: Sun,  4 Oct 2026 21:01:21 +0200
Message-ID: <20261004210122.dc7a8dfbc5f9.I9074ec4427736f66fd5d9d47a53ccd94a1f260bf@changeid>
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

We check the DFS data for a channel under wiphy mutex, but
the code sometimes writes it under RTNL only. Fix that to
avoid data races and to prepare things for later removal
of the RTNL here.

cfg80211_dfs_channels_update_work() must change a bit more
to do this, since it locks other wiphys and nesting locks
is, while possible, too difficult: track the changes in an
array and update everything afterwards.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mlme.c | 90 +++++++++++++++++++++++++++++++++++++--------
 net/wireless/reg.c  |  6 ++-
 2 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a0d1cde26f0c..131039b675fe 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1070,18 +1070,49 @@ void cfg80211_sched_dfs_chan_update(struct cfg80211_registered_device *rdev)
 	queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk, 0);
 }
 
+struct cfg80211_dfs_chan_expiry {
+	struct ieee80211_channel *chan;
+	unsigned long entered;
+	enum nl80211_dfs_state state;
+	enum nl80211_radar_event event;
+};
+
+static bool cfg80211_dfs_chan_expire(struct cfg80211_registered_device *rdev,
+				     struct cfg80211_dfs_chan_expiry *exp,
+				     struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_channel *c = exp->chan;
+
+	guard(wiphy)(&rdev->wiphy);
+
+	/* the state may have changed while the wiphy wasn't locked */
+	if (c->dfs_state != exp->state || c->dfs_state_entered != exp->entered)
+		return false;
+
+	c->dfs_state = NL80211_DFS_USABLE;
+	c->dfs_state_entered = jiffies;
+
+	cfg80211_chandef_create(chandef, c, NL80211_CHAN_NO_HT);
+
+	nl80211_radar_notify(rdev, chandef, exp->event, NULL, GFP_KERNEL);
+
+	return true;
+}
+
 void cfg80211_dfs_channels_update_work(struct work_struct *work)
 {
 	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct cfg80211_dfs_chan_expiry *expired;
 	struct cfg80211_registered_device *rdev;
 	struct cfg80211_chan_def chandef;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *c;
 	struct wiphy *wiphy;
-	bool check_again = false;
+	bool check_again = false, pre_cac_allowed;
 	unsigned long timeout, next_time = 0;
 	unsigned long time_dfs_update;
 	enum nl80211_radar_event radar_event;
+	unsigned int n_chans = 0, n_expired = 0;
 	int bandid, i;
 
 	rdev = container_of(delayed_work, struct cfg80211_registered_device,
@@ -1089,6 +1120,25 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 	wiphy = &rdev->wiphy;
 
 	rtnl_lock();
+	wiphy_lock(wiphy);
+	for (bandid = 0; bandid < NUM_NL80211_BANDS; bandid++) {
+		if (wiphy->bands[bandid])
+			n_chans += wiphy->bands[bandid]->n_channels;
+	}
+
+	expired = kvcalloc(n_chans, sizeof(*expired), GFP_KERNEL);
+	if (!expired) {
+		/* hmm - retry later */
+		queue_delayed_work(cfg80211_wq,
+				   &rdev->dfs_update_channels_wk,
+				   HZ);
+		wiphy_unlock(wiphy);
+		rtnl_unlock();
+		return;
+	}
+
+	pre_cac_allowed = regulatory_pre_cac_allowed(wiphy);
+
 	for (bandid = 0; bandid < NUM_NL80211_BANDS; bandid++) {
 		sband = wiphy->bands[bandid];
 		if (!sband)
@@ -1108,8 +1158,7 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 				time_dfs_update = IEEE80211_DFS_MIN_NOP_TIME_MS;
 				radar_event = NL80211_RADAR_NOP_FINISHED;
 			} else {
-				if (regulatory_pre_cac_allowed(wiphy) ||
-				    cfg80211_any_wiphy_oper_chan(wiphy, c))
+				if (pre_cac_allowed)
 					continue;
 
 				time_dfs_update = REG_PRE_CAC_EXPIRY_GRACE_MS;
@@ -1120,19 +1169,11 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 				  msecs_to_jiffies(time_dfs_update);
 
 			if (time_after_eq(jiffies, timeout)) {
-				c->dfs_state = NL80211_DFS_USABLE;
-				c->dfs_state_entered = jiffies;
-
-				cfg80211_chandef_create(&chandef, c,
-							NL80211_CHAN_NO_HT);
-
-				nl80211_radar_notify(rdev, &chandef,
-						     radar_event, NULL,
-						     GFP_ATOMIC);
-
-				regulatory_propagate_dfs_state(wiphy, &chandef,
-							       c->dfs_state,
-							       radar_event);
+				expired[n_expired].chan = c;
+				expired[n_expired].state = c->dfs_state;
+				expired[n_expired].entered = c->dfs_state_entered;
+				expired[n_expired].event = radar_event;
+				n_expired++;
 				continue;
 			}
 
@@ -1143,8 +1184,25 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 			check_again = true;
 		}
 	}
+	wiphy_unlock(wiphy);
+
+	/* these lock the wiphys, so must be done without holding ours */
+	for (i = 0; i < n_expired; i++) {
+		if (expired[i].event == NL80211_RADAR_PRE_CAC_EXPIRED &&
+		    cfg80211_any_wiphy_oper_chan(wiphy, expired[i].chan))
+			continue;
+
+		if (!cfg80211_dfs_chan_expire(rdev, &expired[i], &chandef))
+			continue;
+
+		regulatory_propagate_dfs_state(wiphy, &chandef,
+					       NL80211_DFS_USABLE,
+					       expired[i].event);
+	}
 	rtnl_unlock();
 
+	kvfree(expired);
+
 	/* reschedule if there are other channels waiting to be cleared again */
 	if (check_again)
 		queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ed4d43a8cb78..28c431e0c5df 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3054,6 +3054,8 @@ static void wiphy_all_share_dfs_chan_state(struct wiphy *wiphy)
 
 	ASSERT_RTNL();
 
+	guard(wiphy)(wiphy);
+
 	for_each_rdev(rdev) {
 		if (wiphy == &rdev->wiphy)
 			continue;
@@ -4270,7 +4272,7 @@ static void cfg80211_check_and_end_cac(struct cfg80211_registered_device *rdev)
 	struct wireless_dev *wdev;
 	unsigned int link_id;
 
-	guard(wiphy)(&rdev->wiphy);
+	lockdep_assert_wiphy(&rdev->wiphy);
 
 	/* If we finished CAC or received radar, we should end any
 	 * CAC running on the same channels.
@@ -4321,6 +4323,8 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 					   chandef->chan->center_freq))
 			continue;
 
+		guard(wiphy)(&rdev->wiphy);
+
 		cfg80211_set_dfs_state(&rdev->wiphy, chandef, dfs_state);
 
 		if (event == NL80211_RADAR_DETECTED ||
-- 
2.55.0

