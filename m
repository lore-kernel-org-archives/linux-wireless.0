Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42345 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3JCNMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 09:12:37 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 2/3] ath10k: track vif list internally
Date: Thu, 3 Oct 2013 15:09:24 +0200
Message-ID: <1380805765-31521-3-git-send-email-michal.kazior@tieto.com> (sfid-20131003_151240_682527_F8B9D0AA)
In-Reply-To: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
References: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 interface interations functions have
peculiar locking issues. This patch introduces
internal (to ath10k) vif list that will be used
for vif iteration purposes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    2 ++
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 drivers/net/wireless/ath/ath10k/mac.c  |    3 +++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7b5dd09..4d04dc8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -710,6 +710,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
 
+	INIT_LIST_HEAD(&ar->arvifs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 
@@ -817,6 +818,7 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err_disconnect_htc;
 
 	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
+	INIT_LIST_HEAD(&ar->arvifs);
 
 	return 0;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ce36daa..de20ac0 100644
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
@@ -402,6 +404,7 @@ struct ath10k {
 	/* protects shared structure data */
 	spinlock_t data_lock;
 
+	struct list_head arvifs;
 	struct list_head peers;
 	wait_queue_head_t peer_mapping_wq;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7f8b258..292e5cd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2051,6 +2051,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+	list_add(&arvif->list, &ar->arvifs);
 
 	vdev_param = ar->wmi.vdev_param->def_keyid;
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
@@ -2131,6 +2132,7 @@ err_peer_delete:
 err_vdev_delete:
 	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
+	list_del(&arvif->list);
 err:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
@@ -2153,6 +2155,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	spin_unlock_bh(&ar->data_lock);
 
 	ar->free_vdev_map |= 1 << (arvif->vdev_id);
+	list_del(&arvif->list);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, vif->addr);
-- 
1.7.9.5

