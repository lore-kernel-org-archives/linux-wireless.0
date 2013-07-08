Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48267 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3GHOIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 04/20] rt2x00: rt2800lib: add BBP post initialization for RT3593
Date: Mon,  8 Jul 2013 16:08:19 +0200
Message-Id: <1373292515-21332-5-git-send-email-juhosg@openwrt.org> (sfid-20130708_160852_961738_7E1BFEF4)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  RT3593_PostBBPInitialization in chips/rt3553.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   48 ++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b650569..7b5c593 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5381,6 +5381,52 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
+static void rt3593_post_bbp_init(struct rt2x00_dev *rt2x00dev)
+{
+	u8 bbp;
+	bool txbf_enabled = false; /* FIXME */
+
+	rt2800_bbp_read(rt2x00dev, 105, &bbp);
+	if (rt2x00dev->default_ant.rx_chain_num == 1)
+		rt2x00_set_field8(&bbp, BBP105_MLD, 0);
+	else
+		rt2x00_set_field8(&bbp, BBP105_MLD, 1);
+	rt2800_bbp_write(rt2x00dev, 105, bbp);
+
+	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x02);
+	rt2800_bbp_write(rt2x00dev, 82, 0x82);
+	rt2800_bbp_write(rt2x00dev, 106, 0x05);
+	rt2800_bbp_write(rt2x00dev, 104, 0x92);
+	rt2800_bbp_write(rt2x00dev, 88, 0x90);
+	rt2800_bbp_write(rt2x00dev, 148, 0xc8);
+	rt2800_bbp_write(rt2x00dev, 47, 0x48);
+	rt2800_bbp_write(rt2x00dev, 120, 0x50);
+
+	if (txbf_enabled)
+		rt2800_bbp_write(rt2x00dev, 163, 0xbd);
+	else
+		rt2800_bbp_write(rt2x00dev, 163, 0x9d);
+
+	/* SNR mapping */
+	rt2800_bbp_write(rt2x00dev, 142, 6);
+	rt2800_bbp_write(rt2x00dev, 143, 160);
+	rt2800_bbp_write(rt2x00dev, 142, 7);
+	rt2800_bbp_write(rt2x00dev, 143, 161);
+	rt2800_bbp_write(rt2x00dev, 142, 8);
+	rt2800_bbp_write(rt2x00dev, 143, 162);
+
+	/* ADC/DAC control */
+	rt2800_bbp_write(rt2x00dev, 31, 0x08);
+
+	/* RX AGC energy lower bound in log2 */
+	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
+
+	/* FIXME: BBP 105 owerwrite? */
+	rt2800_bbp_write(rt2x00dev, 105, 0x04);
+}
+
 static void rt2800_init_rfcsr_3593(struct rt2x00_dev *rt2x00dev)
 {
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
@@ -5459,7 +5505,7 @@ static void rt2800_init_rfcsr_3593(struct rt2x00_dev *rt2x00dev)
 	rt2800_led_open_drain_enable(rt2x00dev);
 	rt2800_normal_mode_setup_3593(rt2x00dev);
 
-	/* TODO: post BBP initialization */
+	rt3593_post_bbp_init(rt2x00dev);
 
 	/* TODO: enable stream mode support */
 }
-- 
1.7.10

