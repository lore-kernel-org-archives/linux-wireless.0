Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab2EJJPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:12 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:12 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 19/78] wl18xx: implement hw op for getting rx packet data length
Date: Thu, 10 May 2012 12:13:24 +0300
Message-Id: <1336641263-5761-20-git-send-email-arik@wizery.com> (sfid-20120510_112501_832930_EDAB5ECD)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the 18xx-specific way for getting the length of a Rx packet.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index fef8726..40ed53c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -458,6 +458,17 @@ wl18xx_get_rx_buf_align(struct wl1271 *wl, u32 rx_desc)
 	return WLCORE_RX_BUF_ALIGNED;
 }
 
+static u32 wl18xx_get_rx_packet_len(struct wl1271 *wl, void *rx_data,
+				    u32 data_len)
+{
+	struct wl1271_rx_descriptor *desc = rx_data;
+
+	/* invalid packet */
+	if (data_len < sizeof(*desc))
+		return 0;
+
+	return data_len - sizeof(*desc);
+}
 
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
@@ -468,6 +479,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.set_tx_desc_blocks = wl18xx_set_tx_desc_blocks,
 	.set_tx_desc_data_len = wl18xx_set_tx_desc_data_len,
 	.get_rx_buf_align = wl18xx_get_rx_buf_align,
+	.get_rx_packet_len = wl18xx_get_rx_packet_len,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
-- 
1.7.9.5

