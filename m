Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46524 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1HYQDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 12:03:22 -0400
Received: by wyg24 with SMTP id 24so1794291wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 09:03:21 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/5] wl12xx: check for ROC on scan_complete
Date: Thu, 25 Aug 2011 19:04:28 +0300
Message-Id: <1314288270-22380-3-git-send-email-eliad@wizery.com> (sfid-20110825_180324_520589_5CC0E8C1)
In-Reply-To: <1314288270-22380-1-git-send-email-eliad@wizery.com>
References: <1314288270-22380-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When scan completes, and we are not associated, we should start
the dev role and ROC. however, we might already be in this situation
(e.g. if we got disconnected during scan). check for it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index b2e2abd..4a4d0d0 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -65,8 +65,9 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	/* return to ROC if needed */
 	is_sta = (wl->bss_type == BSS_TYPE_STA_BSS);
 	is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
-	if ((is_sta && !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) ||
-	    (is_ibss && !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))) {
+	if (((is_sta && !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) ||
+	     (is_ibss && !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))) &&
+	    !test_bit(wl->dev_role_id, wl->roc_map)) {
 		/* restore remain on channel */
 		wl12xx_cmd_role_start_dev(wl);
 		wl12xx_roc(wl, wl->dev_role_id);
-- 
1.7.6.401.g6a319

