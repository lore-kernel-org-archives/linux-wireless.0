Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47439 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab3GAHsP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 03:48:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 02/20] rt2x00: rt2800lib: add BBP register initialization for RT3593
Date: Mon,  1 Jul 2013 09:47:41 +0200
Message-Id: <1372664879-18474-3-git-send-email-juhosg@openwrt.org> (sfid-20130701_094818_897789_C73631A5)
In-Reply-To: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

References:
  NICInitRT3593BbpRegisters in chips/rt3593.c
  NICInitBBP in common/rtmp_init.c
  NICInitAsicFromEEPROM in common/rtmp_init.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6f58ceb..32ecd1a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4505,6 +4505,22 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
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
@@ -4720,6 +4736,9 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
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

