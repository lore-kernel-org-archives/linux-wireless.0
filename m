Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34005 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZAGL1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:27:47 -0500
Message-Id: <20090107112620.653060803@atheros.com> (sfid-20090107_122750_720517_CA2AE6B2)
References: <20090107112346.369581673@atheros.com>
Date: Wed, 07 Jan 2009 13:23:47 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 01/14] mac80211: 802.11w - STA flag for MFP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add flags for setting STA entries and struct ieee80211_if_sta to
indicate whether management frame protection (MFP) is used.

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 include/linux/nl80211.h    |    2 ++
 include/net/cfg80211.h     |    2 ++
 net/mac80211/cfg.c         |    4 ++++
 net/mac80211/debugfs_sta.c |    5 +++--
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    7 +++++--
 net/mac80211/sta_info.h    |    2 ++
 7 files changed, 19 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-07 13:07:38.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-01-07 13:07:41.000000000 +0200
@@ -1,6 +1,6 @@
 /*
  * BSS client mode implementation
- * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright 2003-2008, Jouni Malinen <j@w1.fi>
  * Copyright 2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
@@ -472,7 +472,7 @@ static void ieee80211_send_deauth_disass
 	/* u.deauth.reason_code == u.disassoc.reason_code */
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, ifsta->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
 /* MLME */
@@ -1420,6 +1420,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	rate_control_rate_init(sta);
 
+	if (ifsta->flags & IEEE80211_STA_MFP_ENABLED)
+		set_sta_flags(sta, WLAN_STA_MFP);
+
 	if (elems.wmm_param)
 		set_sta_flags(sta, WLAN_STA_WME);
 
--- wireless-testing.orig/include/linux/nl80211.h	2008-12-31 17:33:38.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-01-07 13:07:41.000000000 +0200
@@ -412,12 +412,14 @@ enum nl80211_iftype {
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
--- wireless-testing.orig/include/net/cfg80211.h	2008-12-31 17:33:38.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-01-07 13:07:41.000000000 +0200
@@ -112,12 +112,14 @@ struct beacon_parameters {
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
--- wireless-testing.orig/net/mac80211/cfg.c	2008-12-31 17:33:38.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-01-07 13:07:41.000000000 +0200
@@ -630,6 +630,10 @@ static void sta_apply_parameters(struct 
 		sta->flags &= ~WLAN_STA_WME;
 		if (params->station_flags & STATION_FLAG_WME)
 			sta->flags |= WLAN_STA_WME;
+
+		sta->flags &= ~WLAN_STA_MFP;
+		if (params->station_flags & STATION_FLAG_MFP)
+			sta->flags |= WLAN_STA_MFP;
 		spin_unlock_bh(&sta->lock);
 	}
 
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2008-12-31 17:33:38.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-01-07 13:07:41.000000000 +0200
@@ -67,14 +67,15 @@ static ssize_t sta_flags_read(struct fil
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
--- wireless-testing.orig/net/mac80211/sta_info.h	2008-12-31 17:33:39.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-01-07 13:07:41.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-07 13:07:38.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-07 13:07:41.000000000 +0200
@@ -260,6 +260,7 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
 #define IEEE80211_STA_TKIP_WEP_USED	BIT(14)
 #define IEEE80211_STA_CSA_RECEIVED	BIT(15)
+#define IEEE80211_STA_MFP_ENABLED	BIT(16)
 /* flags for MLME request */
 #define IEEE80211_STA_REQ_SCAN 0
 #define IEEE80211_STA_REQ_DIRECT_PROBE 1

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
