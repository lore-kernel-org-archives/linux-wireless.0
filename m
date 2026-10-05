Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3B392823
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120382; cv=none; b=N9iSvSsc7wEaA/x9+gSsWVeRC7lH1XjfBgZHCEFz9WdQuq6ghJZOIHs/ieoTT9hSfdXN5fY7Is2QN52ByfG+eDZJPQ9rY5NjR7nmTqdFWs7purtu9sTNeZTSa88vTgm9+YzZVhed4EMsC3BPlv+N1liOLUm2kEDyDth6sG6505o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120382; c=relaxed/simple;
	bh=wLIZr0pMI8qdCNigO0cYfvAJB20mfQ0BrVDtsG8faq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F27f5ypFO/btuefEczNDERJnTCvNja9zoAg05hslVCR4fyGubohBGpIvFGPn11xMYHPRvJhZaV892JASUhN7sCJx/ef8JQNSF4SLo7/eAD9RShNcYOawNVemqcxI3xYM23wIbmg0IRGHMoaJ/MmcpX385/NzT3SMeaZddmEBTB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KsW0Wlo4; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KsW0Wlo4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120382; x=1822656382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wLIZr0pMI8qdCNigO0cYfvAJB20mfQ0BrVDtsG8faq8=;
  b=KsW0Wlo4VXjN3Fea5QP82V+p3qk3SoZvT8FMvtSmZmwRN9CirgN+sBZ7
   605gkAYVwZFgEz2PtTsBTp/6lcW1UdLhZlfd04yneAhrYAM05p6x0ai/2
   IkjbGFa2LFpe1HXjlz8VkwyCkKks40JtUW1k7jRYVMOWEbvyjXxraHPDf
   TMt2tiSMPt0CMKMAroXFfuvqd0THAYWPsE8VQA1/HHW0oZxWOYJ6Cc09+
   l6cygDuOEDYJI9ofUe3uIHYwKXk2NO8bYL0DjqH1upjttk5DL0bPPXyT3
   sAJgDnZME3hEB7Gt1HFvnpqqdYDfS9al2PBYOtKIIGkR0Rwa7w4MRsqvZ
   Q==;
X-CSE-ConnectionGUID: F2ezqEL6SZKa5xi5xdm79A==
X-CSE-MsgGUID: ZYIcsTkhR0Oyf3Db6se0rQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328707"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328707"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:21 -0700
X-CSE-ConnectionGUID: Vz998Ep9TSKvEpxjyWQkhw==
X-CSE-MsgGUID: qNenBhKGRMO/gCoKCq8Kug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569150"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:19 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 10/11] wifi: mac80211_hwsim: nan: Handle more of the NAN configuration
Date: Mon,  5 Oct 2026 10:40:35 +0300
Message-ID: <20261005074037.3506633-11-ilan.peer@intel.com>
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

- Use the discovery beacon interval configured by user space instead of
  always using hardcoded 100 TUs.
- Append the NAN attributes set by user space to the locally generated
  ones in the discovery beacons.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 69 +++++++++++++++++--
 .../net/wireless/virtual/mac80211_hwsim_nan.h |  5 ++
 2 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index 3e05c0f43f79..538ece73b1d5 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -36,6 +36,9 @@ static_assert(DW0_TSF_MASK + 1 == 8192 * 1024);
 /* Size of the NAN vendor element carrying the mandatory attributes */
 #define NAN_BEACON_ELEM_LEN		27
 
+/* Space left in the NAN vendor element for the configured attributes */
+#define NAN_BEACON_EXTRA_ATTRS_LEN	(255 - (NAN_BEACON_ELEM_LEN - 2))
+
 /* Quiet time at the end of each slot where TX is suppressed */
 #define NAN_CHAN_SWITCH_TIME_US		256
 
@@ -704,16 +707,27 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 	struct sk_buff *skb;
 
 	/*
-	 * TODO: Should the configured vendor elements or NAN attributes be
-	 * included in some of these beacons?
+	 * TODO: Should the configured vendor elements be included in some of
+	 * these beacons?
 	 */
 
+	/* Allocate maximal size for NAN IE */
+	if (is_discovery)
+		alloc_size += NAN_BEACON_EXTRA_ATTRS_LEN;
+
 	skb = alloc_skb(alloc_size, GFP_ATOMIC);
 	if (!skb)
 		return;
 
 	spin_lock(&data->nan.state_lock);
 
+	/*
+	 * The attributes configured by user space are appended to the
+	 * mandatory ones.
+	 */
+	if (is_discovery)
+		nan_ie.len += data->nan.extra_nan_attrs_len;
+
 	skb_reserve(skb, IEEE80211_TX_STATUS_HEADROOM);
 	mgmt = skb_put(skb, offsetofend(struct ieee80211_mgmt, u.beacon));
 
