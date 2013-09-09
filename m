Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3IIKgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 06:36:51 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH 2/2] rt2800: comment enable radio initialization sequence
Date: Mon,  9 Sep 2013 12:37:38 +0200
Message-Id: <1378723058-7858-2-git-send-email-sgruszka@redhat.com> (sfid-20130909_123654_890973_F7CE13EA)
In-Reply-To: <1378723058-7858-1-git-send-email-sgruszka@redhat.com>
References: <1378723058-7858-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 8f6820a..959f94f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6625,17 +6625,20 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	u16 word;
 
 	/*
-	 * Initialize all registers.
+	 * Initialize MAC registers.
 	 */
 	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
 		     rt2800_init_registers(rt2x00dev)))
 		return -EIO;
 
+	/*
+	 * Wait BBP/RF to wake up.
+	 */
 	if (unlikely(rt2800_wait_bbp_rf_ready(rt2x00dev)))
 		return -EIO;
 
 	/*
-	 * Send signal to firmware during boot time.
+	 * Send signal during boot time to initialize firmware.
 	 */
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
@@ -6644,9 +6647,15 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
 	msleep(1);
 
+	/*
+	 * Make sure BBP is up and running.
+	 */
 	if (unlikely(rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EIO;
 
+	/*
+	 * Initialize BBP/RF registers.
+	 */
 	rt2800_init_bbp(rt2x00dev);
 	rt2800_init_rfcsr(rt2x00dev);
 
-- 
1.7.11.7

