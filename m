Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:42510 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab2FUONY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:24 -0400
Received: by eeke49 with SMTP id e49so229231eek.41
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:21 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 01/12] wlcore: suppress error message on Rx BA session removal
Date: Thu, 21 Jun 2012 17:13:00 +0300
Message-Id: <1340287991-15241-2-git-send-email-coelho@ti.com> (sfid-20120621_161401_533575_C6C681B9)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The ampdu_action() function is called on the reconfig() path to remove
existing Rx BA sessions. Since these don't exist for the low level
driver, we output an error message. Turn the message into a debug
message for now, until the mac80211 reconfig flow is changed.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 8eefcd7..22b342f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4366,9 +4366,14 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 
 	case IEEE80211_AMPDU_RX_STOP:
 		if (!(*ba_bitmap & BIT(tid))) {
-			ret = -EINVAL;
-			wl1271_error("no active RX BA session on tid: %d",
+			/*
+			 * this happens on reconfig - so only output a debug
+			 * message for now, and don't fail the function.
+			 */
+			wl1271_debug(DEBUG_MAC80211,
+				     "no active RX BA session on tid: %d",
 				     tid);
+			ret = 0;
 			break;
 		}
 
-- 
1.7.10

