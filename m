Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:55073 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbbA3Mdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 07:33:36 -0500
Received: by mail-we0-f182.google.com with SMTP id l61so26824475wev.13
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 04:33:35 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/7] ath10k: protect ar->arvifs linking with data_lock
Date: Fri, 30 Jan 2015 13:31:23 +0100
Message-Id: <1422621086-28970-5-git-send-email-michal.kazior@tieto.com> (sfid-20150130_133343_205791_E6009C45)
In-Reply-To: <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make it possible to iterate over
interface list while in an atomic context,
i.e. tasklet.

Caller should still be careful with accessing
arvif structures though.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e099479..ba66a67 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3331,7 +3331,10 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ar->free_vdev_map &= ~(1LL << arvif->vdev_id);
+
+	spin_lock_bh(&ar->data_lock);
 	list_add(&arvif->list, &ar->arvifs);
+	spin_unlock_bh(&ar->data_lock);
 
 	/* It makes no sense to have firmware do keepalives. mac80211 already
 	 * takes care of this with idle connection polling.
@@ -3458,7 +3461,9 @@ err_peer_delete:
 err_vdev_delete:
 	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	ar->free_vdev_map |= 1LL << arvif->vdev_id;
+	spin_lock_bh(&ar->data_lock);
 	list_del(&arvif->list);
+	spin_unlock_bh(&ar->data_lock);
 
 err:
 	if (arvif->beacon_buf) {
@@ -3493,7 +3498,10 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 			    arvif->vdev_id, ret);
 
 	ar->free_vdev_map |= 1LL << arvif->vdev_id;
+
+	spin_lock_bh(&ar->data_lock);
 	list_del(&arvif->list);
+	spin_unlock_bh(&ar->data_lock);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, vif->addr);
-- 
1.8.5.3

