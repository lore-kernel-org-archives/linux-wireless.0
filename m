Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:3254 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756283Ab2BFW7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:06 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/8] rt2x00: Use saved BBP 25 and 26 values when configuring channel on RT3572.
Date: Mon,  6 Feb 2012 23:45:09 +0100
Message-Id: <1328568313-26267-5-git-send-email-gwingerde@gmail.com> (sfid-20120206_235916_561912_BDD55622)
In-Reply-To: <1328568313-26267-4-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-2-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This brings the rt2800 channel switching code for RT3572 closer to the
v2.5.0.0 Ralink RT3572 driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 7c05dee..8aabd0d 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2444,6 +2444,8 @@ struct mac_iveiv_entry {
 struct rt2800_drv_data {
 	u8 calibration_bw20;
 	u8 calibration_bw40;
+	u8 bbp25;
+	u8 bbp26;
 };
 
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index fad0e77..cb841f4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1754,8 +1754,8 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	if (rf->channel <= 14) {
-		rt2800_bbp_write(rt2x00dev, 25, 0x15);
-		rt2800_bbp_write(rt2x00dev, 26, 0x85);
+		rt2800_bbp_write(rt2x00dev, 25, drv_data->bbp25);
+		rt2800_bbp_write(rt2x00dev, 26, drv_data->bbp26);
 	} else {
 		rt2800_bbp_write(rt2x00dev, 25, 0x09);
 		rt2800_bbp_write(rt2x00dev, 26, 0xff);
@@ -3623,6 +3623,12 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
 	}
 
+	/*
+	 * Save BBP 25 & 26 values for later use in channel switching
+	 */
+	rt2800_bbp_read(rt2x00dev, 25, &drv_data->bbp25);
+	rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
+
 	if (!rt2x00_rt(rt2x00dev, RT5390)) {
 		/*
 		 * Set back to initial state
-- 
1.7.9

