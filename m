Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48208 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3GHOIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 02/20] rt2x00: rt2800lib: add BBP register initialization for RT3593
Date: Mon,  8 Jul 2013 16:08:17 +0200
Message-Id: <1373292515-21332-3-git-send-email-juhosg@openwrt.org> (sfid-20130708_160851_668584_B41DAE39)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

References:
  NICInitRT3593BbpRegisters in chips/rt3593.c
  NICInitBBP in common/rtmp_init.c
  NICInitAsicFromEEPROM in common/rtmp_init.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bfeca29..53ebdb9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4504,6 +4504,22 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_disable_unused_dac_adc(rt2x00dev);
 }
 
+static void rt2800_init_bbp_3593(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_init_bbp_early(rt2x00dev);
+
+	rt2800_bbp_write(rt2x00dev, 79, 0x13);
+	rt2800_bbp_write(rt2x00dev, 80, 0x05);
+	rt2800_bbp_write(rt2x00dev, 81, 0x33);
+	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x19);
+
+	/* Enable DC filter */
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT3593, REV_RT3593E))
+		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+}
+
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 {
 	int ant, div_mode;
@@ -4719,6 +4735,9 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	case RT3572:
 		rt2800_init_bbp_3572(rt2x00dev);
 		break;
+	case RT3593:
+		rt2800_init_bbp_3593(rt2x00dev);
+		return;
 	case RT5390:
 	case RT5392:
 		rt2800_init_bbp_53xx(rt2x00dev);
-- 
1.7.10

