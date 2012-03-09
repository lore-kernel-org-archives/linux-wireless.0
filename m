Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60011 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2CIOb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 09:31:57 -0500
Received: by wgbdr13 with SMTP id dr13so1664811wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 06:31:56 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ivdoorn@gmail.com, gwingerde@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Fix beacon skew in rt2800pci
Date: Fri,  9 Mar 2012 15:31:50 +0100
Message-Id: <1331303510-20322-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120309_153201_669441_83564B28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800pci is suffering from beacon skew in AP mode. Some powersaving
clients (like VOIP phones) are getting into trouble after some time
when the beacon skew is getting too big.

The ralink legacy drivers contain a function that indicates that the
beacon timer is off by 1us per tbtt. And this function works around
that by reducing the beacon interval for every 64th beacon transmission
by 64us (the smallest possible value). Do the same in rt2800pci.

This allows proper powersaving when rt2800pci is used in AP mode.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Thanks to Gertjans per-driver data patch I can add this quirk to
rt2800 only where it belongs!

 drivers/net/wireless/rt2x00/rt2800.h    |    7 +++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |   26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index e5c05d8..063bfa8 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2475,6 +2475,12 @@ struct mac_iveiv_entry {
 #define EIRP_MAX_TX_POWER_LIMIT	0x50
 
 /*
+ * Number of TBTT intervals after which we have to adjust
+ * the hw beacon timer.
+ */
+#define BCN_TBTT_OFFSET 64
+
+/*
  * RT2800 driver data structure
  */
 struct rt2800_drv_data {
@@ -2484,6 +2490,7 @@ struct rt2800_drv_data {
 	u8 bbp26;
 	u8 txmixer_gain_24g;
 	u8 txmixer_gain_5g;
+	unsigned int tbtt_tick;
 };
 
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index edb2297..46a889a 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -815,7 +815,33 @@ static void rt2800pci_pretbtt_tasklet(unsigned long data)
 static void rt2800pci_tbtt_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u32 reg;
+
 	rt2x00lib_beacondone(rt2x00dev);
+
+	if (rt2x00dev->intf_ap_count) {
+		/* 
+		 * The rt2800pci hardware tbtt timer is off by 1us per tbtt
+		 * causing beacon skew and as a result causing problems with
+		 * some powersaving clients over time. Shorten the beacon
+		 * interval every 64 beacons by 64us to mitigate this effect.
+		 */
+		if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 2)) {
+			rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
+					   (rt2x00dev->beacon_int * 16) - 1);
+			rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		} else if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 1)) {
+			rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
+					   (rt2x00dev->beacon_int * 16));
+			rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		}
+		drv_data->tbtt_tick++;
+		drv_data->tbtt_tick %= BCN_TBTT_OFFSET;
+	}
+
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_TBTT);
 }
-- 
1.7.7

