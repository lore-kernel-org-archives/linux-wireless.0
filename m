Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40311 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1KILSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 06:18:25 -0500
Received: by wyh15 with SMTP id 15so1479663wyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 03:18:24 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: make WL1271_FLAG_IDLE flag per-vif
Date: Wed,  9 Nov 2011 13:18:23 +0200
Message-Id: <1320837504-12026-1-git-send-email-eliad@wizery.com> (sfid-20111109_121829_048330_A1BA7D22)
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
index 7d791ad..fa9bcf2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2440,6 +2440,10 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				  bool idle)
 {
 	int ret;
+	bool cur_idle = !test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
+
+	if (idle == cur_idle)
+		return 0;
 
 	if (idle) {
 		/* no need to croc if we weren't busy (e.g. during boot) */
@@ -2458,7 +2462,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			ACX_KEEP_ALIVE_TPL_INVALID);
 		if (ret < 0)
 			goto out;
-		set_bit(WL1271_FLAG_IDLE, &wl->flags);
+		clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
 	} else {
 		/* The current firmware only supports sched_scan in idle */
 		if (wl->sched_scanning) {
@@ -2469,7 +2473,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
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
index a13c49e..48f6b59 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -700,7 +700,7 @@ int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (wlvif->bss_type != BSS_TYPE_STA_BSS)
 		return -EOPNOTSUPP;
 
-	if (!test_bit(WL1271_FLAG_IDLE, &wl->flags))
+	if (test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 		return -EBUSY;
 
 	start = kzalloc(sizeof(*start), GFP_KERNEL);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fd3240a..af39e8f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -248,7 +248,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_ELP_REQUESTED,
 	WL1271_FLAG_IRQ_RUNNING,
-	WL1271_FLAG_IDLE,
 	WL1271_FLAG_FW_TX_BUSY,
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
 	WL1271_FLAG_SUSPENDED,
@@ -268,6 +267,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_RX_STREAMING_STARTED,
 	WLVIF_FLAG_PSPOLL_FAILURE,
 	WLVIF_FLAG_CS_PROGRESS,
+	WLVIF_FLAG_IN_USE,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

