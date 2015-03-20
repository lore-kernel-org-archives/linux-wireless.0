Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33640 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbCTLAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 07:00:50 -0400
Received: by lbbrr9 with SMTP id rr9so8039352lbb.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 04:00:49 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v4 4/6] ath10k: update station counting
Date: Fri, 20 Mar 2015 12:02:57 +0100
Message-Id: <1426849379-7562-5-git-send-email-marek.puzyniak@tieto.com> (sfid-20150320_120053_672371_415DE5D0)
In-Reply-To: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently station counting functions
(inc_num_stations/dec_num_stations) does not handle
tdls type of stations. Tdls station should be counted
because it consumes peer in firmware. Only not tdls
stations are excluded from this counting.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 866c948..3c25507 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4386,14 +4386,14 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 	mutex_unlock(&ar->conf_mutex);
 }
 
-static int ath10k_mac_inc_num_stations(struct ath10k_vif *arvif)
+static int ath10k_mac_inc_num_stations(struct ath10k_vif *arvif,
+				       struct ieee80211_sta *sta)
 {
 	struct ath10k *ar = arvif->ar;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
-	    arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+	if (arvif->vdev_type == WMI_VDEV_TYPE_STA && !sta->tdls)
 		return 0;
 
 	if (ar->num_stations >= ar->max_num_stations)
@@ -4404,14 +4404,14 @@ static int ath10k_mac_inc_num_stations(struct ath10k_vif *arvif)
 	return 0;
 }
 
-static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif)
+static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif,
+					struct ieee80211_sta *sta)
 {
 	struct ath10k *ar = arvif->ar;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
-	    arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+	if (arvif->vdev_type == WMI_VDEV_TYPE_STA && !sta->tdls)
 		return;
 
 	ar->num_stations--;
@@ -4453,7 +4453,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   ar->num_stations + 1, ar->max_num_stations,
 			   ar->num_peers + 1, ar->max_num_peers);
 
-		ret = ath10k_mac_inc_num_stations(arvif);
+		ret = ath10k_mac_inc_num_stations(arvif, sta);
 		if (ret) {
 			ath10k_warn(ar, "refusing to associate station: too many connected already (%d)\n",
 				    ar->max_num_stations);
@@ -4465,7 +4465,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
-			ath10k_mac_dec_num_stations(arvif);
+			ath10k_mac_dec_num_stations(arvif, sta);
 			goto exit;
 		}
 
@@ -4478,7 +4478,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 					    arvif->vdev_id, ret);
 				WARN_ON(ath10k_peer_delete(ar, arvif->vdev_id,
 							   sta->addr));
-				ath10k_mac_dec_num_stations(arvif);
+				ath10k_mac_dec_num_stations(arvif, sta);
 				goto exit;
 			}
 
@@ -4509,7 +4509,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to delete peer %pM for vdev %d: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 
-		ath10k_mac_dec_num_stations(arvif);
+		ath10k_mac_dec_num_stations(arvif, sta);
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC &&
 		   (vif->type == NL80211_IFTYPE_AP ||
-- 
2.1.4

