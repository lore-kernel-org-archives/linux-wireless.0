Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:48063 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab2BMEzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 23:55:33 -0500
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 4/4] rt2800pci: Fix 'Error - MCU request failed' during initialization
Date: Mon, 13 Feb 2012 05:48:39 +0100
Message-Id: <1329108519-5342-5-git-send-email-kubakici@wp.pl> (sfid-20120213_055558_323042_5F547BF2)
In-Reply-To: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bring MCU operations during device initialization to sync
with legacy driver.

This should fix following error:
phy0 -> rt2800pci_mcu_status: Error - MCU request failed,
no response from hardware

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f184a4f..773d078 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -524,14 +524,20 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 
 	switch (state) {
 	case STATE_RADIO_ON:
-		/*
-		 * Before the radio can be enabled, the device first has
-		 * to be woken up. After that it needs a bit of time
-		 * to be fully awake and then the radio can be enabled.
-		 */
-		rt2800pci_set_device_state(rt2x00dev, STATE_AWAKE);
-		msleep(1);
+		/* Initialise all registers and send MCU_BOOT_SIGNAL. */
 		retval = rt2800pci_enable_radio(rt2x00dev);
+
+		/* After resume MCU_BOOT_SIGNAL will trash these. */
+		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+
+		/* Finish initialization procedure. */
+		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF,
+				   0xff, 0x02);
+		rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
+
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKEUP, 0, 0);
+		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
 		break;
 	case STATE_RADIO_OFF:
 		/*
-- 
1.7.7.6

