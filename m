Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D0F38238C
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533794; cv=none; b=RLC4qBtecAW3L+rz0GdOuGKhZ8PyaIaZZs3Q5dAuDybKw8zUWHG4ylXXhWDnZfUiz81cWDbx8pOGZSN9M7yZGz0eTHG34UAejooP53/2G1zE2gBTBkSzBDvtKvreMvNdCQOah8KBz8Gtjbg9ekcUWvCbbhIDAPQTvr8keGfa5j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533794; c=relaxed/simple;
	bh=BWWdxzvyG4+CAQ94GbxfX2T/tcjzB1ex70pKVouCTpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAa1IuAbreGcJuJCzjoP6AjxrW59/vjh69QD/YkD7LfcAkPDtoINLBnuOqPmhYKeHzhuIRwebnRXoWgEDk81/DeyF/7rgu1xf0e2zdYYNDCiAyMIOzv2Vble9AVLcwbMu5UQq1TbvgtIYck4ba2HV5f9UWJ3wdYvNL9Qfzg1WUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bYuZEU1e; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bYuZEU1e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=A+RIWm1t4zYd9eBmLhG6EWCuprSrC9fH8P/AxOiH124=;
	t=1788533791; x=1789743391; b=bYuZEU1eGhMP6jFuUPbn/k90hX/cnnREwyNBxQerwdo0gBV
	rh9wNGj4kPcFJkjmd9CCvW0y7ZoFR7M7u7j6t+KyRpV3Bsg0mGq9fNEm88tg4DQ8BjA5mAJpeDMkh
	2CnmHqE730/0DR5a34q8Yu/2VNqP4fSzedjZoWl8adk4xHI4a8K+G7I8CHom1e6lJo2k1J1C36w68
	aS6DDnmgskRfD8PSALjcKhY+6vfxKu/ptRKyfKk4vs25IRI2A0HmycrVlcOvvnCqck1tNJCXLBZkk
	tH+ONNNFNjGn+0g8w3ky9LRfo09PN59pDR43vD161GD4NykBoqeC9lQ1BZoVXlUw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VLA-00000001SUL-3uxK;
	Fri, 04 Sep 2026 16:56:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+adeb8550754921fece20@syzkaller.appspotmail.com,
	syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com
Subject: [PATCH wireless 8/8] wifi: cfg80211: reduce RTNL holding in regulatory enforcement
Date: Fri,  4 Sep 2026 16:55:08 +0200
Message-ID: <20260904165614.f65bd4d9fa35.I82dac71371d87f39e459fce931b0e5321e4f9767@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145614.423902-10-johannes@sipsolutions.net>
References: <20260904145614.423902-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Regulatory enforcement in reg_check_chans_work() does all work
with the RTNL held, which can block the RTNL for a long time,
which syzbot can hit and report hung tasks.

Except for NAN, we don't need the RTNL for the enforcement, and
the list iteration can be done with RCU instead.

Split the enforcement off into new work structs: for NAN, we
have to have the RTNL to close dependent NAN_DATA interfaces,
everything else can use cfg80211_leave_locked() in a wiphy work.

It'd be doable to use just a single work with RTNL, but then
the RTNL would end up being used all the time, and really it
only needs to be used for NAN.

Assisted-by: LLM
Reported-by: syzbot+adeb8550754921fece20@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=adeb8550754921fece20
Reported-by: syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=101224300649c3eb8af4
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c |  3 +++
 net/wireless/core.h |  2 ++
 net/wireless/reg.c  | 50 +++++++++++++++++++++++++++++++++++++--------
 net/wireless/reg.h  | 16 +++++++++++++++
 4 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8bb2cbd66b48..668380deec7d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -645,6 +645,8 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
 	wiphy_work_init(&rdev->sched_scan_stop_wk, cfg80211_sched_scan_stop_wk);
 	INIT_WORK(&rdev->sched_scan_res_wk, cfg80211_sched_scan_results_wk);
+	wiphy_work_init(&rdev->reg_check_chans_wk, reg_leave_invalid_chans_wk);
+	INIT_WORK(&rdev->reg_leave_nan_wk, reg_leave_invalid_nan_wk);
 	INIT_WORK(&rdev->propagate_radar_detect_wk,
 		  cfg80211_propagate_radar_detect_wk);
 	INIT_WORK(&rdev->propagate_cac_done_wk, cfg80211_propagate_cac_done_wk);
