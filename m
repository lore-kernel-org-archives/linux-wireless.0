Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58791 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900AbZKZJCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:02:46 -0500
Subject: [PATCH 2/3] wl1251: fix bssid handling
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 10:56:06 +0200
Message-ID: <20091126085606.1564.29814.stgit@tikku>
In-Reply-To: <20091126085256.1564.77644.stgit@tikku>
References: <20091126085256.1564.77644.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

bssid needs to be copied first in wl1251_op_bss_info_changed(), otherwise
templates will have incorrect bssid and power save will not work
correctly.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   30 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 8353139..50d17fc 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1110,6 +1110,21 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if (changed & BSS_CHANGED_BSSID) {
+		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+
+		ret = wl1251_build_null_data(wl);
+		if (ret < 0)
+			goto out;
+
+		if (wl->bss_type != BSS_TYPE_IBSS) {
+			ret = wl1251_join(wl, wl->bss_type, wl->channel,
+					  wl->beacon_int, wl->dtim_period);
+			if (ret < 0)
+				goto out_sleep;
+		}
+	}
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->beacon_int = bss_conf->beacon_int;
@@ -1169,21 +1184,6 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (changed & BSS_CHANGED_BSSID) {
-		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
-
-		ret = wl1251_build_null_data(wl);
-		if (ret < 0)
-			goto out;
-
-		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl1251_join(wl, wl->bss_type, wl->channel,
-					  wl->beacon_int, wl->dtim_period);
-			if (ret < 0)
-				goto out_sleep;
-		}
-	}
-
 	if (changed & BSS_CHANGED_BEACON) {
 		beacon = ieee80211_beacon_get(hw, vif);
 		ret = wl1251_cmd_template_set(wl, CMD_BEACON, beacon->data,

