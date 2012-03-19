Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56184 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2CSKHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:07:39 -0400
Received: by mail-we0-f174.google.com with SMTP id x9so5669979wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 03:07:39 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] wl12xx: increase scan timeout to 30s
Date: Mon, 19 Mar 2012 12:06:29 +0200
Message-Id: <1332151589-27272-5-git-send-email-eyal@wizery.com> (sfid-20120319_110743_722002_4ACA4738)
In-Reply-To: <1332151589-27272-1-git-send-email-eyal@wizery.com>
References: <1332151589-27272-1-git-send-email-eyal@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In certain scenarios involving sched scan + normal scan + COEX
scan could take longer than 10s and this triggers a recovery
where it shouldn't. Increase the timeout to avoid that.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index 96ff457..2b300f4 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -55,7 +55,7 @@ void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 #define WL1271_SCAN_BAND_2_4_GHZ 0
 #define WL1271_SCAN_BAND_5_GHZ 1
 
-#define WL1271_SCAN_TIMEOUT    10000 /* msec */
+#define WL1271_SCAN_TIMEOUT    30000 /* msec */
 
 enum {
 	WL1271_SCAN_STATE_IDLE,
-- 
1.7.4.1

