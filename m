Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49967 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab3F1TNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 10/19] rt2x00: rt2800lib: hardcode TX mixer gain values for RT3593
Date: Fri, 28 Jun 2013 21:12:24 +0200
Message-Id: <1372446753-11408-11-git-send-email-juhosg@openwrt.org> (sfid-20130628_211330_808854_046E875A)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reference code uses hardcoded zero TX mixer gain value
for RT3593. Do the same in the rt2x00 driver.

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  NICReadEEPROMParameters in common/rtmp_init.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6f23eb0..ea9b98d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6366,6 +6366,9 @@ static u8 rt2800_get_txmixer_gain_24g(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return 0;
+
 	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
 	if ((word & 0x00ff) != 0x00ff)
 		return rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_BG_VAL);
@@ -6377,6 +6380,9 @@ static u8 rt2800_get_txmixer_gain_5g(struct rt2x00_dev *rt2x00dev)
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

