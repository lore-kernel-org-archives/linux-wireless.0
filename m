Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:58134 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab2BMEz2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 23:55:28 -0500
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 2/4] rt2800usb: remove rt2800usb_set_state function
Date: Mon, 13 Feb 2012 05:48:37 +0100
Message-Id: <1329108519-5342-3-git-send-email-kubakici@wp.pl> (sfid-20120213_055555_839074_DE21BE5E)
In-Reply-To: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove rt2800usb_set_state to make the flow inside USB driver
similar to that of PCI driver.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index d009b6b..15cce5e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -272,17 +272,6 @@ static void rt2800usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_disable_radio(rt2x00dev);
 }
 
-static int rt2800usb_set_state(struct rt2x00_dev *rt2x00dev,
-			       enum dev_state state)
-{
-	if (state == STATE_AWAKE)
-		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 2);
-	else
-		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
-
-	return 0;
-}
-
 static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 				      enum dev_state state)
 {
@@ -295,7 +284,7 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		 * to be woken up. After that it needs a bit of time
 		 * to be fully awake and then the radio can be enabled.
 		 */
-		rt2800usb_set_state(rt2x00dev, STATE_AWAKE);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 2);
 		msleep(1);
 		retval = rt2800usb_enable_radio(rt2x00dev);
 		break;
@@ -305,17 +294,18 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		 * be put to sleep for powersaving.
 		 */
 		rt2800usb_disable_radio(rt2x00dev);
-		rt2800usb_set_state(rt2x00dev, STATE_SLEEP);
-		break;
-	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_OFF:
-		/* No support, but no error either */
-		break;
+		/* fall through */
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
 	case STATE_STANDBY:
+		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
+		break;
 	case STATE_AWAKE:
-		retval = rt2800usb_set_state(rt2x00dev, state);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 2);
+		break;
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		/* No support, but no error either */
 		break;
 	default:
 		retval = -ENOTSUPP;
-- 
1.7.7.6

