Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab1HIJOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:40 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210739wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:40 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 37/40] wl12xx: don't wait for disconnection event
Date: Tue,  9 Aug 2011 12:13:50 +0300
Message-Id: <1312881233-9366-38-git-send-email-eliad@wizery.com> (sfid-20110809_111446_248662_AC27E6D7)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the fw doesn't send the DISCONNECT_EVENT_COMPLETE_ID
on station role stop, so don't wait for it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 9ef8621..ad926d2 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -640,18 +640,12 @@ int wl1271_cmd_role_stop_sta(struct wl1271 *wl)
 	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd role stop");
 		goto out_free;
 	}
 
-	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
-	if (ret < 0) {
-		wl1271_error("cmd role stop sta event completion error");
-		goto out_free;
-	}
-
 	wl1271_free_link(wl, &wl->sta_hlid);
 
 out_free:
 	kfree(cmd);
 
 out:
-- 
1.7.6.401.g6a319

