Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58026 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaJJK5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 06:57:32 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so3534782wgh.28
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 03:57:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: skip some commands on reassoc
Date: Fri, 10 Oct 2014 12:46:16 +0200
Message-Id: <1412937977-5859-3-git-send-email-michal.kazior@tieto.com> (sfid-20141010_125738_658694_76565D20)
In-Reply-To: <1412937977-5859-1-git-send-email-michal.kazior@tieto.com>
References: <1412937977-5859-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to reconfigure peer
completely upon reassociation. This will make it
easier to have a more uniform association code
across different modes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 52 +++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1021e31..266b740 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1615,35 +1615,41 @@ static int ath10k_station_assoc(struct ath10k *ar,
 		return ret;
 	}
 
-	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
-	if (ret) {
-		ath10k_warn(ar, "failed to setup peer SMPS for vdev %d: %d\n",
-			    arvif->vdev_id, ret);
-		return ret;
-	}
-
-	if (!sta->wme && !reassoc) {
-		arvif->num_legacy_stations++;
-		ret  = ath10k_recalc_rtscts_prot(arvif);
+	/* Re-assoc is run only to update supported rates for given station. It
+	 * doesn't make much sense to reconfigure the peer completely.
+	 */
+	if (!reassoc) {
+		ret = ath10k_setup_peer_smps(ar, arvif, sta->addr,
+					     &sta->ht_cap);
 		if (ret) {
-			ath10k_warn(ar, "failed to recalculate rts/cts prot for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to setup peer SMPS for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
-	}
 
-	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
-	if (ret) {
-		ath10k_warn(ar, "failed to install peer wep keys for vdev %i: %d\n",
-			    arvif->vdev_id, ret);
-		return ret;
-	}
+		ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
+		if (ret) {
+			ath10k_warn(ar, "failed to set qos params for STA %pM for vdev %i: %d\n",
+				    sta->addr, arvif->vdev_id, ret);
+			return ret;
+		}
 
-	ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
-	if (ret) {
-		ath10k_warn(ar, "failed to set qos params for STA %pM for vdev %i: %d\n",
-			    sta->addr, arvif->vdev_id, ret);
-		return ret;
+		if (!sta->wme) {
+			arvif->num_legacy_stations++;
+			ret  = ath10k_recalc_rtscts_prot(arvif);
+			if (ret) {
+				ath10k_warn(ar, "failed to recalculate rts/cts prot for vdev %d: %d\n",
+					    arvif->vdev_id, ret);
+				return ret;
+			}
+		}
+
+		ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
+		if (ret) {
+			ath10k_warn(ar, "failed to install peer wep keys for vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+			return ret;
+		}
 	}
 
 	return ret;
-- 
1.8.5.3

