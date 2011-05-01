Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41446 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1EAG4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 02:56:34 -0400
Received: by wwk4 with SMTP id 4so1538955wwk.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 23:56:33 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: simplify wl1271_ssid_set()
Date: Sun,  1 May 2011 09:56:45 +0300
Message-Id: <1304233005-20249-1-git-send-email-eliad@wizery.com> (sfid-20110501_085650_423341_C2DBC09E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify wl1271_ssid_set by re-using cfg80211_find_ie instead of
reimplementing it.

Additionally, add a length check to prevent a potential buffer overflow.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dad81f6..745380a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2347,20 +2347,24 @@ out:
 static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 			    int offset)
 {
-	u8 *ptr = skb->data + offset;
+	u8 ssid_len;
+	const u8 *ptr = cfg80211_find_ie(WLAN_EID_SSID, skb->data + offset,
+					 skb->len - offset);
 
-	/* find the location of the ssid in the beacon */
-	while (ptr < skb->data + skb->len) {
-		if (ptr[0] == WLAN_EID_SSID) {
-			wl->ssid_len = ptr[1];
-			memcpy(wl->ssid, ptr+2, wl->ssid_len);
-			return 0;
-		}
-		ptr += (ptr[1] + 2);
+	if (!ptr) {
+		wl1271_error("No SSID in IEs!");
+		return -ENOENT;
 	}
 
-	wl1271_error("No SSID in IEs!\n");
-	return -ENOENT;
+	ssid_len = ptr[1];
+	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
+		wl1271_error("SSID is too long!");
+		return -EINVAL;
+	}
+
+	wl->ssid_len = ssid_len;
+	memcpy(wl->ssid, ptr+2, ssid_len);
+	return 0;
 }
 
 static int wl1271_bss_erp_info_changed(struct wl1271 *wl,
-- 
1.7.0.4