@@ -724,7 +738,9 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_BEACON);
-	mgmt->u.beacon.beacon_int = cpu_to_le16(is_discovery ? 100 : DWST_TU);
+	mgmt->u.beacon.beacon_int =
+		cpu_to_le16(is_discovery ? data->nan.discovery_beacon_interval :
+			    DWST_TU);
 	mgmt->u.beacon.capab_info =
 		cpu_to_le16(WLAN_CAPABILITY_SHORT_SLOT_TIME |
 			    WLAN_CAPABILITY_SHORT_PREAMBLE);
@@ -755,6 +771,10 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 	skb_put_data(skb, &data->nan.current_ami,
 		     sizeof(data->nan.current_ami));
 
+	if (is_discovery && data->nan.extra_nan_attrs_len)
+		skb_put_data(skb, data->nan.extra_nan_attrs,
+			     data->nan.extra_nan_attrs_len);
+
 	spin_unlock(&data->nan.state_lock);
 
 	mac80211_hwsim_tx_frame(data->hw, skb, channel);
@@ -884,10 +904,11 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
 	tsf_now = mac80211_hwsim_get_tsf(data->hw, data->nan.device_vif);
 
 	/* Wrap value to be after the next TBTT */
-	tbtt = tsf_now + ieee80211_tu_to_usec(100);
+	tbtt = tsf_now + ieee80211_tu_to_usec(data->nan.discovery_beacon_interval);
 
 	/* Round TBTT down to the correct time */
-	div_u64_rem(tbtt, ieee80211_tu_to_usec(100), &remainder);
+	div_u64_rem(tbtt, ieee80211_tu_to_usec(data->nan.discovery_beacon_interval),
+		    &remainder);
 	tbtt = tbtt - remainder;
 
 	hrtimer_set_expires(&data->nan.discovery_beacon_timer,
@@ -899,8 +920,37 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
 static int mac80211_hwsim_nan_set_config(struct mac80211_hwsim_data *data,
 					 struct cfg80211_nan_conf *conf)
 {
+	const u8 *extra_nan_attrs = NULL;
+	const u8 *old;
+
+	if (conf->extra_nan_attrs_len > NAN_BEACON_EXTRA_ATTRS_LEN)
+		return -EINVAL;
+
+	if (conf->extra_nan_attrs_len) {
+		extra_nan_attrs = kmemdup(conf->extra_nan_attrs,
+					  conf->extra_nan_attrs_len,
+					  GFP_KERNEL);
+		if (!extra_nan_attrs)
+			return -ENOMEM;
+	}
+
 	data->nan.notify_dw = conf->enable_dw_notification;
 
+	scoped_guard(spinlock_bh, &data->nan.state_lock) {
+		/*
+		 * Fall back to the device default if user space did not
+		 * configure it
+		 */
+		data->nan.discovery_beacon_interval =
+			conf->discovery_beacon_interval ? : 100;
+
+		old = data->nan.extra_nan_attrs;
+		data->nan.extra_nan_attrs = extra_nan_attrs;
+		data->nan.extra_nan_attrs_len = conf->extra_nan_attrs_len;
+	}
+
+	kfree(old);
+
 	return 0;
 }
 
@@ -953,6 +1003,7 @@ int mac80211_hwsim_nan_stop(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	const u8 *old;
 
 	if (vif->type != NL80211_IFTYPE_NAN || !data->nan.device_vif ||
 	    data->nan.device_vif != vif)
@@ -963,6 +1014,14 @@ int mac80211_hwsim_nan_stop(struct ieee80211_hw *hw,
 	hrtimer_cancel(&data->nan.discovery_beacon_timer);
 	data->nan.device_vif = NULL;
 
+	scoped_guard(spinlock_bh, &data->nan.state_lock) {
+		old = data->nan.extra_nan_attrs;
+		data->nan.extra_nan_attrs = NULL;
+		data->nan.extra_nan_attrs_len = 0;
+	}
+
+	kfree(old);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
index 81e105ac7b8e..81761ab71955 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
@@ -32,6 +32,9 @@ struct mac80211_hwsim_nan_data {
 	/* Later members are protected by this lock */
 	spinlock_t state_lock;
 
+	const u8 *extra_nan_attrs;
+	u16 extra_nan_attrs_len;
+
 	u8 master_pref;
 	u8 random_factor;
 
@@ -53,6 +56,8 @@ struct mac80211_hwsim_nan_data {
 	bool tsf_adjusted;
 	bool tsf_discontinuity;
 
+	u8 discovery_beacon_interval;
+
 	/*
 	 * Local schedule - stores channel definition for each 16TU slot.
 	 * Derived from NMI vif->cfg.nan_schedule. chan == NULL means not
-- 
2.55.0

