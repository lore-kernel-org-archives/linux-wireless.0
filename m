Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59299 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbaKJH0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 02:26:08 -0500
Received: from a88-113-225-236.elisa-laajakaista.fi ([88.113.225.236] helo=dubbel.ger.corp.intel.com)
	by dedo.coelho.fi with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA256:128)
	(Exim 4.80)
	(envelope-from <luca@coelho.fi>)
	id 1XnjMU-00054v-Hg
	for linux-wireless@vger.kernel.org; Mon, 10 Nov 2014 09:26:06 +0200
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Date: Mon, 10 Nov 2014 09:25:57 +0200
Message-Id: <1415604357-27894-1-git-send-email-luca@coelho.fi> (sfid-20141110_082611_863847_CA2632D8)
Subject: [PATCH] wlcore: make wlcore_cmd_send_failsafe() static
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The wlcore_cmd_send_failsafe() function is only called in the cmd.c
file, where it is definde.  Make it static.

Additionally, move the EXPORT_SYMBOL macro for wl1271_cmd_send() to
the right place.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 7 ++++---
 drivers/net/wireless/ti/wlcore/cmd.h | 2 --
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 5c6f3c8..dd2e448 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -131,8 +131,9 @@ static int __wlcore_cmd_send(struct wl1271 *wl, u16 id, void *buf,
  * send command to fw and return cmd status on success
  * valid_rets contains a bitmap of allowed error codes
  */
-int wlcore_cmd_send_failsafe(struct wl1271 *wl, u16 id, void *buf, size_t len,
-			     size_t res_len, unsigned long valid_rets)
+static int wlcore_cmd_send_failsafe(struct wl1271 *wl, u16 id, void *buf,
+				    size_t len, size_t res_len,
+				    unsigned long valid_rets)
 {
 	int ret = __wlcore_cmd_send(wl, id, buf, len, res_len);
 
@@ -153,7 +154,6 @@ fail:
 	wl12xx_queue_recovery_work(wl);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(wl1271_cmd_send);
 
 /*
  * wrapper for wlcore_cmd_send that accept only CMD_STATUS_SUCCESS
@@ -168,6 +168,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		return ret;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_cmd_send);
 
 /*
  * Poll the mailbox event field until any of the bits in the mask is set or a
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index ca6a28b..453684a 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -31,8 +31,6 @@ struct acx_header;
 
 int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
-int wlcore_cmd_send_failsafe(struct wl1271 *wl, u16 id, void *buf, size_t len,
-			     size_t res_len, unsigned long valid_rets);
 int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
 			   u8 *role_id);
 int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
-- 
2.1.1

