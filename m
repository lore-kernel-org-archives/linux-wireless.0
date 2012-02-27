Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36813 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2B0Wll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:41:41 -0500
Received: by wgbdr13 with SMTP id dr13so2121496wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:41:39 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/7] wl12xx: set the ELP entry delay to the FW dyn-ps timeout
Date: Tue, 28 Feb 2012 00:41:28 +0200
Message-Id: <1330382494-31148-1-git-send-email-arik@wizery.com> (sfid-20120227_234144_182709_4A750075)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With PSM handled in FW, the checks in wl1271_elp_work() are always true.
Thus during active traffic we constantly enter and exit ELP (many times
per second). As each ELP exit takes ~10ms, this can have an adverse
effect on throughput and interactivity.
Set the ELP timeout to the dyn-ps timeout. This period is longer and
avoids the above problem. It also makes sense to stay out of ELP while
we are awake on the network, to minimize delays in Tx/Rx. The same thing
was done by the mac80211 dynamic-ps mechanism before the FW DPS changes.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/ps.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 23d6750..78f598b 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -69,8 +69,6 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-#define ELP_ENTRY_DELAY  5
-
 /* Routines to toggle sleep mode while in ELP */
 void wl1271_ps_elp_sleep(struct wl1271 *wl)
 {
@@ -90,7 +88,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 	}
 
 	ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
-				     msecs_to_jiffies(ELP_ENTRY_DELAY));
+		msecs_to_jiffies(wl->conf.conn.dynamic_ps_timeout));
 }
 
 int wl1271_ps_elp_wakeup(struct wl1271 *wl)
-- 
1.7.5.4

