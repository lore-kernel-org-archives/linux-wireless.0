Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34280 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbaHERou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 13:44:50 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath10k:  improve vdev map handling.
Date: Tue,  5 Aug 2014 10:44:44 -0700
Message-Id: <1407260684-22624-1-git-send-email-greearb@candelatech.com> (sfid-20140805_194453_730638_819EE117)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Check vdev map has space before calling ffs,
fix invalid cleanup in failure to create vdev
case.

Open-code the BIT() logic since BIT does not properly
handle 64-bit bitfields and future patches will make
use of larger bitfields.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Use == 0, remove some un-needed parens.

 drivers/net/wireless/ath/ath10k/mac.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3c794203..33a66b9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -597,14 +597,14 @@ static int ath10k_monitor_vdev_create(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	bit = ffs(ar->free_vdev_map);
-	if (bit == 0) {
+	if (ar->free_vdev_map == 0) {
 		ath10k_warn("failed to find free vdev id for monitor vdev\n");
 		return -ENOMEM;
 	}
 
+	bit = ffs(ar->free_vdev_map);
+
 	ar->monitor_vdev_id = bit - 1;
-	ar->free_vdev_map &= ~(1 << ar->monitor_vdev_id);
 
 	ret = ath10k_wmi_vdev_create(ar, ar->monitor_vdev_id,
 				     WMI_VDEV_TYPE_MONITOR,
@@ -612,20 +612,14 @@ static int ath10k_monitor_vdev_create(struct ath10k *ar)
 	if (ret) {
 		ath10k_warn("failed to request monitor vdev %i creation: %d\n",
 			    ar->monitor_vdev_id, ret);
-		goto vdev_fail;
+		return ret;
 	}
 
+	ar->free_vdev_map &= ~(1 << ar->monitor_vdev_id);
 	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d created\n",
 		   ar->monitor_vdev_id);
 
 	return 0;
-
-vdev_fail:
-	/*
-	 * Restore the ID to the global map.
-	 */
-	ar->free_vdev_map |= 1 << (ar->monitor_vdev_id);
-	return ret;
 }
 
 static int ath10k_monitor_vdev_delete(struct ath10k *ar)
@@ -641,7 +635,7 @@ static int ath10k_monitor_vdev_delete(struct ath10k *ar)
 		return ret;
 	}
 
-	ar->free_vdev_map |= 1 << (ar->monitor_vdev_id);
+	ar->free_vdev_map |= 1 << ar->monitor_vdev_id;
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d deleted\n",
 		   ar->monitor_vdev_id);
@@ -2743,11 +2737,12 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	INIT_WORK(&arvif->wep_key_work, ath10k_tx_wep_key_work);
 	INIT_LIST_HEAD(&arvif->list);
 
-	bit = ffs(ar->free_vdev_map);
-	if (bit == 0) {
+	if (ar->free_vdev_map == 0) {
+		ath10k_warn("Free vdev map is empty, no more interfaces allowed.\n");
 		ret = -EBUSY;
 		goto err;
 	}
+	bit = ffs(ar->free_vdev_map);
 
 	arvif->vdev_id = bit - 1;
 	arvif->vdev_subtype = WMI_VDEV_SUBTYPE_NONE;
@@ -2790,7 +2785,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err;
 	}
 
-	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+	ar->free_vdev_map &= ~(1 << arvif->vdev_id);
 	list_add(&arvif->list, &ar->arvifs);
 
 	vdev_param = ar->wmi.vdev_param->def_keyid;
@@ -2883,7 +2878,7 @@ err_peer_delete:
 
 err_vdev_delete:
 	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
-	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+	ar->free_vdev_map |= 1 << arvif->vdev_id;
 	list_del(&arvif->list);
 
 err:
@@ -2919,7 +2914,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		ath10k_warn("failed to stop spectral for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
-	ar->free_vdev_map |= 1 << (arvif->vdev_id);
+	ar->free_vdev_map |= 1 << arvif->vdev_id;
 	list_del(&arvif->list);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
-- 
1.7.11.7

