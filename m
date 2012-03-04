Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58910 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2CDI4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:56:01 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so2663813wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:56:00 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/11] wl12xx: don't allow scanning while device is in ROC
Date: Sun,  4 Mar 2012 10:55:52 +0200
Message-Id: <1330851355-24459-9-git-send-email-eliad@wizery.com> (sfid-20120304_095627_433294_83A43EBD)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

return EBUSY on scan when there is any role
in ROC (not necessarily the one we are going
to use)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85bbe7f..1d5f2d5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3057,8 +3057,6 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 			     struct cfg80211_scan_request *req)
 {
 	struct wl1271 *wl = hw->priv;
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-
 	int ret;
 	u8 *ssid = NULL;
 	size_t len = 0;
@@ -3086,8 +3084,8 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
-	    test_bit(wlvif->role_id, wl->roc_map)) {
+	/* fail if there is any role in ROC */
+	if (find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES) {
 		/* don't allow scanning right now */
 		ret = -EBUSY;
 		goto out_sleep;
-- 
1.7.6.401.g6a319

