Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44360 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756507AbaEILMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:12:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Fri,  9 May 2014 14:11:46 +0300
Message-Id: <1399633911-12788-4-git-send-email-luca@coelho.fi> (sfid-20140509_131241_646892_61FFB0AE)
In-Reply-To: <1399633911-12788-1-git-send-email-luca@coelho.fi>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 3/8] cfg80211: Support multiple CSA counters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Change the type of NL80211_ATTR_CSA_C_OFF_BEACON and
NL80211_ATTR_CSA_C_OFF_PRESP to be NLA_BINARY which allows
userspace to use beacons and probe responses with
multiple CSA counters.
This isn't breaking the API since userspace can
continue to use nla_put_u16 for this attributes, which
is equivalent to a single element u16 array.
In addition advertise max number of supported CSA counters.
This is needed when using CSA and eCSA IEs together.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 18 ++++++++++---
 include/uapi/linux/nl80211.h | 11 +++++---
 net/mac80211/cfg.c           | 10 +++++--
 net/wireless/core.c          |  2 ++
 net/wireless/nl80211.c       | 63 ++++++++++++++++++++++++++++++++++----------
 net/wireless/trace.h         | 22 +++++++++-------
 6 files changed, 94 insertions(+), 32 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ca1faf5..8ac2cc6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -694,8 +694,10 @@ struct cfg80211_ap_settings {
  *
  * @chandef: defines the channel to use after the switch
  * @beacon_csa: beacon data while performing the switch
- * @counter_offset_beacon: offset for the counter within the beacon (tail)
- * @counter_offset_presp: offset for the counter within the probe response
+ * @counter_offsets_beacon: offsets of the counters within the beacon (tail)
+ * @counter_offsets_presp: offsets of the counters within the probe response
+ * @n_counter_offsets_beacon: number of csa counters the beacon (tail)
+ * @n_counter_offsets_presp: number of csa counters in the probe response
  * @beacon_after: beacon data to be used on the new channel
  * @radar_required: whether radar detection is required on the new channel
  * @block_tx: whether transmissions should be blocked while changing
@@ -704,7 +706,10 @@ struct cfg80211_ap_settings {
 struct cfg80211_csa_settings {
 	struct cfg80211_chan_def chandef;
 	struct cfg80211_beacon_data beacon_csa;
-	u16 counter_offset_beacon, counter_offset_presp;
+	const u16 *counter_offsets_beacon;
+	const u16 *counter_offsets_presp;
+	unsigned int n_counter_offsets_beacon;
+	unsigned int n_counter_offsets_presp;
 	struct cfg80211_beacon_data beacon_after;
 	bool radar_required;
 	bool block_tx;
@@ -3046,6 +3051,13 @@ struct wiphy {
 
 	u16 max_ap_assoc_sta;
 
+	/*
+	 * Number of supported csa_counters in beacons and probe responses.
+	 * This value should be set if the driver wishes to limit the number of
+	 * csa counters. Default (0) means infinite.
+	 */
+	u8 max_num_csa_counters;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index aaa752f..a531bf3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1528,10 +1528,10 @@ enum nl80211_commands {
  *	operation).
  * @NL80211_ATTR_CSA_IES: Nested set of attributes containing the IE information
  *	for the time while performing a channel switch.
- * @NL80211_ATTR_CSA_C_OFF_BEACON: Offset of the channel switch counter
- *	field in the beacons tail (%NL80211_ATTR_BEACON_TAIL).
- * @NL80211_ATTR_CSA_C_OFF_PRESP: Offset of the channel switch counter
- *	field in the probe response (%NL80211_ATTR_PROBE_RESP).
+ * @NL80211_ATTR_CSA_C_OFF_BEACON: An array of offsets (u16) to the channel
+ *	switch counters in the beacons tail (%NL80211_ATTR_BEACON_TAIL).
+ * @NL80211_ATTR_CSA_C_OFF_PRESP: An array of offsets (u16) to the channel
+ *	switch counters in the probe response (%NL80211_ATTR_PROBE_RESP).
  *
  * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
  *	As specified in the &enum nl80211_rxmgmt_flags.
@@ -1581,6 +1581,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_CSA_C_OFFSETS_TX: An array of csa counter offsets (u16) which
  *	should be updated when the frame is transmitted.
+ * @NL80211_ATTR_MAX_CSA_COUNTERS: U8 attribute used to advertise the maximum
+ *	supported number of csa counters.
  *
  * @NL80211_ATTR_TDLS_PEER_CAPABILITY: flags for TDLS peer capabilities, u32.
  *	As specified in the &enum nl80211_tdls_peer_capability.
@@ -1927,6 +1929,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_IFACE_SOCKET_OWNER,
 
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
+	NL80211_ATTR_MAX_CSA_COUNTERS,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 86c20a8..6f132a5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3192,8 +3192,14 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 			break;
 
 		sdata->csa_counter_offset_beacon =
-			params->counter_offset_beacon;
-		sdata->csa_counter_offset_presp = params->counter_offset_presp;
+			params->counter_offsets_beacon[0];
+
+		if (params->n_counter_offsets_presp)
+			sdata->csa_counter_offset_presp =
+				params->counter_offsets_presp[0];
+		else
+			sdata->csa_counter_offset_presp = 0;
+
 		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
 		if (err < 0) {
 			kfree(sdata->u.ap.next_beacon);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3978871..d03d8bd 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -402,6 +402,8 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.rts_threshold = (u32) -1;
 	rdev->wiphy.coverage_class = 0;
 
+	rdev->wiphy.max_num_csa_counters = 1;
+
 	return &rdev->wiphy;
 }
 EXPORT_SYMBOL(wiphy_new);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f425a04..6cfff9b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -371,8 +371,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
 	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
-	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
-	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_BINARY },
+	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
@@ -1669,6 +1669,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			nla_nest_end(msg, nested);
 		}
 
+		if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH &&
+		    nla_put_u8(msg, NL80211_ATTR_MAX_CSA_COUNTERS,
+			       dev->wiphy.max_num_csa_counters))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -5862,6 +5867,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	u8 radar_detect_width = 0;
 	int err;
 	bool need_new_beacon = false;
+	int len, i;
 
 	if (!rdev->ops->channel_switch ||
 	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
@@ -5920,26 +5926,55 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (!csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON])
 		return -EINVAL;
 
-	params.counter_offset_beacon =
-		nla_get_u16(csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON]);
-	if (params.counter_offset_beacon >= params.beacon_csa.tail_len)
+	len = nla_len(csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON]);
+	if (!len || (len % sizeof(u16)))
 		return -EINVAL;
 
