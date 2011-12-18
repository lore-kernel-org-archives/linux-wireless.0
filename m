Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65208 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1LRSYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:24:55 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm6so675676wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:24:54 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] wl12xx: make WL1271_FLAG_IDLE flag per-vif
Date: Sun, 18 Dec 2011 20:25:41 +0200
Message-Id: <1324232745-22928-4-git-send-email-eliad@wizery.com> (sfid-20111218_192458_899189_DA36B384)
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Rename the flag to indicate IN_USE (rather than IDLE), as
in the default configuration (i.e. flag is clear) the vif
should be idle.

Change all the bit operations (and elp conditions) appropriately.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    8 ++++++--
 drivers/net/wireless/wl12xx/ps.c     |   10 ++++++++--
 drivers/net/wireless/wl12xx/scan.c   |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 17e62e4..3a8fd33 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2383,6 +2383,10 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				  bool idle)
 {
 	int ret;
+	bool cur_idle = !test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
+
+	if (idle == cur_idle)
+		return 0;
 
 	if (idle) {
 		/* no need to croc if we weren't busy (e.g. during boot) */
@@ -2401,7 +2405,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			ACX_KEEP_ALIVE_TPL_INVALID);
 		if (ret < 0)
 			goto out;
-		set_bit(WL1271_FLAG_IDLE, &wl->flags);
+		clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
 	} else {
 		/* The current firmware only supports sched_scan in idle */
 		if (wl->sched_scanning) {
@@ -2412,7 +2416,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		ret = wl12xx_start_dev(wl, wlvif);
 		if (ret < 0)
 			goto out;
-		clear_bit(WL1271_FLAG_IDLE, &wl->flags);
+		set_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
 	}
 
 out:
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index a7a1108..a2bdacd 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -53,8 +53,11 @@ void wl1271_elp_work(struct work_struct *work)
 		goto out;
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
+		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+			goto out;
+
 		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags) &&
-		    !test_bit(WL1271_FLAG_IDLE, &wl->flags))
+		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			goto out;
 	}
 
@@ -78,8 +81,11 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 		return;
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
+		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+			return;
+
 		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags) &&
-		    !test_bit(WL1271_FLAG_IDLE, &wl->flags))
+		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			return;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 8599dab..108765a 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -703,7 +703,7 @@ int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (wlvif->bss_type != BSS_TYPE_STA_BSS)
 		return -EOPNOTSUPP;
 
-	if (!test_bit(WL1271_FLAG_IDLE, &wl->flags))
+	if (test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 		return -EBUSY;
 
 	start = kzalloc(sizeof(*start), GFP_KERNEL);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index d21f71f..b2b09cd 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -241,7 +241,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_ELP_REQUESTED,
 	WL1271_FLAG_IRQ_RUNNING,
-	WL1271_FLAG_IDLE,
 	WL1271_FLAG_FW_TX_BUSY,
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
 	WL1271_FLAG_SUSPENDED,
@@ -262,6 +261,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_PSPOLL_FAILURE,
 	WLVIF_FLAG_CS_PROGRESS,
 	WLVIF_FLAG_AP_PROBE_RESP_SET,
+	WLVIF_FLAG_IN_USE,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

