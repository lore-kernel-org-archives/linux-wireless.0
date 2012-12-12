Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:40604 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab2LLFbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 00:31:15 -0500
Received: from ip-62-245-101-196.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[62.245.101.196])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 12 Dec 2012 06:31:08 +0100
Date: Wed, 12 Dec 2012 06:30:55 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2800: refactor RFCSR initialization
Message-ID: <20121212053054.GA4356@localhost.localdomain> (sfid-20121212_063119_988826_5FC99DEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800_init_rfcsr() is too big, split RF initialization into per chip
functions. Code will change, but we should setup the same values onto
RF registers and in the same order as before.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  795 ++++++++++++++++---------------
 1 files changed, 423 insertions(+), 372 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d4d0c36..678a61b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3866,6 +3866,400 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
 	return rfcsr24;
 }
 
+static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
+	rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x00);
+}
+
+static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x60);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x41);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
+	rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
+}
+
+static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0xf3);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x83);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x05);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+	rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
+	rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+	rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
+	rt2800_rfcsr_write(rt2x00dev, 43, 0x7b);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
+	rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x98);
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x09);
+	rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+	rt2800_rfcsr_write(rt2x00dev, 61, 0xc1);
+}
+
+static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 0, 0xf0);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x18);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x33);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0xf1);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0xd2);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x42);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x1c);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x5a);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x45);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 36, 0xbd);
+	rt2800_rfcsr_write(rt2x00dev, 37, 0x3c);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x5f);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0xc5);
+	rt2800_rfcsr_write(rt2x00dev, 40, 0x33);
+	rt2800_rfcsr_write(rt2x00dev, 41, 0x5b);
+	rt2800_rfcsr_write(rt2x00dev, 42, 0x5b);
+	rt2800_rfcsr_write(rt2x00dev, 43, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 46, 0xdd);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x0d);
+	rt2800_rfcsr_write(rt2x00dev, 48, 0x14);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x2d);
+	rt2800_rfcsr_write(rt2x00dev, 51, 0x7f);
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x52);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x1b);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x7f);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x52);
+	rt2800_rfcsr_write(rt2x00dev, 58, 0x1b);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 60, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
+}
+
+static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0xe1);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x62);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x8b);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x42);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x34);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0xc0);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x61);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x3b);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0xe0);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x53);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0xe0);
+	rt2800_rfcsr_write(rt2x00dev, 17, 0x94);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x5c);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x4a);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0xb2);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0xf6);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x14);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x3d);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x85);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x41);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
+}
+
+static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 0, 0x70);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x81);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x4c);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x05);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x4a);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0xd8);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0xc3);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0xf1);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0xb9);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x70);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x65);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0xa0);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x53);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0x4c);
+	rt2800_rfcsr_write(rt2x00dev, 17, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0xac);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x93);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0xb3);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0xd0);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x3c);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x15);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x85);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x9b);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x09);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x10);
+}
+
+static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+		rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0xc6);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
+
+	rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+		rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 25, 0xc0);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+		rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 40, 0x4b);
+	rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+	rt2800_rfcsr_write(rt2x00dev, 42, 0xd2);
+	rt2800_rfcsr_write(rt2x00dev, 43, 0x9a);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+		rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 46, 0x7b);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
+
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+		rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 53, 0x84);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x44);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
+
+	rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+		rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
+	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
+}
+
+static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+	rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+	rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
+	rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
+	rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
+	rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
+	rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
+	rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+	rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
+	rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
+	rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
+}
+
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 {
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
@@ -3889,6 +4283,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Init RF calibration.
 	 */
+
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392)) {
@@ -3907,379 +4302,35 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090)) {
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x60);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x41);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
-		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
-	} else if (rt2x00_rt(rt2x00dev, RT3290)) {
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
-		rt2800_rfcsr_write(rt2x00dev, 8, 0xf3);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x83);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 34, 0x05);
-		rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
-		rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
-		rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
-		rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
-		rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
-		rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
-		rt2800_rfcsr_write(rt2x00dev, 43, 0x7b);
-		rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
-		rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
-		rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
-		rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 49, 0x98);
-		rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
-		rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
-		rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
-		rt2800_rfcsr_write(rt2x00dev, 56, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
-		rt2800_rfcsr_write(rt2x00dev, 59, 0x09);
-		rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
-		rt2800_rfcsr_write(rt2x00dev, 61, 0xc1);
-	} else if (rt2x00_rt(rt2x00dev, RT3390)) {
-		rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
-		rt2800_rfcsr_write(rt2x00dev, 1, 0xe1);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x62);
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x8b);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x42);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x34);
-		rt2800_rfcsr_write(rt2x00dev, 8, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0xc0);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x61);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x3b);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0xe0);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x53);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0xe0);
-		rt2800_rfcsr_write(rt2x00dev, 17, 0x94);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x5c);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x4a);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0xb2);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0xf6);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x14);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x3d);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x85);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x41);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
-		rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
-	} else if (rt2x00_rt(rt2x00dev, RT3572)) {
-		rt2800_rfcsr_write(rt2x00dev, 0, 0x70);
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x81);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x4c);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x05);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x4a);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0xd8);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0xc3);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0xf1);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0xb9);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x70);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x65);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0xa0);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x53);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0x4c);
-		rt2800_rfcsr_write(rt2x00dev, 17, 0x23);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0xac);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x93);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0xb3);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0xd0);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x3c);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x15);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x85);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x9b);
-		rt2800_rfcsr_write(rt2x00dev, 30, 0x09);
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x10);
-	} else if (rt2800_is_305x_soc(rt2x00dev)) {
-		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
-		rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
-		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
-		rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x00);
+	if (rt2800_is_305x_soc(rt2x00dev)) {
+		rt2800_init_rfcsr_305x_soc(rt2x00dev);
 		return 0;
-	} else if (rt2x00_rt(rt2x00dev, RT3352)) {
-		rt2800_rfcsr_write(rt2x00dev, 0, 0xf0);
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x23);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0x50);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x18);
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x33);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 8, 0xf1);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0xd2);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x42);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x1c);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x5a);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x45);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 34, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 35, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 36, 0xbd);
-		rt2800_rfcsr_write(rt2x00dev, 37, 0x3c);
-		rt2800_rfcsr_write(rt2x00dev, 38, 0x5f);
-		rt2800_rfcsr_write(rt2x00dev, 39, 0xc5);
-		rt2800_rfcsr_write(rt2x00dev, 40, 0x33);
-		rt2800_rfcsr_write(rt2x00dev, 41, 0x5b);
-		rt2800_rfcsr_write(rt2x00dev, 42, 0x5b);
-		rt2800_rfcsr_write(rt2x00dev, 43, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 44, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 45, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 46, 0xdd);
-		rt2800_rfcsr_write(rt2x00dev, 47, 0x0d);
-		rt2800_rfcsr_write(rt2x00dev, 48, 0x14);
-		rt2800_rfcsr_write(rt2x00dev, 49, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 50, 0x2d);
-		rt2800_rfcsr_write(rt2x00dev, 51, 0x7f);
-		rt2800_rfcsr_write(rt2x00dev, 52, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 53, 0x52);
-		rt2800_rfcsr_write(rt2x00dev, 54, 0x1b);
-		rt2800_rfcsr_write(rt2x00dev, 55, 0x7f);
-		rt2800_rfcsr_write(rt2x00dev, 56, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 57, 0x52);
-		rt2800_rfcsr_write(rt2x00dev, 58, 0x1b);
-		rt2800_rfcsr_write(rt2x00dev, 59, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 60, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
-	} else if (rt2x00_rt(rt2x00dev, RT5390)) {
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-			rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
-		else
-			rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0xc6);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
-
-		rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-			rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
-		else
-			rt2800_rfcsr_write(rt2x00dev, 25, 0xc0);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
-
-		rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
-		rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
-		rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
-		rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
-		rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
-
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-			rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
-		else
-			rt2800_rfcsr_write(rt2x00dev, 40, 0x4b);
-		rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
-		rt2800_rfcsr_write(rt2x00dev, 42, 0xd2);
-		rt2800_rfcsr_write(rt2x00dev, 43, 0x9a);
-		rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
-		rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-			rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
-		else
-			rt2800_rfcsr_write(rt2x00dev, 46, 0x7b);
-		rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
-
-		rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-			rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
-		else
-			rt2800_rfcsr_write(rt2x00dev, 53, 0x84);
-		rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
-		rt2800_rfcsr_write(rt2x00dev, 55, 0x44);
-		rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
-		rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
-		rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
-
-		rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-			rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
-		else
-			rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
-		rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
-	} else if (rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
-		rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
-		rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
-		rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
-		rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
-		rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
-		rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
-		rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
-		rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
-		rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
-		rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
-		rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
-		rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
-		rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
-		rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
-		rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
-		rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
-		rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
-		rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
-		rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
-		rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
-		rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
-		rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
-		rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
-		rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
-		rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
-		rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
-		rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
-		rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
-		rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
+	}
+
+	switch (rt2x00dev->chip.rt) {
+	case RT3070:
+	case RT3071:
+	case RT3090:
+		rt2800_init_rfcsr_30xx(rt2x00dev);
+		break;
+	case RT3290:
+		rt2800_init_rfcsr_3290(rt2x00dev);
+		break;
+	case RT3352:
+		rt2800_init_rfcsr_3352(rt2x00dev);
+		break;
+	case RT3390:
+		rt2800_init_rfcsr_3390(rt2x00dev);
+		break;
+	case RT3572:
+		rt2800_init_rfcsr_3572(rt2x00dev);
+		break;
+	case RT5390:
+		rt2800_init_rfcsr_5390(rt2x00dev);
+		break;
+	case RT5392:
+		rt2800_init_rfcsr_5392(rt2x00dev);
+		break;
 	}
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
-- 
1.7.4.4

