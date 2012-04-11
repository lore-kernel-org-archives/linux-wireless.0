Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:55555 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933119Ab2DKTyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:06 -0400
Received: by lagu2 with SMTP id u2so1387755lag.21
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:03 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 15/24] wlcore/wl12xx: expand functionality of cmd_trigger HW op
Date: Wed, 11 Apr 2012 22:53:31 +0300
Message-Id: <1334174020-18957-16-git-send-email-coelho@ti.com> (sfid-20120411_215432_551956_F2151ED1)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Change the cmd_trigger op to include the write of the command buffer.

Also, instead of letting the lower driver access the cmd_box_addr element
directly, we now pass the address in the trigger_cmd operation, so it
doesn't have to be exported.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    4 +++-
 drivers/net/wireless/ti/wlcore/cmd.c    |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 564ca91..083e1d8 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -707,8 +707,10 @@ out:
 	return ret;
 }
 
-static void wl12xx_trigger_cmd(struct wl1271 *wl)
+static void wl12xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
+			       void *buf, size_t len)
 {
+	wl1271_write(wl, cmd_box_addr, buf, len, false);
 	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_CMD);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 8407590..5c4716c 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -70,7 +70,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	 * TODO: we just need this because one bit is in a different
 	 * place.  Is there any better way?
 	 */
-	wl->ops->trigger_cmd(wl);
+	wl->ops->trigger_cmd(wl, wl->cmd_box_addr, buf, len);
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 7e2881d..83f1d7c 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -37,7 +37,8 @@ enum wl_rx_buf_align;
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
-	void (*trigger_cmd)(struct wl1271 *wl);
+	void (*trigger_cmd)(struct wl1271 *wl, int cmd_box_addr,
+			    void *buf, size_t len);
 	void (*ack_event)(struct wl1271 *wl);
 	u32 (*calc_tx_blocks)(struct wl1271 *wl, u32 len, u32 spare_blks);
 	void (*set_tx_desc_blocks)(struct wl1271 *wl,
-- 
1.7.5.4

