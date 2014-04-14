Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60877 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaDNJwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 05:52:07 -0400
Received: by mail-pb0-f52.google.com with SMTP id rr13so8053938pbb.39
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 02:52:07 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/6] cfg80211: change pointer name
Date: Mon, 14 Apr 2014 17:51:34 +0800
Message-Id: <55b5dc1ff2926d1f8e6671c513fe8f0a5b344d72.1397469036.git.gamerh2o@gmail.com> (sfid-20140414_115413_317048_8BA12A90)
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Name "dev" is too common and ambiguous, let all the pointer name
pointing to struct cfg80211_registered_device be "rdev". This can
improve code readability and consistency(since some places have
already called it rdev).

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/core.h    |   4 +-
 net/wireless/nl80211.c | 258 ++++++++++++++++++++++++-------------------------
 net/wireless/scan.c    | 130 ++++++++++++-------------
 3 files changed, 196 insertions(+), 196 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5b1fdca..200c291 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -240,8 +240,8 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 
 void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
 
-void cfg80211_bss_expire(struct cfg80211_registered_device *dev);
-void cfg80211_bss_age(struct cfg80211_registered_device *dev,
+void cfg80211_bss_expire(struct cfg80211_registered_device *rdev);
+void cfg80211_bss_age(struct cfg80211_registered_device *rdev,
                       unsigned long age_secs);
 
 /* IBSS */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 052c1bf..7dc2719 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1006,42 +1006,42 @@ static int nl80211_send_wowlan_tcp_caps(struct cfg80211_registered_device *rdev,
 }
 
 static int nl80211_send_wowlan(struct sk_buff *msg,
-			       struct cfg80211_registered_device *dev,
+			       struct cfg80211_registered_device *rdev,
 			       bool large)
 {
 	struct nlattr *nl_wowlan;
 
-	if (!dev->wiphy.wowlan)
+	if (!rdev->wiphy.wowlan)
 		return 0;
 
 	nl_wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED);
 	if (!nl_wowlan)
 		return -ENOBUFS;
 
-	if (((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_ANY) &&
+	if (((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_ANY) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_ANY)) ||
-	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_DISCONNECT) &&
+	    ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_DISCONNECT) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_DISCONNECT)) ||
-	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_MAGIC_PKT) &&
+	    ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_MAGIC_PKT) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT)) ||
-	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY) &&
+	    ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED)) ||
-	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
+	    ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE)) ||
-	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_EAP_IDENTITY_REQ) &&
+	    ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_EAP_IDENTITY_REQ) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST)) ||
-	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_4WAY_HANDSHAKE) &&
+	    ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_4WAY_HANDSHAKE) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE)) ||
-	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_RFKILL_RELEASE) &&
+	    ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_RFKILL_RELEASE) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_RFKILL_RELEASE)))
 		return -ENOBUFS;
 
-	if (dev->wiphy.wowlan->n_patterns) {
+	if (rdev->wiphy.wowlan->n_patterns) {
 		struct nl80211_pattern_support pat = {
-			.max_patterns = dev->wiphy.wowlan->n_patterns,
-			.min_pattern_len = dev->wiphy.wowlan->pattern_min_len,
-			.max_pattern_len = dev->wiphy.wowlan->pattern_max_len,
-			.max_pkt_offset = dev->wiphy.wowlan->max_pkt_offset,
+			.max_patterns = rdev->wiphy.wowlan->n_patterns,
+			.min_pattern_len = rdev->wiphy.wowlan->pattern_min_len,
+			.max_pattern_len = rdev->wiphy.wowlan->pattern_max_len,
+			.max_pkt_offset = rdev->wiphy.wowlan->max_pkt_offset,
 		};
 
 		if (nla_put(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN,
@@ -1049,7 +1049,7 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 			return -ENOBUFS;
 	}
 
-	if (large && nl80211_send_wowlan_tcp_caps(dev, msg))
+	if (large && nl80211_send_wowlan_tcp_caps(rdev, msg))
 		return -ENOBUFS;
 
 	nla_nest_end(msg, nl_wowlan);
@@ -1059,19 +1059,19 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 #endif
 
 static int nl80211_send_coalesce(struct sk_buff *msg,
-				 struct cfg80211_registered_device *dev)
+				 struct cfg80211_registered_device *rdev)
 {
 	struct nl80211_coalesce_rule_support rule;
 
-	if (!dev->wiphy.coalesce)
+	if (!rdev->wiphy.coalesce)
 		return 0;
 
-	rule.max_rules = dev->wiphy.coalesce->n_rules;
-	rule.max_delay = dev->wiphy.coalesce->max_delay;
-	rule.pat.max_patterns = dev->wiphy.coalesce->n_patterns;
-	rule.pat.min_pattern_len = dev->wiphy.coalesce->pattern_min_len;
-	rule.pat.max_pattern_len = dev->wiphy.coalesce->pattern_max_len;
-	rule.pat.max_pkt_offset = dev->wiphy.coalesce->max_pkt_offset;
+	rule.max_rules = rdev->wiphy.coalesce->n_rules;
+	rule.max_delay = rdev->wiphy.coalesce->max_delay;
+	rule.pat.max_patterns = rdev->wiphy.coalesce->n_patterns;
+	rule.pat.min_pattern_len = rdev->wiphy.coalesce->pattern_min_len;
+	rule.pat.max_pattern_len = rdev->wiphy.coalesce->pattern_max_len;
+	rule.pat.max_pkt_offset = rdev->wiphy.coalesce->max_pkt_offset;
 
 	if (nla_put(msg, NL80211_ATTR_COALESCE_RULE, sizeof(rule), &rule))
 		return -ENOBUFS;
@@ -1202,7 +1202,7 @@ struct nl80211_dump_wiphy_state {
 	bool split;
 };
 
-static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
+static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			      struct sk_buff *msg, u32 portid, u32 seq,
 			      int flags, struct nl80211_dump_wiphy_state *state)
 {
@@ -1214,7 +1214,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	struct ieee80211_channel *chan;
 	int i;
 	const struct ieee80211_txrx_stypes *mgmt_stypes =
-				dev->wiphy.mgmt_stypes;
+				rdev->wiphy.mgmt_stypes;
 	u32 features;
 
 	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_WIPHY);
@@ -1224,9 +1224,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	if (WARN_ON(!state))
 		return -EINVAL;
 
-	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, dev->wiphy_idx) ||
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_string(msg, NL80211_ATTR_WIPHY_NAME,
-			   wiphy_name(&dev->wiphy)) ||
+			   wiphy_name(&rdev->wiphy)) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			cfg80211_rdev_list_generation))
 		goto nla_put_failure;
