Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab2EJJPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:10 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:09 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 18/78] wl18xx: implement hw op for getting rx buffer data alignment
Date: Thu, 10 May 2012 12:13:23 +0300
Message-Id: <1336641263-5761-19-git-send-email-arik@wizery.com> (sfid-20120510_112456_648219_3BE7FDA4)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the HW op for getting alignment state in wl18xx. The FW aligns
the Rx Ethernet payload data.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   13 +++++++++++++
 drivers/net/wireless/ti/wlcore/rx.h   |    3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index a074d81..fef8726 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -27,6 +27,8 @@
 #include "../wlcore/io.h"
 #include "../wlcore/acx.h"
 #include "../wlcore/tx.h"
+#include "../wlcore/rx.h"
+#include "../wlcore/io.h"
 #include "../wlcore/boot.h"
 
 #include "reg.h"
@@ -447,6 +449,16 @@ wl18xx_set_tx_desc_data_len(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 		     desc->wl18xx_mem.total_mem_blocks);
 }
 
+static enum wl_rx_buf_align
+wl18xx_get_rx_buf_align(struct wl1271 *wl, u32 rx_desc)
+{
+	if (rx_desc & RX_BUF_PADDED_PAYLOAD)
+		return WLCORE_RX_BUF_PADDED;
+
+	return WLCORE_RX_BUF_ALIGNED;
+}
+
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -455,6 +467,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.calc_tx_blocks = wl18xx_calc_tx_blocks,
 	.set_tx_desc_blocks = wl18xx_set_tx_desc_blocks,
 	.set_tx_desc_data_len = wl18xx_set_tx_desc_data_len,
+	.get_rx_buf_align = wl18xx_get_rx_buf_align,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index e9a162a..277936e 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -102,6 +102,9 @@
 /* If set, the start of IP payload is not 4 bytes aligned */
 #define RX_BUF_UNALIGNED_PAYLOAD     BIT(20)
 
+/* If set, the buffer was padded by the FW to be 4 bytes aligned */
+#define RX_BUF_PADDED_PAYLOAD        BIT(30)
+
 /* Describes the alignment state of a Rx buffer */
 enum wl_rx_buf_align {
 	WLCORE_RX_BUF_ALIGNED,
-- 
1.7.9.5

