Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37057 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab3CPSUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:08 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 19/25] rt2800: add write_with_rx_chain function
Date: Sat, 16 Mar 2013 19:19:47 +0100
Message-Id: <1363457993-15541-20-git-send-email-stf_xl@wp.pl> (sfid-20130316_192017_249708_E2CB841B)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
AsicBBPWriteWithRxChain()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rtmp_chip.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    3 +++
 drivers/net/wireless/rt2x00/rt2800lib.c |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 25c94b5..6105243 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1939,6 +1939,9 @@ struct mac_iveiv_entry {
 #define BBP4_BANDWIDTH			FIELD8(0x18)
 #define BBP4_MAC_IF_CTRL		FIELD8(0x40)
 
+/* BBP27 */
+#define BBP27_RX_CHAIN_SEL		FIELD8(0x60)
+
 /*
  * BBP 47: Bandwidth
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e36cf4a..9fa10b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2458,6 +2458,22 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x19 : 0x7F);
 }
 
+static void rt2800_bbp_write_with_rx_chain(struct rt2x00_dev *rt2x00dev,
+					   const unsigned int word,
+					   const u8 value)
+{
+	u8 chain, reg;
+
+	for (chain = 0; chain < rt2x00dev->default_ant.rx_chain_num; chain++) {
+		rt2800_bbp_read(rt2x00dev, 27, &reg);
+		rt2x00_set_field8(&reg,  BBP27_RX_CHAIN_SEL, chain);
+		rt2800_bbp_write(rt2x00dev, 27, reg);
+
+		rt2800_bbp_write(rt2x00dev, word, value);
+	}
+}
+
+
 static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 {
 	u8 cal;
-- 
1.7.4.4

