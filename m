Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57332 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaLQKU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:20:59 -0500
Subject: [PATCH v2 2/8] ath10k: use wmi op version to check which iface
 combination to use
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 17 Dec 2014 12:20:54 +0200
Message-ID: <20141217102054.15964.32162.stgit@potku.adurom.net> (sfid-20141217_112101_781780_A4C8FBAB)
In-Reply-To: <20141217101755.15964.2625.stgit@potku.adurom.net>
References: <20141217101755.15964.2625.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ATH10K_FW_FEATURE_WMI_10X should not be used for anymore as that's
now deprecated, instead use wmi op version.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5475f0fbbe41..4576d758d50b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5064,16 +5064,25 @@ int ath10k_mac_register(struct ath10k *ar)
 	 */
 	ar->hw->queues = 4;
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
-		ar->hw->wiphy->n_iface_combinations =
-			ARRAY_SIZE(ath10k_10x_if_comb);
-	} else {
+	switch (ar->wmi.op_version) {
+	case ATH10K_FW_WMI_OP_VERSION_MAIN:
+	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_if_comb);
-
 		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
+		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_1:
+	case ATH10K_FW_WMI_OP_VERSION_10_2:
+		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
+		ar->hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(ath10k_10x_if_comb);
+		break;
+	case ATH10K_FW_WMI_OP_VERSION_UNSET:
+	case ATH10K_FW_WMI_OP_VERSION_MAX:
+		WARN_ON(1);
+		ret = -EINVAL;
+		goto err_free;
 	}
 
 	ar->hw->netdev_features = NETIF_F_HW_CSUM;

