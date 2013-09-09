Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53543 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3IIJZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:25:05 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn9so3094181wib.11
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:25:04 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/13] wlcore: Allow stopping fw log in recovery
Date: Mon,  9 Sep 2013 12:24:40 +0300
Message-Id: <1378718684-14430-9-git-send-email-eliad@wizery.com> (sfid-20130909_112511_851424_3A84ED58)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Barak Bercovitz <barak@wizery.com>

The FW panic log is read during recovery work.
It has to be stopped properly before reading. otherwise,
inconsistent data might be read which cause the driver
to freeze.

__wlcore_cmd_send has to work for the special case of
CMD_STOP_FWLOGGER, while in recovery, in order to stop
the fw log before it is read.

Signed-off-by: Barak Bercovitz <barak@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index f6a3d7d..8c8dfa3 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -60,7 +60,8 @@ static int __wlcore_cmd_send(struct wl1271 *wl, u16 id, void *buf,
 	u16 status;
 	u16 poll_count = 0;
 
-	if (WARN_ON(unlikely(wl->state == WLCORE_STATE_RESTARTING)))
+	if (WARN_ON(wl->state == WLCORE_STATE_RESTARTING &&
+		    id != CMD_STOP_FWLOGGER))
 		return -EIO;
 
 	cmd = buf;
-- 
1.8.3.rc1.35.g9b79519

