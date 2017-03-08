Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:47385 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdCIAse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 19:48:34 -0500
Date: Thu, 9 Mar 2017 00:54:22 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: fix TX_PWR_CFG_4 register definition
Message-ID: <20170308235412.GA22227@makrotopia.org> (sfid-20170309_014913_870472_7C42D32D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the macros used to describe the TX_PWR_CFG_4 register accidentally
refer to TX_PWR_CFG_3, probably a copy&paste error. Fix that.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 480b08601785..fd1dbd956bad 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -1171,10 +1171,10 @@
 #define TX_PWR_CFG_4_UKNOWN7		FIELD32(0x00000f00)
 #define TX_PWR_CFG_4_UKNOWN8		FIELD32(0x0000f000)
 /* bits for 3T devices */
-#define TX_PWR_CFG_3_STBC4_CH0		FIELD32(0x0000000f)
-#define TX_PWR_CFG_3_STBC4_CH1		FIELD32(0x000000f0)
-#define TX_PWR_CFG_3_STBC6_CH0		FIELD32(0x00000f00)
-#define TX_PWR_CFG_3_STBC6_CH1		FIELD32(0x0000f000)
+#define TX_PWR_CFG_4_STBC4_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_4_STBC4_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_4_STBC6_CH0		FIELD32(0x00000f00)
+#define TX_PWR_CFG_4_STBC6_CH1		FIELD32(0x0000f000)
 
 /*
  * TX_PIN_CFG:
-- 
2.11.1
