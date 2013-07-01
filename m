Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47472 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab3GAHsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 03:48:18 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 01/20] rt2x00: rt2800lib: add MAC register initialization for RT3593
Date: Mon,  1 Jul 2013 09:47:40 +0200
Message-Id: <1372664879-18474-2-git-send-email-juhosg@openwrt.org> (sfid-20130701_094826_239612_62A7756B)
In-Reply-To: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  NICInitRT3593MacRegisters in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
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
index 7b216f9..6f58ceb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3715,6 +3715,23 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
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

