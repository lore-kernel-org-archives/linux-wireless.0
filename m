Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1A3MYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:45 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:44 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/21] rt2x00: Correct initial value of US_CYC_CNT register for pcie interface
Date: Sun, 30 Jan 2011 13:21:22 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301320.29903.IvDoorn@gmail.com> <201101301320.53735.IvDoorn@gmail.com>
In-Reply-To: <201101301320.53735.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301321.23510.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <jay_hung@ralinktech.com>

CLOCK CYCLE: Clock cycle count in 1us
PCI:0x21, PCIE:0x7d, USB:0x1e

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    4 ++++
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index c7e615c..ec8159c 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -372,8 +372,12 @@
 
 /*
  * US_CYC_CNT
+ * BT_MODE_EN: Bluetooth mode enable
+ * CLOCK CYCLE: Clock cycle count in 1us.
+ * PCI:0x21, PCIE:0x7d, USB:0x1e
  */
 #define US_CYC_CNT			0x02a4
+#define US_CYC_CNT_BT_MODE_EN		FIELD32(0x00000100)
 #define US_CYC_CNT_CLOCK_CYCLE		FIELD32(0x000000ff)
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4753fb1..4c34fce 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2207,6 +2207,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_read(rt2x00dev, US_CYC_CNT, &reg);
 		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, 30);
 		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
+	} else if (rt2x00_is_pcie(rt2x00dev)) {
+		rt2800_register_read(rt2x00dev, US_CYC_CNT, &reg);
+		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, 125);
+		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
 	}
 
 	rt2800_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
-- 
1.7.2.3

