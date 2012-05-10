Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab2EJJPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:01 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:01 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 14/78] wl18xx: implement hw op for setting frame length in tx_hw_desc
Date: Thu, 10 May 2012 12:13:19 +0300
Message-Id: <1336641263-5761-15-git-send-email-arik@wizery.com> (sfid-20120510_112552_665595_6C444981)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the frame length during Tx in a way compatible with the 18xx FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c85492e..0a5422c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -321,6 +321,19 @@ wl18xx_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 	desc->wl18xx_mem.reserved = 0;
 }
 
+static void
+wl18xx_set_tx_desc_data_len(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
+			    struct sk_buff *skb)
+{
+	desc->length = cpu_to_le16(skb->len);
+
+	wl1271_debug(DEBUG_TX, "tx_fill_hdr: hlid: %d "
+		     "len: %d life: %d mem: %d", desc->hlid,
+		     le16_to_cpu(desc->length),
+		     le16_to_cpu(desc->life_time),
+		     desc->wl18xx_mem.total_mem_blocks);
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -328,6 +341,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.ack_event	= wl18xx_ack_event,
 	.calc_tx_blocks = wl18xx_calc_tx_blocks,
 	.set_tx_desc_blocks = wl18xx_set_tx_desc_blocks,
+	.set_tx_desc_data_len = wl18xx_set_tx_desc_data_len,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
-- 
1.7.9.5

