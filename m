Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42286 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaJBL5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 07:57:32 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so94456wgh.29
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2014 04:57:31 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: don't create bssid peer for ibss
Date: Thu,  2 Oct 2014 13:56:40 +0200
Message-Id: <1412251000-25377-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141002_135737_069874_2A1C0729)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not really necessary to create bssid peer for
bssid. Self-address peer is sufficient.

This prevents some firmware revisions from crashing.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e3d2a9e..1fbbf8c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1052,14 +1052,6 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 		if (is_zero_ether_addr(arvif->bssid))
 			return;
 
-		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id,
-					 arvif->bssid);
-		if (ret) {
-			ath10k_warn(ar, "failed to delete IBSS BSSID peer %pM for vdev %d: %d\n",
-				    arvif->bssid, arvif->vdev_id, ret);
-			return;
-		}
-
 		memset(arvif->bssid, 0, ETH_ALEN);
 
 		return;
@@ -3178,17 +3170,17 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID &&
 	    vif->type != NL80211_IFTYPE_AP) {
 		if (!is_zero_ether_addr(info->bssid)) {
-			ath10k_dbg(ar, ATH10K_DBG_MAC,
-				   "mac vdev %d create peer %pM\n",
-				   arvif->vdev_id, info->bssid);
-
-			ret = ath10k_peer_create(ar, arvif->vdev_id,
-						 info->bssid);
-			if (ret)
-				ath10k_warn(ar, "failed to add peer %pM for vdev %d when changing bssid: %i\n",
-					    info->bssid, arvif->vdev_id, ret);
-
 			if (vif->type == NL80211_IFTYPE_STATION) {
+				ath10k_dbg(ar, ATH10K_DBG_MAC,
+					   "mac vdev %d create peer %pM\n",
+					   arvif->vdev_id, info->bssid);
+
+				ret = ath10k_peer_create(ar, arvif->vdev_id,
+							 info->bssid);
+				if (ret)
+					ath10k_warn(ar, "failed to add peer %pM for vdev %d when changing bssid: %i\n",
+						    info->bssid, arvif->vdev_id,
+						    ret);
 				/*
 				 * this is never erased as we it for crypto key
 				 * clearing; this is FW requirement
-- 
1.9.1

