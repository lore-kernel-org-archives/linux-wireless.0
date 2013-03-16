Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36934 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab3CPSTm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:42 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 06/25] rt2800: 5592: BBP registers initialization
Date: Sat, 16 Mar 2013 19:19:34 +0100
Message-Id: <1363457993-15541-7-git-send-email-stf_xl@wp.pl> (sfid-20130316_191945_334982_A2B81661)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
NICInitRT5592BbpRegisters()
NICInitBBP()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/common/rtmp_init.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   24 ++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |  110 +++++++++++++++++++++++++++++--
 2 files changed, 125 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index acb5e62..9d18d53 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -90,11 +90,8 @@
 #define REV_RT3390E			0x0211
 #define REV_RT5390F			0x0502
 #define REV_RT5390R			0x1502
+#define REV_RT5592C			0x0221
 
-/*
- * Signal information.
- * Default offset is required for RSSI <-> dBm conversion.
- */
 #define DEFAULT_RSSI_OFFSET		120
 
 /*
@@ -1956,6 +1953,20 @@ struct mac_iveiv_entry {
 #define BBP49_UPDATE_FLAG		FIELD8(0x01)
 
 /*
+ * BBP 105:
+ * - bit0: detect SIG on primary channel only (on 40MHz bandwidth)
+ * - bit1: FEQ (Feed Forward Compensation) for independend streams
+ * - bit2: MLD (Maximum Likehood Detection) for 2 streams (reserved on single
+ *	   stream)
+ * - bit4: channel estimation updates based on remodulation of
+ *	   L-SIG and HT-SIG symbols
+ */
+#define BBP105_DETECT_SIG_ON_PRIMARY	FIELD8(0x01)
+#define BBP105_FEQ			FIELD8(0x02)
+#define BBP105_MLD			FIELD8(0x04)
+#define BBP105_SIG_REMODULATION		FIELD8(0x08)
+
+/*
  * BBP 109
  */
 #define BBP109_TX0_POWER		FIELD8(0x0f)
