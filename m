Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:60565 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYI1W12 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 18:27:28 -0400
Date: Mon, 29 Sep 2008 01:27:27 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH 5/5] ath5k: Add support for AR2417 v2
Message-ID: <20080928222727.GE21335@makis> (sfid-20080929_002730_621613_368692DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add support for AR2417 (include pci id) since my previous patch doesn't sit on top of base.c/ath5k.h anymore.
 * Update module version to 0.6.0

 Changes-Licensed-under: ISC
 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 905076a..22d2c3e 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -72,7 +72,7 @@ MODULE_AUTHOR("Nick Kossifidis");
 MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION("0.5.0 (EXPERIMENTAL)");
+MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
 
 
 /* Known PCI ids */
@@ -93,7 +93,8 @@ static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0019), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
 	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
 	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
-	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
+	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* PCI-E cards */
+	{ PCI_VDEVICE(ATHEROS, 0x001d), .driver_data = AR5K_AR5212 }, /* 2417 Nala */
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
