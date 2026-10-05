Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3114534AE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124227; cv=none; b=WQFvcJWareAvsXp77WSdXVbIIrretiMyuE4E3on3B3ecnZCgQ3UsGP8+NadUgMPvlkeX8AdoyTNXyF1ZJ2liRQ9tF8at/U4lpjGzzrrdfP07hwaybMxZWu/zGxfXY6eJ7+RqetfKBqHttni6Z109twCH8WwvCWckqoR78t7DdEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124227; c=relaxed/simple;
	bh=y6jIroXQiQReTcWxVXS6AgM8t1chRAm/c5Cf/qBhyLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6qXhNsMgag6x2+A9Of5qbrrAjPMiDIcarr9u/O5tavH9jkvEifFJ3gvRe7hXToru70bhHdynFN58xzA0RIDK4FXKxvtMpTpgmjaDiUZUJQXQDgvS3hgnVwl/Ye9n+b4jQfyh01CckHo04WEX0/uLbzqCbOBCyb1b90y56XF4SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j1Mtby5M; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j1Mtby5M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124226; x=1822660226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y6jIroXQiQReTcWxVXS6AgM8t1chRAm/c5Cf/qBhyLA=;
  b=j1Mtby5M3x6g3HOEXTRGiZlDSYcfys1nk9cF7rwrhRIqfSMECVfrIQ4k
   gbelU7BOs2IdOk0JiTYLHCPEp+drPq/i3Fxp64snQr1aICn9UX2sJ7DQQ
   ftv38ryP1bleXUHpBKnAfwFx91KehgWkTb65yf7QiGZxFzQZS6jXMgzmr
   u/2xEYA/qy570SvLFs+DoOeSNZbcRybyY0WLmu58g9tMMi5LXnnZ4fx7C
   hRWwREeTc40P9wp29jNPe3fy9ovnosFwppN7EoRGgNtQpXaXOlqEPR0SR
   AwjhZ9DBAmrMAJZVU4J3Cqbl5h75zXh7KSPzs23aIBurE7F5dVI+xki4X
   w==;
X-CSE-ConnectionGUID: b9eANL2TQVGriO10gku4xA==
X-CSE-MsgGUID: 3GNXRMjvSjSLhVWJIZJgBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591439"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591439"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:25 -0700
X-CSE-ConnectionGUID: ZzkFaSshSGucO7RqipB6ww==
X-CSE-MsgGUID: yP6zSdyoSp67bzeNOTomwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576915"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:23 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 09/11] wifi: mac80211_hwsim: nan: prepare for more configurable NAN settings
Date: Mon,  5 Oct 2026 11:44:56 +0300
Message-ID: <20261005084458.3666739-10-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005084458.3666739-1-ilan.peer@intel.com>
References: <20261005084458.3666739-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for handling more of the NAN configuration setting, do
some refactoring and cleanup:

 - Extract mac80211_hwsim_nan_set_config() and call it both when NAN is
   started and when the configuration changes.
 - Add NAN_BEACON_ELEM_LEN instead of the hardcoded 27.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 32 +++++++++++++++----
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index fab6bd9e3cfb..2b30933ef2f9 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -33,6 +33,9 @@ static_assert(DW0_TSF_MASK + 1 == 8192 * 1024);
 #define NAN_RSSI_CLOSE (-60)
 #define NAN_RSSI_MIDDLE (-75)
 
+/* Size of the NAN vendor element carrying the mandatory attributes */
+#define NAN_BEACON_ELEM_LEN		27
+
 /* Quiet time at the end of each slot where TX is suppressed */
 #define NAN_CHAN_SWITCH_TIME_US		256
 
@@ -685,7 +688,7 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 {
 	struct ieee80211_vendor_ie nan_ie = {
 		.element_id = WLAN_EID_VENDOR_SPECIFIC,
-		.len = 27 - 2,
+		.len = NAN_BEACON_ELEM_LEN - 2,
 		.oui = { u32_get_bits(WLAN_OUI_WFA, 0xff0000),
 			 u32_get_bits(WLAN_OUI_WFA, 0xff00),
 			 u32_get_bits(WLAN_OUI_WFA, 0xff) },
@@ -694,7 +697,7 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 	size_t alloc_size =
 		IEEE80211_TX_STATUS_HEADROOM +
 		offsetofend(struct ieee80211_mgmt, u.beacon) +
-		27 /* size of NAN vendor element */;
+		NAN_BEACON_ELEM_LEN;
 	struct ieee80211_nan_master_indication master_indication;
 	struct ieee80211_nan_attr nan_attr;
 	struct ieee80211_mgmt *mgmt;
@@ -905,11 +908,20 @@ mac80211_hwsim_nan_sched_update_work(struct wiphy *wiphy,
 		ieee80211_nan_sched_update_done(data->nan.device_vif);
 }
 
+static int mac80211_hwsim_nan_set_config(struct mac80211_hwsim_data *data,
+					 struct cfg80211_nan_conf *conf)
+{
+	data->nan.notify_dw = conf->enable_dw_notification;
+
+	return 0;
+}
+
 int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_nan_conf *conf)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	int err;
 
 	if (vif->type != NL80211_IFTYPE_NAN)
 		return -EINVAL;
@@ -917,6 +929,10 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 	if (data->nan.device_vif)
 		return -EALREADY;
 
+	err = mac80211_hwsim_nan_set_config(data, conf);
+	if (err)
+		return err;
+
 	/* set this before starting the timer, as preemption might occur */
 	data->nan.device_vif = vif;
 	data->nan.bands = conf->bands;
@@ -945,8 +961,6 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 
 	ether_addr_copy(data->nan.cluster_id, conf->cluster_id);
 
-	data->nan.notify_dw = conf->enable_dw_notification;
-
 	return 0;
 }
 
@@ -983,13 +997,17 @@ int mac80211_hwsim_nan_change_config(struct ieee80211_hw *hw,
 
 	wiphy_debug(hw->wiphy, "nan_config_changed: changes=0x%x\n", changes);
 
+	if (changes & CFG80211_NAN_CONF_CHANGED_CONFIG) {
+		int err = mac80211_hwsim_nan_set_config(data, conf);
+
+		if (err)
+			return err;
+	}
+
 	/* Handle only the changes we care about for simulation purposes */
 	if (changes & CFG80211_NAN_CONF_CHANGED_BANDS)
 		data->nan.bands = conf->bands;
 
-	if (changes & CFG80211_NAN_CONF_CHANGED_CONFIG)
-		data->nan.notify_dw = conf->enable_dw_notification;
-
 	if (changes & CFG80211_NAN_CONF_CHANGED_PREF) {
 		scoped_guard(spinlock_bh, &data->nan.state_lock)
 			data->nan.master_pref = conf->master_pref;
-- 
2.55.0

