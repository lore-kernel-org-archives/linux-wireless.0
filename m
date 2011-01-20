Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63714 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1ATUcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:32:06 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1007506fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 12:32:06 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/3] mac80211: add SSID for AP mode with change notification
Date: Thu, 20 Jan 2011 22:28:25 +0200
Message-Id: <1295555306-20005-2-git-send-email-arik@wizery.com>
In-Reply-To: <1295555306-20005-1-git-send-email-arik@wizery.com>
References: <1295555306-20005-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating as AP, save SSID data as part of the ieee80211_bss_conf
struct. Allow low level drivers to receive notifications about SSID
changes.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |    6 ++++++
 net/mac80211/cfg.c     |    7 +++++++
 net/mac80211/util.c    |    7 ++++++-
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 62c0ce2..ff3bad1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -164,6 +164,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_QOS: QoS for this association was enabled/disabled. Note
  *	that it is only ever disabled for station mode.
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
+ * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -181,6 +182,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_ARP_FILTER		= 1<<12,
 	BSS_CHANGED_QOS			= 1<<13,
 	BSS_CHANGED_IDLE		= 1<<14,
+	BSS_CHANGED_SSID		= 1<<15,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -243,6 +245,8 @@ enum ieee80211_bss_change {
  * @idle: This interface is idle. There's also a global idle flag in the
  *	hardware config which may be more appropriate depending on what
  *	your driver/device needs to do.
+ * @ssid_len: Length of @ssid in octets (in AP mode)
+ * @ssid: SSID for this BSS (in AP mode)
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -269,6 +273,8 @@ struct ieee80211_bss_conf {
 	bool arp_filter_enabled;
 	bool qos;
 	bool idle;
+	u8 ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4bc8a92..a2a75e9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1172,6 +1172,13 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_HT;
 	}
 
+	if (params->ssid_len > 0) {
+		memcpy(sdata->vif.bss_conf.ssid, params->ssid,
+		       params->ssid_len);
+		sdata->vif.bss_conf.ssid_len = params->ssid_len;
+		changed |= BSS_CHANGED_SSID;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cf68700..a2d2f73 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1212,10 +1212,15 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			changed |= BSS_CHANGED_ASSOC;
 			ieee80211_bss_info_change_notify(sdata, changed);
 			break;
+		case NL80211_IFTYPE_AP:
+			changed |= BSS_CHANGED_SSID |
+				   BSS_CHANGED_BEACON |
+				   BSS_CHANGED_BEACON_ENABLED;
+			ieee80211_bss_info_change_notify(sdata, changed);
+			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
-		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
 			changed |= BSS_CHANGED_BEACON |
 				   BSS_CHANGED_BEACON_ENABLED;
-- 
1.7.1

