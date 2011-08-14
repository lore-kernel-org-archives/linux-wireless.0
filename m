Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55381 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1HNKSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:18:13 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4061056wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:18:12 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 37/40] wl12xx: don't wait for disconnection event
Date: Sun, 14 Aug 2011 13:17:36 +0300
Message-Id: <1313317059-16567-38-git-send-email-eliad@wizery.com> (sfid-20110814_121819_168730_BDDCDFB1)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the fw doesn't send the DISCONNECT_EVENT_COMPLETE_ID
on station role stop, so don't wait for it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index d3e9380..817bc18 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -641,18 +641,12 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl)
 	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd role stop sta");
 		goto out_free;
 	}
 
-	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
-	if (ret < 0) {
-		wl1271_error("cmd role stop sta event completion error");
-		goto out_free;
-	}
-
 	wl12xx_free_link(wl, &wl->sta_hlid);
 
 out_free:
 	kfree(cmd);
 
 out:
-- 
1.7.6.401.g6a319

