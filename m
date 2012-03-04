Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58905 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2CDIz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:55:56 -0500
Received: by mail-we0-f174.google.com with SMTP id x9so1794100wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:55:55 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/11] wl12xx: increment session_counter for device role as well
Date: Sun,  4 Mar 2012 10:55:49 +0200
Message-Id: <1330851355-24459-6-git-send-email-eliad@wizery.com> (sfid-20120304_095624_452994_63603927)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sesssion_counter has to be incremented each time
the dev is started (similar to sta role).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index ae1f3d7..1ef212f 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -531,7 +531,7 @@ static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 			goto out_free;
 	}
 	cmd->device.hlid = wlvif->dev_hlid;
-	cmd->device.session = wlvif->session_counter;
+	cmd->device.session = wl12xx_get_new_session_id(wl, wlvif);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d",
 		     cmd->role_id, cmd->device.hlid, cmd->device.session);
-- 
1.7.6.401.g6a319

