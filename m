Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37619 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2EOOJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:08 -0400
Received: by weyu7 with SMTP id u7so2512825wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:07 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/10] wlcore: use the original elp time in forced_ps mode
Date: Tue, 15 May 2012 17:08:52 +0300
Message-Id: <1337090940-13750-2-git-send-email-arik@wizery.com> (sfid-20120515_160912_774231_D12A4D8C)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The dynamic PS timeout is meaningless in forced PS mode.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/ps.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 87c84d1..47e81b3 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -28,6 +28,8 @@
 
 #define WL1271_WAKEUP_TIMEOUT 500
 
+#define ELP_ENTRY_DELAY  5
+
 void wl1271_elp_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
@@ -72,6 +74,7 @@ out:
 void wl1271_ps_elp_sleep(struct wl1271 *wl)
 {
 	struct wl12xx_vif *wlvif;
+	u32 timeout;
 
 	if (wl->quirks & WLCORE_QUIRK_NO_ELP)
 		return;
@@ -89,8 +92,13 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 			return;
 	}
 
+	if (wl->conf.conn.forced_ps)
+		timeout = ELP_ENTRY_DELAY;
+	else
+		timeout = wl->conf.conn.dynamic_ps_timeout;
+
 	ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
-		msecs_to_jiffies(wl->conf.conn.dynamic_ps_timeout));
+				     msecs_to_jiffies(timeout));
 }
 
 int wl1271_ps_elp_wakeup(struct wl1271 *wl)
-- 
1.7.9.5

