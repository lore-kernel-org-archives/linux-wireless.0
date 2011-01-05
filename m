Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1AEPsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 10:48:19 -0500
Received: by pzk35 with SMTP id 35so1669292pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 07:48:19 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19748.37551.23627.698571@gargle.gargle.HOWL>
Date: Wed, 5 Jan 2011 21:17:59 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] cfg80211: Add HT BSS attributes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Add two new per-BSS attributes to allow configuration of
HT capabilites and operational parameters by hostapd.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |    6 ++++++
 include/net/mac80211.h  |    4 ++++
 net/mac80211/cfg.c      |   15 +++++++++++++++
 net/wireless/nl80211.c  |    6 ++++++
 5 files changed, 37 insertions(+), 0 deletions(-)

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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9b62710..69b0051 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2597,6 +2597,12 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
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

