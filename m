Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2EJJO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:57 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:57 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 12/78] wl18xx: implement hw op for calculating hw block count per packet
Date: Thu, 10 May 2012 12:13:17 +0300
Message-Id: <1336641263-5761-13-git-send-email-arik@wizery.com> (sfid-20120510_111501_733107_82225D49)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the calc_tx_blocks op for the 18xx family.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 70683ad..055b194 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -34,6 +34,7 @@
 
 #define WL18XX_TX_HW_BLOCK_SPARE        1
 #define WL18XX_TX_HW_GEM_BLOCK_SPARE    2
+#define WL18XX_TX_HW_BLOCK_SIZE         268
 
 static struct wl18xx_conf wl18xx_default_conf = {
 	.phy = {
@@ -305,11 +306,18 @@ static void wl18xx_ack_event(struct wl1271 *wl)
 	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL18XX_INTR_TRIG_EVENT_ACK);
 }
 
+static u32 wl18xx_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
+{
+	u32 blk_size = WL18XX_TX_HW_BLOCK_SIZE;
+	return (len + blk_size - 1) / blk_size + spare_blks;
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
 	.trigger_cmd	= wl18xx_trigger_cmd,
 	.ack_event	= wl18xx_ack_event,
+	.calc_tx_blocks = wl18xx_calc_tx_blocks,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
-- 
1.7.9.5

