Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43312 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab3EHIqB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 04:46:01 -0400
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id r488k0l1015582
	for <linux-wireless@vger.kernel.org>; Wed, 8 May 2013 03:46:00 -0500
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id r488k0nl002151
	for <linux-wireless@vger.kernel.org>; Wed, 8 May 2013 03:46:00 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH] wl18xx: use locally administered MAC address if not available from fuse
Date: Wed, 8 May 2013 11:44:37 +0300
Message-ID: <1368002677-16772-1-git-send-email-coelho@ti.com> (sfid-20130508_104610_134725_81F885B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some R&D chips, the device may be left untrimmed and with the MAC
address missing from fuse ROM.  In order to support those devices,
apply a locally administered MAC address instead and generate print
out a message to warn the user.

Based on the original patch by Victor Goldenshtein.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |    6 ++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ae85ae4..e296f34 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1318,6 +1318,12 @@ static int wl18xx_get_mac(struct wl1271 *wl)
 		((mac1 & 0xff000000) >> 24);
 	wl->fuse_nic_addr = (mac1 & 0xffffff);
 
+	if (!wl->fuse_oui_addr && !wl->fuse_nic_addr) {
+		wl->fuse_oui_addr = WL18XX_DEFAULT_LOCAL_OUI;
+		wl->fuse_nic_addr = WL18XX_DEFAULT_LOCAL_NIC;
+		wl1271_warning("MAC address from fuse ROM not available, using locally administered addresses.");
+	}
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 
 out:
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 9204e07..e76bfc7 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -42,6 +42,15 @@
 
 #define WL18XX_RX_BA_MAX_SESSIONS 5
 
+/*
+ * Locally administered MAC address to be used when unavailable in
+ * fuse ROM.  This is TI's 08:00:28 OUI with the locally administered
+ * bit set.  Note that this is actually the assigned BDADDR, the WLAN
+ * MAC addresses are generated incrementally from this one.
+ */
+#define WL18XX_DEFAULT_LOCAL_OUI	(0x0a0028)
+#define WL18XX_DEFAULT_LOCAL_NIC	(0x000000)
+
 struct wl18xx_priv {
 	/* buffer for sending commands to FW */
 	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
-- 
1.7.10.4

