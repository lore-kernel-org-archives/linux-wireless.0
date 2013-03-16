Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41854 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab3CPSUA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:00 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 14/25] rt2800: 5592: setup LDO_CFG0 when configuring channel
Date: Sat, 16 Mar 2013 19:19:42 +0100
Message-Id: <1363457993-15541-15-git-send-email-stf_xl@wp.pl> (sfid-20130316_192007_298375_B85D8432)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
RT5592_ChipSwitchChannel()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 93b9def..189c880 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2187,12 +2187,17 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 					 struct channel_info *info)
 {
 	u8 rfcsr, ep_reg;
+	u32 reg;
 	int power_bound;
 
 	/* TODO */
 	const bool is_11b = false;
 	const bool is_type_ep = false;
 
+	rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+	rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL,
+			   (rf->channel > 14 || conf_is_ht40(conf)) ? 5 : 0);
+	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 
 	/* Order of values on rf_channel entry: N, K, mod, R */
 	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1 & 0xff);
-- 
1.7.4.4

