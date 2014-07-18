Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:61080 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaGRFhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:24 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so3987680wes.6
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/9] staging: vt6656: remove dead structure struct vnt_tx_pkt_info
Date: Fri, 18 Jul 2014 06:36:12 +0100
Message-Id: <1405661776-3345-5-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073732_002452_4634C37E)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 8f318a9..f3ff6f5 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -240,12 +240,6 @@ struct vnt_usb_send_context {
 	unsigned char data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
 };
 
-/* tx packet info for rxtx */
-struct vnt_tx_pkt_info {
-	u16 fifo_ctl;
-	u8 dest_addr[ETH_ALEN];
-};
-
 /*
  * Structure to keep track of USB interrupt packets
  */
@@ -300,7 +294,6 @@ struct vnt_private {
 	/* Variables to track resources for the BULK Out Pipe */
 	struct vnt_usb_send_context *apTD[CB_MAX_TX_DESC];
 	u32 cbTD;
-	struct vnt_tx_pkt_info pkt_info[16];
 
 	/* Variables to track resources for the Interrupt In Pipe */
 	struct vnt_interrupt_buffer int_buf;
-- 
2.0.1

