Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38338 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbYGTNyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 09:54:12 -0400
Message-ID: <48833EAE.6000803@openwrt.org> (sfid-20080720_155415_103789_C8C7AAD4)
Date: Sun, 20 Jul 2008 15:33:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath5k-devel@lists.ath5k.org
Subject: [PATCH 3/5] ath9k: add missing device ID for AR9160 MiniPCI cards
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -8329,6 +8329,8 @@
  	case AR5416_DEVID_PCI:
  	case AR5416_DEVID_PCIE:
  		return "Atheros 5416";
+	case AR9160_DEVID_PCI:
+		return "Atheros 9160";
  	case AR9280_DEVID_PCI:
  	case AR9280_DEVID_PCIE:
  		return "Atheros 9280";
@@ -8350,6 +8352,7 @@
  	switch (devid) {
  	case AR5416_DEVID_PCI:
  	case AR5416_DEVID_PCIE:
+	case AR9160_DEVID_PCI:
  	case AR9280_DEVID_PCI:
  	case AR9280_DEVID_PCIE:
  		ah = ath9k_hw_do_attach(devid, sc, mem, error);
