Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2A3PSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 10:18:43 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/4] rt2800: radio 3xxxx: channel switch RX/TX calibration fixes
Date: Mon, 30 Jan 2012 16:17:59 +0100
Message-Id: <1327936679-12576-4-git-send-email-sgruszka@redhat.com> (sfid-20120130_161847_274425_C0958AB3)
In-Reply-To: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Synchronize code with Ralink driver:
2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
Based on functions:
RT30xx_ChipSwitchChannel
RT33xx_ChipSwitchChannel
NICInitRT3370RFRegisters
and defines from:
include/chip/rt33xx.h

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    8 ++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   19 ++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index abf2ae5..c92fb2e 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1872,6 +1872,13 @@ struct mac_iveiv_entry {
 #define RFCSR23_FREQ_OFFSET		FIELD8(0x7f)
 
 /*
+ * RFCSR 24:
+ */
+#define RFCSR24_TX_AGC_FC		FIELD8(0x1f)
+#define RFCSR24_TX_H20M			FIELD8(0x20)
+#define RFCSR24_TX_CALIB		FIELD8(0x7f)
+
+/*
  * RFCSR 27:
  */
 #define RFCSR27_R1			FIELD8(0x03)
@@ -1892,6 +1899,7 @@ struct mac_iveiv_entry {
  */
 #define RFCSR31_RX_AGC_FC		FIELD8(0x1f)
 #define RFCSR31_RX_H20M			FIELD8(0x20)
+#define RFCSR31_RX_CALIB		FIELD8(0x7f)
 
 /*
  * RFCSR 38:
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b5dcc48..13d83ab 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1646,7 +1646,7 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 					 struct rf_channel *rf,
 					 struct channel_info *info)
 {
-	u8 rfcsr;
+	u8 rfcsr, calib_tx, calib_rx;
 
 	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf1);
 
@@ -1711,8 +1711,21 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
 
-	rt2800_rfcsr_write(rt2x00dev, 24,
-			      rt2x00dev->calibration[conf_is_ht40(conf)]);
+	if (rt2x00_rt(rt2x00dev, RT3390)) {
+		calib_tx = conf_is_ht40(conf) ? 0x68 : 0x4f;
+		calib_rx = conf_is_ht40(conf) ? 0x6f : 0x4f;
+	} else {
+		calib_tx = rt2x00dev->calibration[conf_is_ht40(conf)];
+		calib_rx = rt2x00dev->calibration[conf_is_ht40(conf)];
+	}
+
+	rt2800_rfcsr_read(rt2x00dev, 24, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR24_TX_CALIB, calib_tx);
+	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 31, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR31_RX_CALIB, calib_rx);
+	rt2800_rfcsr_write(rt2x00dev, 31, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
-- 
1.7.1

