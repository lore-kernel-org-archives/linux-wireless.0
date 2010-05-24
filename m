Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:26046 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0EXITE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:19:04 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 6/6] wl1271: Fix scan parameter handling for 5GHz
Date: Mon, 24 May 2010 11:18:20 +0300
Message-Id: <1274689100-14785-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The 5GHz bands were scanned without the proper IE's in place, preventing
proper 5GHz scanning. This patches fixes the problem by storing a pointer
to the scan request (with the IE's) for all iterations of scan.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |    1 +
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |    8 +++++---
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_event.c |   10 +++++-----
 drivers/net/wireless/wl12xx/wl1271_main.c  |   10 ++++------
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index dd2dafc..0fa0501 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -325,6 +325,7 @@ struct wl1271_rx_mem_pool_addr {
 };
 
 struct wl1271_scan {
+	struct cfg80211_scan_request *req;
 	u8 state;
 	u8 ssid[IW_ESSID_MAX_SIZE+1];
 	size_t ssid_len;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index d477929..4ac9a94 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -561,7 +561,7 @@ out:
 }
 
 int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
-		    const u8 *ie, size_t ie_len, u8 active_scan,
+		    struct cfg80211_scan_request *req, u8 active_scan,
 		    u8 high_prio, u8 band, u8 probe_requests)
 {
 
@@ -642,7 +642,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	}
 
 	ret = wl1271_cmd_build_probe_req(wl, ssid, ssid_len,
-					 ie, ie_len, ieee_band);
+					 req->ie, req->ie_len, ieee_band);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
@@ -678,7 +678,9 @@ int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 				memcpy(wl->scan.ssid, ssid, ssid_len);
 			} else
 				wl->scan.ssid_len = 0;
-		}
+			wl->scan.req = req;
+		} else
+			wl->scan.req = NULL;
 	}
 
 	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params), 0);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index f2820b4..ed3d3a7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -42,7 +42,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
 int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
-		    const u8 *ie, size_t ie_len, u8 active_scan,
+		    struct cfg80211_scan_request *req, u8 active_scan,
 		    u8 high_prio, u8 band, u8 probe_requests);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len, int index, u32 rates);
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index cf37aa6..ca52cde 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -43,11 +43,11 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
 			/* FIXME: ie missing! */
 			wl1271_cmd_scan(wl, wl->scan.ssid, wl->scan.ssid_len,
-						NULL, 0,
-						wl->scan.active,
-						wl->scan.high_prio,
-						WL1271_SCAN_BAND_5_GHZ,
-						wl->scan.probe_requests);
+					wl->scan.req,
+					wl->scan.active,
+					wl->scan.high_prio,
+					WL1271_SCAN_BAND_5_GHZ,
+					wl->scan.probe_requests);
 		} else {
 			mutex_unlock(&wl->mutex);
 			ieee80211_scan_completed(wl->hw, false);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 50650e6..0e16a1f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1632,13 +1632,11 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 
 	if (wl1271_11a_enabled())
-		ret = wl1271_cmd_scan(hw->priv, ssid, len,
-				      req->ie, req->ie_len, 1, 0,
-				      WL1271_SCAN_BAND_DUAL, 3);
+		ret = wl1271_cmd_scan(hw->priv, ssid, len, req,
+				      1, 0, WL1271_SCAN_BAND_DUAL, 3);
 	else
-		ret = wl1271_cmd_scan(hw->priv, ssid, len,
-				      req->ie, req->ie_len, 1, 0,
-				      WL1271_SCAN_BAND_2_4_GHZ, 3);
+		ret = wl1271_cmd_scan(hw->priv, ssid, len, req,
+				      1, 0, WL1271_SCAN_BAND_2_4_GHZ, 3);
 
 	wl1271_ps_elp_sleep(wl);
 
-- 
1.6.3.3

