Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B63DB335
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281233; cv=none; b=FL/EZznsVJh4QWrdZwcwAaH7did+WQUsvZ2XMF+tp1d7PJOe0l4lRgIi02ruYwtDlzMHhDvwrbDR4+aGX9G9eNsKZ1Ocfxxvn8x+UEAWh8UFjIx4V5QFO7RNL/OUEf5CbOvNnfwpGNBrEnpI7eMOIvBneqcXmJi+tUJ1e00uo2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281233; c=relaxed/simple;
	bh=2yTQW7fQnSnfpRMlQB8V8G1mFiimKjukcZKJJ8u8aWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVruL36aPNZ/gRQxlVTYXsUBpbDd4mKl6rw/ofSFo5++aW/E7B1MjiDUJMJVIxARQIDCJ4fctVGRijYu/l7G4Hk2sLBYw/kEtRC6k28iBkfCJRIkd8KqXHJWkIdiJojusfLuhvsrQUixYFSb5wW6JG9IfUX/8N5AmSe2/EMXOK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=dciAvA8j; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="dciAvA8j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=K2uBLoTLtNqQ3IQm2V/F0JrE7EIcLDJFC6AC3b2xscc=;
	t=1791281230; x=1792490830; b=dciAvA8j4umCRPne+FQYREeEiLvu6dNOf+X9bNR9g7aV1Q+
	i/yx/MksRrK7XufgnxMJ3yZXj/44Y7mVH+Srv55kXzw4qchyZaW5ufYLBOJrZYWeO5tlKSh+xwEox
	FQq8auDc3PDDbOC5CxhUsEm/istomPeba0pa2KRsY5M0U+tHoxdn6gGzoR/FpIc6sX3+pG+EX15D8
	/PwvRuwBB+pWCbDOhWvT9nsabeDsntBPl9dLEV29a8PGdmbrCDE3qSYzhAxNdteMQ8wsgMRfgd8RF
	MwDuy8nyZ77YVRo7YLxLLgRuO9vPybF/vOJY2u+yOOIH/2uJfB7xnjQ1hbfkHEvA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24i-00000006XqW-1UAZ;
	Tue, 06 Oct 2026 12:07:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 08/19] wifi: cfg80211: update channel DFS data under wiphy mutex
Date: Tue,  6 Oct 2026 12:04:06 +0200
Message-ID: <20261006120655.e90b467f7739.I9074ec4427736f66fd5d9d47a53ccd94a1f260bf@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
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
index 13d6fc5a56aa..a7602d6d4c64 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3060,6 +3060,8 @@ static void wiphy_all_share_dfs_chan_state(struct wiphy *wiphy)
 
 	ASSERT_RTNL();
 
+	guard(wiphy)(wiphy);
+
 	for_each_rdev(rdev) {
 		if (wiphy == &rdev->wiphy)
 			continue;
@@ -4276,7 +4278,7 @@ static void cfg80211_check_and_end_cac(struct cfg80211_registered_device *rdev)
 	struct wireless_dev *wdev;
 	unsigned int link_id;
 
-	guard(wiphy)(&rdev->wiphy);
+	lockdep_assert_wiphy(&rdev->wiphy);
 
 	/* If we finished CAC or received radar, we should end any
 	 * CAC running on the same channels.
@@ -4327,6 +4329,8 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 					   chandef->chan->center_freq))
 			continue;
 
+		guard(wiphy)(&rdev->wiphy);
+
 		cfg80211_set_dfs_state(&rdev->wiphy, chandef, dfs_state);
 
 		if (event == NL80211_RADAR_DETECTED ||
-- 
2.55.0

