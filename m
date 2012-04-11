Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:55329 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761145Ab2DKTyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:13 -0400
Received: by lbbgj3 with SMTP id gj3so1656556lbb.27
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:10 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 23/24] wlcore: add module param to prevent HW recovery
Date: Wed, 11 Apr 2012 22:53:39 +0300
Message-Id: <1334174020-18957-24-git-send-email-coelho@ti.com> (sfid-20120411_215423_850339_07DB6D12)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Allow preventing HW recovery from a module param. The driver/FW will
remain stuck, to allow easier FW debugging.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 730bbb1..b80f08b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -57,6 +57,7 @@
 
 static char *fwlog_param;
 static bool bug_on_recovery;
+static bool no_recovery;
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 struct ieee80211_vif *vif,
@@ -874,6 +875,14 @@ static void wl1271_recovery_work(struct work_struct *work)
 	BUG_ON(bug_on_recovery &&
 	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
 
+	if (no_recovery) {
+		wl1271_info("No recovery (chosen on module load). Fw will remain stuck.");
+		clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
+		goto out_unlock;
+	}
+
+	BUG_ON(bug_on_recovery);
+
 	/*
 	 * Advance security sequence number to overcome potential progress
 	 * in the firmware during recovery. This doens't hurt if the network is
@@ -5071,6 +5080,9 @@ MODULE_PARM_DESC(fwlog,
 module_param(bug_on_recovery, bool, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(bug_on_recovery, "BUG() on fw recovery");
 
+module_param(no_recovery, bool, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(no_recovery, "Prevent HW recovery. FW will remain stuck.");
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-- 
1.7.5.4

