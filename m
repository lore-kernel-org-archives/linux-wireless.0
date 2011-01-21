Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:65318 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab1AUBrn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 20:47:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 17:47:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Paul Shaw <paul.shaw@atheros.com>
Subject: [PATCH] ath9k_hw: disabled PAPRD for AR9003
Date: Thu, 20 Jan 2011 17:47:39 -0800
Message-ID: <1295574459-12104-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003's PAPRD was enabled prematurely, and is causing some
large discrepancies on throughput and network connectivity.
For example downlink (RX) throughput against an AR9280 AP
can vary widlely from 43-73 Mbit/s while disabling this
gets AR9382 (2x2) up to around 93 Mbit/s in a 2.4 GHz HT20 setup.

Cc: stable@kernel.org
Cc: Paul Shaw <paul.shaw@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 +++++-
 drivers/net/wireless/ath/ath9k/hw.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1afb8bb..9f01e50 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -369,6 +369,9 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	else
 		ah->config.ht_enable = 0;
 
+	/* PAPRD needs some more work to be enabled */
+	ah->config.paprd_disable = 1;
+
 	ah->config.rx_intr_mitigation = true;
 	ah->config.pcieSerDesWrite = true;
 
@@ -1933,7 +1936,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
 		pCap->tx_desc_len = sizeof(struct ar9003_txc);
 		pCap->txs_len = sizeof(struct ar9003_txs);
-		if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
+		if (!ah->config.paprd_disable &&
+		    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c2b3515..ad8c2c7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -228,6 +228,7 @@ struct ath9k_ops_config {
 	u32 pcie_waen;
 	u8 analog_shiftreg;
 	u8 ht_enable;
+	u8 paprd_disable;
 	u32 ofdm_trig_low;
 	u32 ofdm_trig_high;
 	u32 cck_trig_high;
-- 
1.7.3.2.90.gd4c43

