Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob129.obsmtp.com ([74.125.149.136]:43855 "EHLO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754560Ab2DKJi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:29 -0400
Received: by lbbge1 with SMTP id ge1so618434lbb.23
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:26 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 12/16] wlcore/wl12xx: add command trigger and event ack operations
Date: Wed, 11 Apr 2012 12:37:59 +0300
Message-Id: <1334137083-13490-13-git-send-email-coelho@ti.com> (sfid-20120411_113846_077835_E7F0570A)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different chips may use different bits in the interrupt trigger
register.  Add operations to handle these differences.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   12 ++++++++++++
 drivers/net/wireless/ti/wl12xx/reg.h    |   16 ++++++++++++++++
 drivers/net/wireless/ti/wlcore/cmd.c    |    6 +++++-
 drivers/net/wireless/ti/wlcore/event.c  |    7 +++++--
 drivers/net/wireless/ti/wlcore/wlcore.h |   18 ++----------------
 5 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index cef2884..8d82203 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -571,6 +571,16 @@ out:
 	return ret;
 }
 
+static void wl12xx_trigger_cmd(struct wl1271 *wl)
+{
+	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_CMD);
+}
+
+static void wl12xx_ack_event(struct wl1271 *wl)
+{
+	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_EVENT_ACK);
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -637,6 +647,8 @@ static void wl12xx_get_mac(struct wl1271 *wl)
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip	= wl12xx_identify_chip,
 	.boot		= wl12xx_boot,
+	.trigger_cmd	= wl12xx_trigger_cmd,
+	.ack_event	= wl12xx_ack_event,
 	.get_pg_ver	= wl12xx_get_pg_ver,
 	.get_mac	= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wl12xx/reg.h b/drivers/net/wireless/ti/wl12xx/reg.h
index 003041b..79ede02 100644
--- a/drivers/net/wireless/ti/wl12xx/reg.h
+++ b/drivers/net/wireless/ti/wl12xx/reg.h
@@ -490,6 +490,22 @@ enum {
 
 /* end PLL configuration algorithm for wl128x */
 
+/*
+ * Host Command Interrupt. Setting this bit masks
+ * the interrupt that the host issues to inform
+ * the FW that it has sent a command
+ * to the Wlan hardware Command Mailbox.
+ */
+#define WL12XX_INTR_TRIG_CMD		BIT(0)
+
+/*
+ * Host Event Acknowlegde Interrupt. The host
+ * sets this bit to acknowledge that it received
+ * the unsolicited information from the event
+ * mailbox.
+ */
+#define WL12XX_INTR_TRIG_EVENT_ACK	BIT(1)
+
 /*===============================================
   HI_CFG Interface Configuration Register Values
   ------------------------------------------
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 3ec86e9..e80f674 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -66,7 +66,11 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 	wl1271_write(wl, wl->cmd_box_addr, buf, len, false);
 
-	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
+	/*
+	 * TODO: we just need this because one bit is in a different
+	 * place.  Is there any better way?
+	 */
+	wl->ops->trigger_cmd(wl);
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 078cb01..e3f572c 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -305,8 +305,11 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 	if (ret < 0)
 		return ret;
 
-	/* then we let the firmware know it can go on...*/
-	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+	/*
+	 * TODO: we just need this because one bit is in a different
+	 * place.  Is there any better way?
+	 */
+	wl->ops->ack_event(wl);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 38d1ed2..76c27dd 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -30,6 +30,8 @@
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
+	void (*trigger_cmd)(struct wl1271 *wl);
+	void (*ack_event)(struct wl1271 *wl);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
@@ -345,22 +347,6 @@ int wlcore_free_hw(struct wl1271 *wl);
 /* Hardware to Embedded CPU Interrupts - first 32-bit register set */
 
 /*
- * Host Command Interrupt. Setting this bit masks
- * the interrupt that the host issues to inform
- * the FW that it has sent a command
- * to the Wlan hardware Command Mailbox.
- */
-#define INTR_TRIG_CMD       BIT(0)
-
-/*
- * Host Event Acknowlegde Interrupt. The host
- * sets this bit to acknowledge that it received
- * the unsolicited information from the event
- * mailbox.
- */
-#define INTR_TRIG_EVENT_ACK BIT(1)
-
-/*
  * The host sets this bit to inform the Wlan
  * FW that a TX packet is in the XFER
  * Buffer #0.
-- 
1.7.5.4

