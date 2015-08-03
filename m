Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36743 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbHCJQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 05:16:14 -0400
Received: by lbbud7 with SMTP id ud7so70412244lbb.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 02:16:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: remove futile fragmentation threshold config
Date: Mon,  3 Aug 2015 11:16:42 +0200
Message-Id: <1438593403-316-1-git-send-email-michal.kazior@tieto.com> (sfid-20150803_111621_994767_AD89C919)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 1010ba4c5d1c ("ath10k: unregister and
remove frag_threshold callback") didn't remove all
instances of (futile) fragmentation threshold
configuration. No known firmware supports the
parameter so don't even bother setting it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index acd222f3b899..879af9c3bd4a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -678,20 +678,6 @@ static int ath10k_mac_set_rts(struct ath10k_vif *arvif, u32 value)
 	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, value);
 }
 
-static int ath10k_mac_set_frag(struct ath10k_vif *arvif, u32 value)
-{
-	struct ath10k *ar = arvif->ar;
-	u32 vdev_param;
-
-	if (value != 0xFFFFFFFF)
-		value = clamp_t(u32, arvif->ar->hw->wiphy->frag_threshold,
-				ATH10K_FRAGMT_THRESHOLD_MIN,
-				ATH10K_FRAGMT_THRESHOLD_MAX);
-
-	vdev_param = ar->wmi.vdev_param->fragmentation_threshold;
-	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, value);
-}
-
 static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 {
 	int ret;
@@ -4276,13 +4262,6 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err_peer_delete;
 	}
 
-	ret = ath10k_mac_set_frag(arvif, ar->hw->wiphy->frag_threshold);
-	if (ret) {
-		ath10k_warn(ar, "failed to set frag threshold for vdev %d: %d\n",
-			    arvif->vdev_id, ret);
-		goto err_peer_delete;
-	}
-
 	arvif->txpower = vif->bss_conf.txpower;
 	ret = ath10k_mac_txpower_recalc(ar);
 	if (ret) {
-- 
2.1.4

