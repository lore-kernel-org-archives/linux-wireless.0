Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:34573
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab3JYWPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 18:15:46 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 1/2] cw1200: Make the "scan failed" message into a warning
Date: Fri, 25 Oct 2013 18:15:42 -0400
Message-Id: <1382739343-5727-1-git-send-email-pizza@shaftnet.org> (sfid-20131026_001549_297924_6DB0B563)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reason that a scan failed for some reason (typically bad
parameters) should be logged even when debugging is turned off.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/scan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/cw1200/scan.c b/drivers/net/wireless/cw1200/scan.c
index ee3c190..84755ab 100644
--- a/drivers/net/wireless/cw1200/scan.c
+++ b/drivers/net/wireless/cw1200/scan.c
@@ -173,8 +173,9 @@ void cw1200_scan_work(struct work_struct *work)
 			cw1200_set_pm(priv, &priv->powersave_mode);
 
 		if (priv->scan.status < 0)
-			wiphy_dbg(priv->hw->wiphy, "[SCAN] Scan failed (%d).\n",
-				  priv->scan.status);
+			wiphy_warn(priv->hw->wiphy,
+				   "[SCAN] Scan failed (%d).\n",
+				   priv->scan.status);
 		else if (priv->scan.req)
 			wiphy_dbg(priv->hw->wiphy,
 				  "[SCAN] Scan completed.\n");
-- 
1.8.3.1