@@ -1234,43 +1234,43 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	switch (state->split_start) {
 	case 0:
 		if (nla_put_u8(msg, NL80211_ATTR_WIPHY_RETRY_SHORT,
-			       dev->wiphy.retry_short) ||
+			       rdev->wiphy.retry_short) ||
 		    nla_put_u8(msg, NL80211_ATTR_WIPHY_RETRY_LONG,
-			       dev->wiphy.retry_long) ||
+			       rdev->wiphy.retry_long) ||
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
-				dev->wiphy.frag_threshold) ||
+				rdev->wiphy.frag_threshold) ||
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
-				dev->wiphy.rts_threshold) ||
+				rdev->wiphy.rts_threshold) ||
 		    nla_put_u8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
-			       dev->wiphy.coverage_class) ||
+			       rdev->wiphy.coverage_class) ||
 		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
-			       dev->wiphy.max_scan_ssids) ||
+			       rdev->wiphy.max_scan_ssids) ||
 		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
-			       dev->wiphy.max_sched_scan_ssids) ||
+			       rdev->wiphy.max_sched_scan_ssids) ||
 		    nla_put_u16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
-				dev->wiphy.max_scan_ie_len) ||
+				rdev->wiphy.max_scan_ie_len) ||
 		    nla_put_u16(msg, NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
-				dev->wiphy.max_sched_scan_ie_len) ||
+				rdev->wiphy.max_sched_scan_ie_len) ||
 		    nla_put_u8(msg, NL80211_ATTR_MAX_MATCH_SETS,
-			       dev->wiphy.max_match_sets))
+			       rdev->wiphy.max_match_sets))
 			goto nla_put_failure;
 
-		if ((dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN) &&
 		    nla_put_flag(msg, NL80211_ATTR_SUPPORT_IBSS_RSN))
 			goto nla_put_failure;
-		if ((dev->wiphy.flags & WIPHY_FLAG_MESH_AUTH) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_MESH_AUTH) &&
 		    nla_put_flag(msg, NL80211_ATTR_SUPPORT_MESH_AUTH))
 			goto nla_put_failure;
-		if ((dev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
 		    nla_put_flag(msg, NL80211_ATTR_SUPPORT_AP_UAPSD))
 			goto nla_put_failure;
-		if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FW_ROAM) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FW_ROAM) &&
 		    nla_put_flag(msg, NL80211_ATTR_ROAM_SUPPORT))
 			goto nla_put_failure;
-		if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_SUPPORT))
 			goto nla_put_failure;
-		if ((dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
 		state->split_start++;
@@ -1278,35 +1278,35 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			break;
 	case 1:
 		if (nla_put(msg, NL80211_ATTR_CIPHER_SUITES,
-			    sizeof(u32) * dev->wiphy.n_cipher_suites,
-			    dev->wiphy.cipher_suites))
+			    sizeof(u32) * rdev->wiphy.n_cipher_suites,
+			    rdev->wiphy.cipher_suites))
 			goto nla_put_failure;
 
 		if (nla_put_u8(msg, NL80211_ATTR_MAX_NUM_PMKIDS,
-			       dev->wiphy.max_num_pmkids))
+			       rdev->wiphy.max_num_pmkids))
 			goto nla_put_failure;
 
-		if ((dev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_PROTOCOL) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_PROTOCOL) &&
 		    nla_put_flag(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE))
 			goto nla_put_failure;
 
 		if (nla_put_u32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
-				dev->wiphy.available_antennas_tx) ||
+				rdev->wiphy.available_antennas_tx) ||
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
-				dev->wiphy.available_antennas_rx))
+				rdev->wiphy.available_antennas_rx))
 			goto nla_put_failure;
 
