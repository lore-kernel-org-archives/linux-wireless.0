Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50593 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3CLNpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:32 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id r2CDjW4j003586
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:32 -0500
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r2CDjWG0017320
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:32 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Igal Chernobelsky <igalc@ti.com>
Subject: [PATCH 01/13] wlcore: enter elp in force ps mode in 5ms
Date: Tue, 12 Mar 2013 15:44:12 +0200
Message-ID: <1363095864-24422-2-git-send-email-coelho@ti.com> (sfid-20130312_144549_332476_1EF8C97C)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

It is requiered to enter sleep mode with smaller delay in forced PS mode.
This fixes issue of testing force PS mode during VoIP traffic where packets
are sent every 20ms. Chip never enters ps mode with default 30 ms delay
in such test.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/ps.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 9b7b6e2..9654577 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -29,6 +29,7 @@
 #define WL1271_WAKEUP_TIMEOUT 500
 
 #define ELP_ENTRY_DELAY  30
+#define ELP_ENTRY_DELAY_FORCE_PS  5
 
 void wl1271_elp_work(struct work_struct *work)
 {
@@ -98,7 +99,8 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 			return;
 	}
 
-	timeout = ELP_ENTRY_DELAY;
+	timeout = wl->conf.conn.forced_ps ?
+			ELP_ENTRY_DELAY_FORCE_PS : ELP_ENTRY_DELAY;
 	ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
 				     msecs_to_jiffies(timeout));
 }
-- 
1.7.10.4

