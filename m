Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43406 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1AFI3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 03:29:17 -0500
Received: by iyi12 with SMTP id 12so14668195iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 00:29:17 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19749.32067.311517.479374@gargle.gargle.HOWL>
Date: Thu, 6 Jan 2011 13:58:51 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC v2] cfg80211: Add HT BSS attributes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Add two new per-BSS attributes to allow configuration of
HT capabilites and operational parameters by hostapd.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
v2: Initialize values and set the parameters in managed mode also.

 include/linux/nl80211.h     |    6 ++++++
 include/net/cfg80211.h      |    6 ++++++
 include/net/mac80211.h      |    4 ++++
 net/mac80211/cfg.c          |   15 +++++++++++++++
 net/mac80211/driver-trace.h |    4 ++++
 net/mac80211/ieee80211_i.h  |    9 ++++++---
 net/mac80211/mlme.c         |   10 +++++++---
 net/wireless/nl80211.c      |    8 ++++++++
 8 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2b89b71..94c7dde 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -881,6 +881,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_MESH_SETUP: Optional mesh setup parameters.  These cannot be
  * changed once the mesh is active.
  *
+ * @NL80211_ATTR_BSS_HT_CAPAB: HT Capabilities for a BSS.
+ * @NL80211_ATTR_BSS_HT_PARAM: Current operational HT parameters.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1068,6 +1071,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 
+	NL80211_ATTR_BSS_HT_CAPAB,
+	NL80211_ATTR_BSS_HT_PARAM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bcc9f44..67a2351 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -607,6 +607,10 @@ struct mpath_info {
  * @ap_isolate: do not forward packets between connected stations
  * @ht_opmode: HT Operation mode
  * 	(u16 = opmode, -1 = do not change)
+ * @ht_capab: HT capabilities
+ *	(u16 = capabilties, -1 = do not change)
+ * @ht_param: HT Operating parameters
+ *	(u8 = parameters, -1 = do not change)
  */
 struct bss_parameters {
 	int use_cts_prot;
@@ -616,6 +620,8 @@ struct bss_parameters {
 	u8 basic_rates_len;
 	int ap_isolate;
 	int ht_opmode;
+	int ht_capab;
+	int ht_param;
 };
 
 /*
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b3fd5a..a7efd18 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -227,6 +227,8 @@ enum ieee80211_bss_change {
  *	example.
  * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
  *	This field is only valid when the channel type is one of the HT types.
+ * @ht_capab: HT capabilities (as in &struct ieee80211_ht_cap).
+ * @ht_param: Operational HT parameters (as in &struct ieee80211_ht_info).
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
  *	implies disabled
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
@@ -261,6 +263,8 @@ struct ieee80211_bss_conf {
 	u32 basic_rates;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
+	u16 ht_capab;
+	u8 ht_param;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
 	enum nl80211_channel_type channel_type;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4bc8a92..f10c92b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1172,6 +1172,21 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_HT;
 	}
 
+	if (params->ht_capab >= 0) {
+		struct ieee80211_local *local = wiphy_priv(wiphy);
+		struct ieee80211_supported_band *sband =
+			wiphy->bands[local->oper_channel->band];
+
+		sdata->vif.bss_conf.ht_capab =
+			(u16) (params->ht_capab & sband->ht_cap.cap);
+		changed |= BSS_CHANGED_HT;
+	}
+
+	if (params->ht_param >= 0) {
+		sdata->vif.bss_conf.ht_param = (u8) params->ht_param;
+		changed |= BSS_CHANGED_HT;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 49c8421..1b34cb7 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -255,6 +255,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u32, changed)
 		__field(bool, enable_beacon)
 		__field(u16, ht_operation_mode)
+		__field(u16, ht_capab)
+		__field(u8, ht_param)
 	),
 
 	TP_fast_assign(
@@ -273,6 +275,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->basic_rates = info->basic_rates;
 		__entry->enable_beacon = info->enable_beacon;
 		__entry->ht_operation_mode = info->ht_operation_mode;
+		__entry->ht_capab = info->ht_capab;
+		__entry->ht_param = info->ht_param;
 	),
 
 	TP_printk(
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..228f569 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -549,10 +549,13 @@ struct ieee80211_sub_if_data {
 	char name[IFNAMSIZ];
 
 	/*
-	 * keep track of whether the HT opmode (stored in
-	 * vif.bss_info.ht_operation_mode) is valid.
+	 * Keeps track of the validity of HT information, namely,
+	 *
+	 * vif.bss_info.ht_operation_mode,
+	 * vif.bss_info.ht_capab,
+	 * vif.bss_info.ht_param
 	 */
-	bool ht_opmode_valid;
+	bool ht_state_valid;
 
 	/* to detect idle changes */
 	bool old_idle;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45fbb9e..66cde6a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -225,12 +225,16 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
-	if (sdata->ht_opmode_valid != enable_ht ||
+	if (sdata->ht_state_valid != enable_ht ||
 	    sdata->vif.bss_conf.ht_operation_mode != ht_opmode ||
+	    sdata->vif.bss_conf.ht_capab != ap_ht_cap_flags ||
+	    sdata->vif.bss_conf.ht_param != hti->ht_param ||
 	    prev_chantype != channel_type) {
 		changed |= BSS_CHANGED_HT;
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
-		sdata->ht_opmode_valid = enable_ht;
+		sdata->vif.bss_conf.ht_capab = ap_ht_cap_flags;
+		sdata->vif.bss_conf.ht_param = hti->ht_param;
+		sdata->ht_state_valid = enable_ht;
 	}
 
 	return changed;
@@ -986,7 +990,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
 
 	/* on the next assoc, re-program HT parameters */
-	sdata->ht_opmode_valid = false;
+	sdata->ht_state_valid = false;
 
 	local->power_constr_level = 0;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9b62710..125612c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2576,6 +2576,8 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	params.use_short_slot_time = -1;
 	params.ap_isolate = -1;
 	params.ht_opmode = -1;
+	params.ht_capab = -1;
+	params.ht_param = -1;
 
 	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
 		params.use_cts_prot =
@@ -2597,6 +2599,12 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_BSS_HT_OPMODE])
 		params.ht_opmode =
 			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_OPMODE]);
+	if (info->attrs[NL80211_ATTR_BSS_HT_CAPAB])
+		params.ht_capab =
+			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_CAPAB]);
+	if (info->attrs[NL80211_ATTR_BSS_HT_PARAM])
+		params.ht_param =
+			nla_get_u8(info->attrs[NL80211_ATTR_BSS_HT_PARAM]);
 
 	if (!rdev->ops->change_bss)
 		return -EOPNOTSUPP;
-- 
1.7.3.4

