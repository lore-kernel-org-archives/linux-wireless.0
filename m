Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:44671 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdAMVV3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:21:29 -0500
Date: Fri, 13 Jan 2017 22:21:20 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 06/40] rt2x00: rt2800lib: init additional beacon offset
 registers
Message-ID: <20170113212115.GA3391@makrotopia.org> (sfid-20170113_222131_764251_814AAAB9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    | 14 ++++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 24 ++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index a81852cfb4f9..02ed0d512734 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -629,6 +629,20 @@
  */
 #define PBF_DBG				0x043c
 
+/* BCN_OFFSET2 */
+#define BCN_OFFSET2			0x0444
+#define BCN_OFFSET2_BCN8		FIELD32(0x000000ff)
+#define BCN_OFFSET2_BCN9		FIELD32(0x0000ff00)
+#define BCN_OFFSET2_BCN10		FIELD32(0x00ff0000)
+#define BCN_OFFSET2_BCN11		FIELD32(0xff000000)
+
+/* BCN_OFFSET3 */
+#define BCN_OFFSET3			0x0448
+#define BCN_OFFSET3_BCN12		FIELD32(0x000000ff)
+#define BCN_OFFSET3_BCN13		FIELD32(0x0000ff00)
+#define BCN_OFFSET3_BCN14		FIELD32(0x00ff0000)
+#define BCN_OFFSET3_BCN15		FIELD32(0xff000000)
+
 /*
  * RF registers
  */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 0893d9147af9..5058494d6c27 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4665,6 +4665,30 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	if (ret)
 		return ret;
 
+	if (drv_data->hw_beacon_count == 16) {
+		rt2800_register_read(rt2x00dev, BCN_OFFSET2, &reg);
+		rt2x00_set_field32(&reg, BCN_OFFSET2_BCN8,
+				   rt2800_get_beacon_offset(rt2x00dev, 8));
+		rt2x00_set_field32(&reg, BCN_OFFSET2_BCN9,
+				   rt2800_get_beacon_offset(rt2x00dev, 9));
+		rt2x00_set_field32(&reg, BCN_OFFSET2_BCN10,
+				   rt2800_get_beacon_offset(rt2x00dev, 10));
+		rt2x00_set_field32(&reg, BCN_OFFSET2_BCN11,
+				   rt2800_get_beacon_offset(rt2x00dev, 11));
+		rt2800_register_write(rt2x00dev, BCN_OFFSET2, reg);
+
+		rt2800_register_read(rt2x00dev, BCN_OFFSET3, &reg);
+		rt2x00_set_field32(&reg, BCN_OFFSET3_BCN12,
+				   rt2800_get_beacon_offset(rt2x00dev, 12));
+		rt2x00_set_field32(&reg, BCN_OFFSET3_BCN13,
+				   rt2800_get_beacon_offset(rt2x00dev, 13));
+		rt2x00_set_field32(&reg, BCN_OFFSET3_BCN14,
+				   rt2800_get_beacon_offset(rt2x00dev, 14));
+		rt2x00_set_field32(&reg, BCN_OFFSET3_BCN15,
+				   rt2800_get_beacon_offset(rt2x00dev, 15));
+		rt2800_register_write(rt2x00dev, BCN_OFFSET3, reg);
+	}
+
 	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
 	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
 
-- 
2.11.0
