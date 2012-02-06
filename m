Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1475 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428Ab2BFW7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:04 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 7/8] rt2x00: Fix RT3572 channel switch RFCSR 7 programming.
Date: Mon,  6 Feb 2012 23:45:12 +0100
Message-Id: <1328568313-26267-8-git-send-email-gwingerde@gmail.com> (sfid-20120206_235911_977556_DDF68256)
In-Reply-To: <1328568313-26267-7-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-2-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-4-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-5-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-6-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-7-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align with the v2.5.0.0 Ralink RT3572 driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 8aabd0d..c6648b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1819,10 +1819,12 @@ struct mac_iveiv_entry {
  * RFCSR 7:
  */
 #define RFCSR7_RF_TUNING		FIELD8(0x01)
-#define RFCSR7_R02				FIELD8(0x07)
-#define RFCSR7_R3				FIELD8(0x08)
-#define RFCSR7_R45				FIELD8(0x30)
-#define RFCSR7_R67				FIELD8(0xc0)
+#define RFCSR7_BIT1			FIELD8(0x02)
+#define RFCSR7_BIT2			FIELD8(0x04)
+#define RFCSR7_BIT3			FIELD8(0x08)
+#define RFCSR7_BIT4			FIELD8(0x10)
+#define RFCSR7_BIT5			FIELD8(0x20)
+#define RFCSR7_BITS67			FIELD8(0xc0)
 
 /*
  * RFCSR 11:
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2afb798..28dc6ba 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1865,7 +1865,12 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
 		rt2800_rfcsr_write(rt2x00dev, 29, 0x9b);
 	} else {
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x14);
+		rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR7_BIT2, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR7_BIT3, 0);
+		rt2x00_set_field8(&rfcsr, RFCSR7_BIT4, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR7_BITS67, 0);
+		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 		rt2800_rfcsr_write(rt2x00dev, 9, 0xc0);
 		rt2800_rfcsr_write(rt2x00dev, 10, 0xf1);
 		rt2800_rfcsr_write(rt2x00dev, 11, 0x00);
-- 
1.7.9

