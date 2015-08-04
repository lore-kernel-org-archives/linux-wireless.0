Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34123 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbHDFZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 01:25:07 -0400
From: Vivek Natarajan <nataraja@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH 2/2] ath10k: Enable MU MIMO txbf support for QCA99X0
Date: Tue, 4 Aug 2015 10:45:12 +0530
Message-ID: <1438665312-2768-2-git-send-email-nataraja@qti.qualcomm.com> (sfid-20150804_072512_148744_B08BEB0E)
In-Reply-To: <1438665312-2768-1-git-send-email-nataraja@qti.qualcomm.com>
References: <1438665312-2768-1-git-send-email-nataraja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables MU-MIMO transmit beamforming support
for QCA99X0 chipsets.

Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 44 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h |  5 ++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4eb29aa..aaec5e2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4046,6 +4046,43 @@ static u32 get_nss_from_chainmask(u16 chain_mask)
 	return 1;
 }
 
+static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
+{
+	u32 value = 0;
+	struct ath10k *ar = arvif->ar;
+
+	if (ath10k_wmi_get_txbf_conf_scheme(ar) != WMI_TXBF_CONF_BEFORE_ASSOC)
+		return 0;
+
+	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE))
+		value |= SM((ar->num_rf_chains - 1), WMI_TXBF_STS_CAP_OFFSET);
+
+	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
+				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE))
+		value |= SM((ar->num_rf_chains - 1), WMI_BF_SOUND_DIM_OFFSET);
+
+	if (!value)
+		return 0;
+
+	if (ar->vht_cap_info & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)
+		value |= WMI_VDEV_PARAM_TXBF_SU_TX_BFER;
+
+	if (ar->vht_cap_info & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)
+		value |= (WMI_VDEV_PARAM_TXBF_MU_TX_BFER |
+			  WMI_VDEV_PARAM_TXBF_SU_TX_BFER);
+
+	if (ar->vht_cap_info & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)
+		value |= WMI_VDEV_PARAM_TXBF_SU_TX_BFEE;
+
+	if (ar->vht_cap_info & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)
+		value |= (WMI_VDEV_PARAM_TXBF_MU_TX_BFEE |
+			  WMI_VDEV_PARAM_TXBF_SU_TX_BFEE);
+
+	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					 ar->wmi.vdev_param->txbf, value);
+}
+
 /*
  * TODO:
  * Figure out how to handle WMI_VDEV_SUBTYPE_P2P_DEVICE,
@@ -4272,6 +4309,13 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		}
 	}
 
+	ret = ath10k_mac_set_txbf_conf(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to set txbf for vdev %d: %d\n",
+			    arvif->vdev_id, ret);
+		goto err_peer_delete;
+	}
+
 	ret = ath10k_mac_set_rts(arvif, ar->hw->wiphy->rts_threshold);
 	if (ret) {
 		ath10k_warn(ar, "failed to set rts threshold for vdev %d: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 754cc33..232500a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4628,6 +4628,11 @@ enum wmi_10_4_vdev_param {
 #define WMI_VDEV_PARAM_TXBF_SU_TX_BFER BIT(2)
 #define WMI_VDEV_PARAM_TXBF_MU_TX_BFER BIT(3)
 
+#define WMI_TXBF_STS_CAP_OFFSET_LSB	4
+#define WMI_TXBF_STS_CAP_OFFSET_MASK	0xf0
+#define WMI_BF_SOUND_DIM_OFFSET_LSB	8
+#define WMI_BF_SOUND_DIM_OFFSET_MASK	0xf00
+
 /* slot time long */
 #define WMI_VDEV_SLOT_TIME_LONG		0x1
 /* slot time short */
-- 
1.9.1

