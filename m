Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:60497 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaDTLGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:21 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so2973120eek.27
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:20 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 8/9] b43: N-PHY: fix selection of init & calib values
Date: Sun, 20 Apr 2014 13:05:50 +0200
Message-Id: <1397991951-13478-9-git-send-email-zajec5@gmail.com> (sfid-20140420_130701_590319_CE3F7747)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Logic in specs and our code was wrong. Init and calibration values for
newer cards depend on radio revision, not PHY revision.
To make code clearer, change tables names to include "radio" or "phy".

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This will yield few "line over 80 characters" warnings, but it's only for some
tables, not a real code.
---
 drivers/net/wireless/b43/radio_2056.c | 172 +++++++++++++++++++++-------------
 1 file changed, 105 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
index d252c52..a07e4ca 100644
--- a/drivers/net/wireless/b43/radio_2056.c
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -48,7 +48,7 @@ struct b2056_inittabs_pts {
 	unsigned int rx_length;
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev3_syn[] = {
+static const struct b2056_inittab_entry b2056_inittab_phy_rev3_syn[] = {
 	[B2056_SYN_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -232,7 +232,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev3_syn[] = {
 	[B2056_SYN_LOGEN_TX_CMOS_VALID]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev3_tx[] = {
+static const struct b2056_inittab_entry b2056_inittab_phy_rev3_tx[] = {
 	[B2056_TX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -380,7 +380,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev3_tx[] = {
 	[B2056_TX_STATUS_TXLPF_RC]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev3_rx[] = {
+static const struct b2056_inittab_entry b2056_inittab_phy_rev3_rx[] = {
 	[B2056_RX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -530,7 +530,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev3_rx[] = {
 	[B2056_RX_STATUS_HPC_RC]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev4_syn[] = {
+static const struct b2056_inittab_entry b2056_inittab_phy_rev4_syn[] = {
 	[B2056_SYN_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -714,7 +714,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev4_syn[] = {
 	[B2056_SYN_LOGEN_TX_CMOS_VALID]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev4_tx[] = {
+static const struct b2056_inittab_entry b2056_inittab_phy_rev4_tx[] = {
 	[B2056_TX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -862,7 +862,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev4_tx[] = {
 	[B2056_TX_STATUS_TXLPF_RC]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev4_rx[] = {
+static const struct b2056_inittab_entry b2056_inittab_phy_rev4_rx[] = {
 	[B2056_RX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -1012,7 +1012,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev4_rx[] = {
 	[B2056_RX_STATUS_HPC_RC]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev5_syn[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev5_syn[] = {
 	[B2056_SYN_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -1196,7 +1196,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev5_syn[] = {
 	[B2056_SYN_LOGEN_TX_CMOS_VALID]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev5_tx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev5_tx[] = {
 	[B2056_TX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -1352,7 +1352,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev5_tx[] = {
 	[B2056_TX_GMBB_IDAC7]		= { .ghz5 = 0x0075, .ghz2 = 0x0075, UPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev5_rx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev5_rx[] = {
 	[B2056_RX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -1502,7 +1502,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev5_rx[] = {
 	[B2056_RX_STATUS_HPC_RC]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev6_syn[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev6_syn[] = {
 	[B2056_SYN_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -1686,7 +1686,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev6_syn[] = {
 	[B2056_SYN_LOGEN_TX_CMOS_VALID]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev6_tx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev6_tx[] = {
 	[B2056_TX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -1842,7 +1842,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev6_tx[] = {
 	[B2056_TX_GMBB_IDAC7]		= { .ghz5 = 0x0070, .ghz2 = 0x0070, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev6_rx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev6_rx[] = {
 	[B2056_RX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -1992,7 +1992,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev6_rx[] = {
 	[B2056_RX_STATUS_HPC_RC]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev7_syn[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev7_9_syn[] = {
 	[B2056_SYN_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -2176,7 +2176,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev7_syn[] = {
 	[B2056_SYN_LOGEN_TX_CMOS_VALID]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev7_tx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev7_9_tx[] = {
 	[B2056_TX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -2332,7 +2332,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev7_tx[] = {
 	[B2056_TX_GMBB_IDAC7]		= { .ghz5 = 0x0075, .ghz2 = 0x0075, UPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev7_rx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev7_9_rx[] = {
 	[B2056_RX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -2482,7 +2482,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev7_rx[] = {
 	[B2056_RX_STATUS_HPC_RC]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev8_syn[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev8_syn[] = {
 	[B2056_SYN_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_SYN_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -2666,7 +2666,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev8_syn[] = {
 	[B2056_SYN_LOGEN_TX_CMOS_VALID]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev8_tx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev8_tx[] = {
 	[B2056_TX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_TX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -2822,7 +2822,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev8_tx[] = {
 	[B2056_TX_GMBB_IDAC7]		= { .ghz5 = 0x0070, .ghz2 = 0x0070, NOUPLOAD, },
 };
 
-static const struct b2056_inittab_entry b2056_inittab_rev8_rx[] = {
+static const struct b2056_inittab_entry b2056_inittab_radio_rev8_rx[] = {
 	[B2056_RX_RESERVED_ADDR2]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR3]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
 	[B2056_RX_RESERVED_ADDR4]	= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
@@ -3018,22 +3018,22 @@ static const struct b2056_inittab_entry b2056_inittab_radio_rev11_rx[] = {
 };
 
 #define INITTABSPTS(prefix) \
-	.syn		= prefix##_syn,			\
-	.syn_length	= ARRAY_SIZE(prefix##_syn),	\
-	.tx		= prefix##_tx,			\
-	.tx_length	= ARRAY_SIZE(prefix##_tx),	\
-	.rx		= prefix##_rx,			\
-	.rx_length	= ARRAY_SIZE(prefix##_rx)
+	static const struct b2056_inittabs_pts prefix = {	\
+		.syn		= prefix##_syn,			\
+		.syn_length	= ARRAY_SIZE(prefix##_syn),	\
+		.tx		= prefix##_tx,			\
+		.tx_length	= ARRAY_SIZE(prefix##_tx),	\
+		.rx		= prefix##_rx,			\
+		.rx_length	= ARRAY_SIZE(prefix##_rx),	\
+	}
 
-static const struct b2056_inittabs_pts b2056_inittabs[] = {
-	[3] = { INITTABSPTS(b2056_inittab_rev3) },
-	[4] = { INITTABSPTS(b2056_inittab_rev4) },
-	[5] = { INITTABSPTS(b2056_inittab_rev5) },
-	[6] = { INITTABSPTS(b2056_inittab_rev6) },
-	[7] = { INITTABSPTS(b2056_inittab_rev7) },
-	[8] = { INITTABSPTS(b2056_inittab_rev8) },
-	[9] = { INITTABSPTS(b2056_inittab_rev7) },
-};
+INITTABSPTS(b2056_inittab_phy_rev3);
+INITTABSPTS(b2056_inittab_phy_rev4);
+INITTABSPTS(b2056_inittab_radio_rev5);
+INITTABSPTS(b2056_inittab_radio_rev6);
+INITTABSPTS(b2056_inittab_radio_rev7_9);
+INITTABSPTS(b2056_inittab_radio_rev8);
+INITTABSPTS(b2056_inittab_radio_rev11);
 
 #define RADIOREGS3(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
 		   r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
@@ -3086,7 +3086,7 @@ static const struct b2056_inittabs_pts b2056_inittabs[] = {
 	.phy_regs.phy_bw6	= r5
 
 /* http://bcm-v4.sipsolutions.net/802.11/Radio/2056/ChannelTable */
-static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev3[] = {
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_phy_rev3[] = {
   {	.freq			= 4920,
 	RADIOREGS3(0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04,
 		   0x0c, 0x01, 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00,
@@ -4081,7 +4081,7 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev3[] =
   },
 };
 
-static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev4[] = {
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_phy_rev4[] = {
   {	.freq			= 4920,
 	RADIOREGS3(0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04,
 		   0x0c, 0x01, 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00,
@@ -5076,7 +5076,7 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev4[] =
   },
 };
 
-static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev5[] = {
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_radio_rev5[] = {
   {	.freq			= 4920,
 	RADIOREGS3(0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04,
 		   0x0c, 0x01, 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00,
@@ -6071,7 +6071,7 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev5[] =
   },
 };
 
-static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev6[] = {
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_radio_rev6[] = {
   {	.freq			= 4920,
 	RADIOREGS3(0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04,
 		   0x0c, 0x01, 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00,
@@ -7066,7 +7066,7 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev6[] =
   },
 };
 
-static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev7_9[] = {
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_radio_rev7_9[] = {
   {	.freq			= 4920,
 	RADIOREGS3(0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04,
 		   0x0c, 0x01, 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00,
@@ -8061,7 +8061,7 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev7_9[]
   },
 };
 
-static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev8[] = {
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_radio_rev8[] = {
   {	.freq			= 4920,
 	RADIOREGS3(0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04,
 		   0x0c, 0x01, 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00,
@@ -9257,6 +9257,35 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_radio_rev
 	},
 };
 
+static const struct b2056_inittabs_pts
+*b43_nphy_get_inittabs_rev3(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+
+	switch (dev->phy.rev) {
+	case 3:
+		return &b2056_inittab_phy_rev3;
+	case 4:
+		return &b2056_inittab_phy_rev4;
+	default:
+		switch (phy->radio_rev) {
+		case 5:
+			return &b2056_inittab_radio_rev5;
+		case 6:
+			return &b2056_inittab_radio_rev6;
+		case 7:
+		case 9:
+			return &b2056_inittab_radio_rev7_9;
+		case 8:
+			return &b2056_inittab_radio_rev8;
+		case 11:
+			return &b2056_inittab_radio_rev11;
+		}
+	}
+
+	return NULL;
+}
+
 static void b2056_upload_inittab(struct b43_wldev *dev, bool ghz5,
 				 bool ignore_uploadflag, u16 routing,
 				 const struct b2056_inittab_entry *e,
@@ -9283,11 +9312,11 @@ void b2056_upload_inittabs(struct b43_wldev *dev,
 {
 	const struct b2056_inittabs_pts *pts;
 
-	if (dev->phy.rev >= ARRAY_SIZE(b2056_inittabs)) {
+	pts = b43_nphy_get_inittabs_rev3(dev);
+	if (!pts) {
 		B43_WARN_ON(1);
 		return;
 	}
-	pts = &b2056_inittabs[dev->phy.rev];
 
 	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
 				B2056_SYN, pts->syn, pts->syn_length);
@@ -9306,11 +9335,12 @@ void b2056_upload_syn_pll_cp2(struct b43_wldev *dev, bool ghz5)
 	const struct b2056_inittabs_pts *pts;
 	const struct b2056_inittab_entry *e;
 
-	if (dev->phy.rev >= ARRAY_SIZE(b2056_inittabs)) {
+	pts = b43_nphy_get_inittabs_rev3(dev);
+	if (!pts) {
 		B43_WARN_ON(1);
 		return;
 	}
-	pts = &b2056_inittabs[dev->phy.rev];
+
 	e = &pts->syn[B2056_SYN_PLL_CP2];
 
 	b43_radio_write(dev, B2056_SYN_PLL_CP2, ghz5 ? e->ghz5 : e->ghz2);
@@ -9319,38 +9349,46 @@ void b2056_upload_syn_pll_cp2(struct b43_wldev *dev, bool ghz5)
 const struct b43_nphy_channeltab_entry_rev3 *
 b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
 {
+	struct b43_phy *phy = &dev->phy;
 	const struct b43_nphy_channeltab_entry_rev3 *e;
 	unsigned int length, i;
 
-	switch (dev->phy.rev) {
+	switch (phy->rev) {
 	case 3:
-		e = b43_nphy_channeltab_rev3;
-		length = ARRAY_SIZE(b43_nphy_channeltab_rev3);
+		e = b43_nphy_channeltab_phy_rev3;
+		length = ARRAY_SIZE(b43_nphy_channeltab_phy_rev3);
 		break;
 	case 4:
-		e = b43_nphy_channeltab_rev4;
-		length = ARRAY_SIZE(b43_nphy_channeltab_rev4);
-		break;
-	case 5:
-		e = b43_nphy_channeltab_rev5;
-		length = ARRAY_SIZE(b43_nphy_channeltab_rev5);
-		break;
-	case 6:
-		e = b43_nphy_channeltab_rev6;
-		length = ARRAY_SIZE(b43_nphy_channeltab_rev6);
-		break;
-	case 7:
-	case 9:
-		e = b43_nphy_channeltab_rev7_9;
-		length = ARRAY_SIZE(b43_nphy_channeltab_rev7_9);
-		break;
-	case 8:
-		e = b43_nphy_channeltab_rev8;
-		length = ARRAY_SIZE(b43_nphy_channeltab_rev8);
+		e = b43_nphy_channeltab_phy_rev4;
+		length = ARRAY_SIZE(b43_nphy_channeltab_phy_rev4);
 		break;
 	default:
-		B43_WARN_ON(1);
-		return NULL;
+		switch (phy->radio_rev) {
+		case 5:
+			e = b43_nphy_channeltab_radio_rev5;
+			length = ARRAY_SIZE(b43_nphy_channeltab_radio_rev5);
+			break;
+		case 6:
+			e = b43_nphy_channeltab_radio_rev6;
+			length = ARRAY_SIZE(b43_nphy_channeltab_radio_rev6);
+			break;
+		case 7:
+		case 9:
+			e = b43_nphy_channeltab_radio_rev7_9;
+			length = ARRAY_SIZE(b43_nphy_channeltab_radio_rev7_9);
+			break;
+		case 8:
+			e = b43_nphy_channeltab_radio_rev8;
+			length = ARRAY_SIZE(b43_nphy_channeltab_radio_rev8);
+			break;
+		case 11:
+			e = b43_nphy_channeltab_radio_rev11;
+			length = ARRAY_SIZE(b43_nphy_channeltab_radio_rev11);
+			break;
+		default:
+			B43_WARN_ON(1);
+			return NULL;
+		}
 	}
 
 	for (i = 0; i < length; i++, e++) {
-- 
1.8.4.5

