Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48338 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3GHOI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:57 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 11/20] rt2x00: rt2800lib: hardcode TX mixer gain values for RT3593
Date: Mon,  8 Jul 2013 16:08:26 +0200
Message-Id: <1373292515-21332-12-git-send-email-juhosg@openwrt.org> (sfid-20130708_162039_918185_681CDA99)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reference code uses hardcoded zero TX mixer gain value
for RT3593. Do the same in the rt2x00 driver.

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  NICReadEEPROMParameters in common/rtmp_init.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1f32732..65045e0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6365,6 +6365,9 @@ static u8 rt2800_get_txmixer_gain_24g(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return 0;
+
 	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
 	if ((word & 0x00ff) != 0x00ff)
 		return rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_BG_VAL);
@@ -6376,6 +6379,9 @@ static u8 rt2800_get_txmixer_gain_5g(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return 0;
+
 	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A, &word);
 	if ((word & 0x00ff) != 0x00ff)
 		return rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_A_VAL);
-- 
1.7.10

