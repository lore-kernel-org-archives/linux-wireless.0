Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62571 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:46:09 -0500
Received: by mail-wi0-f172.google.com with SMTP id o1so5699747wic.11
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:46:08 -0800 (PST)
Message-Id: <d343eda14ab39b1890edf2d2a4e1456eae55a254.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_154618_732471_DFADE9AE)
In-Reply-To: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
References: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 16 Dec 2012 01:41:37 +0100
Subject: [PATCH 4/8] carl9170: allow P2P_GO interface creation after
 P2P_CLIENT
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic reported that after a change in wpa_supplicant
["nl80211: Automatically use concurrent P2P if possible"],
carl9170 was no longer able to host a P2P network.

This patch tackles the problem by allowing GO interfaces to be
registered, long after the P2P_CLIENT interface is brought up.

Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |   54 ++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 9dce200..5d3cb88 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -580,7 +580,7 @@ static int carl9170_op_add_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct carl9170_vif_info *vif_priv = (void *) vif->drv_priv;
-	struct ieee80211_vif *main_vif;
+	struct ieee80211_vif *main_vif, *old_main = NULL;
 	struct ar9170 *ar = hw->priv;
 	int vif_id = -1, err = 0;
 
@@ -602,6 +602,15 @@ static int carl9170_op_add_interface(struct ieee80211_hw *hw,
 		goto init;
 	}
 
+	/* Because the AR9170 HW's MAC doesn't provide full support for
+	 * multiple, independent interfaces [of different operation modes].
+	 * We have to select ONE main interface [main mode of HW], but we
+	 * can have multiple slaves [AKA: entry in the ACK-table].
+	 *
+	 * The first (from HEAD/TOP) interface in the ar->vif_list is
+	 * always the main intf. All following intfs in this list
+	 * are considered to be slave intfs.
+	 */
 	main_vif = carl9170_get_main_vif(ar);
 
 	if (main_vif) {
@@ -610,6 +619,18 @@ static int carl9170_op_add_interface(struct ieee80211_hw *hw,
 			if (vif->type == NL80211_IFTYPE_STATION)
 				break;
 
+			/* P2P GO [master] use-case
+			 * Because the P2P GO station is selected dynamically
+			 * by all participating peers of a WIFI Direct network,
+			 * the driver has be able to change the main interface
+			 * operating mode on the fly.
+			 */
+			if (main_vif->p2p && vif->p2p &&
+			    vif->type == NL80211_IFTYPE_AP) {
+				old_main = main_vif;
+				break;
+			}
+
 			err = -EBUSY;
 			rcu_read_unlock();
 
@@ -648,14 +669,41 @@ static int carl9170_op_add_interface(struct ieee80211_hw *hw,
 	vif_priv->id = vif_id;
 	vif_priv->enable_beacon = false;
 	ar->vifs++;
-	list_add_tail_rcu(&vif_priv->list, &ar->vif_list);
+	if (old_main) {
+		/* We end up in here, if the main interface is being replaced.
+		 * Put the new main interface at the HEAD of the list and the
+		 * previous inteface will automatically become second in line.
+		 */
+		list_add_rcu(&vif_priv->list, &ar->vif_list);
+	} else {
+		/* Add new inteface. If the list is empty, it will become the
+		 * main inteface, otherwise it will be slave.
+		 */
+		list_add_tail_rcu(&vif_priv->list, &ar->vif_list);
+	}
 	rcu_assign_pointer(ar->vif_priv[vif_id].vif, vif);
 
 init:
-	if (carl9170_get_main_vif(ar) == vif) {
+	main_vif = carl9170_get_main_vif(ar);
+
+	if (main_vif == vif) {
 		rcu_assign_pointer(ar->beacon_iter, vif_priv);
 		rcu_read_unlock();
 
+		if (old_main) {
+			struct carl9170_vif_info *old_main_priv =
+				(void *) old_main->drv_priv;
+			/* downgrade old main intf to slave intf.
+			 * NOTE: We are no longer under rcu_read_lock.
+			 * But we are still holding ar->mutex, so the
+			 * vif data [id, addr] is safe.
+			 */
+			err = carl9170_mod_virtual_mac(ar, old_main_priv->id,
+						       old_main->addr);
+			if (err)
+				goto unlock;
+		}
+
 		err = carl9170_init_interface(ar, vif);
 		if (err)
 			goto unlock;
-- 
1.7.10.4

