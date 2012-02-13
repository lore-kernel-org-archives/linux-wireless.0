Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:58108 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab2BMEz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 23:55:26 -0500
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 1/4] rt2800pci: remove rt2800pci_set_state function
Date: Mon, 13 Feb 2012 05:48:36 +0100
Message-Id: <1329108519-5342-2-git-send-email-kubakici@wp.pl> (sfid-20120213_055555_262238_F11550B9)
In-Reply-To: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800pci_set_state was introduced to group requests preceded with
common introduction. As that introduction is no longer used
rt2800pci_set_state can be removed.

Note that this patch changes behaviour for STATE_DEEP_SLEEP and
STATE_STANDBY, but those states are not used in rt2800 anyway.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   38 ++++++++++--------------------
 1 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 6ad6929..6ab4637 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -517,23 +517,6 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
-			       enum dev_state state)
-{
-	if (state == STATE_AWAKE) {
-		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
-		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
-	} else if (state == STATE_SLEEP) {
-		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS,
-					 0xffffffff);
-		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID,
-					 0xffffffff);
-		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
-	}
-
-	return 0;
-}
-
 static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 				      enum dev_state state)
 {
@@ -546,7 +529,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		 * to be woken up. After that it needs a bit of time
 		 * to be fully awake and then the radio can be enabled.
 		 */
-		rt2800pci_set_state(rt2x00dev, STATE_AWAKE);
+		rt2800pci_set_device_state(rt2x00dev, STATE_AWAKE);
 		msleep(1);
 		retval = rt2800pci_enable_radio(rt2x00dev);
 		break;
@@ -556,17 +539,22 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		 * be put to sleep for powersaving.
 		 */
 		rt2800pci_disable_radio(rt2x00dev);
-		rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
-		break;
-	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_OFF:
-		rt2800pci_toggle_irq(rt2x00dev, state);
-		break;
+		/* fall through */
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
 	case STATE_STANDBY:
+		/* PCIe devices won't report status after SLEEP request. */
+		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
+		break;
 	case STATE_AWAKE:
-		retval = rt2800pci_set_state(rt2x00dev, state);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
+		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
+		break;
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		rt2800pci_toggle_irq(rt2x00dev, state);
 		break;
 	default:
 		retval = -ENOTSUPP;
-- 
1.7.7.6

