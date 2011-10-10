Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1JJINJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:09 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:08 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 19/29] wl12xx: make WL1271_FLAG_PSPOLL_FAILURE flag per-vif
Date: Mon, 10 Oct 2011 10:13:07 +0200
Message-Id: <1318234397-21081-20-git-send-email-eliad@wizery.com> (sfid-20111010_101334_756131_CC07A474)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |    4 ++--
 drivers/net/wireless/wl12xx/main.c   |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index d8b183b..1f60a1f 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -49,7 +49,7 @@ void wl1271_pspoll_work(struct work_struct *work)
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	if (!test_and_clear_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags))
+	if (!test_and_clear_bit(WLVIF_FLAG_PSPOLL_FAILURE, &wlvif->flags))
 		goto out;
 
 	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
@@ -89,7 +89,7 @@ static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl,
 					 wlvif->basic_rate, true);
 		if (ret < 0)
 			return;
-		set_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags);
+		set_bit(WLVIF_FLAG_PSPOLL_FAILURE, &wlvif->flags);
 		ieee80211_queue_delayed_work(wl->hw, &wlvif->pspoll_work,
 					     msecs_to_jiffies(delay));
 	}
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 25599ad..c54c456 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2514,7 +2514,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	 * incorrectly changed after the pspoll failure active window.
 	 */
 	if (changed & IEEE80211_CONF_CHANGE_PS)
-		clear_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags);
+		clear_bit(WLVIF_FLAG_PSPOLL_FAILURE, &wlvif->flags);
 
 	if (conf->flags & IEEE80211_CONF_PS &&
 	    !test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 88d48b1..9701784 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -320,7 +320,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_ELP_REQUESTED,
 	WL1271_FLAG_IRQ_RUNNING,
 	WL1271_FLAG_IDLE,
-	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_FW_TX_BUSY,
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
 	WL1271_FLAG_SUSPENDED,
@@ -339,6 +338,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_PSM_REQUESTED,
 	WLVIF_FLAG_STA_STATE_SENT,
 	WLVIF_FLAG_RX_STREAMING_STARTED,
+	WLVIF_FLAG_PSPOLL_FAILURE,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

