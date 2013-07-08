Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48224 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3GHOIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:44 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 07/20] rt2x00: rt2800lib: fix antenna configuration for RT3593
Date: Mon,  8 Jul 2013 16:08:22 +0200
Message-Id: <1373292515-21332-8-git-send-email-juhosg@openwrt.org> (sfid-20130708_160848_152849_84C4ED65)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the RT3593 chipset, BBP register 86 must be
configured by different values based on the RX
antenna numbers.

Configure this register from the 'rt2800_config_ant'
function.

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  RT3593_CONFIG_SET_BY_ANTENNA in include/chip/rt3593.h

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1a6a4eb..958215c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1803,6 +1803,13 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 
 	rt2800_bbp_write(rt2x00dev, 3, r3);
 	rt2800_bbp_write(rt2x00dev, 1, r1);
+
+	if (rt2x00_rt(rt2x00dev, RT3593)) {
+		if (ant->rx_chain_num == 1)
+			rt2800_bbp_write(rt2x00dev, 86, 0x00);
+		else
+			rt2800_bbp_write(rt2x00dev, 86, 0x46);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2800_config_ant);
 
-- 
1.7.10

