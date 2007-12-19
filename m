Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:44869 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXLSQKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:25 -0500
Subject: [PATCH 120/48] libertas: allow for PS mode to be disabled when firmware doesn't support it
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50ty-00020K-7r@pmac.infradead.org> (sfid-20071219_161031_229476_F908DADA)
Date: Wed, 19 Dec 2007 15:32:06 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 14:41:13 -0500

Otherwise, we go into an endless busy loop trying to enable PS mode when
the command queue is empty, dealing with the error response, and then
trying to enable PS mode again because the command queue is empty.... it
doesn't really save much power.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/dev.h  |    1 +
 drivers/net/wireless/libertas/host.h |    5 +++++
 drivers/net/wireless/libertas/wext.c |    7 +++++++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index fe50457..1c6ec4d 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -260,6 +260,7 @@ struct lbs_private {
 	u16 psmode;		/* Wlan802_11PowermodeCAM=disable
 				   Wlan802_11PowermodeMAX_PSP=enable */
 	u32 psstate;
+	char ps_supported;
 	u8 needtowakeup;
 
 	struct PS_CMD_ConfirmSleep lbs_ps_confirm_sleep;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 4c03e12..1aa0407 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -209,6 +209,11 @@
 #define	CMD_TYPE_MAX_PSP		0x0001
 #define CMD_TYPE_FAST_PSP		0x0002
 
+/* Options for CMD_802_11_FW_WAKE_METHOD */
+#define CMD_WAKE_METHOD_UNCHANGED	0x0000
+#define CMD_WAKE_METHOD_COMMAND_INT	0x0001
+#define CMD_WAKE_METHOD_GPIO		0x0002
+
 /* Define action or option for CMD_BT_ACCESS */
 enum cmd_bt_access_opts {
 	/* The bt commands start at 5 instead of 1 because the old dft commands
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index b1e2472..3e8d555 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -734,6 +734,13 @@ static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!priv->ps_supported) {
+		if (vwrq->disabled)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
 	/* PS is currently supported only in Infrastructure mode
 	 * Remove this check if it is to be supported in IBSS mode also
 	 */
-- 
1.5.3.4

