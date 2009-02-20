Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16422 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbZBTJrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 04:47:11 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 01:47:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18846.31547.103150.442091@gargle.gargle.HOWL> (sfid-20090220_104715_975839_C805A336)
Date: Fri, 20 Feb 2009 15:13:23 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/5] ath9k: Fix bug in EEPROM chainmask retrieval
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using wrong chainmasks would have an adverse impact on performance.
This patch fixes chainmask retrieval for non-PCIE cards.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 6f2e92e..2acbb84 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3220,14 +3220,11 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
-	if ((ah->is_pciexpress)
-	    || (eeval & AR5416_OPFLAGS_11A)) {
-		pCap->rx_chainmask =
-			ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
-	} else {
-		pCap->rx_chainmask =
-			(ath9k_hw_gpio_get(ah, 0)) ? 0x5 : 0x7;
-	}
+	if ((ah->hw_version.devid == AR5416_DEVID_PCI) &&
+	    !(eeval & AR5416_OPFLAGS_11A))
+		pCap->rx_chainmask = ath9k_hw_gpio_get(ah, 0) ? 0x5 : 0x7;
+	else
+		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
 
 	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
 		ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
-- 
1.6.1

