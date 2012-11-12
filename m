Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2KLV7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:11 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:11 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 13/17] Use ARRAY_SIZE instead of in-code constants
Date: Mon, 12 Nov 2012 23:58:27 +0200
Message-Id: <1352757511-26957-14-git-send-email-maxtram95@gmail.com> (sfid-20121112_231527_520619_338FF1F5)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_rtl8225z2.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/r8180_rtl8225z2.c b/r8180_rtl8225z2.c
index eba9786..c592f79 100644
--- a/r8180_rtl8225z2.c
+++ b/r8180_rtl8225z2.c
@@ -132,7 +132,7 @@ static const u16 rtl8225z2_rxgain[] = {
 	0x0794, 0x0795, 0x0798, 0x0799, 0x079a, 0x079b, 0x079c, 0x079d,
 	0x07a0, 0x07a1, 0x07a2, 0x07a3, 0x07a4, 0x07a5, 0x07a8, 0x07a9,
 	0x03aa, 0x03ab, 0x03ac, 0x03ad, 0x03b0, 0x03b1, 0x03b2, 0x03b3,
-	0x03b4, 0x03b5, 0x03b8, 0x03b9, 0x03ba, 0x03bb, 0x03bb
+	0x03b4, 0x03b5, 0x03b8, 0x03b9, 0x03ba, 0x03bb
 
 };
 
@@ -431,8 +431,8 @@ void rtl8225z2_rf_init(struct net_device *dev)
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	int i;
 	short channel = 1;
-	u16	brsr;
-	u32	data, addr;
+	u16 brsr;
+	u32 data;
 
 	priv->chan = channel;
 
@@ -473,8 +473,8 @@ void rtl8225z2_rf_init(struct net_device *dev)
 
 	write_rtl8225(dev, 0x0, 0x1b7);
 
-	for (i = 0; i < 95; i++) {
-		write_rtl8225(dev, 0x1, (u8)(i + 1));
+	for (i = 0; i < ARRAY_SIZE(rtl8225z2_rxgain); i++) {
+		write_rtl8225(dev, 0x1, i + 1);
 		write_rtl8225(dev, 0x2, rtl8225z2_rxgain[i]);
 	}
 
@@ -504,14 +504,12 @@ void rtl8225z2_rf_init(struct net_device *dev)
 
 	write_rtl8225(dev, 0x0, 0x2bf);
 
-	for (i = 0; i < 128; i++) {
-		data = rtl8225_agc[i];
-
-		addr = i + 0x80; /* enable writing AGC table */
-		write_phy_ofdm(dev, 0xb, data);
+	for (i = 0; i < ARRAY_SIZE(rtl8225_agc); i++) {
+		write_phy_ofdm(dev, 0xb, rtl8225_agc[i]);
 		mdelay(1);
 
-		write_phy_ofdm(dev, 0xa, addr);
+		/* enable writing AGC table */
+		write_phy_ofdm(dev, 0xa, i + 0x80);
 		mdelay(1);
 	}
 
-- 
1.7.10.4

