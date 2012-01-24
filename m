Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51042 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001Ab2AXKdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 05:33:51 -0500
Received: by lagp5 with SMTP id p5so2170467lag.38
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 02:33:48 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: remove unnecessary shadow declaration
Date: Tue, 24 Jan 2012 12:33:38 +0200
Message-Id: <1327401218-1427-1-git-send-email-coelho@ti.com> (sfid-20120124_113354_496755_753623C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The vif variable was being declared inside one of the internal blocks
of wl1271_event_process.  This is not necessary, since this variable
is already declared in the function context.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index d3280df68..cfc38ea 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -344,7 +344,6 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 
 		/* TODO: configure only the relevant vif */
 		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 			bool success;
 
 			if (!test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS,
@@ -352,6 +351,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 				continue;
 
 			success = mbox->channel_switch_status ? false : true;
+			vif = wl12xx_wlvif_to_vif(wlvif);
+
 			ieee80211_chswitch_done(vif, success);
 		}
 	}
-- 
1.7.4.1

