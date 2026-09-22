Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7D8538D9B
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077332; cv=none; b=cwLaniq3Ox16dPpgPDc7d0GE1uqF3MxjHCHtpVMKZWJ1FCOIPSSsKSbIdyQbvC5QM6VMoUFQayoXWYEkK2ut+psYgvVaVIBOqmHmk6CgBj/xTejL4YOYJyjCp0mhSjKbSw/2oX6bEsdPpk0JKX/GpyjbsULeJMkZZyaJB3RfvFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077332; c=relaxed/simple;
	bh=AOvxjAiX2FRLTsynE8ep23z/TkoMwZabYogr3Pp1r+A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cYdZ05qQRpkC12U6RS12xSdQuiOPQO+hdHXuqtgQ0khpHlaxARSJiYpAMTnCBn5OQENsfzHsXnpYWqkFEE8OSNoyUWNWcMyqfKgplhbE8xOZ7l65mWqx62qjdYpQPhvwQP2G8ahFUkc7IF7TlCEHH2w2npAp/1B6pD4bdGII4h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I0ld0465; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I0ld0465"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077330; x=1821613330;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AOvxjAiX2FRLTsynE8ep23z/TkoMwZabYogr3Pp1r+A=;
  b=I0ld0465suh2yQ9cAfF6XansG4PIjKns5WhrSOi4/l3YZtzJQBEN4Dmf
   EU70sCBazEGx8BL2/3frYLN1gIbxpNaGsIw0Y2aInxuEvChWs4QgvBHvw
   BU8WKzAXt2guO4jOW8DOJWqaLPYNsFqWkwl+rwRhlVpPlcSxgnd/M86Kg
   LljVnZRYKkRpkSUJx/JQfOhak91uG1Be0qRbUl04Iy7AiPj1+r/Z6DQX4
   TyXkfvaXWd5L+HsmvdPKHiDL2frcdS3YS+T1gEZVLOI+UQLGqmkrlixhV
   HXKBVYsST+BG1gfrgtd45x8/ZcthbEsafuI+axrMo3PbEeF9Gp+aw781l
   w==;
X-CSE-ConnectionGUID: 8a1elT4UR0OBLOBN5gXM6g==
X-CSE-MsgGUID: bERWrjKMQjumPcLTQjqc5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90693724"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="90693724"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:42:09 -0700
X-CSE-ConnectionGUID: qqn+w3w1ST6g5+D7oMRQEw==
X-CSE-MsgGUID: 8y2VMz2uQnCSh1JmPGet3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="271654873"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:42:08 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211_hwsim: Support NAN deferred schedule completion
Date: Tue, 22 Sep 2026 14:44:03 +0300
Message-Id: <20260922144356.81f62b390ef6.I21654fe82a0065a055a1b958297b2beb4337a1f0@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Simulate firmware completing a deferred NAN schedule update in
mac80211_hwsim by calling ieee80211_nan_sched_update_done() from a delayed
work, so that the completion notification reaches user space after the
update request returns, as it would with real hardware. This doesn't really
implement the schedule update flow and doesn't announce anything to the
peers. However, it should be good enough meanwhile for some minimal testing.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 22 +++++++++++++++++++
 .../net/wireless/virtual/mac80211_hwsim_nan.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index 7be64c45babf..2d9f6d7b9251 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -906,6 +906,18 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
+static void
+mac80211_hwsim_nan_sched_update_work(struct wiphy *wiphy,
+				     struct wiphy_work *work)
+{
+	struct mac80211_hwsim_data *data =
+		container_of(work, struct mac80211_hwsim_data,
+			     nan.sched_update_work.work);
+
+	if (data->nan.device_vif)
+		ieee80211_nan_sched_update_done(data->nan.device_vif);
+}
+
 int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_nan_conf *conf)
@@ -922,6 +934,9 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 	data->nan.device_vif = vif;
 	data->nan.bands = conf->bands;
 
+	wiphy_delayed_work_init(&data->nan.sched_update_work,
+				mac80211_hwsim_nan_sched_update_work);
+
 	scoped_guard(spinlock_bh, &data->nan.state_lock) {
 		/* Start in the "scan" phase and stay there for a little bit */
 		data->nan.phase = MAC80211_HWSIM_NAN_PHASE_SCAN;
@@ -960,6 +975,7 @@ int mac80211_hwsim_nan_stop(struct ieee80211_hw *hw,
 	hrtimer_cancel(&data->nan.slot_timer);
 	hrtimer_cancel(&data->nan.resume_txqs_timer);
 	hrtimer_cancel(&data->nan.discovery_beacon_timer);
+	wiphy_delayed_work_cancel(hw->wiphy, &data->nan.sched_update_work);
 	data->nan.device_vif = NULL;
 
 	return 0;
@@ -1296,6 +1312,12 @@ void mac80211_hwsim_nan_local_sched_changed(struct ieee80211_hw *hw,
 	}
 
 	spin_unlock_bh(&data->nan.state_lock);
+
+	/* Simulate firmware completing a deferred schedule update */
+	if (vif->cfg.nan_sched.deferred)
+		wiphy_delayed_work_queue(hw->wiphy,
+					 &data->nan.sched_update_work,
+					 msecs_to_jiffies(10));
 }
 
 int mac80211_hwsim_nan_peer_sched_changed(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
index 81e105ac7b8e..2801a1d8dcf0 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
@@ -59,6 +59,9 @@ struct mac80211_hwsim_nan_data {
 	 * available in that slot (except DW which is implicit).
 	 */
 	struct cfg80211_chan_def local_sched[CFG80211_NAN_SCHED_NUM_TIME_SLOTS];
+
+	/* Simulates the firmware completing a deferred schedule update */
+	struct wiphy_delayed_work sched_update_work;
 };
 
 enum hrtimer_restart
-- 
2.34.1

