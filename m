Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53588 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1JJINF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:05 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so8169287bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:05 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 17/29] wl12xx: make WL1271_FLAG_RX_STREAMING_STARTED flag per-vif
Date: Mon, 10 Oct 2011 10:13:05 +0200
Message-Id: <1318234397-21081-18-git-send-email-eliad@wizery.com> (sfid-20111010_101311_401148_B14DB0BA)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   10 +++++-----
 drivers/net/wireless/wl12xx/tx.c     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 92f38c5..36c7493 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -514,9 +514,9 @@ static int wl1271_set_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		goto out;
 
 	if (enable)
-		set_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags);
+		set_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags);
 	else
-		clear_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags);
+		clear_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags);
 out:
 	return ret;
 }
@@ -531,7 +531,7 @@ int wl1271_recalc_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	int period = wl->conf.rx_streaming.interval;
 
 	/* don't reconfigure if rx_streaming is disabled */
-	if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+	if (!test_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags))
 		goto out;
 
 	/* reconfigure/disable according to new streaming_period */
@@ -558,7 +558,7 @@ static void wl1271_rx_streaming_enable_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags) ||
+	if (test_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags) ||
 	    !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
 	    (!wl->conf.rx_streaming.always &&
 	     !test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags)))
@@ -594,7 +594,7 @@ static void wl1271_rx_streaming_disable_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+	if (!test_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index a6bc979..9589446 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -670,7 +670,7 @@ void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids)
 			continue;
 
 		/* enable rx streaming */
-		if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+		if (!test_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags))
 			ieee80211_queue_work(wl->hw,
 					     &wlvif->rx_streaming_enable_work);
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 6a1df2c..4741a4b 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -327,7 +327,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_SUSPENDED,
 	WL1271_FLAG_PENDING_WORK,
 	WL1271_FLAG_SOFT_GEMINI,
-	WL1271_FLAG_RX_STREAMING_STARTED,
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
 	WL1271_FLAG_CS_PROGRESS,
 };
@@ -339,6 +338,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_PSM,
 	WLVIF_FLAG_PSM_REQUESTED,
 	WLVIF_FLAG_STA_STATE_SENT,
+	WLVIF_FLAG_RX_STREAMING_STARTED,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