-	/* sanity check - counters should be the same */
-	if (params.beacon_csa.tail[params.counter_offset_beacon] !=
-	    params.count)
+	params.n_counter_offsets_beacon = len / sizeof(u16);
+	if (rdev->wiphy.max_num_csa_counters &&
+	    (params.n_counter_offsets_beacon >
+	     rdev->wiphy.max_num_csa_counters))
 		return -EINVAL;
 
+	params.counter_offsets_beacon =
+		nla_data(csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON]);
+
+	/* sanity checks -counters should fit and be the same */
+	for (i = 0; i < params.n_counter_offsets_beacon; i++) {
+		u16 offset = params.counter_offsets_beacon[i];
+
+		if (offset >= params.beacon_csa.tail_len)
+			return -EINVAL;
+
+		if (params.beacon_csa.tail[offset] != params.count)
+			return -EINVAL;
+	}
+
 	if (csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]) {
-		params.counter_offset_presp =
-			nla_get_u16(csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]);
-		if (params.counter_offset_presp >=
-		    params.beacon_csa.probe_resp_len)
+		len = nla_len(csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]);
+		if (!len || (len % sizeof(u16)))
 			return -EINVAL;
 
-		if (params.beacon_csa.probe_resp[params.counter_offset_presp] !=
-		    params.count)
+		params.n_counter_offsets_presp = len / sizeof(u16);
+		if (rdev->wiphy.max_num_csa_counters &&
+		    (params.n_counter_offsets_beacon >
+		     rdev->wiphy.max_num_csa_counters))
 			return -EINVAL;
+
+		params.counter_offsets_presp =
+			nla_data(csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]);
+
+		/* sanity checks -counters should fit and be the same */
+		for (i = 0; i < params.n_counter_offsets_presp; i++) {
+			u16 offset = params.counter_offsets_presp[i];
+
+			if (offset >= params.beacon_csa.probe_resp_len)
+				return -EINVAL;
+
+			if (params.beacon_csa.probe_resp[offset] !=
+			    params.count)
+				return -EINVAL;
+		}
 	}
 
 skip_beacons:
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index cdfbb00..560ed77 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1876,29 +1876,33 @@ TRACE_EVENT(rdev_channel_switch,
 		WIPHY_ENTRY
 		NETDEV_ENTRY
 		CHAN_DEF_ENTRY
-		__field(u16, counter_offset_beacon)
-		__field(u16, counter_offset_presp)
 		__field(bool, radar_required)
 		__field(bool, block_tx)
 		__field(u8, count)
+		__dynamic_array(u16, bcn_ofs, params->n_counter_offsets_beacon)
+		__dynamic_array(u16, pres_ofs, params->n_counter_offsets_presp)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
 		CHAN_DEF_ASSIGN(&params->chandef);
-		__entry->counter_offset_beacon = params->counter_offset_beacon;
-		__entry->counter_offset_presp = params->counter_offset_presp;
 		__entry->radar_required = params->radar_required;
 		__entry->block_tx = params->block_tx;
 		__entry->count = params->count;
+		memcpy(__get_dynamic_array(bcn_ofs),
+		       params->counter_offsets_beacon,
+		       params->n_counter_offsets_beacon * sizeof(u16));
+
+		/* probe response offsets are optional */
+		if (params->n_counter_offsets_presp)
+			memcpy(__get_dynamic_array(pres_ofs),
+			       params->counter_offsets_presp,
+			       params->n_counter_offsets_presp * sizeof(u16));
 	),
 	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT
-		  ", block_tx: %d, count: %u, radar_required: %d"
-		  ", counter offsets (beacon/presp): %u/%u",
+		  ", block_tx: %d, count: %u, radar_required: %d",
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG,
-		  __entry->block_tx, __entry->count, __entry->radar_required,
-		  __entry->counter_offset_beacon,
-		  __entry->counter_offset_presp)
+		  __entry->block_tx, __entry->count, __entry->radar_required)
 );
 
 TRACE_EVENT(rdev_set_qos_map,
-- 
2.0.0.rc0

