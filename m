Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36827 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbcCFRPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 12:15:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id l68so6967167wml.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 09:15:41 -0800 (PST)
Received: from localhost.localdomain (93-172-245-144.bb.netvision.net.il. [93.172.245.144])
        by smtp.gmail.com with ESMTPSA id 202sm9575459wmo.7.2016.03.06.09.15.39
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 06 Mar 2016 09:15:40 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wlcore: don't WARN_ON in case of existing ROC
Date: Sun,  6 Mar 2016 19:15:33 +0200
Message-Id: <1457284534-10789-1-git-send-email-eliad@wizery.com> (sfid-20160306_181549_816662_9A897124)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When working with AP + P2P, it's possible to get into
a state when the AP is in ROC (due to assiciating station)
while trying to ROC on the P2P interface.

Replace the WARN_ON with wl1271_error to avoid warnings
in this case.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d1109c4..cb2e8b6 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5506,9 +5506,10 @@ static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
 		goto out;
 
 	/* return EBUSY if we can't ROC right now */
-	if (WARN_ON(wl->roc_vif ||
-		    find_first_bit(wl->roc_map,
-				   WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES)) {
+	if (wl->roc_vif ||
+	    find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES) {
+		wl1271_warning("active roc on role %d",
+			       find_first_bit(wl->roc_map, WL12XX_MAX_ROLES));
 		ret = -EBUSY;
 		goto out;
 	}
-- 
2.6.3

