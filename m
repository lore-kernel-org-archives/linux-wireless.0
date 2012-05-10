Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409Ab2EJJQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:21 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:20 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 50/78] wl18xx: derive the MAC address from the BD_ADDR in fuse ROM
Date: Thu, 10 May 2012 12:13:55 +0300
Message-Id: <1336641263-5761-51-git-send-email-arik@wizery.com> (sfid-20120510_111930_080082_ED395465)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add the get_mac operation in order to fetch the BD_ADDR from fuse ROM,
so that we can derive the WLAN MAC addresses from it.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   18 ++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/reg.h  |    3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index df407be..52d63ff 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -975,6 +975,23 @@ static int wl18xx_plt_init(struct wl1271 *wl)
 	return wl->ops->boot(wl);
 }
 
+static void wl18xx_get_mac(struct wl1271 *wl)
+{
+	u32 mac1, mac2;
+
+	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+
+	mac1 = wl1271_read32(wl, WL18XX_REG_FUSE_BD_ADDR_1);
+	mac2 = wl1271_read32(wl, WL18XX_REG_FUSE_BD_ADDR_2);
+
+	/* these are the two parts of the BD_ADDR */
+	wl->fuse_oui_addr = ((mac2 & 0xffff) << 8) +
+		((mac1 & 0xff000000) >> 24);
+	wl->fuse_nic_addr = (mac1 & 0xffffff);
+
+	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -994,6 +1011,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.set_rx_csum = wl18xx_set_rx_csum,
 	.sta_get_ap_rate_mask = wl18xx_sta_get_ap_rate_mask,
 	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
+	.get_mac	= wl18xx_get_mac,
 };
 
 /* HT cap appropriate for wide channels */
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index aaedf91..43863d3 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -132,6 +132,9 @@
 #define WL18XX_PG_VER_MASK		0x70
 #define WL18XX_PG_VER_OFFSET		4
 
+#define WL18XX_REG_FUSE_BD_ADDR_1	0xA02602
+#define WL18XX_REG_FUSE_BD_ADDR_2	0xA02606
+
 #define WL18XX_CMD_MBOX_ADDRESS		0xB007B4
 
 #define WL18XX_FW_STATUS_ADDR		0x50F8
-- 
1.7.9.5

