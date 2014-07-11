Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58263 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaGKACV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:21 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so291243wgh.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:20 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/14] wlcore: increase max roc duration to 30 seconds
Date: Fri, 11 Jul 2014 03:01:34 +0300
Message-Id: <1405036899-27396-10-git-send-email-eliad@wizery.com> (sfid-20140711_020224_730114_09C98606)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we don't have any actual limitation in the driver, so
increase it arbitrarily to 30 seconds.

The long ROC is needed for the smart config.flow.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 4c16262..01b4d9e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5806,7 +5806,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 		sizeof(struct ieee80211_header);
 
-	wl->hw->wiphy->max_remain_on_channel_duration = 5000;
+	wl->hw->wiphy->max_remain_on_channel_duration = 30000;
 
 	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD |
 				WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-- 
1.8.5.1.109.g3d252a9

