Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53714 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2I0Kil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:41 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 12/31] wlcore: configure wowlan regardless of wakeup conditions
Date: Thu, 27 Sep 2012 13:37:50 +0300
Message-Id: <1348742289-6587-13-git-send-email-luca@coelho.fi> (sfid-20120927_124002_454659_141FB40F)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

wowlan filters should be configured in any case in suspend/resume.
This shouldn't be dependent on whether wakeup conditions are the
same for suspend and resume states. Only the FW command to
reconfigure wakeup conditions should be avoided in such a case.

Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7fe19de..a797ce7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1603,12 +1603,6 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		goto out;
 
-	if ((wl->conf.conn.suspend_wake_up_event ==
-	     wl->conf.conn.wake_up_event) &&
-	    (wl->conf.conn.suspend_listen_interval ==
-	     wl->conf.conn.listen_interval))
-		goto out;
-
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
@@ -1617,6 +1611,12 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (ret < 0)
 		goto out_sleep;
 
+	if ((wl->conf.conn.suspend_wake_up_event ==
+	     wl->conf.conn.wake_up_event) &&
+	    (wl->conf.conn.suspend_listen_interval ==
+	     wl->conf.conn.listen_interval))
+		goto out_sleep;
+
 	ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.suspend_wake_up_event,
 				    wl->conf.conn.suspend_listen_interval);
@@ -1672,13 +1672,6 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if ((!is_ap) && (!is_sta))
 		return;
 
-	if (is_sta &&
-	    ((wl->conf.conn.suspend_wake_up_event ==
-	      wl->conf.conn.wake_up_event) &&
-	     (wl->conf.conn.suspend_listen_interval ==
-	      wl->conf.conn.listen_interval)))
-		return;
-
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		return;
@@ -1686,6 +1679,12 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if (is_sta) {
 		wl1271_configure_wowlan(wl, NULL);
 
+		if ((wl->conf.conn.suspend_wake_up_event ==
+		     wl->conf.conn.wake_up_event) &&
+		    (wl->conf.conn.suspend_listen_interval ==
+		     wl->conf.conn.listen_interval))
+			goto out_sleep;
+
 		ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.wake_up_event,
 				    wl->conf.conn.listen_interval);
@@ -1698,6 +1697,7 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 	}
 
+out_sleep:
 	wl1271_ps_elp_sleep(wl);
 }
 
-- 
1.7.10.4

