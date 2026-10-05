Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A053939CE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120381; cv=none; b=OURaaKyCuHbeD782j9bHpZt8p7zIGszvUrE1COQhcaa6rfBa+4ZRqaA0anmdXxpdmEhKWz+ghHWmLjSr2+y2Ey6S8tae8IQhL2L6mRyFjF+nf0f5FcJeVnYFTxTdcA+8fm1Pb/TfuWbS7DyWJTUxS80B4caq64AMF/MBoQcRO4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120381; c=relaxed/simple;
	bh=47m2cQ24UF95DfIrvB3MhjmS8yeDuvN1qVQc7hoNyok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uvx4ZfX6dP5UGVzRb6D0SBoeV/PkPTRPT3cldPIxN7P8kZ0eeuVC9CINYi4XNNbm+tc5XLUJD4ukPtb5hemrmFKhBSxLOf0mcbDD6Tl+3Xs3CnySTQ6wlKvbR5iRcanoAau8xfpChCLfgBMmZIhdbYiFY0122nTUVFi4jQaduZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B3Vmh+Z7; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B3Vmh+Z7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120380; x=1822656380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=47m2cQ24UF95DfIrvB3MhjmS8yeDuvN1qVQc7hoNyok=;
  b=B3Vmh+Z7nMXXMJ5Jv6LhmqSDWYYmSCxMErr3E2NXmGovnET5CenxlXO4
   /JgsGxfzrPiDsQcMs2uqHZgy5f/p0yt26DteImOz4R9+Kv3uvYsSXDLcD
   GxOsRJMbSV90Wkcx2MRc51v7C7ZeIdyC2voNHgD5zlCsMcnYIclwfGyXp
   uRKfJ+1liepYphhsTnG0hoSPb7vhCYu9g7qZjlEwh92QVFGX54q0Jzit9
   rxWWeoGoXn1loT9fyhGniGnSkfJw8mqCBC2ahKCezCRsO0WP2ZYYeg26+
   tc5Y+vTfo/rNFQw8ZvuRIwQn6OZFIENpcEI2AGrkyP/dCsQp3aSxaeGdS
   A==;
X-CSE-ConnectionGUID: R7IG3w8NQjKOXfNcnSlSXA==
X-CSE-MsgGUID: EzRQIeqNTka0wBCmHsZfrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328705"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328705"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:20 -0700
X-CSE-ConnectionGUID: wc1OlrmxQuCj+gERGCz4/A==
X-CSE-MsgGUID: 9oCBrj3yRYyaNF6vtqrU/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569145"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:18 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 09/11] wifi: mac80211_hwsim: nan: prepare for more configurable NAN settings
Date: Mon,  5 Oct 2026 10:40:34 +0300
Message-ID: <20261005074037.3506633-10-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005074037.3506633-1-ilan.peer@intel.com>
References: <20261005074037.3506633-1-ilan.peer@intel.com>
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
index f0732dd2eb79..3e05c0f43f79 100644
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
@@ -893,11 +896,20 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
 	return HRTIMER_RESTART;
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
@@ -905,6 +917,10 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 	if (data->nan.device_vif)
 		return -EALREADY;
 
+	err = mac80211_hwsim_nan_set_config(data, conf);
+	if (err)
+		return err;
+
 	/* set this before starting the timer, as preemption might occur */
 	data->nan.device_vif = vif;
 	data->nan.bands = conf->bands;
@@ -930,8 +946,6 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 
 	ether_addr_copy(data->nan.cluster_id, conf->cluster_id);
 
-	data->nan.notify_dw = conf->enable_dw_notification;
-
 	return 0;
 }
 
@@ -967,13 +981,17 @@ int mac80211_hwsim_nan_change_config(struct ieee80211_hw *hw,
 
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

