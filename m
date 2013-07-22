Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43240 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3GVMNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:13:49 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/4] ath10k: fix rts/fragmentation threshold setup
Date: Mon, 22 Jul 2013 14:13:31 +0200
Message-ID: <1374495211-20353-5-git-send-email-michal.kazior@tieto.com> (sfid-20130722_141354_872949_F939587A)
In-Reply-To: <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
 <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
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
index 6144b3b..d0a7761 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -332,6 +332,29 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
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
@@ -1897,7 +1920,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	enum wmi_sta_powersave_param param;
 	int ret = 0;
-	u32 value, rts, frag;
+	u32 value;
 	int bit;
 
 	mutex_lock(&ar->conf_mutex);
@@ -2000,20 +2023,12 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
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
@@ -2728,11 +2743,7 @@ static void ath10k_set_rts_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
 		return;
 
-	rts = min_t(u32, rts, ATH10K_RTS_MAX);
-
-	ar_iter->ret = ath10k_wmi_vdev_set_param(ar_iter->ar, arvif->vdev_id,
-						 WMI_VDEV_PARAM_RTS_THRESHOLD,
-						 rts);
+	ar_iter->ret = ath10k_mac_set_rts(arvif, rts);
 	if (ar_iter->ret)
 		ath10k_warn("Failed to set RTS threshold for VDEV: %d\n",
 			    arvif->vdev_id);
@@ -2764,7 +2775,6 @@ static void ath10k_set_frag_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath10k_generic_iter *ar_iter = data;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	u32 frag = ar_iter->ar->hw->wiphy->frag_threshold;
-	int ret;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
@@ -2775,15 +2785,7 @@ static void ath10k_set_frag_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
 		return;
 
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

