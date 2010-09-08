Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36123 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0IHS6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 14:58:10 -0400
Received: by ewy23 with SMTP id 23so343042ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 11:58:08 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/06] rt2x00: Initialize AMPDU_BA_WINSIZE register
Date: Wed, 8 Sep 2010 20:56:04 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201009082055.38033.IvDoorn@gmail.com>
In-Reply-To: <201009082055.38033.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009082056.05708.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since we're not using the AMPDU_BA_WINSIZE register to force the BlockAck
window size (we specify it in every TXWI) we should initialize it to 0.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   12 ++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 70a5cb8..2edc774 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -639,6 +639,18 @@
 #define LED_CFG_LED_POLAR		FIELD32(0x40000000)
 
 /*
+ * AMPDU_BA_WINSIZE: Force BlockAck window size
+ * FORCE_WINSIZE_ENABLE:
+ *   0: Disable forcing of BlockAck window size
+ *   1: Enable forcing of BlockAck window size, overwrites values BlockAck
+ *      window size values in the TXWI
+ * FORCE_WINSIZE: BlockAck window size
+ */
+#define AMPDU_BA_WINSIZE		0x1040
+#define AMPDU_BA_WINSIZE_FORCE_WINSIZE_ENABLE FIELD32(0x00000020)
+#define AMPDU_BA_WINSIZE_FORCE_WINSIZE	FIELD32(0x0000001f)
+
+/*
  * XIFS_TIME_CFG: MAC timing
  * CCKM_SIFS_TIME: unit 1us. Applied after CCK RX/TX
  * OFDM_SIFS_TIME: unit 1us. Applied after OFDM RX/TX
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 27a6e22..9cfb9b31 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2053,6 +2053,14 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);
 
 	/*
+	 * Do not force the BA window size, we use the TXWI to set it
+	 */
+	rt2800_register_read(rt2x00dev, AMPDU_BA_WINSIZE, &reg);
+	rt2x00_set_field32(&reg, AMPDU_BA_WINSIZE_FORCE_WINSIZE_ENABLE, 0);
+	rt2x00_set_field32(&reg, AMPDU_BA_WINSIZE_FORCE_WINSIZE, 0);
+	rt2800_register_write(rt2x00dev, AMPDU_BA_WINSIZE, reg);
+
+	/*
 	 * We must clear the error counters.
 	 * These registers are cleared on read,
 	 * so we may pass a useless variable to store the value.
-- 
1.7.2.2

