Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F6842588C
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124231; cv=none; b=FyOLC64JBcK778QF6yy4KhuDW4PoZxGG2tHgCbjxIctba7N821rA3Wcl22DRu7HclEsziivid/rn0mwioIQPx+K5v4bhDdisxy5kyMIPXiOLomZybh1e/vJkyRnHyPu0mVjqg/QHWs8xJaBMawIdMsrVW0N2JDT+TDlW2lUQc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124231; c=relaxed/simple;
	bh=6ssLgXfPOcNF7qxe50kVS9brLyK8jEY/gmQjOGviObs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJynJP+yP9kpD3TWQbNjBA5mDOCRsIC9z2o96jdrcOyIbyKXfFR5ctiP8oPSWl+/v0Xe19sG68mm9LYB1Lqg4DkNDPK/7iAFuxymWnQUrKO1bmC8cOqW9NYJhVDBxLZYAJxDo9XOrf1GjOoiKuSX/vmeEkw957twC0q2GY7VOsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kx5p7y3m; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kx5p7y3m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124230; x=1822660230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ssLgXfPOcNF7qxe50kVS9brLyK8jEY/gmQjOGviObs=;
  b=kx5p7y3mV0CAtCC9H751vtz5rQD5z2YjJulYcTaWFmRwg8NeKixSVTu1
   axb6g82KnkBTnm6sng4eizcRavCm9SvI45gqWXrlQaEexhlTsPeYjAdIg
   vbgYKlm3TyOoNwNFLTk4Mis3xer/kzOY8e3XarFrwo1fpveVpBzrJR2KE
   8x1ljXRU1GLIRBxBPho/bm7/4zsCXZiBTVQABOvdpSjWPCdJORCTJl7v2
   cfFVAofxgYCL5VaAteDO4e0C6ezGkNoIm2tXjuLOhby0uHgdZ/IP5RTe9
   8QnaUkc6v0w7O/2Zgoue899UqwuRZzQTs2vUQYG8Ekx5psWS4rHVdhTZe
   Q==;
X-CSE-ConnectionGUID: vspCm08zTiK9CVcH4CujMg==
X-CSE-MsgGUID: h1EjiWBHSHWVmkdIzqMIKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591444"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591444"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:29 -0700
X-CSE-ConnectionGUID: HnvOd9GdRWqn98oX2cEoDQ==
X-CSE-MsgGUID: DcLCcM70TsetaE+vj49j/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576923"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:26 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v3 11/11] wifi: mac80211_hwsim: add NAN Instant Communication support
Date: Mon,  5 Oct 2026 11:44:58 +0300
Message-ID: <20261005084458.3666739-12-ilan.peer@intel.com>
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
index 762f99eb15e4..7e65474c9df1 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1775,6 +1775,7 @@ struct tx_iter_data {
 	struct ieee80211_channel *channel;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_hw *hw;
+	struct sk_buff *skb;
 	bool receive;
 };
 
@@ -1787,6 +1788,7 @@ static void mac80211_hwsim_tx_iter(void *_data, u8 *addr,
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
@@ -5841,7 +5844,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 						 BIT(NL80211_BAND_5GHZ);
 
 		hw->wiphy->nan_capa.flags = WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC |
-					    WIPHY_NAN_FLAGS_USERSPACE_DE;
+					    WIPHY_NAN_FLAGS_USERSPACE_DE |
+					    WIPHY_NAN_FLAGS_INSTANT_COMM;
 		hw->wiphy->nan_capa.op_mode = NAN_OP_MODE_PHY_MODE_MASK |
 					      NAN_OP_MODE_80P80MHZ |
 					      NAN_OP_MODE_160MHZ;
@@ -6643,6 +6647,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		struct tx_iter_data iter_data = {
 			.hw = data2->hw,
 			.rx_status = &rx_status,
+			.skb = skb,
 		};
 
 		/* throw away off-channel packets, but allow both the temporary
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index e7815eb95c55..6f90856099e8 100644
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
@@ -956,6 +1014,8 @@ static int mac80211_hwsim_nan_set_config(struct mac80211_hwsim_data *data,
 		data->nan.discovery_beacon_interval =
 			conf->discovery_beacon_interval ? : 100;
 
+		data->nan.instant_comm = conf->instant_comm;
+
 		old = data->nan.extra_nan_attrs;
 		data->nan.extra_nan_attrs = extra_nan_attrs;
 		data->nan.extra_nan_attrs_len = conf->extra_nan_attrs_len;
@@ -991,9 +1051,13 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 				mac80211_hwsim_nan_sched_update_work);
 
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
@@ -1034,6 +1098,7 @@ int mac80211_hwsim_nan_stop(struct ieee80211_hw *hw,
 		old = data->nan.extra_nan_attrs;
 		data->nan.extra_nan_attrs = NULL;
 		data->nan.extra_nan_attrs_len = 0;
+		data->nan.instant_comm = false;
 	}
 
 	kfree(old);
@@ -1061,6 +1126,16 @@ int mac80211_hwsim_nan_change_config(struct ieee80211_hw *hw,
 
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
@@ -1249,9 +1324,16 @@ bool mac80211_hwsim_nan_txq_transmitting(struct ieee80211_hw *hw,
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
@@ -1304,15 +1386,32 @@ void mac80211_hwsim_nan_get_tx_chandef(struct ieee80211_hw *hw,
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
index e73634e479e8..0684f9b823ba 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
@@ -56,6 +56,7 @@ struct mac80211_hwsim_nan_data {
 	bool tsf_adjusted;
 	bool tsf_discontinuity;
 
+	bool instant_comm;
 	u8 discovery_beacon_interval;
 
 	/*
@@ -98,6 +99,7 @@ void mac80211_hwsim_nan_get_tx_chandef(struct ieee80211_hw *hw,
 				       struct cfg80211_chan_def *chandef);
 
 bool mac80211_hwsim_nan_receive(struct ieee80211_hw *hw,
+				struct sk_buff *skb,
 				struct ieee80211_channel *channel,
 				struct ieee80211_rx_status *rx_status);
 
-- 
2.55.0

