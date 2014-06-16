Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:32224 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaFPQrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:47:06 -0400
Received: from ip-94-112-189-223.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.189.223])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 16 Jun 2014 18:40:23 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH] rt2x00: fix rfkill regression on rt2500pci
Date: Mon, 16 Jun 2014 18:45:15 +0200
Message-Id: <1402937115-5399-1-git-send-email-stf_xl@wp.pl> (sfid-20140616_184711_412136_A03671DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

As reported by Niels, starting rfkill polling during device probe
(commit e2bc7c5, generally sane change) broke rfkill on rt2500pci
device. I considered that bug as some initalization issue, which
should be fixed on rt2500pci specific code. But after several
attempts (see bug report for details) we fail to find working solution.
Hence I decided to revert to old behaviour on rt2500pci to fix
regression.

Additionally patch also unregister rfkill on device remove instead
of ifconfig down, what was another issue introduced by bad commit.

Bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=73821

Fixes: e2bc7c5f3cb8 ("rt2x00: Fix rfkill_polling register function.")
Cc: stable@vger.kernel.org
Bisected-by: Niels <nille0386@googlemail.com>
Reported-and-tested-by: Niels <nille0386@googlemail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |    7 ++++++-
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |   24 +++++++++++++++++++++---
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 2f1cd92..a511ccc 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1681,8 +1681,13 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
+	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO)) {
 		__set_bit(CAPABILITY_HW_BUTTON, &rt2x00dev->cap_flags);
+		/*
+		 * On this device RFKILL initialized during probe does not work.
+		 */
+		__set_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags);
+	}
 
 	/*
 	 * Check if the BBP tuning should be enabled.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 010b765..d13f25c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -693,6 +693,7 @@ enum rt2x00_capability_flags {
 	REQUIRE_SW_SEQNO,
 	REQUIRE_HT_TX_DESC,
 	REQUIRE_PS_AUTOWAKE,
+	REQUIRE_DELAYED_RFKILL,
 
 	/*
 	 * Capabilities
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2bde672..4fa43a2e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1126,9 +1126,10 @@ static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Unregister extra components.
+	 * Stop rfkill polling.
 	 */
-	rt2x00rfkill_unregister(rt2x00dev);
+	if (test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_unregister(rt2x00dev);
 
 	/*
 	 * Allow the HW to uninitialize.
@@ -1166,6 +1167,12 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 
 	set_bit(DEVICE_STATE_INITIALIZED, &rt2x00dev->flags);
 
+	/*
+	 * Start rfkill polling.
+	 */
+	if (test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_register(rt2x00dev);
+
 	return 0;
 }
 
@@ -1375,7 +1382,12 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00link_register(rt2x00dev);
 	rt2x00leds_register(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
-	rt2x00rfkill_register(rt2x00dev);
+
+	/*
+	 * Start rfkill polling.
+	 */
+	if (!test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_register(rt2x00dev);
 
 	return 0;
 
@@ -1391,6 +1403,12 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 
 	/*
+	 * Stop rfkill polling.
+	 */
+	if (!test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_unregister(rt2x00dev);
+
+	/*
 	 * Disable radio.
 	 */
 	rt2x00lib_disable_radio(rt2x00dev);
-- 
1.7.4.4

