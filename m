Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49908 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab3F1TNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 06/19] rt2x00: rt2800lib: fix antenna configuration for RT3593
Date: Fri, 28 Jun 2013 21:12:20 +0200
Message-Id: <1372446753-11408-7-git-send-email-juhosg@openwrt.org> (sfid-20130628_211327_610536_55FB5B08)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
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
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6f6f48f..fa5bbae 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1804,6 +1804,13 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 
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

