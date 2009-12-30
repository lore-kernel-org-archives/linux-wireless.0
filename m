Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:65239 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbZL3Kgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 05:36:52 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/6] rt2x00: RF3052 is a valid RF chipset for USB devices as well.
Date: Wed, 30 Dec 2009 11:36:31 +0100
Message-Id: <1262169394-11647-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-3-git-send-email-gwingerde@gmail.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RF3052 chipset is now also being integrated onto USB devices, so
allow the RF chipset and don't treat it as PCI/SOC only.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 8ff7db8..bcb7e17 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1862,7 +1862,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rf(rt2x00dev, RF3020) &&
 	    !rt2x00_rf(rt2x00dev, RF2020) &&
 	    !rt2x00_rf(rt2x00dev, RF3021) &&
-	    !rt2x00_rf(rt2x00dev, RF3022)) {
+	    !rt2x00_rf(rt2x00dev, RF3022) &&
+	    !rt2x00_rf(rt2x00dev, RF3052)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -2047,7 +2048,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rf(rt2x00dev, RF2820) ||
 	    rt2x00_rf(rt2x00dev, RF2720) ||
-	    (rt2x00_intf_is_pci(rt2x00dev) && rt2x00_rf(rt2x00dev, RF3052))) {
+	    rt2x00_rf(rt2x00dev, RF3052)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals;
 	} else if (rt2x00_rf(rt2x00dev, RF2850) || rt2x00_rf(rt2x00dev, RF2750)) {
-- 
1.6.6

