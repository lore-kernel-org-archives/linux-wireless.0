Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35573 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab3IKR5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 13:57:07 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>,
	Steven Liu <steven.liu@mediatek.com>,
	JasonYS Cheng <jasonys.cheng@mediatek.com>
Subject: [PATCH] rt2x00: rt2800lib: fix band selection and LNA PE control for RT3593 PCIe cards
Date: Wed, 11 Sep 2013 19:56:45 +0200
Message-Id: <1378922205-19054-1-git-send-email-juhosg@openwrt.org> (sfid-20130911_195711_279095_295CB11F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The band selection and PE control code for the
RT3593 chipsets only handles USB based devices
currently. Due to this limitation RT3593 based
PCIe cards are not working correctly.

On PCIe cards band selection is controlled via
GPIO #8 which is identical to the USB devices.
The LNA PE control is slightly different, all
LNA PEs are controlled by GPIO #4.

Update the code to configure the GPIO_CTRL register
correctly on PCIe devices.

Cc: Steven Liu <steven.liu@mediatek.com>
Cc: JasonYS Cheng <jasonys.cheng@mediatek.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 88ce656..5f0a94c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3315,29 +3315,37 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 8, 0x80);
 
 	if (rt2x00_rt(rt2x00dev, RT3593)) {
-		if (rt2x00_is_usb(rt2x00dev)) {
-			rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+		rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
 
-			/* Band selection. GPIO #8 controls all paths */
+		/* Band selection */
+		if (rt2x00_is_usb(rt2x00dev) ||
+		    rt2x00_is_pcie(rt2x00dev)) {
+			/* GPIO #8 controls all paths */
 			rt2x00_set_field32(&reg, GPIO_CTRL_DIR8, 0);
 			if (rf->channel <= 14)
 				rt2x00_set_field32(&reg, GPIO_CTRL_VAL8, 1);
 			else
 				rt2x00_set_field32(&reg, GPIO_CTRL_VAL8, 0);
+		}
 
+		/* LNA PE control. */
+		if (rt2x00_is_usb(rt2x00dev)) {
+			/* GPIO #4 controls PE0 and PE1,
+			 * GPIO #7 controls PE2
+			 */
 			rt2x00_set_field32(&reg, GPIO_CTRL_DIR4, 0);
 			rt2x00_set_field32(&reg, GPIO_CTRL_DIR7, 0);
 
-			/* LNA PE control.
-			* GPIO #4 controls PE0 and PE1,
-			* GPIO #7 controls PE2
-			*/
 			rt2x00_set_field32(&reg, GPIO_CTRL_VAL4, 1);
 			rt2x00_set_field32(&reg, GPIO_CTRL_VAL7, 1);
-
-			rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
+		} else if (rt2x00_is_pcie(rt2x00dev)) {
+			/* GPIO #4 controls PE0, PE1 and PE2 */
+			rt2x00_set_field32(&reg, GPIO_CTRL_DIR4, 0);
+			rt2x00_set_field32(&reg, GPIO_CTRL_VAL4, 1);
 		}
 
+		rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
+
 		/* AGC init */
 		if (rf->channel <= 14)
 			reg = 0x1c + 2 * rt2x00dev->lna_gain;
-- 
1.7.10
