Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63072 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0LZI1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 03:27:40 -0500
Received: by wwa36 with SMTP id 36so8300613wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 00:27:38 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: don't join upon disassociation
Date: Sun, 26 Dec 2010 10:27:50 +0200
Message-Id: <1293352070-17513-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx "rejoins" upon every BSS_CHANGED_BSSID notification.
However, there is no need to rejoin after disassociation, so just
filter out the case when the new bssid is 00:00:00:00:00:00.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 062247e..7aa783c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1944,19 +1944,23 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
 			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 
-			ret = wl1271_cmd_build_null_data(wl);
-			if (ret < 0)
-				goto out_sleep;
+			if (!is_zero_ether_addr(wl->bssid)) {
+				ret = wl1271_cmd_build_null_data(wl);
+				if (ret < 0)
+					goto out_sleep;
 
-			ret = wl1271_build_qos_null_data(wl);
-			if (ret < 0)
-				goto out_sleep;
+				ret = wl1271_build_qos_null_data(wl);
+				if (ret < 0)
+					goto out_sleep;
 
-			/* filter out all packets not from this BSSID */
-			wl1271_configure_filters(wl, 0);
+				/* filter out all packets not from this BSSID */
+				wl1271_configure_filters(wl, 0);
 
-			/* Need to update the BSSID (for filtering etc) */
-			do_join = true;
+				/*
+				 * Need to update the BSSID (for filtering etc)
+				 */
+				do_join = true;
+			}
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-- 
1.7.0.4

