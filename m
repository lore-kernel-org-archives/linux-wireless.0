Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51553 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab1HWNga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 09:36:30 -0400
Received: by fxh19 with SMTP id 19so238388fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 06:36:29 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: enter psm only after station role was started
Date: Tue, 23 Aug 2011 16:37:01 +0300
Message-Id: <1314106622-7481-1-git-send-email-eliad@wizery.com> (sfid-20110823_153633_881490_C9218575)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The station didn't get into psm after recovery, because
psm was configured before sta role was started.

Move wl1271_ps_set_mode() to be executed only after
the role was started.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9094fa5..91fbebb 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3349,19 +3349,6 @@ sta_not_found:
 			ret = wl1271_acx_conn_monit_params(wl, true);
 			if (ret < 0)
 				goto out;
-
-			/* If we want to go in PSM but we're not there yet */
-			if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
-			    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
-				enum wl1271_cmd_ps_mode mode;
-
-				mode = STATION_POWER_SAVE_MODE;
-				ret = wl1271_ps_set_mode(wl, mode,
-							 wl->basic_rate,
-							 true);
-				if (ret < 0)
-					goto out;
-			}
 		} else {
 			/* use defaults when not associated */
 			bool was_assoc =
@@ -3505,6 +3492,19 @@ sta_not_found:
 			if (ret < 0)
 				goto out;
 		}
+
+		/* If we want to go in PSM but we're not there yet */
+		if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
+		    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+			enum wl1271_cmd_ps_mode mode;
+
+			mode = STATION_POWER_SAVE_MODE;
+			ret = wl1271_ps_set_mode(wl, mode,
+						 wl->basic_rate,
+						 true);
+			if (ret < 0)
+				goto out;
+		}
 	}
 
 	/* Handle new association with HT. Do this after join. */
-- 
1.7.6.401.g6a319

