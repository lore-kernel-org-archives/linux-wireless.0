Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D54B7A37
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861494; cv=none; b=RVZT5RpiwRCgUTv6pJifvxb0GFn115Zn/0A34N/44iLkWcbGd6PaR0qvv1/7KxOaOftIwx2atmx7rwSVaA9gXbewEjGjeffBDFSf3Ga1TynYrwu/Nzo1meMYPfnWbuaZLKmuuQ0BLvXQubv1iXu43xt28Fzc0XI+O4beFdz00O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861494; c=relaxed/simple;
	bh=BrbveAY6oRHkE6Q5W5wYqi0zByqDlKzwNcBAGjwthNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M08KDM2SZqrc0ORm5BxjX3ja6mHWDxNzZoK1vuy6skWns3Eng1Aqn1SUpWoA+cOPO2ZDTswhQst34MoM/03fqQ5qB8pZa+fD8B+dv+dHgZi83zq8aMIRmVtiWyd8fCQwnWuj7v+7lS1PGU3l49WHjPtO5dz6GPVKZBvpVuFr8/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M+k9pfLi; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M+k9pfLi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861490; x=1822397490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BrbveAY6oRHkE6Q5W5wYqi0zByqDlKzwNcBAGjwthNk=;
  b=M+k9pfLi2cKypUpEfzobcmAORQyEj7BEFEMx0bqDh3k494CHMN1zKOIL
   +yjYo0HTI8deBtj6RinSgiJBgbkl98z82sQlpZ8X6ozUsCO9IxCWxVac7
   qYafMARypLZGeS3fBzMgtmTW0xSdyXJGBBYp5etHZ/546SNbH8rzNPIqt
   j6EU9nN84URFzYF+y8DD6fD9Rs51mHSzz4mMeVKW/TpYizzHtm6uG4IVZ
   o1mt8wxdbZ9+8roNWlkbV5MYnXQE0qw4joGHdxNMe9ke66EW6iTIIXcMj
   0Y8ti1X7J9AOz6O7nZuTPXGq3sOAWz0UJuU2LYcRKoDeiCRmnK2Pk+F2O
   g==;
X-CSE-ConnectionGUID: 5Yj/fw7CRy2skjvahojPrA==
X-CSE-MsgGUID: 0dG2gpJJQVCo/EAKSaArBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750538"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750538"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:24 -0700
X-CSE-ConnectionGUID: vWAns49wScS9lU/LfkHEBA==
X-CSE-MsgGUID: 5jV/z6b7TG2+BVJTugnC6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26464"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:23 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 7/7] wifi: mac80211_hwsim: add NAN Instant Communication support
Date: Thu,  1 Oct 2026 16:33:11 +0300
Message-Id: <20261001162941.7e69a74a7ba5.Ib1a57bccf328a19dc55b914ccab73d023fe0876f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

Advertise Instant Communication support, and when it is enabled transmit
the discovery beacons disregarding the role and the state, with the
configured beacon interval and the NAN attributes set by user space.

In addition, accept beacons that carry a Service ID List or a Subscribe
Service ID List attribute at any time, so that they are forwarded to
mac80211.

When in instant communication, discovery beacons received during
non DW slots are processed for anchor master tracking and
synchronization.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/virtual/mac80211_hwsim_main.c    |   7 +-
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 231 +++++++++++++++---
 .../net/wireless/virtual/mac80211_hwsim_nan.h |   8 +
 3 files changed, 217 insertions(+), 29 deletions(-)

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
index fab6bd9e3cfb..79c41a66a07e 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -33,6 +33,12 @@ static_assert(DW0_TSF_MASK + 1 == 8192 * 1024);
 #define NAN_RSSI_CLOSE (-60)
 #define NAN_RSSI_MIDDLE (-75)
 
+/* Size of the NAN vendor element carrying the mandatory attributes */
+#define NAN_BEACON_ELEM_LEN		27
+
+/* Space left in the NAN vendor element for the configured attributes */
+#define NAN_BEACON_EXTRA_ATTRS_LEN	(255 - (NAN_BEACON_ELEM_LEN - 2))
+
 /* Quiet time at the end of each slot where TX is suppressed */
 #define NAN_CHAN_SWITCH_TIME_US		256
 
