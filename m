Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:24681 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXJFBPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 21:15:34 -0400
Received: by wx-out-0506.google.com with SMTP id h31so633319wxd
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2007 18:15:33 -0700 (PDT)
Date: Fri, 5 Oct 2007 21:16:57 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 1/6] ath5k: Ported new initval changes from OpenBSD to ath5k
Message-ID: <20071006011657.GA24862@pogo> (sfid-20071006_021624_077144_696CC607)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071006010449.GA25022@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ported new initval changes from OpenBSD to ath5k to ar5212_ini[] and
ar5212_ini_mode[]. This also adds an O(log(N)) bitswap for one byte
on ath5k_hw_bitswap(), thanks to Tom from OpenBSD. These changes
have been tested.

Changes-licensed-under: ISC
Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/hw.h       |   14 +++++++++---
 drivers/net/wireless/ath5k/initvals.c |   34 +++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.h b/drivers/net/wireless/ath5k/hw.h
index d48754c..24da1c8 100644
--- a/drivers/net/wireless/ath5k/hw.h
+++ b/drivers/net/wireless/ath5k/hw.h
@@ -427,13 +427,11 @@ struct ath5k_hw_tx_status {
 #define AR5K_INIT_CFG	0x00000000
 #endif
 
-/*#define AR5K_REG_READ(_reg)	ath5k_hw_reg_read(hal, _reg)
-
-#define AR5K_REG_WRITE(_reg, _val)	ath5k_hw_reg_write(hal, _val, _reg)*/
-
+/* Shift and then mask */
 #define AR5K_REG_SM(_val, _flags)					\
 	(((_val) << _flags##_S) & (_flags))
 
+/* Mask and then shift */
 #define AR5K_REG_MS(_val, _flags)					\
 	(((_val) & (_flags)) >> _flags##_S)
 
@@ -579,6 +577,14 @@ static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
 {
 	u32 retval = 0, bit, i;
 
+	/* O(log(N)) bitswap for one byte */
+	if (bits == 8) {
+		val = ((val & 0xF0) >>  4) | ((val & 0x0F) <<  4);
+		val = ((val & 0xCC) >>  2) | ((val & 0x33) <<  2);
+		val = ((val & 0xAA) >>  1) | ((val & 0x55) <<  1);
+		return val;
+	}
+
 	for (i = 0; i < bits; i++) {
 		bit = (val >> i) & 1;
 		retval = (retval << 1) | bit;
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 11aeacc..1f96a86 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -710,6 +710,12 @@ static const struct ath5k_ini ar5212_ini[] = {
 	{ AR5K_PHY(657), 0x00007bb6 },
 	{ AR5K_PHY(658), 0x0fff3ffc },
 	{ AR5K_PHY_CCKTXCTL, 0x00000000 },
+	{ AR5K_BB_GAIN(0),  0x00000000 },	/* 0x9b00 */
+	{ AR5K_BB_GAIN(10), 0x0000000c },	/* 0x9b28 */
+	{ AR5K_BB_GAIN(14), 0x00000012 },	/* 0x9b38 */
+	{ AR5K_BB_GAIN(25), 0x00000021 },	/* 0x9b64 */
+	{ AR5K_BB_GAIN(35), 0x0000002d },	/* 0x9b8c */
+	{ AR5K_BB_GAIN(39), 0x00000033 },	/* 0x9b9c */
 };
 
 /* Initial mode-specific settings for AR5212 */
@@ -747,6 +753,34 @@ static const struct ath5k_ini_mode ar5212_ini_mode[] = {
 		{ 0x0000a0e0, 0x00014068, 0x00005880, 0x0000b0e0, 0x00014068 } },
 	{ AR5K_TIME_OUT,
 		{ 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840, 0x06e006e0 } },
+	{ 0x9804,
+		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },
+	{ 0x9820,
+		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
+	{ 0x9834,
+		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	{ 0x9838,
+		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	{ 0x9844,
+		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25 } },
+	{ 0x9850,
+		{ 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
+	{ 0x9858,
+		{ 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },
+	{ 0x9860,
+		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10 } },
+	{ 0x9864,
+		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+	{ 0x9868,
+		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },
+	{ 0x9918,
+		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },
+	{ 0x9924,
+		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },
+	{ 0xa180,
+		{ 0x10ff14ff, 0x10ff14ff, 0x10ff10ff, 0x10ff19ff, 0x10ff19ff } },
+	{ 0xa230,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },
 };
 
 /* Initial mode-specific settings for AR5212 + RF5111 */
-- 
1.5.2.5

