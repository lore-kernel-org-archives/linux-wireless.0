Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51900 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbbJ0MVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 08:21:41 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/4] ath10k: remove supported chain mask
Date: Tue, 27 Oct 2015 17:51:11 +0530
Message-ID: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151027_132144_943905_504E9316)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing supported chainmask fields as it can be always derived
from num_rf_chains.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  2 --
 drivers/net/wireless/ath/ath10k/mac.c  | 17 +++++------------
 drivers/net/wireless/ath/ath10k/wmi.c  |  6 ++++--
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cc7cdd..cd598cf 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -730,8 +730,6 @@ struct ath10k {
 	int num_started_vdevs;
 
 	/* Protected by conf-mutex */
-	u8 supp_tx_chainmask;
-	u8 supp_rx_chainmask;
 	u8 cfg_tx_chainmask;
 	u8 cfg_rx_chainmask;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 484c1a1..b4eb9fd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3736,13 +3736,8 @@ static int ath10k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (ar->cfg_tx_chainmask) {
-		*tx_ant = ar->cfg_tx_chainmask;
-		*rx_ant = ar->cfg_rx_chainmask;
-	} else {
-		*tx_ant = ar->supp_tx_chainmask;
-		*rx_ant = ar->supp_rx_chainmask;
-	}
+	*tx_ant = ar->cfg_tx_chainmask;
+	*rx_ant = ar->cfg_rx_chainmask;
 
 	mutex_unlock(&ar->conf_mutex);
 
@@ -3884,9 +3879,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		}
 	}
 
-	if (ar->cfg_tx_chainmask)
-		__ath10k_set_antenna(ar, ar->cfg_tx_chainmask,
-				     ar->cfg_rx_chainmask);
+	__ath10k_set_antenna(ar, ar->cfg_tx_chainmask, ar->cfg_rx_chainmask);
 
 	/*
 	 * By default FW set ARP frames ac to voice (6). In that case ARP
@@ -7157,8 +7150,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	ar->hw->wiphy->available_antennas_rx = ar->supp_rx_chainmask;
-	ar->hw->wiphy->available_antennas_tx = ar->supp_tx_chainmask;
+	ar->hw->wiphy->available_antennas_rx = ar->cfg_rx_chainmask;
+	ar->hw->wiphy->available_antennas_tx = ar->cfg_tx_chainmask;
 
 	if (!test_bit(ATH10K_FW_FEATURE_NO_P2P, ar->fw_features))
 		ar->hw->wiphy->interface_modes |=
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6e7d7a7..b36ecf2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4335,8 +4335,10 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 		ar->num_rf_chains = ar->max_spatial_stream;
 	}
 
-	ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
-	ar->supp_rx_chainmask = (1 << ar->num_rf_chains) - 1;
+	if (!ar->cfg_tx_chainmask) {
+		ar->cfg_tx_chainmask = (1 << ar->num_rf_chains) - 1;
+		ar->cfg_rx_chainmask = (1 << ar->num_rf_chains) - 1;
+	}
 
 	if (strlen(ar->hw->wiphy->fw_version) == 0) {
 		snprintf(ar->hw->wiphy->fw_version,
-- 
2.6.2