@@ -213,6 +219,37 @@ mac80211_hwsim_nan_schedule_slot(struct mac80211_hwsim_data *data, u8 slot,
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
@@ -263,15 +300,26 @@ void mac80211_hwsim_nan_rx(struct ieee80211_hw *hw,
 		slot = hwsim_nan_slot_from_tsf(rx_status.mactime);
 	}
 
+	/* (overly) simplify things, only track 2.4 GHz here */
+	if (rx_status.freq != 2437)
+		return;
+
 	/*
-	 * (overly) simplify things, only track 2.4 GHz here. Also, ignore
-	 * frames outside of the 2.4 GHz DW slot, unless in the initial SCAN
-	 * phase.
+	 * Ignore frames outside of the 2.4 GHz DW slot, unless in the initial
+	 * SCAN phase or in Instant Communication, where discovery beacons are
+	 * received outside the DW.
 	 */
-	if ((slot != SLOT_24GHZ_DW &&
-	     data->nan.phase != MAC80211_HWSIM_NAN_PHASE_SCAN) ||
-	    rx_status.freq != 2437)
-		return;
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
 
 	/* Just ignore low RSSI beacons that we cannot sync to */
 	if (rx_status.signal < NAN_RSSI_MIDDLE)
@@ -623,10 +671,12 @@ mac80211_hwsim_nan_exec_state_transitions(struct mac80211_hwsim_data *data)
 
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
@@ -685,7 +735,7 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 {
 	struct ieee80211_vendor_ie nan_ie = {
 		.element_id = WLAN_EID_VENDOR_SPECIFIC,
-		.len = 27 - 2,
+		.len = NAN_BEACON_ELEM_LEN - 2,
 		.oui = { u32_get_bits(WLAN_OUI_WFA, 0xff0000),
 			 u32_get_bits(WLAN_OUI_WFA, 0xff00),
 			 u32_get_bits(WLAN_OUI_WFA, 0xff) },
@@ -694,23 +744,39 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 	size_t alloc_size =
 		IEEE80211_TX_STATUS_HEADROOM +
 		offsetofend(struct ieee80211_mgmt, u.beacon) +
-		27 /* size of NAN vendor element */;
+		NAN_BEACON_ELEM_LEN;
 	struct ieee80211_nan_master_indication master_indication;
 	struct ieee80211_nan_attr nan_attr;
 	struct ieee80211_mgmt *mgmt;
 	struct sk_buff *skb;
+	u16 beacon_int;
 
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
+	 * The attributes configured by user space, e.g. the Service ID List
+	 * and Subscribe Service ID List attributes (needed for Instant
+	 * Communication), are appended to the mandatory ones.
+	 */
+	if (is_discovery)
+		nan_ie.len += data->nan.extra_nan_attrs_len;
+
+	beacon_int = is_discovery ? data->nan.discovery_beacon_interval :
+		DWST_TU;
+
 	skb_reserve(skb, IEEE80211_TX_STATUS_HEADROOM);
 	mgmt = skb_put(skb, offsetofend(struct ieee80211_mgmt, u.beacon));
 
@@ -721,7 +787,7 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_BEACON);
-	mgmt->u.beacon.beacon_int = cpu_to_le16(is_discovery ? 100 : DWST_TU);
+	mgmt->u.beacon.beacon_int = cpu_to_le16(beacon_int);
 	mgmt->u.beacon.capab_info =
 		cpu_to_le16(WLAN_CAPABILITY_SHORT_SLOT_TIME |
 			    WLAN_CAPABILITY_SHORT_PREAMBLE);
@@ -752,6 +818,10 @@ mac80211_hwsim_nan_tx_beacon(struct mac80211_hwsim_data *data,
 	skb_put_data(skb, &data->nan.current_ami,
 		     sizeof(data->nan.current_ami));
 
+	if (is_discovery && data->nan.extra_nan_attrs_len)
+		skb_put_data(skb, data->nan.extra_nan_attrs,
+			     data->nan.extra_nan_attrs_len);
+
 	spin_unlock(&data->nan.state_lock);
 
 	mac80211_hwsim_tx_frame(data->hw, skb, channel);
@@ -856,6 +926,7 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
 	struct mac80211_hwsim_data *data =
 		container_of(timer, struct mac80211_hwsim_data,
 			     nan.discovery_beacon_timer);
+	u16 beacon_int;
 	u32 remainder;
 	u64 tsf_now;
 	u64 tbtt;
@@ -864,11 +935,21 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
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
 
+	beacon_int = data->nan.discovery_beacon_interval;
+
 	mac80211_hwsim_nan_tx_beacon(
 		data, true, ieee80211_get_channel(data->hw->wiphy, 2437));
 
@@ -881,10 +962,10 @@ mac80211_hwsim_nan_discovery_beacon_timer(struct hrtimer *timer)
 	tsf_now = mac80211_hwsim_get_tsf(data->hw, data->nan.device_vif);
 
 	/* Wrap value to be after the next TBTT */
-	tbtt = tsf_now + ieee80211_tu_to_usec(100);
+	tbtt = tsf_now + ieee80211_tu_to_usec(beacon_int);
 
 	/* Round TBTT down to the correct time */
-	div_u64_rem(tbtt, ieee80211_tu_to_usec(100), &remainder);
+	div_u64_rem(tbtt, ieee80211_tu_to_usec(beacon_int), &remainder);
 	tbtt = tbtt - remainder;
 
 	hrtimer_set_expires(&data->nan.discovery_beacon_timer,
@@ -905,11 +986,51 @@ mac80211_hwsim_nan_sched_update_work(struct wiphy *wiphy,
 		ieee80211_nan_sched_update_done(data->nan.device_vif);
 }
 
+static int mac80211_hwsim_nan_set_config(struct mac80211_hwsim_data *data,
+					 struct cfg80211_nan_conf *conf)
+{
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
+	data->nan.notify_dw = conf->enable_dw_notification;
+
+	scoped_guard(spinlock_bh, &data->nan.state_lock) {
+		/*
+		 * Fall back to the device default if user space did not
+		 * configure it
+		 */
+		data->nan.discovery_beacon_interval =
+			conf->discovery_beacon_interval ? : 100;
+
+		data->nan.instant_comm = conf->instant_comm;
+
+		old = data->nan.extra_nan_attrs;
+		data->nan.extra_nan_attrs = extra_nan_attrs;
+		data->nan.extra_nan_attrs_len = conf->extra_nan_attrs_len;
+	}
+
+	kfree(old);
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
@@ -917,6 +1038,10 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 	if (data->nan.device_vif)
 		return -EALREADY;
 
+	err = mac80211_hwsim_nan_set_config(data, conf);
+	if (err)
+		return err;
+
 	/* set this before starting the timer, as preemption might occur */
 	data->nan.device_vif = vif;
 	data->nan.bands = conf->bands;
@@ -925,9 +1050,13 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
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
@@ -945,8 +1074,6 @@ int mac80211_hwsim_nan_start(struct ieee80211_hw *hw,
 
 	ether_addr_copy(data->nan.cluster_id, conf->cluster_id);
 
-	data->nan.notify_dw = conf->enable_dw_notification;
-
 	return 0;
 }
 
@@ -954,6 +1081,7 @@ int mac80211_hwsim_nan_stop(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+	const u8 *old;
 
 	if (vif->type != NL80211_IFTYPE_NAN || !data->nan.device_vif ||
 	    data->nan.device_vif != vif)
@@ -965,6 +1093,15 @@ int mac80211_hwsim_nan_stop(struct ieee80211_hw *hw,
 	wiphy_delayed_work_cancel(hw->wiphy, &data->nan.sched_update_work);
 	data->nan.device_vif = NULL;
 
+	scoped_guard(spinlock_bh, &data->nan.state_lock) {
+		old = data->nan.extra_nan_attrs;
+		data->nan.extra_nan_attrs = NULL;
+		data->nan.extra_nan_attrs_len = 0;
+		data->nan.instant_comm = false;
+	}
+
+	kfree(old);
+
 	return 0;
 }
 
@@ -983,13 +1120,27 @@ int mac80211_hwsim_nan_change_config(struct ieee80211_hw *hw,
 
 	wiphy_debug(hw->wiphy, "nan_config_changed: changes=0x%x\n", changes);
 
+	if (changes & CFG80211_NAN_CONF_CHANGED_CONFIG) {
+		int err = mac80211_hwsim_nan_set_config(data, conf);
+
+		if (err)
+			return err;
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
@@ -1172,9 +1323,16 @@ bool mac80211_hwsim_nan_txq_transmitting(struct ieee80211_hw *hw,
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
@@ -1227,15 +1385,32 @@ void mac80211_hwsim_nan_get_tx_chandef(struct ieee80211_hw *hw,
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
index 2801a1d8dcf0..7d1a05868eaa 100644
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
 
@@ -53,6 +56,10 @@ struct mac80211_hwsim_nan_data {
 	bool tsf_adjusted;
 	bool tsf_discontinuity;
 
+	/* Wi-Fi Aware version 4.0, Section 13 */
+	bool instant_comm;
+	u8 discovery_beacon_interval;
+
 	/*
 	 * Local schedule - stores channel definition for each 16TU slot.
 	 * Derived from NMI vif->cfg.nan_schedule. chan == NULL means not
@@ -93,6 +100,7 @@ void mac80211_hwsim_nan_get_tx_chandef(struct ieee80211_hw *hw,
 				       struct cfg80211_chan_def *chandef);
 
 bool mac80211_hwsim_nan_receive(struct ieee80211_hw *hw,
+				struct sk_buff *skb,
 				struct ieee80211_channel *channel,
 				struct ieee80211_rx_status *rx_status);
 
-- 
2.34.1