@@ -1975,6 +1986,11 @@ struct mac_iveiv_entry {
 #define BBP152_RX_DEFAULT_ANT		FIELD8(0x80)
 
 /*
+ * BBP 254: unknown
+ */
+#define BBP254_BIT7			FIELD8(0x80)
+
+/*
  * RFCSR registers
  * The wordsize of the RFCSR is 8 bits.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a35bce4..16e4200 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3744,6 +3744,104 @@ static int rt2800_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 	return -EACCES;
 }
 
+static void rt2800_bbp4_mac_if_ctrl(struct rt2x00_dev *rt2x00dev)
+{
+	u8 value;
+
+	rt2800_bbp_read(rt2x00dev, 4, &value);
+	rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
+	rt2800_bbp_write(rt2x00dev, 4, value);
+}
+
+static void rt2800_init_bbp_5592_glrt(struct rt2x00_dev *rt2x00dev)
+{
+	const u8 glrt_table[] = {
+		0xE0, 0x1F, 0X38, 0x32, 0x08, 0x28, 0x19, 0x0A, 0xFF, 0x00, /* 128 ~ 137 */
+		0x16, 0x10, 0x10, 0x0B, 0x36, 0x2C, 0x26, 0x24, 0x42, 0x36, /* 138 ~ 147 */
+		0x30, 0x2D, 0x4C, 0x46, 0x3D, 0x40, 0x3E, 0x42, 0x3D, 0x40, /* 148 ~ 157 */
+		0X3C, 0x34, 0x2C, 0x2F, 0x3C, 0x35, 0x2E, 0x2A, 0x49, 0x41, /* 158 ~ 167 */
+		0x36, 0x31, 0x30, 0x30, 0x0E, 0x0D, 0x28, 0x21, 0x1C, 0x16, /* 168 ~ 177 */
+		0x50, 0x4A, 0x43, 0x40, 0x10, 0x10, 0x10, 0x10, 0x00, 0x00, /* 178 ~ 187 */
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 188 ~ 197 */
+		0x00, 0x00, 0x7D, 0x14, 0x32, 0x2C, 0x36, 0x4C, 0x43, 0x2C, /* 198 ~ 207 */
+		0x2E, 0x36, 0x30, 0x6E,					    /* 208 ~ 211 */
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(glrt_table); i++) {
+		rt2800_bbp_write(rt2x00dev, 195, 128 + i);
+		rt2800_bbp_write(rt2x00dev, 196, glrt_table[i]);
+	}
+};
+
+static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
+{
+	int ant, div_mode;
+	u16 eeprom;
+	u8 value;
+
+	rt2800_bbp_read(rt2x00dev, 105, &value);
+	rt2x00_set_field8(&value, BBP105_MLD,
+			  rt2x00dev->default_ant.rx_chain_num == 2);
+	rt2800_bbp_write(rt2x00dev, 105, value);
+
+	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
+
+	rt2800_bbp_write(rt2x00dev, 20, 0x06);
+	rt2800_bbp_write(rt2x00dev, 31, 0x08);
+	rt2800_bbp_write(rt2x00dev, 65, 0x2C);
+	rt2800_bbp_write(rt2x00dev, 68, 0xDD);
+	rt2800_bbp_write(rt2x00dev, 69, 0x1A);
+	rt2800_bbp_write(rt2x00dev, 70, 0x05);
+	rt2800_bbp_write(rt2x00dev, 73, 0x13);
+	rt2800_bbp_write(rt2x00dev, 74, 0x0F);
+	rt2800_bbp_write(rt2x00dev, 75, 0x4F);
+	rt2800_bbp_write(rt2x00dev, 76, 0x28);
+	rt2800_bbp_write(rt2x00dev, 77, 0x59);
+	rt2800_bbp_write(rt2x00dev, 84, 0x9A);
+	rt2800_bbp_write(rt2x00dev, 86, 0x38);
+	rt2800_bbp_write(rt2x00dev, 88, 0x90);
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+	rt2800_bbp_write(rt2x00dev, 92, 0x02);
+	rt2800_bbp_write(rt2x00dev, 95, 0x9a);
+	rt2800_bbp_write(rt2x00dev, 98, 0x12);
+	rt2800_bbp_write(rt2x00dev, 103, 0xC0);
+	rt2800_bbp_write(rt2x00dev, 104, 0x92);
+	/* FIXME BBP105 owerwrite */
+	rt2800_bbp_write(rt2x00dev, 105, 0x3C);
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
+	rt2800_bbp_write(rt2x00dev, 128, 0x12);
+	rt2800_bbp_write(rt2x00dev, 134, 0xD0);
+	rt2800_bbp_write(rt2x00dev, 135, 0xF6);
+	rt2800_bbp_write(rt2x00dev, 137, 0x0F);
+
+	/* Initialize GLRT (Generalized Likehood Radio Test) */
+	rt2800_init_bbp_5592_glrt(rt2x00dev);
+
+	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	div_mode = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_ANT_DIVERSITY);
+	ant = (div_mode == 3) ? 1 : 0;
+	rt2800_bbp_read(rt2x00dev, 152, &value);
+	if (ant == 0) {
+		/* Main antenna */
+		rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
+	} else {
+		/* Auxiliary antenna */
+		rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 0);
+	}
+	rt2800_bbp_write(rt2x00dev, 152, value);
+
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5592, REV_RT5592C)) {
+		rt2800_bbp_read(rt2x00dev, 254, &value);
+		rt2x00_set_field8(&value, BBP254_BIT7, 1);
+		rt2800_bbp_write(rt2x00dev, 254, value);
+	}
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x19);
+}
+
 static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
@@ -3755,6 +3853,11 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
+	if (rt2x00_rt(rt2x00dev, RT5592)) {
+		rt2800_init_bbp_5592(rt2x00dev);
+		return 0;
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT3352)) {
 		rt2800_bbp_write(rt2x00dev, 3, 0x00);
 		rt2800_bbp_write(rt2x00dev, 4, 0x50);
@@ -3762,11 +3865,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_bbp_read(rt2x00dev, 4, &value);
-		rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
-		rt2800_bbp_write(rt2x00dev, 4, value);
-	}
+	    rt2x00_rt(rt2x00dev, RT5392))
+		rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 
 	if (rt2800_is_305x_soc(rt2x00dev) ||
 	    rt2x00_rt(rt2x00dev, RT3290) ||
-- 
1.7.4.4

