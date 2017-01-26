Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:47997 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbdAZPNj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 10:13:39 -0500
Received: from dflxv15.itg.ti.com ([128.247.5.124])
        by fllnx210.ext.ti.com (8.15.1/8.15.1) with ESMTP id v0QFDc8e002832
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2017 09:13:38 -0600
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
        by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id v0QFDc7b031303
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2017 09:13:38 -0600
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wlcore: print the sdio buffer after reading it
Date: Thu, 26 Jan 2017 17:35:13 +0200
Message-ID: <20170126153513.25007-1-guym@ti.com> (sfid-20170126_161342_714977_7428CB94)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix an issue where we printed the sdio buffer before
actually read it.

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 47fe7f9..287023e 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -81,13 +81,6 @@ static int __must_check wl12xx_sdio_raw_read(struct device *child, int addr,
 
 	sdio_claim_host(func);
 
-	if (unlikely(dump)) {
-		printk(KERN_DEBUG "wlcore_sdio: READ from 0x%04x\n", addr);
-		print_hex_dump(KERN_DEBUG, "wlcore_sdio: READ ",
-				DUMP_PREFIX_OFFSET, 16, 1,
-				buf, len, false);
-	}
-
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		dev_dbg(child->parent, "sdio read 52 addr 0x%x, byte 0x%02x\n",
@@ -107,6 +100,13 @@ static int __must_check wl12xx_sdio_raw_read(struct device *child, int addr,
 	if (WARN_ON(ret))
 		dev_err(child->parent, "sdio read failed (%d)\n", ret);
 
+	if (unlikely(dump)) {
+		printk(KERN_DEBUG "wlcore_sdio: READ from 0x%04x\n", addr);
+		print_hex_dump(KERN_DEBUG, "wlcore_sdio: READ ",
+			       DUMP_PREFIX_OFFSET, 16, 1,
+			       buf, len, false);
+	}
+
 	return ret;
 }
 
-- 
2.6.4
