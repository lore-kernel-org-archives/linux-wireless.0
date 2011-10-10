Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1JJINL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:11 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:10 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 20/29] wl12xx: make WL1271_FLAG_CS_PROGRESS flag per-vif
Date: Mon, 10 Oct 2011 10:13:08 +0200
Message-Id: <1318234397-21081-21-git-send-email-eliad@wizery.com> (sfid-20111010_101315_938840_0310745C)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |   22 ++++++++++++----------
 drivers/net/wireless/wl12xx/main.c   |   12 ++++++++----
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 1f60a1f..a47312d 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -345,16 +345,18 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		 * 1) channel switch complete with status=0
 		 * 2) channel switch failed status=1
 		 */
-		if (test_and_clear_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags)) {
-			/* TODO: configure only the relevant vif */
-			wl12xx_for_each_wlvif_sta(wl, wlvif) {
-				struct ieee80211_vif *vif =
-					wl12xx_wlvif_to_vif(wlvif);
-				bool success = mbox->channel_switch_status ?
-					false : true;
-
-				ieee80211_chswitch_done(vif, success);
-			}
+
+		/* TODO: configure only the relevant vif */
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+			bool success;
+
+			if (!test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS,
+						&wl->flags))
+				continue;
+
+			success = mbox->channel_switch_status ? false : true;
+			ieee80211_chswitch_done(vif, success);
 		}
 	}
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c54c456..90f04f1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2307,7 +2307,7 @@ static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	if (test_and_clear_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags)) {
+	if (test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags)) {
 		wl12xx_cmd_stop_channel_switch(wl);
 		ieee80211_chswitch_done(wl->vif, false);
 	}
@@ -4265,6 +4265,7 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 				     struct ieee80211_channel_switch *ch_switch)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
@@ -4281,10 +4282,13 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_cmd_channel_switch(wl, ch_switch);
+	/* TODO: change mac80211 to pass vif as param */
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		ret = wl12xx_cmd_channel_switch(wl, ch_switch);
 
-	if (!ret)
-		set_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags);
+		if (!ret)
+			set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
+	}
 
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9701784..b76713d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -326,7 +326,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_PENDING_WORK,
 	WL1271_FLAG_SOFT_GEMINI,
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
-	WL1271_FLAG_CS_PROGRESS,
 };
 
 enum wl12xx_vif_flags {
@@ -339,6 +338,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_STA_STATE_SENT,
 	WLVIF_FLAG_RX_STREAMING_STARTED,
 	WLVIF_FLAG_PSPOLL_FAILURE,
+	WLVIF_FLAG_CS_PROGRESS,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

