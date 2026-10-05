Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A8F3921E9
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120385; cv=none; b=V0W2YAbPR2U/DHQAv0j4q6BdM1O7Lg75LUKrLVuxXdJC3TXl2UgrQO57c/3BQQgw4nJKuuNoBPq3nkCFgvvDXdgm2AdtcMW1+mTLOvCZPbV1TITXI0gATvKV+E6wdK8QOaopXGMF3fdevgy+hWCrTrpOP1p/A46dnC0M6cDEc4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120385; c=relaxed/simple;
	bh=bejflRfF0KRZl/z8YoVph+gvXNC+cyn8JSy2eqkH6zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeFjJAyz7hfjSQdDOd6w9dU5gC5e4yfbF6oms82B0z01cRppnchG+b3psUh2b6B9A1449w5j74g+Y/ruHhoKTZZG3CA/H9JKNUGJ4TPxKwJ9Wkj2S43EN+J27wI7atVAnnQoaYMP8q7PcjpJPvM5KMr0QuPyG7iP/Iq1SkbR6cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Icg2VbrZ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Icg2VbrZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120384; x=1822656384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bejflRfF0KRZl/z8YoVph+gvXNC+cyn8JSy2eqkH6zg=;
  b=Icg2VbrZulFkwztFuAA0h/B8+u9wPSoYTS7Qb1k3tdS14luWj/kJyXYq
   y7SfafjW+QsrU5T+u3MtSzmy+u6D1O/xprKd/qvneF1b18xOmtspAIuEr
   IZEBFULorq0ayPOLI8CqVP9CUFObhyvGgIog2LVAPZ/PDv88HHHZwYuuz
   zAMto2Bq5qM0Dj6pvthbEa8Q5Cg+3veGxVOd5nF1gQ5akwyOZskPCCFFT
   Fn2NY/rS/6tyV/zMaxUvwviwf4dRYYLFCWcJ2w4+uxkxUoWdnHlWudStL
   ohDQ+ltR5b/KiCxRaMuI4TRj2a+AGRAdnVcMMpYoVLYBX2Z4e5VKGe+HM
   Q==;
X-CSE-ConnectionGUID: LY03TDVgRjK52qmju6aDFw==
X-CSE-MsgGUID: DzDiuykaSOSKxVOA6LDY9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328709"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328709"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:23 -0700
X-CSE-ConnectionGUID: T7A7ZPkwQwuJ7l5ihtNHHQ==
X-CSE-MsgGUID: YsGUAUGuQPmQHkgup7aUvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569159"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:21 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v2 11/11] wifi: mac80211_hwsim: add NAN Instant Communication support
Date: Mon,  5 Oct 2026 10:40:36 +0300
Message-ID: <20261005074037.3506633-12-ilan.peer@intel.com>
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

Advertise Instant Communication (IC) support, and when it is enabled:

- Transmit the discovery beacons disregarding the role and the state,
  with the configured beacon interval and the NAN attributes set by
  user space.
- Accept beacons that carry a Service ID List or a Subscribe Service
  ID List attribute at any time, so that they are forwarded to
  mac80211.
- Process discovery beacons received during non DW slots for anchor
  master tracking and synchronization.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/virtual/mac80211_hwsim_main.c    |   7 +-
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 129 ++++++++++++++++--
 .../net/wireless/virtual/mac80211_hwsim_nan.h |   2 +
 3 files changed, 122 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd1..5d235946e19a 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1772,6 +1772,7 @@ struct tx_iter_data {
 	struct ieee80211_channel *channel;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_hw *hw;
+	struct sk_buff *skb;
 	bool receive;
 };
 