@@ -1344,6 +1346,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 	cancel_delayed_work_sync(&rdev->background_cac_done_wk);
 	flush_work(&rdev->destroy_work);
+	flush_work(&rdev->reg_leave_nan_wk);
 	flush_work(&rdev->propagate_radar_detect_wk);
 	flush_work(&rdev->propagate_cac_done_wk);
 	flush_work(&rdev->mgmt_registrations_update_wk);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 85dfb3ac803b..6138d207caf4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -114,6 +114,8 @@ struct cfg80211_registered_device {
 	struct work_struct destroy_work;
 	struct wiphy_work sched_scan_stop_wk;
 	struct work_struct sched_scan_res_wk;
+	struct wiphy_work reg_check_chans_wk;
+	struct work_struct reg_leave_nan_wk;
 
 	struct cfg80211_chan_def radar_chandef;
 	struct work_struct propagate_radar_detect_wk;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9910b080b402..11665e0a7efc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2446,19 +2446,52 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	return true;
 }
 
-static void reg_leave_invalid_chans(struct wiphy *wiphy)
+void reg_leave_invalid_nan_wk(struct work_struct *work)
 {
+	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	rdev = container_of(work, struct cfg80211_registered_device,
+			    reg_leave_nan_wk);
+
+	/* stopping NAN closes its data interfaces, which needs the RTNL */
+	rtnl_lock();
 
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		bool valid;
 
-		scoped_guard(wiphy, wiphy)
-			valid = reg_wdev_chan_valid(wiphy, wdev);
+		if (wdev->iftype != NL80211_IFTYPE_NAN)
+			continue;
+
+		scoped_guard(wiphy, &rdev->wiphy)
+			valid = reg_wdev_chan_valid(&rdev->wiphy, wdev);
 		if (!valid)
 			cfg80211_leave(rdev, wdev, -1);
 	}
+
+	rtnl_unlock();
+}
+
+void reg_leave_invalid_chans_wk(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct wireless_dev *wdev;
+
+	lockdep_assert_held(&wiphy->mtx);
+
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (reg_wdev_chan_valid(wiphy, wdev))
+			continue;
+
+		/*
+		 * Tearing down NAN needs the RTNL for closing NAN_DATA
+		 * interfaces, handle that separately.
+		 */
+		if (wdev->iftype == NL80211_IFTYPE_NAN)
+			schedule_work(&rdev->reg_leave_nan_wk);
+		else
+			cfg80211_leave_locked(rdev, wdev, -1);
+	}
 }
 
 static void reg_check_chans_work(struct work_struct *work)
@@ -2466,12 +2499,13 @@ static void reg_check_chans_work(struct work_struct *work)
 	struct cfg80211_registered_device *rdev;
 
 	pr_debug("Verifying active interfaces after reg change\n");
-	rtnl_lock();
 
-	for_each_rdev(rdev)
-		reg_leave_invalid_chans(&rdev->wiphy);
+	rcu_read_lock();
 
-	rtnl_unlock();
+	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list)
+		wiphy_work_queue(&rdev->wiphy, &rdev->reg_check_chans_wk);
+
+	rcu_read_unlock();
 }
 
 void reg_check_channels(void)
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index fc31c5f9a61a..c587079ead8f 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -178,6 +178,22 @@ int reg_reload_regdb(void);
  */
 void reg_check_channels(void);
 
+/**
+ * reg_leave_invalid_chans_wk - check if channels are no longer usable and leave
+ * @wiphy: the wiphy to check
+ * @work: the work struct
+ */
+void reg_leave_invalid_chans_wk(struct wiphy *wiphy, struct wiphy_work *work);
+
+/**
+ * reg_leave_invalid_nan_wk - check channels and tear down NAN when unusable
+ * @work: the work struct
+ *
+ * Stopping a NAN interface needs the RTNL, so it cannot be done from
+ * reg_leave_invalid_chans_wk() which runs with the wiphy mutex held.
+ */
+void reg_leave_invalid_nan_wk(struct work_struct *work);
+
 extern const u8 shipped_regdb_certs[];
 extern unsigned int shipped_regdb_certs_len;
 extern const u8 extra_regdb_certs[];
-- 
2.55.0

