Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:44351 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753299AbdF2PmF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 11:42:05 -0400
From: Joe Perches <joe@perches.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Neaten refresh_scan - remove always 1 argument
Date: Thu, 29 Jun 2017 08:42:00 -0700
Message-Id: <322381310d985c391c32d1919144b098ebb1b6d0.1498750174.git.joe@perches.com> (sfid-20170629_174210_470714_B1DDC211)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All uses of refresh_scan() have a constant 1 as the second argument.
Remove it and neaten the function declaration.

Miscellanea:

o Remove overly deep indentation by using continue;
o Remove unnecessary test of the address of a static array as it's
  always non-zero
o Rename and use proper type for the first void * argument as it's
  always the struct wilc_priv *
o Move variables into loop where used

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 65 ++++++++++-------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 68fd5b3b8b2d..ac5aaafa461c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -214,48 +214,39 @@ static u32 get_rssi_avg(struct network_info *network_info)
 	return rssi_v;
 }
 
-static void refresh_scan(void *user_void, u8 all, bool direct_scan)
+static void refresh_scan(struct wilc_priv *priv, bool direct_scan)
 {
-	struct wilc_priv *priv;
-	struct wiphy *wiphy;
-	struct cfg80211_bss *bss = NULL;
+	struct wiphy *wiphy = priv->dev->ieee80211_ptr->wiphy;
 	int i;
-	int rssi = 0;
-
-	priv = user_void;
-	wiphy = priv->dev->ieee80211_ptr->wiphy;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
 		struct network_info *network_info;
+		s32 freq;
+		struct ieee80211_channel *channel;
+		int rssi;
+		struct cfg80211_bss *bss;
 
 		network_info = &last_scanned_shadow[i];
 
-		if (!network_info->found || all) {
-			s32 freq;
-			struct ieee80211_channel *channel;
-
-			if (network_info) {
-				freq = ieee80211_channel_to_frequency((s32)network_info->ch, NL80211_BAND_2GHZ);
-				channel = ieee80211_get_channel(wiphy, freq);
-
-				rssi = get_rssi_avg(network_info);
-				if (memcmp("DIRECT-", network_info->ssid, 7) ||
-				    direct_scan) {
-					bss = cfg80211_inform_bss(wiphy,
-								  channel,
-								  CFG80211_BSS_FTYPE_UNKNOWN,
-								  network_info->bssid,
-								  network_info->tsf_hi,
-								  network_info->cap_info,
-								  network_info->beacon_period,
-								  (const u8 *)network_info->ies,
-								  (size_t)network_info->ies_len,
-								  (s32)rssi * 100,
-								  GFP_KERNEL);
-					cfg80211_put_bss(wiphy, bss);
-				}
-			}
-		}
+		if (!memcmp("DIRECT-", network_info->ssid, 7) && !direct_scan)
+			continue;
+
+		freq = ieee80211_channel_to_frequency((s32)network_info->ch,
+						      NL80211_BAND_2GHZ);
+		channel = ieee80211_get_channel(wiphy, freq);
+		rssi = get_rssi_avg(network_info);
+		bss = cfg80211_inform_bss(wiphy,
+					  channel,
+					  CFG80211_BSS_FTYPE_UNKNOWN,
+					  network_info->bssid,
+					  network_info->tsf_hi,
+					  network_info->cap_info,
+					  network_info->beacon_period,
+					  (const u8 *)network_info->ies,
+					  (size_t)network_info->ies_len,
+					  (s32)rssi * 100,
+					  GFP_KERNEL);
+		cfg80211_put_bss(wiphy, bss);
 	}
 }
 
@@ -442,7 +433,7 @@ static void CfgScanResult(enum scan_event scan_event,
 				}
 			}
 		} else if (scan_event == SCAN_EVENT_DONE) {
-			refresh_scan(priv, 1, false);
+			refresh_scan(priv, false);
 
 			mutex_lock(&priv->scan_req_lock);
 
@@ -466,7 +457,7 @@ static void CfgScanResult(enum scan_event scan_event,
 				};
 
 				update_scan_time();
-				refresh_scan(priv, 1, false);
+				refresh_scan(priv, false);
 
 				cfg80211_scan_done(priv->pstrScanReq, &info);
 				priv->bCfgScanning = false;
@@ -540,7 +531,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			}
 
 			if (bNeedScanRefresh)
-				refresh_scan(priv, 1, true);
+				refresh_scan(priv, true);
 		}
 
 		cfg80211_connect_result(dev, pstrConnectInfo->bssid,
-- 
2.10.0.rc2.1.g053435c
