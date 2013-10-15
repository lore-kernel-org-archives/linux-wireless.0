Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:33624 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JOSq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 14:46:59 -0400
Subject: [PATCH 3/7] ath10k: track vif list internally
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:46:56 +0300
Message-ID: <20131015184656.14123.70575.stgit@localhost6.localdomain6> (sfid-20131015_204701_681835_CF828C3D)
In-Reply-To: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

mac80211 interface interations functions have
peculiar locking issues. This patch introduces
internal (to ath10k) vif list that will be used
for vif iteration purposes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    2 ++
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 drivers/net/wireless/ath/ath10k/mac.c  |    3 +++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c5561a9..ed51b51 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -713,6 +713,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
 
+	INIT_LIST_HEAD(&ar->arvifs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 
@@ -824,6 +825,7 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err_disconnect_htc;
 
 	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
+	INIT_LIST_HEAD(&ar->arvifs);
 
 	return 0;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index cef5455..0934f76 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -205,6 +205,8 @@ struct ath10k_peer {
 #define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
 
 struct ath10k_vif {
+	struct list_head list;
+
 	u32 vdev_id;
 	enum wmi_vdev_type vdev_type;
 	enum wmi_vdev_subtype vdev_subtype;
@@ -404,6 +406,7 @@ struct ath10k {
 	/* protects shared structure data */
 	spinlock_t data_lock;
 
+	struct list_head arvifs;
 	struct list_head peers;
 	wait_queue_head_t peer_mapping_wq;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 16e55bd..c8e4180 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2093,6 +2093,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+	list_add(&arvif->list, &ar->arvifs);
 
 	vdev_param = ar->wmi.vdev_param->def_keyid;
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
@@ -2175,6 +2176,7 @@ err_peer_delete:
 err_vdev_delete:
 	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+	list_del(&arvif->list);
 
 err:
 	mutex_unlock(&ar->conf_mutex);
@@ -2201,6 +2203,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	spin_unlock_bh(&ar->data_lock);
 
 	ar->free_vdev_map |= 1 << (arvif->vdev_id);
+	list_del(&arvif->list);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, vif->addr);

