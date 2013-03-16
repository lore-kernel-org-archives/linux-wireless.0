Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41800 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab3CPSTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:48 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 07/25] rt2800: 5592: common BBP initialization
Date: Sat, 16 Mar 2013 19:19:35 +0100
Message-Id: <1363457993-15541-8-git-send-email-stf_xl@wp.pl> (sfid-20130316_191952_148635_02E3B8AA)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Add BBP registers initialization common with other chipsets, but for now
performed only for 5592.

Based on:
NICInitBBP()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/common/rtmp_init.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 16e4200..9ac6f20 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3774,12 +3774,34 @@ static void rt2800_init_bbp_5592_glrt(struct rt2x00_dev *rt2x00dev)
 	}
 };
 
+static void rt2800_init_bbb_early(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_bbp_write(rt2x00dev, 65, 0x2C);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+	rt2800_bbp_write(rt2x00dev, 68, 0x0B);
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+	rt2800_bbp_write(rt2x00dev, 73, 0x10);
+	rt2800_bbp_write(rt2x00dev, 81, 0x37);
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+	rt2800_bbp_write(rt2x00dev, 83, 0x6A);
+	rt2800_bbp_write(rt2x00dev, 84, 0x99);
+	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+	rt2800_bbp_write(rt2x00dev, 103, 0x00);
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
+}
+
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
 {
 	int ant, div_mode;
 	u16 eeprom;
 	u8 value;
 
+	rt2800_init_bbb_early(rt2x00dev);
+
 	rt2800_bbp_read(rt2x00dev, 105, &value);
 	rt2x00_set_field8(&value, BBP105_MLD,
 			  rt2x00dev->default_ant.rx_chain_num == 2);
-- 
1.7.4.4

