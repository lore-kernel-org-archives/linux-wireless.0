Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:51720 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933461AbaDJGvy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 02:51:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com,
	yegorslists@googlemail.com
Date: Thu, 10 Apr 2014 09:50:33 +0300
Message-Id: <1397112633-24486-1-git-send-email-luca@coelho.fi> (sfid-20140410_085205_245734_8923DB89)
Subject: [PATCH] wlcore: ignore dummy packet events in PLT mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luca@coelho.fi>

Sometimes the firmware sends a dummy packet event while we are in PLT
mode.  This doesn't make sense, it's a firmware bug.  Fix this by
ignoring dummy packet events when we're PLT mode.

Reported-by: Yegor Yefremov <yegorslists@googlemail.com>
Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 1f9a360..8d5174c 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -158,6 +158,11 @@ EXPORT_SYMBOL_GPL(wlcore_event_channel_switch);
 
 void wlcore_event_dummy_packet(struct wl1271 *wl)
 {
+	if (wl->plt) {
+		wl1271_info(DEBUG_EVENT, "Got DUMMY_PACKET event in PLT mode.  FW bug, ignoring.");
+		return;
+	}
+
 	wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
 	wl1271_tx_dummy_packet(wl);
 }
-- 
1.9.1

