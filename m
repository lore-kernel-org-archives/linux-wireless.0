Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:31023 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab2BVU7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 15:59:20 -0500
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v3 2/2] rt2800pci: Fix 'Error - MCU request failed' during initialization
Date: Wed, 22 Feb 2012 21:58:58 +0100
Message-Id: <1329944338-4696-2-git-send-email-kubakici@wp.pl> (sfid-20120222_215923_212160_AF8C5454)
In-Reply-To: <1329944338-4696-1-git-send-email-kubakici@wp.pl>
References: <1329944338-4696-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bring MCU operations during device initialization to sync
with legacy driver.

This should fix following error:
phy0 -> rt2800pci_mcu_status: Error - MCU request failed,
no response from hardware

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
v3: move code from switch statement to appropriate function.
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 891547c..ac874db 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -501,11 +501,27 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
+	int retval;
+
 	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
 		     rt2800pci_init_queues(rt2x00dev)))
 		return -EIO;
 
-	return rt2800_enable_radio(rt2x00dev);
+	retval = rt2800_enable_radio(rt2x00dev);
+	if (retval)
+		return retval;
+
+	/* After resume MCU_BOOT_SIGNAL will trash these. */
+	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+
+	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF, 0xff, 0x02);
+	rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
+
+	rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKEUP, 0, 0);
+	rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
+
+	return retval;
 }
 
 static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
@@ -543,13 +559,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 
 	switch (state) {
 	case STATE_RADIO_ON:
-		/*
-		 * Before the radio can be enabled, the device first has
-		 * to be woken up. After that it needs a bit of time
-		 * to be fully awake and then the radio can be enabled.
-		 */
-		rt2800pci_set_state(rt2x00dev, STATE_AWAKE);
-		msleep(1);
 		retval = rt2800pci_enable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_OFF:
-- 
1.7.7.6

