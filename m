Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59296 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750812AbaKJHZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 02:25:27 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: dan.carpenter@oracle.com
Date: Mon, 10 Nov 2014 09:25:17 +0200
Message-Id: <1415604317-26688-1-git-send-email-luca@coelho.fi> (sfid-20141110_082532_717496_8D341475)
In-Reply-To: <20141107100543.GA16332@mwanda>
References: <20141107100543.GA16332@mwanda>
Subject: [PATCH] wlcore: check minimum buffer size in some cmd_send functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Check for the minimum required buffer length in wlcore_cmd_send() and
wlcore_cmd_configure_failsafe.  This ensures that we will never try to
use a buffer that is smaller than the required header.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

NOTE: this is only compile-tested.

drivers/net/wireless/ti/wlcore/cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 05604ee..5c6f3c8 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -64,6 +64,9 @@ static int __wlcore_cmd_send(struct wl1271 *wl, u16 id, void *buf,
 		     id != CMD_STOP_FWLOGGER))
 		return -EIO;
 
+	if (WARN_ON_ONCE(len < sizeof(*cmd)))
+		return -EIO;
+
 	cmd = buf;
 	cmd->id = cpu_to_le16(id);
 	cmd->status = 0;
@@ -891,6 +894,9 @@ int wlcore_cmd_configure_failsafe(struct wl1271 *wl, u16 id, void *buf,
 
 	wl1271_debug(DEBUG_CMD, "cmd configure (%d)", id);
 
+	if (WARN_ON_ONCE(len < sizeof(*acx)))
+		return -EIO;
+
 	acx->id = cpu_to_le16(id);
 
 	/* payload length, does not include any headers */
-- 
2.1.1

