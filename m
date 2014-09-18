Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48680 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbaIRNcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:32:09 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so1041607wib.14
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:32:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/9] ath10k: fix tx/rx chainmask init
Date: Thu, 18 Sep 2014 15:21:19 +0200
Message-Id: <1411046487-19544-2-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153216_990000_2E37E069)
In-Reply-To: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware reports the number of RF chains so use
that for initialization of supp_{tx,rx}_chainmask
instead of using a macro for 3x3 chips.

This should make tx/rx chainmask reports correct
for chips other than 3x3.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 ---------
 drivers/net/wireless/ath/ath10k/wmi.c | 6 ++++++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4670930..c738827 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4800,15 +4800,6 @@ int ath10k_mac_register(struct ath10k *ar)
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_AP);
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		/* TODO:  Have to deal with 2x2 chips if/when the come out. */
-		ar->supp_tx_chainmask = TARGET_10X_TX_CHAIN_MASK;
-		ar->supp_rx_chainmask = TARGET_10X_RX_CHAIN_MASK;
-	} else {
-		ar->supp_tx_chainmask = TARGET_TX_CHAIN_MASK;
-		ar->supp_rx_chainmask = TARGET_RX_CHAIN_MASK;
-	}
-
 	ar->hw->wiphy->available_antennas_rx = ar->supp_rx_chainmask;
 	ar->hw->wiphy->available_antennas_tx = ar->supp_tx_chainmask;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2c42bd5..772cca5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2198,6 +2198,9 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
 	}
 
+	ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
+	ar->supp_rx_chainmask = (1 << ar->num_rf_chains) - 1;
+
 	ar->ath_common.regulatory.current_rd =
 		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
 
@@ -2268,6 +2271,9 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
 	}
 
+	ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
+	ar->supp_rx_chainmask = (1 << ar->num_rf_chains) - 1;
+
 	ar->ath_common.regulatory.current_rd =
 		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
 
-- 
1.8.5.3

