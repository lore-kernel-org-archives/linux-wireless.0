Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30807 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2DKJqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:46:40 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] mac80211: remove ieee80211_rx_bss_get
Date: Wed, 11 Apr 2012 15:16:12 +0530
Message-ID: <1334137572-7061-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120411_114644_588480_05E214AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

its not used where, while we directly obtain ieee80211_bss's
pointer in ibss.c by calling cfg80211_get_bss

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |    3 ---
 net/mac80211/scan.c        |   14 --------------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ea9623c..865597b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1269,9 +1269,6 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee802_11_elems *elems,
 			  struct ieee80211_channel *channel,
 			  bool beacon);
-struct ieee80211_bss *
-ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len);
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c70e176..d6086e4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -29,20 +29,6 @@
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
 
-struct ieee80211_bss *
-ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len)
-{
-	struct cfg80211_bss *cbss;
-
-	cbss = cfg80211_get_bss(local->hw.wiphy,
-				ieee80211_get_channel(local->hw.wiphy, freq),
-				bssid, ssid, ssid_len, 0, 0);
-	if (!cbss)
-		return NULL;
-	return (void *)cbss->priv;
-}
-
 static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
 {
 	struct ieee80211_bss *bss = (void *)cbss->priv;
-- 
1.7.0.4

