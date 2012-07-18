Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36757 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039Ab2GRMOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:14:02 -0400
Received: by lboj14 with SMTP id j14so2871748lbo.21
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:59 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 13/14] wlcore: wait for command completion event when sending CMD_ROLE_STOP
Date: Wed, 18 Jul 2012 15:13:32 +0300
Message-Id: <1342613613-917-14-git-send-email-coelho@ti.com> (sfid-20120718_141424_958960_B8358B30)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to wait for the command completion event when we send the
CMD_ROLE_STOP event otherwise we may try to send CMD_ROLE_START too
soon and get out-of-sync with the firmware.

In some cases, the firmware may not send the event, so we wait for the
event or for the timeout, whichever comes first.

This patch is based on an earlier version by Eliad.

Cc: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index a23949c..20e1bd9 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -497,6 +497,7 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
+	bool timeout = false;
 
 	if (WARN_ON(wlvif->sta.hlid == WL12XX_INVALID_LINK_ID))
 		return -EINVAL;
@@ -519,6 +520,17 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
+	/*
+	 * Sometimes the firmware doesn't send this event, so we just
+	 * time out without failing.  Queue recovery for other
+	 * failures.
+	 */
+	ret = wl1271_cmd_wait_for_event_or_timeout(wl,
+						   ROLE_STOP_COMPLETE_EVENT_ID,
+						   &timeout);
+	if (ret)
+		wl12xx_queue_recovery_work(wl);
+
 	wl12xx_free_link(wl, wlvif, &wlvif->sta.hlid);
 
 out_free:
-- 
1.7.10.4

