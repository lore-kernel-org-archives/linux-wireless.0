Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:52616 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYJCUsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:55 -0400
Received: by yx-out-2324.google.com with SMTP id 8so298717yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:53 -0700 (PDT)
Subject: [PATCH 5/8] b43: remove b43_radio_{read|write}16 from phy_a.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:47 -0700
Message-Id: <1223066927.6512.30.camel@brick> (sfid-20081003_224908_930968_B8332220)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the mask/set helpers.  One place in init_2060 has a mismatched register
pair in a nested read/write, but it has been that way form the beginning
so I haven't changed that.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy_a.c |  124 ++++++++++++++++----------------------
 1 files changed, 53 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index 0f1a84c..aafd5f6 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -81,7 +81,7 @@ void b43_radio_set_tx_iq(struct b43_wldev *dev)
 {
 	static const u8 data_high[5] = { 0x00, 0x40, 0x80, 0x90, 0xD0 };
 	static const u8 data_low[5] = { 0x00, 0x01, 0x05, 0x06, 0x0A };
-	u16 tmp = b43_radio_read16(dev, 0x001E);
+	u16 tmp = b43_radio_read(dev, 0x001E);
 	int i, j;
 
 	for (i = 0; i < 5; i++) {
@@ -97,19 +97,17 @@ void b43_radio_set_tx_iq(struct b43_wldev *dev)
 
 static void aphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 {
-	u16 freq, r8, tmp;
+	u16 freq, r8;
 
 	freq = channel2freq_a(channel);
 
-	r8 = b43_radio_read16(dev, 0x0008);
+	r8 = b43_radio_read(dev, 0x0008);
 	b43_write16(dev, 0x03F0, freq);
-	b43_radio_write16(dev, 0x0008, r8);
+	b43_radio_write(dev, 0x0008, r8);
 
 	//TODO: write max channel TX power? to Radio 0x2D
-	tmp = b43_radio_read16(dev, 0x002E);
-	tmp &= 0x0080;
 	//TODO: OR tmp with the Power out estimation for this channel?
-	b43_radio_write16(dev, 0x002E, tmp);
+	b43_radio_mask(dev, 0x002E, 0x0080);
 
 	if (freq >= 4920 && freq <= 5500) {
 		/*
@@ -118,30 +116,21 @@ static void aphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 		 */
 		r8 = 3 * freq / 116;	/* is equal to r8 = freq * 0.025862 */
 	}
-	b43_radio_write16(dev, 0x0007, (r8 << 4) | r8);
-	b43_radio_write16(dev, 0x0020, (r8 << 4) | r8);
-	b43_radio_write16(dev, 0x0021, (r8 << 4) | r8);
-	b43_radio_write16(dev, 0x0022, (b43_radio_read16(dev, 0x0022)
-					& 0x000F) | (r8 << 4));
-	b43_radio_write16(dev, 0x002A, (r8 << 4));
-	b43_radio_write16(dev, 0x002B, (r8 << 4));
-	b43_radio_write16(dev, 0x0008, (b43_radio_read16(dev, 0x0008)
-					& 0x00F0) | (r8 << 4));
-	b43_radio_write16(dev, 0x0029, (b43_radio_read16(dev, 0x0029)
-					& 0xFF0F) | 0x00B0);
-	b43_radio_write16(dev, 0x0035, 0x00AA);
-	b43_radio_write16(dev, 0x0036, 0x0085);
-	b43_radio_write16(dev, 0x003A, (b43_radio_read16(dev, 0x003A)
-					& 0xFF20) |
-			  freq_r3A_value(freq));
-	b43_radio_write16(dev, 0x003D,
-			  b43_radio_read16(dev, 0x003D) & 0x00FF);
-	b43_radio_write16(dev, 0x0081, (b43_radio_read16(dev, 0x0081)
-					& 0xFF7F) | 0x0080);
-	b43_radio_write16(dev, 0x0035,
-			  b43_radio_read16(dev, 0x0035) & 0xFFEF);
-	b43_radio_write16(dev, 0x0035, (b43_radio_read16(dev, 0x0035)
-					& 0xFFEF) | 0x0010);
+	b43_radio_write(dev, 0x0007, (r8 << 4) | r8);
+	b43_radio_write(dev, 0x0020, (r8 << 4) | r8);
+	b43_radio_write(dev, 0x0021, (r8 << 4) | r8);
+	b43_radio_maskset(dev, 0x0022, 0x000F, (r8 << 4));
+	b43_radio_write(dev, 0x002A, (r8 << 4));
+	b43_radio_write(dev, 0x002B, (r8 << 4));
+	b43_radio_maskset(dev, 0x0008, 0x00F0, (r8 << 4));
+	b43_radio_maskset(dev, 0x0029, 0xFF0F, 0x00B0);
+	b43_radio_write(dev, 0x0035, 0x00AA);
+	b43_radio_write(dev, 0x0036, 0x0085);
+	b43_radio_maskset(dev, 0x003A, 0xFF20, freq_r3A_value(freq));
+	b43_radio_mask(dev, 0x003D, 0x00FF);
+	b43_radio_maskset(dev, 0x0081, 0xFF7F, 0x0080);
+	b43_radio_mask(dev, 0x0035, 0xFFEF);
+	b43_radio_maskset(dev, 0x0035, 0xFFEF, 0x0010);
 	b43_radio_set_tx_iq(dev);
 	//TODO: TSSI2dbm workaround
 //FIXME	b43_phy_xmitpower(dev);
@@ -149,36 +138,33 @@ static void aphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 
 void b43_radio_init2060(struct b43_wldev *dev)
 {
-	b43_radio_write16(dev, 0x0004, 0x00C0);
-	b43_radio_write16(dev, 0x0005, 0x0008);
-	b43_radio_write16(dev, 0x0009, 0x0040);
-	b43_radio_write16(dev, 0x0005, 0x00AA);
-	b43_radio_write16(dev, 0x0032, 0x008F);
-	b43_radio_write16(dev, 0x0006, 0x008F);
-	b43_radio_write16(dev, 0x0034, 0x008F);
-	b43_radio_write16(dev, 0x002C, 0x0007);
-	b43_radio_write16(dev, 0x0082, 0x0080);
-	b43_radio_write16(dev, 0x0080, 0x0000);
-	b43_radio_write16(dev, 0x003F, 0x00DA);
-	b43_radio_write16(dev, 0x0005, b43_radio_read16(dev, 0x0005) & ~0x0008);
-	b43_radio_write16(dev, 0x0081, b43_radio_read16(dev, 0x0081) & ~0x0010);
-	b43_radio_write16(dev, 0x0081, b43_radio_read16(dev, 0x0081) & ~0x0020);
-	b43_radio_write16(dev, 0x0081, b43_radio_read16(dev, 0x0081) & ~0x0020);
+	b43_radio_write(dev, 0x0004, 0x00C0);
+	b43_radio_write(dev, 0x0005, 0x0008);
+	b43_radio_write(dev, 0x0009, 0x0040);
+	b43_radio_write(dev, 0x0005, 0x00AA);
+	b43_radio_write(dev, 0x0032, 0x008F);
+	b43_radio_write(dev, 0x0006, 0x008F);
+	b43_radio_write(dev, 0x0034, 0x008F);
+	b43_radio_write(dev, 0x002C, 0x0007);
+	b43_radio_write(dev, 0x0082, 0x0080);
+	b43_radio_write(dev, 0x0080, 0x0000);
+	b43_radio_write(dev, 0x003F, 0x00DA);
+	b43_radio_mask(dev, 0x0005, ~0x0008);
+	b43_radio_mask(dev, 0x0081, ~0x0010);
+	b43_radio_mask(dev, 0x0081, ~0x0020);
+	b43_radio_mask(dev, 0x0081, ~0x0020);
 	msleep(1);		/* delay 400usec */
 
-	b43_radio_write16(dev, 0x0081,
-			  (b43_radio_read16(dev, 0x0081) & ~0x0020) | 0x0010);
+	b43_radio_maskset(dev, 0x0081, ~0x0020, 0x0010);
 	msleep(1);		/* delay 400usec */
 
-	b43_radio_write16(dev, 0x0005,
-			  (b43_radio_read16(dev, 0x0005) & ~0x0008) | 0x0008);
-	b43_radio_write16(dev, 0x0085, b43_radio_read16(dev, 0x0085) & ~0x0010);
-	b43_radio_write16(dev, 0x0005, b43_radio_read16(dev, 0x0005) & ~0x0008);
-	b43_radio_write16(dev, 0x0081, b43_radio_read16(dev, 0x0081) & ~0x0040);
-	b43_radio_write16(dev, 0x0081,
-			  (b43_radio_read16(dev, 0x0081) & ~0x0040) | 0x0040);
-	b43_radio_write16(dev, 0x0005,
-			  (b43_radio_read16(dev, 0x0081) & ~0x0008) | 0x0008);
+	b43_radio_maskset(dev, 0x0005, ~0x0008, 0x0008);
+	b43_radio_mask(dev, 0x0085, ~0x0010);
+	b43_radio_mask(dev, 0x0005, ~0x0008);
+	b43_radio_mask(dev, 0x0081, ~0x0040);
+	b43_radio_maskset(dev, 0x0081, ~0x0040, 0x0040);
+	b43_radio_write(dev, 0x0005,
+			  (b43_radio_read(dev, 0x0081) & ~0x0008) | 0x0008);
 	b43_phy_write(dev, 0x0063, 0xDDC6);
 	b43_phy_write(dev, 0x0069, 0x07BE);
 	b43_phy_write(dev, 0x006A, 0x0000);
@@ -230,18 +216,15 @@ static void b43_phy_ww(struct b43_wldev *dev)
 		b43_phy_read(dev, B43_PHY_OFDM(0x1B)) | 0x1000);
 	b43_phy_write(dev, B43_PHY_OFDM(0x82),
 		(b43_phy_read(dev, B43_PHY_OFDM(0x82)) & 0xF0FF) | 0x0300);
-	b43_radio_write16(dev, 0x0009,
-		b43_radio_read16(dev, 0x0009) | 0x0080);
-	b43_radio_write16(dev, 0x0012,
-		(b43_radio_read16(dev, 0x0012) & 0xFFFC) | 0x0002);
+	b43_radio_set(dev, 0x0009, 0x0080);
+	b43_radio_maskset(dev, 0x0012, 0xFFFC, 0x0002);
 	b43_wa_initgains(dev);
 	b43_phy_write(dev, B43_PHY_OFDM(0xBA), 0x3ED5);
 	b = b43_phy_read(dev, B43_PHY_PWRDOWN);
 	b43_phy_write(dev, B43_PHY_PWRDOWN, (b & 0xFFF8) | 0x0005);
-	b43_radio_write16(dev, 0x0004,
-		b43_radio_read16(dev, 0x0004) | 0x0004);
+	b43_radio_set(dev, 0x0004, 0x0004);
 	for (i = 0x10; i <= 0x20; i++) {
-		b43_radio_write16(dev, 0x0013, i);
+		b43_radio_write(dev, 0x0013, i);
 		curr_s = b43_phy_read(dev, B43_PHY_OTABLEQ) & 0x00FF;
 		if (!curr_s) {
 			best_s = 0x0000;
@@ -252,9 +235,8 @@ static void b43_phy_ww(struct b43_wldev *dev)
 			best_s = curr_s;
 	}
 	b43_phy_write(dev, B43_PHY_PWRDOWN, b);
-	b43_radio_write16(dev, 0x0004,
-		b43_radio_read16(dev, 0x0004) & 0xFFFB);
-	b43_radio_write16(dev, 0x0013, best_s);
+	b43_radio_mask(dev, 0x0004, 0xFFFB);
+	b43_radio_write(dev, 0x0013, best_s);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1_R1, 0, 0xFFEC);
 	b43_phy_write(dev, B43_PHY_OFDM(0xB7), 0x1E80);
 	b43_phy_write(dev, B43_PHY_OFDM(0xB6), 0x1C00);
@@ -518,14 +500,14 @@ static void b43_aphy_op_software_rfkill(struct b43_wldev *dev,
 	if (state == RFKILL_STATE_UNBLOCKED) {
 		if (phy->radio_on)
 			return;
-		b43_radio_write16(dev, 0x0004, 0x00C0);
-		b43_radio_write16(dev, 0x0005, 0x0008);
+		b43_radio_write(dev, 0x0004, 0x00C0);
+		b43_radio_write(dev, 0x0005, 0x0008);
 		b43_phy_write(dev, 0x0010, b43_phy_read(dev, 0x0010) & 0xFFF7);
 		b43_phy_write(dev, 0x0011, b43_phy_read(dev, 0x0011) & 0xFFF7);
 		b43_radio_init2060(dev);
 	} else {
-		b43_radio_write16(dev, 0x0004, 0x00FF);
-		b43_radio_write16(dev, 0x0005, 0x00FB);
+		b43_radio_write(dev, 0x0004, 0x00FF);
+		b43_radio_write(dev, 0x0005, 0x00FB);
 		b43_phy_write(dev, 0x0010, b43_phy_read(dev, 0x0010) | 0x0008);
 		b43_phy_write(dev, 0x0011, b43_phy_read(dev, 0x0011) | 0x0008);
 	}
-- 
1.6.0.2.471.g47a76


