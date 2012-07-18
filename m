Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:56712 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab2GRMNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:50 -0400
Received: by lbom4 with SMTP id m4so2661484lbo.30
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:47 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 02/14] wlcore: don't re-configure wakeup conditions if not needed
Date: Wed, 18 Jul 2012 15:13:21 +0300
Message-Id: <1342613613-917-3-git-send-email-coelho@ti.com> (sfid-20120718_141358_489566_45439A46)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

suspend and resume callbacks configure wakeup conditions to the FW
which may be different between suspend and resume.
This feature is currently not utilized as both in suspend and resume
FW wakeup every 1 DTIM. Avoid waking up the chip and doing the FW command
unless there's an actual difference in the wakeup conditions.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9f04b64..d486eea 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1585,6 +1585,12 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		goto out;
 
+	if ((wl->conf.conn.suspend_wake_up_event ==
+	     wl->conf.conn.wake_up_event) &&
+	    (wl->conf.conn.suspend_listen_interval ==
+	     wl->conf.conn.listen_interval))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
@@ -1648,6 +1654,13 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if ((!is_ap) && (!is_sta))
 		return;
 
+	if (is_sta &&
+	    ((wl->conf.conn.suspend_wake_up_event ==
+	      wl->conf.conn.wake_up_event) &&
+	     (wl->conf.conn.suspend_listen_interval ==
+	      wl->conf.conn.listen_interval)))
+		return;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		return;
-- 
1.7.10.4

