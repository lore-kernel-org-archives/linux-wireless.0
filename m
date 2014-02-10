Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55793 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaBJLsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:05 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so4017221wgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:48:04 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/18] wlcore: consider multiple APs when checking active_link_count
Date: Mon, 10 Feb 2014 13:47:30 +0200
Message-Id: <1392032854-28126-15-git-send-email-eliad@wizery.com> (sfid-20140210_130007_451873_A9B65270)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each AP has its own global and broadcast links, so when
checking for active sta count (according to the active_link_count)
we must take them all into account.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 10 +++++-----
 drivers/net/wireless/ti/wlcore/tx.c   | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d80d40c..8106c96 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -345,12 +345,12 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 	 * Start high-level PS if the STA is asleep with enough blocks in FW.
 	 * Make an exception if this is the only connected link. In this
 	 * case FW-memory congestion is less of a problem.
-	 * Note that a single connected STA means 3 active links, since we must
-	 * account for the global and broadcast AP links. The "fw_ps" check
-	 * assures us the third link is a STA connected to the AP. Otherwise
-	 * the FW would not set the PSM bit.
+	 * Note that a single connected STA means 2*ap_count + 1 active links,
+	 * since we must account for the global and broadcast AP links
+	 * for each AP. The "fw_ps" check assures us the other link is a STA
+	 * connected to the AP. Otherwise the FW would not set the PSM bit.
 	 */
-	else if (wl->active_link_count > 3 && fw_ps &&
+	else if (wl->active_link_count > (wl->ap_count*2 + 1) && fw_ps &&
 		 tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 38b31a0..40b4311 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -134,12 +134,12 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl,
 	 * into high-level PS and clean out its TX queues.
 	 * Make an exception if this is the only connected link. In this
 	 * case FW-memory congestion is less of a problem.
-	 * Note that a single connected STA means 3 active links, since we must
-	 * account for the global and broadcast AP links. The "fw_ps" check
-	 * assures us the third link is a STA connected to the AP. Otherwise
-	 * the FW would not set the PSM bit.
+	 * Note that a single connected STA means 2*ap_count + 1 active links,
+	 * since we must account for the global and broadcast AP links
+	 * for each AP. The "fw_ps" check assures us the other link is a STA
+	 * connected to the AP. Otherwise the FW would not set the PSM bit.
 	 */
-	if (wl->active_link_count > 3 && fw_ps &&
+	if (wl->active_link_count > (wl->ap_count*2 + 1) && fw_ps &&
 	    tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
-- 
1.8.5.2.229.g4448466.dirty

