Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:56508 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3JDFnv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 01:43:51 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT v2 1/4] ath10k: fix add_interface failure handling
Date: Fri, 4 Oct 2013 07:43:42 +0200
Message-ID: <1380865425-3791-2-git-send-email-michal.kazior@tieto.com> (sfid-20131004_074355_603704_381F5BC7)
In-Reply-To: <1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
References: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
 <1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If something failed along add_interface() setup it
was possible to leak a vdev id, vdev and peer.

This could end up with leaked FW state or FW crash
(assuming add_interface() failure wasn't a result of
a crash).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   50 ++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8684e03..7f8b258 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2001,18 +2001,17 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	if ((vif->type == NL80211_IFTYPE_MONITOR) && ar->monitor_present) {
 		ath10k_warn("Only one monitor interface allowed\n");
 		ret = -EBUSY;
-		goto exit;
+		goto err;
 	}
 
 	bit = ffs(ar->free_vdev_map);
 	if (bit == 0) {
 		ret = -EBUSY;
-		goto exit;
+		goto err;
 	}
 
 	arvif->vdev_id = bit - 1;
 	arvif->vdev_subtype = WMI_VDEV_SUBTYPE_NONE;
-	ar->free_vdev_map &= ~(1 << arvif->vdev_id);
 
 	if (ar->p2p)
 		arvif->vdev_subtype = WMI_VDEV_SUBTYPE_P2P_DEVICE;
@@ -2048,26 +2047,32 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 				     arvif->vdev_subtype, vif->addr);
 	if (ret) {
 		ath10k_warn("WMI vdev create failed: ret %d\n", ret);
-		goto exit;
+		goto err;
 	}
 
+	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+
 	vdev_param = ar->wmi.vdev_param->def_keyid;
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
 					arvif->def_wep_key_index);
-	if (ret)
+	if (ret) {
 		ath10k_warn("Failed to set default keyid: %d\n", ret);
+		goto err_vdev_delete;
+	}
 
 	vdev_param = ar->wmi.vdev_param->tx_encap_type;
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					ATH10K_HW_TXRX_NATIVE_WIFI);
-	if (ret)
+	if (ret) {
 		ath10k_warn("Failed to set TX encap: %d\n", ret);
+		goto err_vdev_delete;
+	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
 		if (ret) {
 			ath10k_warn("Failed to create peer for AP: %d\n", ret);
-			goto exit;
+			goto err_vdev_delete;
 		}
 	}
 
@@ -2076,38 +2081,57 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		value = WMI_STA_PS_RX_WAKE_POLICY_WAKE;
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
-		if (ret)
+		if (ret) {
 			ath10k_warn("Failed to set RX wake policy: %d\n", ret);
+			goto err_peer_delete;
+		}
 
 		param = WMI_STA_PS_PARAM_TX_WAKE_THRESHOLD;
 		value = WMI_STA_PS_TX_WAKE_THRESHOLD_ALWAYS;
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
-		if (ret)
+		if (ret) {
 			ath10k_warn("Failed to set TX wake thresh: %d\n", ret);
+			goto err_peer_delete;
+		}
 
 		param = WMI_STA_PS_PARAM_PSPOLL_COUNT;
 		value = WMI_STA_PS_PSPOLL_COUNT_NO_MAX;
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
-		if (ret)
+		if (ret) {
 			ath10k_warn("Failed to set PSPOLL count: %d\n", ret);
+			goto err_peer_delete;
+		}
 	}
 
 	ret = ath10k_mac_set_rts(arvif, ar->hw->wiphy->rts_threshold);
-	if (ret)
+	if (ret) {
 		ath10k_warn("failed to set rts threshold for vdev %d (%d)\n",
 			    arvif->vdev_id, ret);
+		goto err_peer_delete;
+	}
 
 	ret = ath10k_mac_set_frag(arvif, ar->hw->wiphy->frag_threshold);
-	if (ret)
+	if (ret) {
 		ath10k_warn("failed to set frag threshold for vdev %d (%d)\n",
 			    arvif->vdev_id, ret);
+		goto err_peer_delete;
+	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
 		ar->monitor_present = true;
 
-exit:
+	mutex_unlock(&ar->conf_mutex);
+	return 0;
+
+err_peer_delete:
+	if (arvif->vdev_type == WMI_VDEV_TYPE_AP)
+		ath10k_wmi_peer_delete(ar, arvif->vdev_id, vif->addr);
+err_vdev_delete:
+	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
+	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+err:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
 }
-- 
1.7.9.5

