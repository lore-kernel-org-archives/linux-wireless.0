Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35626 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbIPLL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:11:57 -0400
Received: by pacfv12 with SMTP id fv12so210908339pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:11:57 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/10] staging: wilc1000: linux_wlan_spi.c: fix kzalloc error check
Date: Wed, 16 Sep 2015 20:11:31 +0900
Message-Id: <1442401895-7463-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131200_421729_6E5C0376)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixs error check of kzalloc.
If kzalloc is failed, return type is used as -ENOMEM.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 3e24256..51bbd96 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -125,10 +125,8 @@ int linux_spi_write(u8 *b, u32 len)
 		int remainder = len % TXRX_PHASE_SIZE;
 
 		char *r_buffer = kzalloc(TXRX_PHASE_SIZE, GFP_KERNEL);
-
-		if (!r_buffer) {
-			PRINT_ER("Failed to allocate memory for r_buffer\n");
-		}
+		if (!r_buffer)
+			return -ENOMEM;
 
 		if (blk) {
 			while (i < blk)	{
@@ -208,10 +206,9 @@ int linux_spi_write(u8 *b, u32 len)
 			.delay_usecs = 0,
 		};
 		char *r_buffer = kzalloc(len, GFP_KERNEL);
+		if (!r_buffer)
+			return -ENOMEM;
 
-		if (!r_buffer) {
-			PRINT_ER("Failed to allocate memory for r_buffer\n");
-		}
 		tr.rx_buf = r_buffer;
 		PRINT_D(BUS_DBG, "Request writing %d bytes\n", len);
 
@@ -257,10 +254,8 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 		int remainder = rlen % TXRX_PHASE_SIZE;
 
 		char *t_buffer = kzalloc(TXRX_PHASE_SIZE, GFP_KERNEL);
-
-		if (!t_buffer) {
-			PRINT_ER("Failed to allocate memory for t_buffer\n");
-		}
+		if (!t_buffer)
+			return -ENOMEM;
 
 		if (blk) {
 			while (i < blk)	{
@@ -337,10 +332,9 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 
 		};
 		char *t_buffer = kzalloc(rlen, GFP_KERNEL);
+		if (!t_buffer)
+			return -ENOMEM;
 
-		if (!t_buffer) {
-			PRINT_ER("Failed to allocate memory for t_buffer\n");
-		}
 		tr.tx_buf = t_buffer;
 
 		memset(&msg, 0, sizeof(msg));
-- 
2.5.1