-		if ((dev->wiphy.flags & WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD) &&
 		    nla_put_u32(msg, NL80211_ATTR_PROBE_RESP_OFFLOAD,
-				dev->wiphy.probe_resp_offload))
+				rdev->wiphy.probe_resp_offload))
 			goto nla_put_failure;
 
-		if ((dev->wiphy.available_antennas_tx ||
-		     dev->wiphy.available_antennas_rx) &&
-		    dev->ops->get_antenna) {
+		if ((rdev->wiphy.available_antennas_tx ||
+		     rdev->wiphy.available_antennas_rx) &&
+		    rdev->ops->get_antenna) {
 			u32 tx_ant = 0, rx_ant = 0;
 			int res;
-			res = rdev_get_antenna(dev, &tx_ant, &rx_ant);
+			res = rdev_get_antenna(rdev, &tx_ant, &rx_ant);
 			if (!res) {
 				if (nla_put_u32(msg,
 						NL80211_ATTR_WIPHY_ANTENNA_TX,
@@ -1323,7 +1323,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			break;
 	case 2:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
-					dev->wiphy.interface_modes))
+					rdev->wiphy.interface_modes))
 				goto nla_put_failure;
 		state->split_start++;
 		if (state->split)
@@ -1337,7 +1337,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		     band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
 
-			sband = dev->wiphy.bands[band];
+			sband = rdev->wiphy.bands[band];
 
 			if (!sband)
 				continue;
@@ -1414,7 +1414,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		i = 0;
 #define CMD(op, n)							\
 		 do {							\
-			if (dev->ops->op) {				\
+			if (rdev->ops->op) {				\
 				i++;					\
 				if (nla_put_u32(msg, i, NL80211_CMD_ ## n)) \
 					goto nla_put_failure;		\
@@ -1438,32 +1438,32 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		CMD(set_pmksa, SET_PMKSA);
 		CMD(del_pmksa, DEL_PMKSA);
 		CMD(flush_pmksa, FLUSH_PMKSA);
-		if (dev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL)
+		if (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL)
 			CMD(remain_on_channel, REMAIN_ON_CHANNEL);
 		CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
 		CMD(mgmt_tx, FRAME);
 		CMD(mgmt_tx_cancel_wait, FRAME_WAIT_CANCEL);
-		if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
+		if (rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 			i++;
 			if (nla_put_u32(msg, i, NL80211_CMD_SET_WIPHY_NETNS))
 				goto nla_put_failure;
 		}
-		if (dev->ops->set_monitor_channel || dev->ops->start_ap ||
-		    dev->ops->join_mesh) {
+		if (rdev->ops->set_monitor_channel || rdev->ops->start_ap ||
+		    rdev->ops->join_mesh) {
 			i++;
 			if (nla_put_u32(msg, i, NL80211_CMD_SET_CHANNEL))
 				goto nla_put_failure;
 		}
 		CMD(set_wds_peer, SET_WDS_PEER);
-		if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) {
+		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) {
 			CMD(tdls_mgmt, TDLS_MGMT);
 			CMD(tdls_oper, TDLS_OPER);
 		}
-		if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
 			CMD(sched_scan_start, START_SCHED_SCAN);
 		CMD(probe_client, PROBE_CLIENT);
 		CMD(set_noack_map, SET_NOACK_MAP);
-		if (dev->wiphy.flags & WIPHY_FLAG_REPORTS_OBSS) {
+		if (rdev->wiphy.flags & WIPHY_FLAG_REPORTS_OBSS) {
 			i++;
 			if (nla_put_u32(msg, i, NL80211_CMD_REGISTER_BEACONS))
 				goto nla_put_failure;
@@ -1473,7 +1473,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if (state->split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
-			if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
+			if (rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
 				CMD(channel_switch, CHANNEL_SWITCH);
 		}
 		CMD(set_qos_map, SET_QOS_MAP);
@@ -1484,13 +1484,13 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 
 #undef CMD
 
-		if (dev->ops->connect || dev->ops->auth) {
+		if (rdev->ops->connect || rdev->ops->auth) {
 			i++;
 			if (nla_put_u32(msg, i, NL80211_CMD_CONNECT))
 				goto nla_put_failure;
 		}
 
-		if (dev->ops->disconnect || dev->ops->deauth) {
+		if (rdev->ops->disconnect || rdev->ops->deauth) {
 			i++;
 			if (nla_put_u32(msg, i, NL80211_CMD_DISCONNECT))
 				goto nla_put_failure;
@@ -1501,14 +1501,14 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if (state->split)
 			break;
 	case 5:
-		if (dev->ops->remain_on_channel &&
-		    (dev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL) &&
+		if (rdev->ops->remain_on_channel &&
+		    (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL) &&
 		    nla_put_u32(msg,
 				NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
-				dev->wiphy.max_remain_on_channel_duration))
+				rdev->wiphy.max_remain_on_channel_duration))
 			goto nla_put_failure;
 
-		if ((dev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX) &&
 		    nla_put_flag(msg, NL80211_ATTR_OFFCHANNEL_TX_OK))
 			goto nla_put_failure;
 
@@ -1519,7 +1519,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			break;
 	case 6:
 #ifdef CONFIG_PM
-		if (nl80211_send_wowlan(msg, dev, state->split))
+		if (nl80211_send_wowlan(msg, rdev, state->split))
 			goto nla_put_failure;
 		state->split_start++;
 		if (state->split)
@@ -1529,10 +1529,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 #endif
 	case 7:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
-					dev->wiphy.software_iftypes))
+					rdev->wiphy.software_iftypes))
 			goto nla_put_failure;
 
-		if (nl80211_put_iface_combinations(&dev->wiphy, msg,
+		if (nl80211_put_iface_combinations(&rdev->wiphy, msg,
 						   state->split))
 			goto nla_put_failure;
 
@@ -1540,12 +1540,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if (state->split)
 			break;
 	case 8:
-		if ((dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
 		    nla_put_u32(msg, NL80211_ATTR_DEVICE_AP_SME,
-				dev->wiphy.ap_sme_capa))
+				rdev->wiphy.ap_sme_capa))
 			goto nla_put_failure;
 
-		features = dev->wiphy.features;
+		features = rdev->wiphy.features;
 		/*
 		 * We can only add the per-channel limit information if the
 		 * dump is split, otherwise it makes it too big. Therefore
@@ -1556,16 +1556,16 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if (nla_put_u32(msg, NL80211_ATTR_FEATURE_FLAGS, features))
 			goto nla_put_failure;
 
-		if (dev->wiphy.ht_capa_mod_mask &&
+		if (rdev->wiphy.ht_capa_mod_mask &&
 		    nla_put(msg, NL80211_ATTR_HT_CAPABILITY_MASK,
-			    sizeof(*dev->wiphy.ht_capa_mod_mask),
-			    dev->wiphy.ht_capa_mod_mask))
+			    sizeof(*rdev->wiphy.ht_capa_mod_mask),
+			    rdev->wiphy.ht_capa_mod_mask))
 			goto nla_put_failure;
 
-		if (dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME &&
-		    dev->wiphy.max_acl_mac_addrs &&
+		if (rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME &&
+		    rdev->wiphy.max_acl_mac_addrs &&
 		    nla_put_u32(msg, NL80211_ATTR_MAC_ACL_MAX,
-				dev->wiphy.max_acl_mac_addrs))
+				rdev->wiphy.max_acl_mac_addrs))
 			goto nla_put_failure;
 
 		/*
@@ -1581,41 +1581,41 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		state->split_start++;
 		break;
 	case 9:
-		if (dev->wiphy.extended_capabilities &&
+		if (rdev->wiphy.extended_capabilities &&
 		    (nla_put(msg, NL80211_ATTR_EXT_CAPA,
-			     dev->wiphy.extended_capabilities_len,
-			     dev->wiphy.extended_capabilities) ||
+			     rdev->wiphy.extended_capabilities_len,
+			     rdev->wiphy.extended_capabilities) ||
 		     nla_put(msg, NL80211_ATTR_EXT_CAPA_MASK,
-			     dev->wiphy.extended_capabilities_len,
-			     dev->wiphy.extended_capabilities_mask)))
+			     rdev->wiphy.extended_capabilities_len,
+			     rdev->wiphy.extended_capabilities_mask)))
 			goto nla_put_failure;
 
-		if (dev->wiphy.vht_capa_mod_mask &&
+		if (rdev->wiphy.vht_capa_mod_mask &&
 		    nla_put(msg, NL80211_ATTR_VHT_CAPABILITY_MASK,
-			    sizeof(*dev->wiphy.vht_capa_mod_mask),
-			    dev->wiphy.vht_capa_mod_mask))
+			    sizeof(*rdev->wiphy.vht_capa_mod_mask),
+			    rdev->wiphy.vht_capa_mod_mask))
 			goto nla_put_failure;
 
 		state->split_start++;
 		break;
 	case 10:
-		if (nl80211_send_coalesce(msg, dev))
+		if (nl80211_send_coalesce(msg, rdev))
 			goto nla_put_failure;
 
-		if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ) &&
+		if ((rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ) &&
 		    (nla_put_flag(msg, NL80211_ATTR_SUPPORT_5_MHZ) ||
 		     nla_put_flag(msg, NL80211_ATTR_SUPPORT_10_MHZ)))
 			goto nla_put_failure;
 
-		if (dev->wiphy.max_ap_assoc_sta &&
+		if (rdev->wiphy.max_ap_assoc_sta &&
 		    nla_put_u32(msg, NL80211_ATTR_MAX_AP_ASSOC_STA,
-				dev->wiphy.max_ap_assoc_sta))
+				rdev->wiphy.max_ap_assoc_sta))
 			goto nla_put_failure;
 
 		state->split_start++;
 		break;
 	case 11:
-		if (dev->wiphy.n_vendor_commands) {
+		if (rdev->wiphy.n_vendor_commands) {
 			const struct nl80211_vendor_cmd_info *info;
 			struct nlattr *nested;
 
@@ -1623,15 +1623,15 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			if (!nested)
 				goto nla_put_failure;
 
-			for (i = 0; i < dev->wiphy.n_vendor_commands; i++) {
-				info = &dev->wiphy.vendor_commands[i].info;
+			for (i = 0; i < rdev->wiphy.n_vendor_commands; i++) {
+				info = &rdev->wiphy.vendor_commands[i].info;
 				if (nla_put(msg, i + 1, sizeof(*info), info))
 					goto nla_put_failure;
 			}
 			nla_nest_end(msg, nested);
 		}
 
-		if (dev->wiphy.n_vendor_events) {
+		if (rdev->wiphy.n_vendor_events) {
 			const struct nl80211_vendor_cmd_info *info;
 			struct nlattr *nested;
 
@@ -1640,8 +1640,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			if (!nested)
 				goto nla_put_failure;
 
-			for (i = 0; i < dev->wiphy.n_vendor_events; i++) {
-				info = &dev->wiphy.vendor_events[i];
+			for (i = 0; i < rdev->wiphy.n_vendor_events; i++) {
+				info = &rdev->wiphy.vendor_events[i];
 				if (nla_put(msg, i + 1, sizeof(*info), info))
 					goto nla_put_failure;
 			}
@@ -1697,7 +1697,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	int idx = 0, ret;
 	struct nl80211_dump_wiphy_state *state = (void *)cb->args[0];
-	struct cfg80211_registered_device *dev;
+	struct cfg80211_registered_device *rdev;
 
 	rtnl_lock();
 	if (!state) {
@@ -1716,17 +1716,17 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 		cb->args[0] = (long)state;
 	}
 
-	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
-		if (!net_eq(wiphy_net(&dev->wiphy), sock_net(skb->sk)))
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (!net_eq(wiphy_net(&rdev->wiphy), sock_net(skb->sk)))
 			continue;
 		if (++idx <= state->start)
 			continue;
 		if (state->filter_wiphy != -1 &&
-		    state->filter_wiphy != dev->wiphy_idx)
+		    state->filter_wiphy != rdev->wiphy_idx)
 			continue;
 		/* attempt to fit multiple wiphy data chunks into the skb */
 		do {
-			ret = nl80211_send_wiphy(dev, skb,
+			ret = nl80211_send_wiphy(rdev, skb,
 						 NETLINK_CB(cb->skb).portid,
 						 cb->nlh->nlmsg_seq,
 						 NLM_F_MULTI, state);
@@ -1774,14 +1774,14 @@ static int nl80211_dump_wiphy_done(struct netlink_callback *cb)
 static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
-	struct cfg80211_registered_device *dev = info->user_ptr[0];
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct nl80211_dump_wiphy_state state = {};
 
 	msg = nlmsg_new(4096, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	if (nl80211_send_wiphy(dev, msg, info->snd_portid, info->snd_seq, 0,
+	if (nl80211_send_wiphy(rdev, msg, info->snd_portid, info->snd_seq, 0,
 			       &state) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
@@ -2355,7 +2355,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
-	struct cfg80211_registered_device *dev = info->user_ptr[0];
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -2363,7 +2363,7 @@ static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
 		return -ENOMEM;
 
 	if (nl80211_send_iface(msg, info->snd_portid, info->snd_seq, 0,
-			       dev, wdev) < 0) {
+			       rdev, wdev) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -3675,13 +3675,13 @@ static int nl80211_dump_station(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
 	struct station_info sinfo;
-	struct cfg80211_registered_device *dev;
+	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 	u8 mac_addr[ETH_ALEN];
 	int sta_idx = cb->args[2];
 	int err;
 
-	err = nl80211_prepare_wdev_dump(skb, cb, &dev, &wdev);
+	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
 	if (err)
 		return err;
 
@@ -3690,14 +3690,14 @@ static int nl80211_dump_station(struct sk_buff *skb,
 		goto out_err;
 	}
 
-	if (!dev->ops->dump_station) {
+	if (!rdev->ops->dump_station) {
 		err = -EOPNOTSUPP;
 		goto out_err;
 	}
 
 	while (1) {
 		memset(&sinfo, 0, sizeof(sinfo));
-		err = rdev_dump_station(dev, wdev->netdev, sta_idx,
+		err = rdev_dump_station(rdev, wdev->netdev, sta_idx,
 					mac_addr, &sinfo);
 		if (err == -ENOENT)
 			break;
@@ -3707,7 +3707,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 		if (nl80211_send_station(skb,
 				NETLINK_CB(cb->skb).portid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				dev, wdev->netdev, mac_addr,
+				rdev, wdev->netdev, mac_addr,
 				&sinfo) < 0)
 			goto out;
 
@@ -3719,7 +3719,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 	cb->args[2] = sta_idx;
 	err = skb->len;
  out_err:
-	nl80211_finish_wdev_dump(dev);
+	nl80211_finish_wdev_dump(rdev);
 
 	return err;
 }
@@ -4380,18 +4380,18 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 			      struct netlink_callback *cb)
 {
 	struct mpath_info pinfo;
-	struct cfg80211_registered_device *dev;
+	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 	u8 dst[ETH_ALEN];
 	u8 next_hop[ETH_ALEN];
 	int path_idx = cb->args[2];
 	int err;
 
-	err = nl80211_prepare_wdev_dump(skb, cb, &dev, &wdev);
+	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
 	if (err)
 		return err;
 
-	if (!dev->ops->dump_mpath) {
+	if (!rdev->ops->dump_mpath) {
 		err = -EOPNOTSUPP;
 		goto out_err;
 	}
@@ -4402,7 +4402,7 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 	}
 
 	while (1) {
-		err = rdev_dump_mpath(dev, wdev->netdev, path_idx, dst,
+		err = rdev_dump_mpath(rdev, wdev->netdev, path_idx, dst,
 				      next_hop, &pinfo);
 		if (err == -ENOENT)
 			break;
@@ -4423,7 +4423,7 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 	cb->args[2] = path_idx;
 	err = skb->len;
  out_err:
-	nl80211_finish_wdev_dump(dev);
+	nl80211_finish_wdev_dump(rdev);
 	return err;
 }
 
@@ -6175,12 +6175,12 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 			struct netlink_callback *cb)
 {
 	struct survey_info survey;
-	struct cfg80211_registered_device *dev;
+	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 	int survey_idx = cb->args[2];
 	int res;
 
-	res = nl80211_prepare_wdev_dump(skb, cb, &dev, &wdev);
+	res = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
 	if (res)
 		return res;
 
@@ -6189,7 +6189,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 		goto out_err;
 	}
 
-	if (!dev->ops->dump_survey) {
+	if (!rdev->ops->dump_survey) {
 		res = -EOPNOTSUPP;
 		goto out_err;
 	}
@@ -6197,7 +6197,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 	while (1) {
 		struct ieee80211_channel *chan;
 
-		res = rdev_dump_survey(dev, wdev->netdev, survey_idx, &survey);
+		res = rdev_dump_survey(rdev, wdev->netdev, survey_idx, &survey);
 		if (res == -ENOENT)
 			break;
 		if (res)
@@ -6209,7 +6209,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 			goto out;
 		}
 
-		chan = ieee80211_get_channel(&dev->wiphy,
+		chan = ieee80211_get_channel(&rdev->wiphy,
 					     survey.channel->center_freq);
 		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
 			survey_idx++;
@@ -6228,7 +6228,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 	cb->args[2] = survey_idx;
 	res = skb->len;
  out_err:
-	nl80211_finish_wdev_dump(dev);
+	nl80211_finish_wdev_dump(rdev);
 	return res;
 }
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7d09a71..dd04cd9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -81,10 +81,10 @@ static void bss_free(struct cfg80211_internal_bss *bss)
 	kfree(bss);
 }
 
-static inline void bss_ref_get(struct cfg80211_registered_device *dev,
+static inline void bss_ref_get(struct cfg80211_registered_device *rdev,
 			       struct cfg80211_internal_bss *bss)
 {
-	lockdep_assert_held(&dev->bss_lock);
+	lockdep_assert_held(&rdev->bss_lock);
 
 	bss->refcount++;
 	if (bss->pub.hidden_beacon_bss) {
@@ -95,10 +95,10 @@ static inline void bss_ref_get(struct cfg80211_registered_device *dev,
 	}
 }
 
-static inline void bss_ref_put(struct cfg80211_registered_device *dev,
+static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
 			       struct cfg80211_internal_bss *bss)
 {
-	lockdep_assert_held(&dev->bss_lock);
+	lockdep_assert_held(&rdev->bss_lock);
 
 	if (bss->pub.hidden_beacon_bss) {
 		struct cfg80211_internal_bss *hbss;
@@ -114,10 +114,10 @@ static inline void bss_ref_put(struct cfg80211_registered_device *dev,
 		bss_free(bss);
 }
 
-static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
+static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 				  struct cfg80211_internal_bss *bss)
 {
-	lockdep_assert_held(&dev->bss_lock);
+	lockdep_assert_held(&rdev->bss_lock);
 
 	if (!list_empty(&bss->hidden_list)) {
 		/*
@@ -134,31 +134,31 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 	}
 
 	list_del_init(&bss->list);
-	rb_erase(&bss->rbn, &dev->bss_tree);
-	bss_ref_put(dev, bss);
+	rb_erase(&bss->rbn, &rdev->bss_tree);
+	bss_ref_put(rdev, bss);
 	return true;
 }
 
-static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
+static void __cfg80211_bss_expire(struct cfg80211_registered_device *rdev,
 				  unsigned long expire_time)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
 	bool expired = false;
 
-	lockdep_assert_held(&dev->bss_lock);
+	lockdep_assert_held(&rdev->bss_lock);
 
-	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
+	list_for_each_entry_safe(bss, tmp, &rdev->bss_list, list) {
 		if (atomic_read(&bss->hold))
 			continue;
 		if (!time_after(expire_time, bss->ts))
 			continue;
 
-		if (__cfg80211_unlink_bss(dev, bss))
+		if (__cfg80211_unlink_bss(rdev, bss))
 			expired = true;
 	}
 
 	if (expired)
-		dev->bss_generation++;
+		rdev->bss_generation++;
 }
 
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
@@ -322,21 +322,21 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-void cfg80211_bss_age(struct cfg80211_registered_device *dev,
+void cfg80211_bss_age(struct cfg80211_registered_device *rdev,
                       unsigned long age_secs)
 {
 	struct cfg80211_internal_bss *bss;
 	unsigned long age_jiffies = msecs_to_jiffies(age_secs * MSEC_PER_SEC);
 
-	spin_lock_bh(&dev->bss_lock);
-	list_for_each_entry(bss, &dev->bss_list, list)
+	spin_lock_bh(&rdev->bss_lock);
+	list_for_each_entry(bss, &rdev->bss_list, list)
 		bss->ts -= age_jiffies;
-	spin_unlock_bh(&dev->bss_lock);
+	spin_unlock_bh(&rdev->bss_lock);
 }
 
-void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
+void cfg80211_bss_expire(struct cfg80211_registered_device *rdev)
 {
-	__cfg80211_bss_expire(dev, jiffies - IEEE80211_SCAN_RESULT_EXPIRE);
+	__cfg80211_bss_expire(rdev, jiffies - IEEE80211_SCAN_RESULT_EXPIRE);
 }
 
 const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
@@ -526,16 +526,16 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val)
 {
-	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
 
 	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, capa_mask,
 			       capa_val);
 
-	spin_lock_bh(&dev->bss_lock);
+	spin_lock_bh(&rdev->bss_lock);
 
-	list_for_each_entry(bss, &dev->bss_list, list) {
+	list_for_each_entry(bss, &rdev->bss_list, list) {
 		if ((bss->pub.capability & capa_mask) != capa_val)
 			continue;
 		if (channel && bss->pub.channel != channel)
@@ -546,12 +546,12 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 			continue;
 		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
 			res = bss;
-			bss_ref_get(dev, res);
+			bss_ref_get(rdev, res);
 			break;
 		}
 	}
 
-	spin_unlock_bh(&dev->bss_lock);
+	spin_unlock_bh(&rdev->bss_lock);
 	if (!res)
 		return NULL;
 	trace_cfg80211_return_bss(&res->pub);
@@ -559,10 +559,10 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_get_bss);
 
-static void rb_insert_bss(struct cfg80211_registered_device *dev,
+static void rb_insert_bss(struct cfg80211_registered_device *rdev,
 			  struct cfg80211_internal_bss *bss)
 {
-	struct rb_node **p = &dev->bss_tree.rb_node;
+	struct rb_node **p = &rdev->bss_tree.rb_node;
 	struct rb_node *parent = NULL;
 	struct cfg80211_internal_bss *tbss;
 	int cmp;
@@ -585,15 +585,15 @@ static void rb_insert_bss(struct cfg80211_registered_device *dev,
 	}
 
 	rb_link_node(&bss->rbn, parent, p);
-	rb_insert_color(&bss->rbn, &dev->bss_tree);
+	rb_insert_color(&bss->rbn, &rdev->bss_tree);
 }
 
 static struct cfg80211_internal_bss *
-rb_find_bss(struct cfg80211_registered_device *dev,
+rb_find_bss(struct cfg80211_registered_device *rdev,
 	    struct cfg80211_internal_bss *res,
 	    enum bss_compare_mode mode)
 {
-	struct rb_node *n = dev->bss_tree.rb_node;
+	struct rb_node *n = rdev->bss_tree.rb_node;
 	struct cfg80211_internal_bss *bss;
 	int r;
 
@@ -612,7 +612,7 @@ rb_find_bss(struct cfg80211_registered_device *dev,
 	return NULL;
 }
 
-static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
+static bool cfg80211_combine_bsses(struct cfg80211_registered_device *rdev,
 				   struct cfg80211_internal_bss *new)
 {
 	const struct cfg80211_bss_ies *ies;
@@ -642,7 +642,7 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 
 	/* This is the bad part ... */
 
-	list_for_each_entry(bss, &dev->bss_list, list) {
+	list_for_each_entry(bss, &rdev->bss_list, list) {
 		if (!ether_addr_equal(bss->pub.bssid, new->pub.bssid))
 			continue;
 		if (bss->pub.channel != new->pub.channel)
@@ -676,7 +676,7 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_internal_bss *
-cfg80211_bss_update(struct cfg80211_registered_device *dev,
+cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		    struct cfg80211_internal_bss *tmp,
 		    bool signal_valid)
 {
@@ -687,14 +687,14 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 
 	tmp->ts = jiffies;
 
-	spin_lock_bh(&dev->bss_lock);
+	spin_lock_bh(&rdev->bss_lock);
 
 	if (WARN_ON(!rcu_access_pointer(tmp->pub.ies))) {
-		spin_unlock_bh(&dev->bss_lock);
+		spin_unlock_bh(&rdev->bss_lock);
 		return NULL;
 	}
 
-	found = rb_find_bss(dev, tmp, BSS_CMP_REGULAR);
+	found = rb_find_bss(rdev, tmp, BSS_CMP_REGULAR);
 
 	if (found) {
 		/* Update IEs */
@@ -781,7 +781,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		 * is allocated on the stack since it's not needed in the
 		 * more common case of an update
 		 */
-		new = kzalloc(sizeof(*new) + dev->wiphy.bss_priv_size,
+		new = kzalloc(sizeof(*new) + rdev->wiphy.bss_priv_size,
 			      GFP_ATOMIC);
 		if (!new) {
 			ies = (void *)rcu_dereference(tmp->pub.beacon_ies);
@@ -797,9 +797,9 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		INIT_LIST_HEAD(&new->hidden_list);
 
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
-			hidden = rb_find_bss(dev, tmp, BSS_CMP_HIDE_ZLEN);
+			hidden = rb_find_bss(rdev, tmp, BSS_CMP_HIDE_ZLEN);
 			if (!hidden)
-				hidden = rb_find_bss(dev, tmp,
+				hidden = rb_find_bss(rdev, tmp,
 						     BSS_CMP_HIDE_NUL);
 			if (hidden) {
 				new->pub.hidden_beacon_bss = &hidden->pub;
@@ -816,24 +816,24 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 			 * expensive search for any probe responses that should
 			 * be grouped with this beacon for updates ...
 			 */
-			if (!cfg80211_combine_bsses(dev, new)) {
+			if (!cfg80211_combine_bsses(rdev, new)) {
 				kfree(new);
 				goto drop;
 			}
 		}
 
-		list_add_tail(&new->list, &dev->bss_list);
-		rb_insert_bss(dev, new);
+		list_add_tail(&new->list, &rdev->bss_list);
+		rb_insert_bss(rdev, new);
 		found = new;
 	}
 
-	dev->bss_generation++;
-	bss_ref_get(dev, found);
-	spin_unlock_bh(&dev->bss_lock);
+	rdev->bss_generation++;
+	bss_ref_get(rdev, found);
+	spin_unlock_bh(&rdev->bss_lock);
 
 	return found;
  drop:
-	spin_unlock_bh(&dev->bss_lock);
+	spin_unlock_bh(&rdev->bss_lock);
 	return NULL;
 }
 
@@ -1005,7 +1005,7 @@ EXPORT_SYMBOL(cfg80211_inform_bss_width_frame);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
-	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (!pub)
@@ -1013,15 +1013,15 @@ void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
-	spin_lock_bh(&dev->bss_lock);
-	bss_ref_get(dev, bss);
-	spin_unlock_bh(&dev->bss_lock);
+	spin_lock_bh(&rdev->bss_lock);
+	bss_ref_get(rdev, bss);
+	spin_unlock_bh(&rdev->bss_lock);
 }
 EXPORT_SYMBOL(cfg80211_ref_bss);
 
 void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
-	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (!pub)
@@ -1029,15 +1029,15 @@ void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
-	spin_lock_bh(&dev->bss_lock);
-	bss_ref_put(dev, bss);
-	spin_unlock_bh(&dev->bss_lock);
+	spin_lock_bh(&rdev->bss_lock);
+	bss_ref_put(rdev, bss);
+	spin_unlock_bh(&rdev->bss_lock);
 }
 EXPORT_SYMBOL(cfg80211_put_bss);
 
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
-	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (WARN_ON(!pub))
@@ -1045,12 +1045,12 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
-	spin_lock_bh(&dev->bss_lock);
+	spin_lock_bh(&rdev->bss_lock);
 	if (!list_empty(&bss->list)) {
-		if (__cfg80211_unlink_bss(dev, bss))
-			dev->bss_generation++;
+		if (__cfg80211_unlink_bss(rdev, bss))
+			rdev->bss_generation++;
 	}
-	spin_unlock_bh(&dev->bss_lock);
+	spin_unlock_bh(&rdev->bss_lock);
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
@@ -1459,7 +1459,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 }
 
 
-static int ieee80211_scan_results(struct cfg80211_registered_device *dev,
+static int ieee80211_scan_results(struct cfg80211_registered_device *rdev,
 				  struct iw_request_info *info,
 				  char *buf, size_t len)
 {
@@ -1467,18 +1467,18 @@ static int ieee80211_scan_results(struct cfg80211_registered_device *dev,
 	char *end_buf = buf + len;
 	struct cfg80211_internal_bss *bss;
 
-	spin_lock_bh(&dev->bss_lock);
-	cfg80211_bss_expire(dev);
+	spin_lock_bh(&rdev->bss_lock);
+	cfg80211_bss_expire(rdev);
 
-	list_for_each_entry(bss, &dev->bss_list, list) {
+	list_for_each_entry(bss, &rdev->bss_list, list) {
 		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
-			spin_unlock_bh(&dev->bss_lock);
+			spin_unlock_bh(&rdev->bss_lock);
 			return -E2BIG;
 		}
-		current_ev = ieee80211_bss(&dev->wiphy, info, bss,
+		current_ev = ieee80211_bss(&rdev->wiphy, info, bss,
 					   current_ev, end_buf);
 	}
-	spin_unlock_bh(&dev->bss_lock);
+	spin_unlock_bh(&rdev->bss_lock);
 	return current_ev - buf;
 }
 
-- 
1.9.0

