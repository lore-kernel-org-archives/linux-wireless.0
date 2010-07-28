Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38096 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0G1Qp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 12:45:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: add led_disable module option
Date: Wed, 28 Jul 2010 12:31:51 -0400
Message-Id: <1280334711-6141-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not everyone agrees about LED behaviour...give them an escape hatch that
will at least stop the lights from annoying them.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 67aa52e..6c416db 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -43,6 +43,10 @@
 #include "ath5k.h"
 #include "base.h"
 
+static int modparam_led_disable;
+module_param_named(led_disable, modparam_led_disable, bool, S_IRUGO);
+MODULE_PARM_DESC(led_disable, "Disable software-controlled LEDs.");
+
 #define ATH_SDEVICE(subv,subd) \
 	.vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
 	.subvendor = (subv), .subdevice = (subd)
@@ -165,6 +169,9 @@ int ath5k_init_leds(struct ath5k_softc *sc)
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 	const struct pci_device_id *match;
 
+	if (modparam_led_disable)
+		goto out;
+
 	match = pci_match_id(&ath5k_led_devices[0], pdev);
 	if (match) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-- 
1.7.1.1

