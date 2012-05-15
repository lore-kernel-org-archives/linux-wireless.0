Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53305 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2EOLxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 07:53:15 -0400
Received: by wgbdr13 with SMTP id dr13so5684845wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 04:53:14 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: send beacon loss events to userspace
Date: Tue, 15 May 2012 14:53:17 +0300
Message-Id: <1337082797-25423-1-git-send-email-eliad@wizery.com> (sfid-20120515_135318_825684_E87993AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send beacon loss events to userspace, so it will be
able to initiate roaming before disconnection

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on "nl80211: add new rssi event to indicate beacon loss"

 drivers/net/wireless/ti/wlcore/event.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 4ed83579..c976f04 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -156,6 +156,15 @@ static int wl1271_event_process(struct wl1271 *wl)
 		 */
 		ieee80211_queue_delayed_work(wl->hw, &wl->connection_loss_work,
 					     msecs_to_jiffies(delay));
+
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			vif = wl12xx_wlvif_to_vif(wlvif);
+
+			ieee80211_cqm_rssi_notify(
+					vif,
+					NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
+					GFP_KERNEL);
+		}
 	}
 
 	if (vector & REGAINED_BSS_EVENT_ID) {
-- 
1.7.6.401.g6a319

