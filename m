Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:32778 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab0DWNyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 09:54:54 -0400
Received: by bwz25 with SMTP id 25so11241198bwz.28
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 06:54:53 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: rt2800: use tx_power2 in rt2800_config_channel_rf3xxx
Date: Fri, 23 Apr 2010 15:54:43 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004231554.43474.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get closer to what the ralink driver does by setting the rf register 13
to tx_power2 during channel switch.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Just found that difference between rt2x00 and the ralink driver.
However I couldn't see any obvious improvements. So, this change
is mostly for completeness.

 drivers/net/wireless/rt2x00/rt2800.h    |    5 +++++
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index ec89372..1c59dc6 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1566,6 +1566,11 @@ struct mac_iveiv_entry {
 #define RFCSR12_TX_POWER		FIELD8(0x1f)
 
 /*
+ * RFCSR 13:
+ */
+#define RFCSR13_TX_POWER		FIELD8(0x1f)
+
+/*
  * RFCSR 15:
  */
 #define RFCSR15_TX_LO2_EN		FIELD8(0x08)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index aa02ff6..3ee9882 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -794,6 +794,11 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 			  TXPOWER_G_TO_DEV(info->tx_power1));
 	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
+	rt2800_rfcsr_read(rt2x00dev, 13, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
+			  TXPOWER_G_TO_DEV(info->tx_power2));
+	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
+
 	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
-- 
1.6.4.2

