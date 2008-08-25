Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:51583 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbYHYI7q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 04:59:46 -0400
Date: Mon, 25 Aug 2008 11:58:58 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211/cfg80211: HT capabilities for NEW_STA
Message-ID: <20080825085858.GB9415@jm.kir.nu> (sfid-20080825_105949_841886_824F5401)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow userspace (e.g., hostapd) to set HT capabilities for associated
STAs. This is based on a patch from Zhu Yi <yi.zhu@intel.com> (only
the NL80211_ATTR_HT_CAPABILITY for NEW_STA part is included here).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h
+++ wireless-testing/include/linux/nl80211.h
@@ -207,6 +207,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_BSS_SHORT_SLOT_TIME: whether short slot time enabled
  *	(u8, 0 or 1)
  *
+ * @NL80211_ATTR_HT_CAPABILITY: HT Capability information element (from
+ *	association request when used with NL80211_CMD_NEW_STATION)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -254,16 +257,25 @@ enum nl80211_attrs {
 	NL80211_ATTR_BSS_SHORT_PREAMBLE,
 	NL80211_ATTR_BSS_SHORT_SLOT_TIME,
 
+	NL80211_ATTR_HT_CAPABILITY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
+/*
+ * Allow user space programs to use #ifdef on new attributes by defining them
+ * here
+ */
+#define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
+
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
 #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
+#define NL80211_HT_CAPABILITY_LEN		26
 
 /**
  * enum nl80211_iftype - (virtual) interface types
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h
+++ wireless-testing/include/net/cfg80211.h
@@ -152,6 +152,7 @@ struct station_parameters {
 	u16 aid;
 	u8 supported_rates_len;
 	u8 plink_action;
+	struct ieee80211_ht_cap *ht_capa;
 };
 
 /**
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c
+++ wireless-testing/net/mac80211/cfg.c
@@ -674,6 +674,11 @@ static void sta_apply_parameters(struct 
 		sta->supp_rates[local->oper_channel->band] = rates;
 	}
 
+	if (params->ht_capa) {
+		ieee80211_ht_cap_ie_to_ht_info(params->ht_capa,
+					       &sta->ht_info);
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->plink_action) {
 		switch (params->plink_action) {
 		case PLINK_ACTION_OPEN:
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c
+++ wireless-testing/net/wireless/nl80211.c
@@ -91,6 +91,9 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_BSS_CTS_PROT] = { .type = NLA_U8 },
 	[NL80211_ATTR_BSS_SHORT_PREAMBLE] = { .type = NLA_U8 },
 	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] = { .type = NLA_U8 },
+
+	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
+					 .len = NL80211_HT_CAPABILITY_LEN },
 };
 
 /* message building helper */
@@ -1129,6 +1132,10 @@ static int nl80211_set_station(struct sk
 		params.listen_interval =
 		    nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
+		params.ht_capa =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
+
 	if (parse_station_flags(info->attrs[NL80211_ATTR_STA_FLAGS],
 				&params.station_flags))
 		return -EINVAL;
@@ -1192,6 +1199,9 @@ static int nl80211_new_station(struct sk
 	params.listen_interval =
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
+		params.ht_capa =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
 	if (parse_station_flags(info->attrs[NL80211_ATTR_STA_FLAGS],
 				&params.station_flags))

-- 
Jouni Malinen                                            PGP id EFC895FA
