Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:43537 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbbBFMDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 07:03:55 -0500
Received: by mail-we0-f172.google.com with SMTP id x3so7700719wes.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 04:03:54 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 4/7] ath10k: protect ar->arvifs linking with data_lock
Date: Fri,  6 Feb 2015 13:02:51 +0100
Message-Id: <1423224174-24764-5-git-send-email-michal.kazior@tieto.com> (sfid-20150206_130416_523376_EE9594C0)
In-Reply-To: <1423224174-24764-1-git-send-email-michal.kazior@tieto.com>
References: <1423224174-24764-1-git-send-email-michal.kazior@tieto.com>
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
index 2348f8b..1d7e0ae 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3314,7 +3314,10 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ar->free_vdev_map &= ~(1LL << arvif->vdev_id);
+
+	spin_lock_bh(&ar->data_lock);
 	list_add(&arvif->list, &ar->arvifs);
+	spin_unlock_bh(&ar->data_lock);
 
 	/* It makes no sense to have firmware do keepalives. mac80211 already
 	 * takes care of this with idle connection polling.
@@ -3434,7 +3437,9 @@ err_peer_delete:
 err_vdev_delete:
 	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	ar->free_vdev_map |= 1LL << arvif->vdev_id;
+	spin_lock_bh(&ar->data_lock);
 	list_del(&arvif->list);
+	spin_unlock_bh(&ar->data_lock);
 
 err:
 	if (arvif->beacon_buf) {
@@ -3467,7 +3472,10 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
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

