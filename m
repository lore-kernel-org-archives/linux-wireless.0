Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:1473 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756432Ab2BFW7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:05 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/8] rt2x00: Fix RFCSR 12 & 13 programming on RT3572 channel switching.
Date: Mon,  6 Feb 2012 23:45:10 +0100
Message-Id: <1328568313-26267-6-git-send-email-gwingerde@gmail.com> (sfid-20120206_235931_117638_3F14654F)
In-Reply-To: <1328568313-26267-5-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-2-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-4-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-5-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align with v2.5.0.0 Ralink RT3572 driver for 2.4GHz band channel switch.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index cb841f4..66af6f4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1783,8 +1783,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	if (rf->channel <= 14) {
 		rt2x00_set_field8(&rfcsr, RFCSR12_DR0, 3);
 		rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
-				(info->default_power1 & 0x3) |
-				((info->default_power1 & 0xC) << 1));
+				  info->default_power1);
 	} else {
 		rt2x00_set_field8(&rfcsr, RFCSR12_DR0, 7);
 		rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
@@ -1797,8 +1796,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	if (rf->channel <= 14) {
 		rt2x00_set_field8(&rfcsr, RFCSR13_DR0, 3);
 		rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
-				(info->default_power2 & 0x3) |
-				((info->default_power2 & 0xC) << 1));
+				  info->default_power2);
 	} else {
 		rt2x00_set_field8(&rfcsr, RFCSR13_DR0, 7);
 		rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
-- 
1.7.9

