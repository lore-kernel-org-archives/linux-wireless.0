Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35772 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbKHHuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:39 -0500
Received: by pasz6 with SMTP id z6so170553746pas.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:38 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 22/32] staging: wilc1000: rename u8KeyLen in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:15 +0900
Message-Id: <1446968965-8958-22-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_091410_256912_E34D00A9)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8KeyLen to key_len to avoid camelcase.
It is used as local variable in order to save gtk_key_len that is
argument of this function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7b647ce..0028bed 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3281,7 +3281,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	u8 u8KeyLen = gtk_key_len;
+	u8 key_len = gtk_key_len;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -3290,10 +3290,10 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (rx_mic)
-		u8KeyLen += RX_MIC_KEY_LEN;
+		key_len += RX_MIC_KEY_LEN;
 
 	if (tx_mic)
-		u8KeyLen += TX_MIC_KEY_LEN;
+		key_len += TX_MIC_KEY_LEN;
 
 	if (key_rsc) {
 		msg.body.key_info.attr.wpa.seq = kmalloc(key_rsc_len, GFP_KERNEL);
@@ -3311,7 +3311,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.key = kmalloc(u8KeyLen, GFP_KERNEL);
+	msg.body.key_info.attr.wpa.key = kmalloc(key_len, GFP_KERNEL);
 	memcpy(msg.body.key_info.attr.wpa.key, rx_gtk, gtk_key_len);
 
 	if (rx_mic)
@@ -3323,7 +3323,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 		       TX_MIC_KEY_LEN);
 
 	msg.body.key_info.attr.wpa.index = index;
-	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
+	msg.body.key_info.attr.wpa.key_len = key_len;
 	msg.body.key_info.attr.wpa.seq_len = key_rsc_len;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.6.3

