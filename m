Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35559 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbHMMKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:10:20 -0400
Received: by lbcbn3 with SMTP id bn3so25641832lbc.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 05:10:19 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: split ap/ibss wep key install process
Date: Thu, 13 Aug 2015 14:10:46 +0200
Message-Id: <1439467846-8351-1-git-send-email-michal.kazior@tieto.com> (sfid-20150813_141023_942572_45918B0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently it's not safe to install both pairwise
and groupwise keys on AP vdevs as it can cause
traffic to stop working in some multi-vif
(WPA+WEP) cases.

Fixes: ce90b27128c2 ("ath10k: fix multiple key static wep with ibss")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 44 +++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index acd222f3b899..eabfe68a1c48 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -247,6 +247,10 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (WARN_ON(arvif->vif->type != NL80211_IFTYPE_AP &&
+		    arvif->vif->type != NL80211_IFTYPE_ADHOC))
+		return -EINVAL;
+
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find(ar, arvif->vdev_id, addr);
 	spin_unlock_bh(&ar->data_lock);
@@ -258,21 +262,34 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 		if (arvif->wep_keys[i] == NULL)
 			continue;
 
-		flags = 0;
-		flags |= WMI_KEY_PAIRWISE;
+		switch (arvif->vif->type) {
+		case NL80211_IFTYPE_AP:
+			flags = WMI_KEY_PAIRWISE;
 
-		ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
-					 addr, flags);
-		if (ret < 0)
-			return ret;
+			if (arvif->def_wep_key_idx == i)
+				flags |= WMI_KEY_TX_USAGE;
 
-		flags = 0;
-		flags |= WMI_KEY_GROUP;
+			ret = ath10k_install_key(arvif, arvif->wep_keys[i],
+						 SET_KEY, addr, flags);
+			if (ret < 0)
+				return ret;
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			ret = ath10k_install_key(arvif, arvif->wep_keys[i],
+						 SET_KEY, addr,
+						 WMI_KEY_PAIRWISE);
+			if (ret < 0)
+				return ret;
 
-		ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
-					 addr, flags);
-		if (ret < 0)
-			return ret;
+			ret = ath10k_install_key(arvif, arvif->wep_keys[i],
+						 SET_KEY, addr, WMI_KEY_GROUP);
+			if (ret < 0)
+				return ret;
+			break;
+		default:
+			WARN_ON(1);
+			return -EINVAL;
+		}
 
 		spin_lock_bh(&ar->data_lock);
 		peer->keys[i] = arvif->wep_keys[i];
@@ -287,6 +304,9 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 	 *
 	 * FIXME: Revisit. Perhaps this can be done in a less hacky way.
 	 */
+	if (arvif->vif->type != NL80211_IFTYPE_ADHOC)
+		return 0;
+
 	if (arvif->def_wep_key_idx == -1)
 		return 0;
 
-- 
2.1.4

