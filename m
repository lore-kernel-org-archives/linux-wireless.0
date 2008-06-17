Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56156 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYFQP7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 11:59:19 -0400
Message-Id: <20080617155824.032914723@localhost> (sfid-20080617_175922_521066_DF5C64C6)
References: <20080617154008.883383150@localhost>
Date: Tue, 17 Jun 2008 18:40:09 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 1/7] 802.11w: STA flag for MFP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add flags for setting STA entries and struct ieee80211_if_sta to
indicate whether management frame protection (MFP) is used.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h
+++ wireless-testing/net/mac80211/ieee80211_i.h
@@ -300,6 +300,7 @@ struct mesh_config {
 #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
+#define IEEE80211_STA_MFP_ENABLED	BIT(14)
 struct ieee80211_if_sta {
 	struct timer_list timer;
 	struct work_struct work;
Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c
+++ wireless-testing/net/mac80211/mlme.c
@@ -1,6 +1,6 @@
 /*
  * BSS client mode implementation
- * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright 2003-2008, Jouni Malinen <j@w1.fi>
  * Copyright 2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
@@ -885,7 +885,7 @@ static void ieee80211_send_deauth(struct
 	skb_put(skb, 2);
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(dev, skb, ifsta->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
 
@@ -914,7 +914,7 @@ static void ieee80211_send_disassoc(stru
 	skb_put(skb, 2);
 	mgmt->u.disassoc.reason_code = cpu_to_le16(reason);
 
-	ieee80211_sta_tx(dev, skb, 0);
+	ieee80211_sta_tx(dev, skb, ifsta->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
 
@@ -2107,6 +2107,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	rate_control_rate_init(sta, local);
 
+	if (ifsta->flags & IEEE80211_STA_MFP_ENABLED)
+		set_sta_flags(sta, WLAN_STA_MFP);
+
 	if (elems.wmm_param) {
 		set_sta_flags(sta, WLAN_STA_WME);
 		rcu_read_unlock();
Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h
+++ wireless-testing/include/linux/nl80211.h
@@ -286,12 +286,14 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_SHORT_PREAMBLE: station is capable of receiving frames
  *	with short barker preamble
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
+ * @NL80211_STA_FLAG_MFP: station uses management frame protection
  */
 enum nl80211_sta_flags {
 	__NL80211_STA_FLAG_INVALID,
 	NL80211_STA_FLAG_AUTHORIZED,
 	NL80211_STA_FLAG_SHORT_PREAMBLE,
 	NL80211_STA_FLAG_WME,
+	NL80211_STA_FLAG_MFP,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h
+++ wireless-testing/include/net/cfg80211.h
@@ -110,12 +110,14 @@ struct beacon_parameters {
  * @STATION_FLAG_SHORT_PREAMBLE: station is capable of receiving frames
  *	with short preambles
  * @STATION_FLAG_WME: station is WME/QoS capable
+ * @STATION_FLAG_MFP: station uses management frame protection
  */
 enum station_flags {
 	STATION_FLAG_CHANGED		= 1<<0,
 	STATION_FLAG_AUTHORIZED		= 1<<NL80211_STA_FLAG_AUTHORIZED,
 	STATION_FLAG_SHORT_PREAMBLE	= 1<<NL80211_STA_FLAG_SHORT_PREAMBLE,
 	STATION_FLAG_WME		= 1<<NL80211_STA_FLAG_WME,
+	STATION_FLAG_MFP		= 1<<NL80211_STA_FLAG_MFP,
 };
 
 /**
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c
+++ wireless-testing/net/mac80211/cfg.c
@@ -618,6 +618,10 @@ static void sta_apply_parameters(struct 
 		sta->flags &= ~WLAN_STA_WME;
 		if (params->station_flags & STATION_FLAG_WME)
 			sta->flags |= WLAN_STA_WME;
+
+		sta->flags &= ~WLAN_STA_MFP;
+		if (params->station_flags & STATION_FLAG_MFP)
+			sta->flags |= WLAN_STA_MFP;
 		spin_unlock_bh(&sta->lock);
 	}
 
Index: wireless-testing/net/mac80211/debugfs_sta.c
===================================================================
--- wireless-testing.orig/net/mac80211/debugfs_sta.c
+++ wireless-testing/net/mac80211/debugfs_sta.c
@@ -74,14 +74,15 @@ static ssize_t sta_flags_read(struct fil
 	char buf[100];
 	struct sta_info *sta = file->private_data;
 	u32 staflags = get_sta_flags(sta);
-	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s",
+	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s",
 		staflags & WLAN_STA_AUTH ? "AUTH\n" : "",
 		staflags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
 		staflags & WLAN_STA_PS ? "PS\n" : "",
 		staflags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
 		staflags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
 		staflags & WLAN_STA_WME ? "WME\n" : "",
-		staflags & WLAN_STA_WDS ? "WDS\n" : "");
+		staflags & WLAN_STA_WDS ? "WDS\n" : "",
+		staflags & WLAN_STA_MFP ? "MFP\n" : "");
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 STA_OPS(flags);
Index: wireless-testing/net/mac80211/sta_info.h
===================================================================
--- wireless-testing.orig/net/mac80211/sta_info.h
+++ wireless-testing/net/mac80211/sta_info.h
@@ -34,6 +34,7 @@
  * @WLAN_STA_CLEAR_PS_FILT: Clear PS filter in hardware (using the
  *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
  *	frame to this station is transmitted.
+ * @WLAN_STA_MFP: Management frame protection is used with this STA.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -46,6 +47,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_WDS		= 1<<7,
 	WLAN_STA_PSPOLL		= 1<<8,
 	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
+	WLAN_STA_MFP		= 1<<10,
 };
 
 #define STA_TID_NUM 16

--

-- 
Jouni Malinen                                            PGP id EFC895FA
