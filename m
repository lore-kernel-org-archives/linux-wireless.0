Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298Ab1JEJ4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:24 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so1903568bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:23 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 24/29] wl12xx: move ps_compl into wlvif
Date: Wed,  5 Oct 2011 11:56:01 +0200
Message-Id: <1317808566-18857-25-git-send-email-eliad@wizery.com> (sfid-20111005_115629_919187_925DD707)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move ps_compl into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |    6 +++---
 drivers/net/wireless/wl12xx/main.c   |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 1ea508b..fac4eae 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -149,9 +149,9 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 			/* enable beacon early termination */
 			ret = wl1271_acx_bet_enable(wl, wlvif, true);
 
-		if (wl->ps_compl) {
-			complete(wl->ps_compl);
-			wl->ps_compl = NULL;
+		if (wlvif->ps_compl) {
+			complete(wlvif->ps_compl);
+			wlvif->ps_compl = NULL;
 		}
 		break;
 	default:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4fe7662..1d3ed60 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1636,7 +1636,7 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 		DECLARE_COMPLETION_ONSTACK(compl);
 
-		wl->ps_compl = &compl;
+		wlvif->ps_compl = &compl;
 		ret = wl1271_ps_set_mode(wl, wlvif, STATION_POWER_SAVE_MODE,
 				   wlvif->basic_rate, true);
 		if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index d016509..d153b24 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -508,7 +508,6 @@ struct wl1271 {
 	struct timer_list rx_streaming_timer;
 
 	struct completion *elp_compl;
-	struct completion *ps_compl;
 	struct delayed_work elp_work;
 
 	/* counter for ps-poll delivery failures */
@@ -650,6 +649,7 @@ struct wl12xx_vif {
 	/* Session counter for the chipset */
 	int session_counter;
 
+	struct completion *ps_compl;
 	struct delayed_work pspoll_work;
 };
 
-- 
1.7.6.401.g6a319