@@ -1784,6 +1785,7 @@ static void mac80211_hwsim_tx_iter(void *_data, u8 *addr,
 	if (vif->type == NL80211_IFTYPE_NAN ||
 	    vif->type == NL80211_IFTYPE_NAN_DATA) {
 		data->receive = mac80211_hwsim_nan_receive(data->hw,
+							   data->skb,
 							   data->channel,
 							   data->rx_status);
 		return;
@@ -1968,6 +1970,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 			.hw = data2->hw,
 			.channel = chan,
 			.rx_status = &rx_status,
+			.skb = skb,
 		};
 
 		if (data == data2)
@@ -5800,7 +5803,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 						 BIT(NL80211_BAND_5GHZ);
 
 		hw->wiphy->nan_capa.flags = WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC |
-					    WIPHY_NAN_FLAGS_USERSPACE_DE;
+					    WIPHY_NAN_FLAGS_USERSPACE_DE |
+					    WIPHY_NAN_FLAGS_INSTANT_COMM;
 		hw->wiphy->nan_capa.op_mode = NAN_OP_MODE_PHY_MODE_MASK |
 					      NAN_OP_MODE_80P80MHZ |
 					      NAN_OP_MODE_160MHZ;
@@ -6546,6 +6550,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		struct tx_iter_data iter_data = {
 			.hw = data2->hw,
 			.rx_status = &rx_status,
+			.skb = skb,
 		};
 
 		/* throw away off-channel packets, but allow both the temporary
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index 538ece73b1d5..1f058ec9c159 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -219,6 +219,37 @@ mac80211_hwsim_nan_schedule_slot(struct mac80211_hwsim_data *data, u8 slot,
 			    mac80211_hwsim_tsf_to_boottime(data, tsf));
 }
 
+static bool hwsim_nan_beacon_has_service_ids(struct sk_buff *skb)
+{
+	const struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	const struct ieee80211_nan_attr *nan_attr;
+	const struct element *elem;
+	size_t len;
+
+	if (skb->len < offsetofend(struct ieee80211_mgmt, u.beacon) ||
+	    !ieee80211_is_beacon(mgmt->frame_control))
+		return false;
+
+	len = skb->len - offsetofend(struct ieee80211_mgmt, u.beacon);
+
+	/* TODO: fragmented NAN elements are not supported */
+	for_each_element_id(elem, WLAN_EID_VENDOR_SPECIFIC,
+			    mgmt->u.beacon.variable, len) {
+		if (elem->datalen < 4 ||
+		    get_unaligned_be32(elem->data) !=
+		    (WLAN_OUI_WFA << 8 | WLAN_OUI_TYPE_WFA_NAN))
+			continue;
+
+		for_each_nan_attr(nan_attr, elem->data + 4, elem->datalen - 4)
+			if (nan_attr->attr == NAN_ATTR_SERVICE_ID_LIST ||
+			    nan_attr->attr ==
+			    NAN_ATTR_SUBSCRIBE_SERVICE_ID_LIST)
+				return true;
+	}
+
+	return false;
+}
+
 void mac80211_hwsim_nan_rx(struct ieee80211_hw *hw,
 			   struct sk_buff *skb)
 {
@@ -270,15 +301,32 @@ void mac80211_hwsim_nan_rx(struct ieee80211_hw *hw,
 	}
 
 	/*
-	 * (overly) simplify things, only track 2.4 GHz here. Also, ignore
-	 * frames outside of the 2.4 GHz DW slot, unless in the initial SCAN
-	 * phase.
+	 * Only sync on 2.4 GHz, which all NAN devices attend. The slot number
+	 * is derived from the local TSF, so before being synchronized a 5 GHz
+	 * beacon from a different device may fall into the local 2.4 GHz DW
+	 * slot. Filter by frequency to keep such beacons out of master
+	 * selection and synchronization.
 	 */
-	if ((slot != SLOT_24GHZ_DW &&
-	     data->nan.phase != MAC80211_HWSIM_NAN_PHASE_SCAN) ||
-	    rx_status.freq != 2437)
+	if (rx_status.freq != 2437)
 		return;
 
+	/*
+	 * Ignore frames outside of the 2.4 GHz DW slot, unless in the initial
+	 * SCAN phase or in Instant Communication, where discovery beacons are
+	 * received outside the DW.
+	 */
+	if (slot != SLOT_24GHZ_DW) {
+		bool rx_outside_dw;
+
+		scoped_guard(spinlock_bh, &data->nan.state_lock)
+			rx_outside_dw = data->nan.instant_comm ||
+				data->nan.phase ==
+				MAC80211_HWSIM_NAN_PHASE_SCAN;
+
+		if (!rx_outside_dw)
+			return;
+	}
+
 	/* Just ignore low RSSI beacons that we cannot sync to */
 	if (rx_status.signal < NAN_RSSI_MIDDLE)
 		return;
@@ -629,10 +677,12 @@ mac80211_hwsim_nan_exec_state_transitions(struct mac80211_hwsim_data *data)
 
 	/*
 	 * The discovery beacon timer will stop automatically. Make sure it is
-	 * running if we are master. Do not bother with a proper alignment it
-	 * will sync itself to the TSF after the first TX.
+	 * running if we are master or if Instant Communication is enabled. Do
+	 * not bother with a proper alignment it will sync itself to the TSF
+	 * after the first TX.
 	 */
-	if (data->nan.role == MAC80211_HWSIM_NAN_ROLE_MASTER &&
+	if ((data->nan.role == MAC80211_HWSIM_NAN_ROLE_MASTER ||
+	     data->nan.instant_comm) &&
 	    !hrtimer_active(&data->nan.discovery_beacon_timer))
 		hrtimer_start(&data->nan.discovery_beacon_timer,
 			      ns_to_ktime(10 * NSEC_PER_USEC),
@@ -887,7 +937,15 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
 		return HRTIMER_NORESTART;
 
 	scoped_guard(spinlock, &data->nan.state_lock) {
-		if (data->nan.phase == MAC80211_HWSIM_NAN_PHASE_SCAN ||
+		if (data->nan.phase == MAC80211_HWSIM_NAN_PHASE_SCAN)
+			return HRTIMER_NORESTART;
+
+		/*
+		 * With Instant Communication the discovery beacons are
+		 * transmitted disregarding the role and the state, see
+		 * Wi-Fi Aware version 4.0 section 13.
+		 */
+		if (!data->nan.instant_comm &&
 		    data->nan.role != MAC80211_HWSIM_NAN_ROLE_MASTER)
 			return HRTIMER_NORESTART;
 	}
@@ -944,6 +1002,8 @@ static int mac80211_hwsim_nan_set_config(struct mac80211_hwsim_data *data,
 		data->nan.discovery_beacon_interval =
 			conf->discovery_beacon_interval ? : 100;
 
+		data->nan.instant_comm = conf->instant_comm;
+
 		old = data->nan.extra_nan_attrs;
 		data->nan.extra_nan_attrs = extra_nan_attrs;
 		data->nan.extra_nan_attrs_len = conf->extra_nan_attrs_len;
@@ -976,9 +1036,13 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 	data->nan.bands = conf->bands;
 
 	scoped_guard(spinlock_bh, &data->nan.state_lock) {
-		/* Start in the "scan" phase and stay there for a little bit */
+		/*
+		 * Start in the "scan" phase and stay there for a little bit,
+		 * unless Instant Communication is configured, in which case an
+		 * own cluster is started immediately.
+		 */
 		data->nan.phase = MAC80211_HWSIM_NAN_PHASE_SCAN;
-		data->nan.random_factor_valid_dwst = 1;
+		data->nan.random_factor_valid_dwst = conf->instant_comm ? 0 : 1;
 		data->nan.random_factor = 0;
 		data->nan.master_pref = conf->master_pref;
 		data->nan.role = MAC80211_HWSIM_NAN_ROLE_MASTER;
@@ -1018,6 +1082,7 @@ int mac80211_hwsim_nan_stop(struct ieee80211_hw *hw,
 		old = data->nan.extra_nan_attrs;
 		data->nan.extra_nan_attrs = NULL;
 		data->nan.extra_nan_attrs_len = 0;
+		data->nan.instant_comm = false;
 	}
 
 	kfree(old);
@@ -1045,6 +1110,16 @@ int mac80211_hwsim_nan_change_config(struct ieee80211_hw *hw,
 
 		if (err)
 			return err;
+
+		/*
+		 * When Instant Communication is enabled discovery beacons are
+		 * transmitted regardless of the role and the state.
+		 */
+		if (conf->instant_comm &&
+		    !hrtimer_active(&data->nan.discovery_beacon_timer))
+			hrtimer_start(&data->nan.discovery_beacon_timer,
+				      ns_to_ktime(10 * NSEC_PER_USEC),
+				      HRTIMER_MODE_REL_SOFT);
 	}
 
 	/* Handle only the changes we care about for simulation purposes */
@@ -1233,9 +1308,16 @@ bool mac80211_hwsim_nan_txq_transmitting(struct ieee80211_hw *hw,
 	is_dw_slot = mac80211_hwsim_nan_is_dw_slot(data, slot);
 
 	if (!txq->sta) {
-		/* Non-STA TXQ: allow management frames during DW */
-		if (txq->vif->type == NL80211_IFTYPE_NAN)
-			return is_dw_slot;
+		/* Non-STA TXQ: allow management frames during DW or IC */
+		if (txq->vif->type == NL80211_IFTYPE_NAN) {
+			if (is_dw_slot)
+				return true;
+
+			/* Outside the DW the local schedule must allow it */
+			guard(spinlock_bh)(&data->nan.state_lock);
+			return data->nan.instant_comm &&
+				data->nan.local_sched[slot].chan;
+		}
 
 		/* Allow multicast data when all the peers are available
 		 * on this slot
@@ -1288,15 +1370,32 @@ void mac80211_hwsim_nan_get_tx_chandef(struct ieee80211_hw *hw,
 }
 
 bool mac80211_hwsim_nan_receive(struct ieee80211_hw *hw,
+				struct sk_buff *skb,
 				struct ieee80211_channel *channel,
 				struct ieee80211_rx_status *rx_status)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	bool instant_comm;
 	u8 slot;
 
 	if (WARN_ON_ONCE(!data->nan.device_vif))
 		return false;
 
+	scoped_guard(spinlock_bh, &data->nan.state_lock)
+		instant_comm = data->nan.instant_comm;
+
+	/*
+	 * During Instant Communication a peer advertises its services in the
+	 * discovery beacons, which are transmitted disregarding the roles and
+	 * the states, see Section 13 in Wi-Fi Aware v4.0.
+	 * Note that while according to the specification Instant communication
+	 * should be enabled only on the NAN discovery channels, do not force
+	 * this here, and allow receiving NAN frames on any channel if Instant
+	 * Communication is enabled.
+	 */
+	if (instant_comm && hwsim_nan_beacon_has_service_ids(skb))
+		return true;
+
 	if (data->nan.phase == MAC80211_HWSIM_NAN_PHASE_SCAN)
 		return channel->center_freq == 2437;
 
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
index 81761ab71955..995d1f6feb29 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
@@ -56,6 +56,7 @@ struct mac80211_hwsim_nan_data {
 	bool tsf_adjusted;
 	bool tsf_discontinuity;
 
+	bool instant_comm;
 	u8 discovery_beacon_interval;
 
 	/*
@@ -95,6 +96,7 @@ void mac80211_hwsim_nan_get_tx_chandef(struct ieee80211_hw *hw,
 				       struct cfg80211_chan_def *chandef);
 
 bool mac80211_hwsim_nan_receive(struct ieee80211_hw *hw,
+				struct sk_buff *skb,
 				struct ieee80211_channel *channel,
 				struct ieee80211_rx_status *rx_status);
 
-- 
2.55.0

