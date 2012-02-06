Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3292 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415Ab2BFW7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:07 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 6/8] rt2x00: Align RT3572 channel switch RFCSR 1 programming with Ralink driver.
Date: Mon,  6 Feb 2012 23:45:11 +0100
Message-Id: <1328568313-26267-7-git-send-email-gwingerde@gmail.com> (sfid-20120206_235920_971802_6580D97C)
In-Reply-To: <1328568313-26267-6-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-2-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-4-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-5-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-6-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align with the v2.5.0.0 Ralink RT3572 driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 66af6f4..2afb798 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1806,11 +1806,12 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
 	if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
 		if (rf->channel <= 14) {
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
-- 
1.7.9

