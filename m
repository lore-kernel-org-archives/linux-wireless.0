Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57153 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1BTM6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:13 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2477439eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:12 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/8] rt2x00: Add/Modify the GPIO register definition
Date: Sun, 20 Feb 2011 13:57:22 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201102201354.53379.IvDoorn@gmail.com> <201102201356.27555.IvDoorn@gmail.com> <201102201356.55216.IvDoorn@gmail.com>
In-Reply-To: <201102201356.55216.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102201357.23078.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shiang Tu <shiang_tu@ralinktech.com>

Revise/Add GPIO register related definitions

Signed-off-by: Shiang Tu <shiang_tu@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   10 ++++++++--
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index d3a693b..591ac32 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -281,8 +281,14 @@
 #define GPIO_CTRL_CFG_BIT5		FIELD32(0x00000020)
 #define GPIO_CTRL_CFG_BIT6		FIELD32(0x00000040)
 #define GPIO_CTRL_CFG_BIT7		FIELD32(0x00000080)
-#define GPIO_CTRL_CFG_BIT8		FIELD32(0x00000100)
-#define GPIO_CTRL_CFG_GPIOD		FIELD32(0x00000800)
+#define GPIO_CTRL_CFG_GPIOD_BIT0	FIELD32(0x00000100)
+#define GPIO_CTRL_CFG_GPIOD_BIT1	FIELD32(0x00000200)
+#define GPIO_CTRL_CFG_GPIOD_BIT2	FIELD32(0x00000400)
+#define GPIO_CTRL_CFG_GPIOD_BIT3	FIELD32(0x00000800)
+#define GPIO_CTRL_CFG_GPIOD_BIT4	FIELD32(0x00001000)
+#define GPIO_CTRL_CFG_GPIOD_BIT5	FIELD32(0x00002000)
+#define GPIO_CTRL_CFG_GPIOD_BIT6	FIELD32(0x00004000)
+#define GPIO_CTRL_CFG_GPIOD_BIT7	FIELD32(0x00008000)
 
 /*
  * MCU_CMD_CFG
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5592180..bed97eb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1384,7 +1384,7 @@ static void rt2800_set_ant_diversity(struct rt2x00_dev *rt2x00dev,
 				   eesk_pin, 0);
 
 	rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD, 0);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT3, 0);
 	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, gpio_bit3);
 	rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
 }
-- 
1.7.2.3

