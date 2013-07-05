Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43826 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 03/16] ath10k: setup rts/frag thresholds upon vdev creation
Date: Fri,  5 Jul 2013 16:15:04 +0300
Message-Id: <1373030117-18077-4-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_152039_792717_3612AA59)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

mac80211 configures rts/frag thresholds per-hw not
per-vif. ath10k FW expects those values to be set
per-vdev (i.e. per-vif).

ath10k should now respect rts/frag thresholds set
before a given interface was brought up.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9943ee9..ff0bb38 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1753,7 +1753,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	enum wmi_sta_powersave_param param;
 	int ret = 0;
-	u32 value;
+	u32 value, rts, frag;
 	int bit;
 
 	mutex_lock(&ar->conf_mutex);
@@ -1856,6 +1856,24 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 			ath10k_warn("Failed to set PSPOLL count: %d\n", ret);
 	}
 
+	rts = min_t(u32, ar->hw->wiphy->rts_threshold, ATH10K_RTS_MAX);
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					 WMI_VDEV_PARAM_RTS_THRESHOLD,
+					 rts);
+	if (ret)
+		ath10k_warn("failed to set rts threshold for vdev %d (%d)\n",
+			    arvif->vdev_id, ret);
+
+	frag = clamp_t(u32, ar->hw->wiphy->frag_threshold,
+		       ATH10K_FRAGMT_THRESHOLD_MIN,
+		       ATH10K_FRAGMT_THRESHOLD_MAX);
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					WMI_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+					frag);
+	if (ret)
+		ath10k_warn("failed to set frag threshold for vdev %d (%d)\n",
+			    arvif->vdev_id, ret);
+
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
 		ar->monitor_present = true;
 
-- 
1.7.9.5

