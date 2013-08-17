Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46651 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab3HQMJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:09:45 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 6/6] rt2x00: rt2800lib: adjust frequency offset for RF3053
Date: Sat, 17 Aug 2013 14:09:33 +0200
Message-Id: <1376741373-10032-7-git-send-email-juhosg@openwrt.org> (sfid-20130817_140950_448711_E37B86DE)
In-Reply-To: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
References: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Along with other chipsets, the Ralink driver uses the
frequency adjustment code for RF3053 as well. Remove
the bogus place-holder comment from the RF3053 specific
channel configuration function and call the frequency
adjustment function instead

Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  RT3593_ChipSwitchChannel function in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1b81fc9..aa6b6b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2360,7 +2360,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	}
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
-	/* TODO: frequency calibration? */
+	rt2800_adjust_freq_offset(rt2x00dev);
 
 	if (conf_is_ht40(conf)) {
 		txrx_agc_fc = rt2x00_get_field8(drv_data->calibration_bw40,
-- 
1.7.10
