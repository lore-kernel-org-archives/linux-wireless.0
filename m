Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48204 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3GHOIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 01/20] rt2x00: rt2800lib: add MAC register initialization for RT3593
Date: Mon,  8 Jul 2013 16:08:16 +0200
Message-Id: <1373292515-21332-2-git-send-email-juhosg@openwrt.org> (sfid-20130708_160850_192893_674B613C)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  NICInitRT3593MacRegisters in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9216834..02bc80d 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -88,6 +88,7 @@
 #define REV_RT3071E			0x0211
 #define REV_RT3090E			0x0211
 #define REV_RT3390E			0x0211
+#define REV_RT3593E			0x0211
 #define REV_RT5390F			0x0502
 #define REV_RT5390R			0x1502
 #define REV_RT5592C			0x0221
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d325ca2..bfeca29 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3714,6 +3714,23 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT3572)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
+	} else if (rt2x00_rt(rt2x00dev, RT3593)) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000402);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3593, REV_RT3593E)) {
+			rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1,
+					   &eeprom);
+			if (rt2x00_get_field16(eeprom,
+					       EEPROM_NIC_CONF1_DAC_TEST))
+				rt2800_register_write(rt2x00dev, TX_SW_CFG2,
+						      0x0000001f);
+			else
+				rt2800_register_write(rt2x00dev, TX_SW_CFG2,
+						      0x0000000f);
+		} else {
+			rt2800_register_write(rt2x00dev, TX_SW_CFG2,
+					      0x00000000);
+		}
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
 		   rt2x00_rt(rt2x00dev, RT5392) ||
 		   rt2x00_rt(rt2x00dev, RT5592)) {
-- 
1.7.10

