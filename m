Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0KRLc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:32:56 -0500
Received: by mail-fx0-f46.google.com with SMTP id 6so1460042fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:32:56 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/18] wl1271: AP mode - change filter config
Date: Thu, 18 Nov 2010 13:32:24 +0200
Message-Id: <1290079951-16793-12-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not configure a group address table in AP mode

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 30d7a77..ee866d2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1591,7 +1591,8 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	int ret;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 configure filter");
+	wl1271_debug(DEBUG_MAC80211, "mac80211 configure filter changed %x"
+		     " total %x", changed, *total);
 
 	mutex_lock(&wl->mutex);
 
@@ -1605,15 +1606,16 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-
-	if (*total & FIF_ALLMULTI)
-		ret = wl1271_acx_group_address_tbl(wl, false, NULL, 0);
-	else if (fp)
-		ret = wl1271_acx_group_address_tbl(wl, fp->enabled,
-						   fp->mc_list,
-						   fp->mc_list_length);
-	if (ret < 0)
-		goto out_sleep;
+	if (wl->bss_type != BSS_TYPE_AP_BSS) {
+		if (*total & FIF_ALLMULTI)
+			ret = wl1271_acx_group_address_tbl(wl, false, NULL, 0);
+		else if (fp)
+			ret = wl1271_acx_group_address_tbl(wl, fp->enabled,
+							   fp->mc_list,
+							   fp->mc_list_length);
+		if (ret < 0)
+			goto out_sleep;
+	}
 
 	/* determine, whether supported filter values have changed */
 	if (changed == 0)
-- 
1.7.1

