Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:55153 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3GRGdZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 02:33:25 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: fix rts/fragmentation threshold setup
Date: Thu, 18 Jul 2013 08:33:13 +0200
Message-ID: <1374129193-3533-4-git-send-email-michal.kazior@tieto.com> (sfid-20130718_083329_822692_089DF284)
In-Reply-To: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If RTS and fragmentation threshold values are
0xFFFFFFFF they should be considered disabled and
no min/max limits must be applied.

This fixes some issues with throughput issues,
especially with VHT.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   54 +++++++++++++++++----------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3d0f876..019c6b8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -331,6 +331,29 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 	return 0;
 }
 
+static int  ath10k_mac_set_rts(struct ath10k_vif *arvif, u32 value)
+{
+	if (value != 0xFFFFFFFF)
+		value = min_t(u32, arvif->ar->hw->wiphy->rts_threshold,
+			      ATH10K_RTS_MAX);
+
+	return ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id,
+					 WMI_VDEV_PARAM_RTS_THRESHOLD,
+					 value);
+}
+
+static int ath10k_mac_set_frag(struct ath10k_vif *arvif, u32 value)
+{
+	if (value != 0xFFFFFFFF)
+		value = clamp_t(u32, arvif->ar->hw->wiphy->frag_threshold,
+				ATH10K_FRAGMT_THRESHOLD_MIN,
+				ATH10K_FRAGMT_THRESHOLD_MAX);
+
+	return ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id,
+					 WMI_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+					 value);
+}
+
 static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 {
 	int ret;
@@ -1803,7 +1826,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	enum wmi_sta_powersave_param param;
 	int ret = 0;
-	u32 value, rts, frag;
+	u32 value;
 	int bit;
 
 	mutex_lock(&ar->conf_mutex);
@@ -1906,20 +1929,12 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 			ath10k_warn("Failed to set PSPOLL count: %d\n", ret);
 	}
 
-	rts = min_t(u32, ar->hw->wiphy->rts_threshold, ATH10K_RTS_MAX);
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-					 WMI_VDEV_PARAM_RTS_THRESHOLD,
-					 rts);
+	ret = ath10k_mac_set_rts(arvif, ar->hw->wiphy->rts_threshold);
 	if (ret)
 		ath10k_warn("failed to set rts threshold for vdev %d (%d)\n",
 			    arvif->vdev_id, ret);
 
-	frag = clamp_t(u32, ar->hw->wiphy->frag_threshold,
-		       ATH10K_FRAGMT_THRESHOLD_MIN,
-		       ATH10K_FRAGMT_THRESHOLD_MAX);
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-					WMI_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
-					frag);
+	ret = ath10k_mac_set_frag(arvif, ar->hw->wiphy->frag_threshold);
 	if (ret)
 		ath10k_warn("failed to set frag threshold for vdev %d (%d)\n",
 			    arvif->vdev_id, ret);
@@ -2627,11 +2642,7 @@ static void ath10k_set_rts_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
-	rts = min_t(u32, rts, ATH10K_RTS_MAX);
-
-	ar_iter->ret = ath10k_wmi_vdev_set_param(ar_iter->ar, arvif->vdev_id,
-						 WMI_VDEV_PARAM_RTS_THRESHOLD,
-						 rts);
+	ar_iter->ret = ath10k_mac_set_rts(arvif, rts);
 	if (ar_iter->ret)
 		ath10k_warn("Failed to set RTS threshold for VDEV: %d\n",
 			    arvif->vdev_id);
@@ -2663,19 +2674,10 @@ static void ath10k_set_frag_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath10k_generic_iter *ar_iter = data;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	u32 frag = ar_iter->ar->hw->wiphy->frag_threshold;
-	int ret;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
-	frag = clamp_t(u32, frag,
-		       ATH10K_FRAGMT_THRESHOLD_MIN,
-		       ATH10K_FRAGMT_THRESHOLD_MAX);
-
-	ret = ath10k_wmi_vdev_set_param(ar_iter->ar, arvif->vdev_id,
-					WMI_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
-					frag);
-
-	ar_iter->ret = ret;
+	ar_iter->ret = ath10k_mac_set_frag(arvif, frag);
 	if (ar_iter->ret)
 		ath10k_warn("Failed to set frag threshold for VDEV: %d\n",
 			    arvif->vdev_id);
-- 
1.7.9.5

