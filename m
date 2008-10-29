Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45160 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbYJ2Rxm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 13:53:42 -0400
Message-Id: <20081029175238.066813010@localhost> (sfid-20081029_185344_333111_64EEB953)
References: <20081029174934.817700763@localhost>
Date: Wed, 29 Oct 2008 19:49:36 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] nl80211: Add basic rate configuration for AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new attribute, NL80211_ATTR_BSS_BASIC_RATES, that can be used with
NL80211_CMD_SET_BSS for userspace (e.g., hostapd) to set which rates are
in the basic rate set.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h
+++ wireless-testing/include/linux/nl80211.h
@@ -243,6 +243,9 @@ enum nl80211_commands {
  *	(u8, 0 or 1)
  * @NL80211_ATTR_BSS_SHORT_SLOT_TIME: whether short slot time enabled
  *	(u8, 0 or 1)
+ * @NL80211_ATTR_BSS_BASIC_RATES: basic rates, array of basic
+ *	rates in format defined by IEEE 802.11 7.3.2.2 but without the length
+ *	restriction (at most %NL80211_MAX_SUPP_RATES).
  *
  * @NL80211_ATTR_HT_CAPABILITY: HT Capability information element (from
  *	association request when used with NL80211_CMD_NEW_STATION)
@@ -307,6 +310,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MESH_PARAMS,
 
+	NL80211_ATTR_BSS_BASIC_RATES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -318,6 +323,7 @@ enum nl80211_attrs {
  * here
  */
 #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
+#define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h
+++ wireless-testing/include/net/cfg80211.h
@@ -280,11 +280,16 @@ struct mpath_info {
  *	(0 = no, 1 = yes, -1 = do not change)
  * @use_short_slot_time: Whether the use of short slot time is allowed
  *	(0 = no, 1 = yes, -1 = do not change)
+ * @basic_rates: basic rates in IEEE 802.11 format
+ *	(or NULL for no change)
+ * @basic_rates_len: number of basic rates
  */
 struct bss_parameters {
 	int use_cts_prot;
 	int use_short_preamble;
 	int use_short_slot_time;
+	u8 *basic_rates;
+	u8 basic_rates_len;
 };
 
 /**
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c
+++ wireless-testing/net/mac80211/cfg.c
@@ -1046,6 +1046,24 @@ static int ieee80211_change_bss(struct w
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
 
+	if (params->basic_rates) {
+		int i, j;
+		u32 rates = 0;
+		struct ieee80211_local *local = wiphy_priv(wiphy);
+		struct ieee80211_supported_band *sband =
+			wiphy->bands[local->oper_channel->band];
+
+		for (i = 0; i < params->basic_rates_len; i++) {
+			int rate = (params->basic_rates[i] & 0x7f) * 5;
+			for (j = 0; j < sband->n_bitrates; j++) {
+				if (sband->bitrates[j].bitrate == rate)
+					rates |= BIT(j);
+			}
+		}
+		sdata->vif.bss_conf.basic_rates = rates;
+		changed |= BSS_CHANGED_BASIC_RATES;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c
+++ wireless-testing/net/wireless/nl80211.c
@@ -95,6 +95,8 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_BSS_CTS_PROT] = { .type = NLA_U8 },
 	[NL80211_ATTR_BSS_SHORT_PREAMBLE] = { .type = NLA_U8 },
 	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] = { .type = NLA_U8 },
+	[NL80211_ATTR_BSS_BASIC_RATES] = { .type = NLA_BINARY,
+					   .len = NL80211_MAX_SUPP_RATES },
 
 	[NL80211_ATTR_MESH_PARAMS] = { .type = NLA_NESTED },
 
@@ -1613,6 +1615,12 @@ static int nl80211_set_bss(struct sk_buf
 	if (info->attrs[NL80211_ATTR_BSS_SHORT_SLOT_TIME])
 		params.use_short_slot_time =
 		    nla_get_u8(info->attrs[NL80211_ATTR_BSS_SHORT_SLOT_TIME]);
+	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
+		params.basic_rates =
+			nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+		params.basic_rates_len =
+			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+	}
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)

--

-- 
Jouni Malinen                                            PGP id EFC895FA
