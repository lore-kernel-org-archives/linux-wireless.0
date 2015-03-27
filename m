Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:32845 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbbC0IYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 04:24:45 -0400
Received: by labto5 with SMTP id to5so64915163lab.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2015 01:24:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix static wep with more than 1 key in client mode
Date: Fri, 27 Mar 2015 08:21:56 +0000
Message-Id: <1427444516-974-2-git-send-email-michal.kazior@tieto.com> (sfid-20150327_092449_787092_DEE57789)
In-Reply-To: <1427444516-974-1-git-send-email-michal.kazior@tieto.com>
References: <1427444516-974-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default keyidx callback may be called after
more than 1 key is installed. This led to only 1
WEP key being reinstalled only. This caused Rxed
traffic encrypted with other WEP keys to be
dropped in client mode.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 45 +++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9d873900257d..3baea2b671dd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -259,41 +259,44 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 	return first_errno;
 }
 
-static int ath10k_mac_vif_sta_fix_wep_key(struct ath10k_vif *arvif)
+static int ath10k_mac_vif_sta_fix_wep_key(struct ath10k_vif *arvif, int keyidx)
 {
 	struct ath10k *ar = arvif->ar;
 	enum nl80211_iftype iftype = arvif->vif->type;
 	struct ieee80211_key_conf *key;
-	u32 flags = 0;
-	int num = 0;
-	int i;
+	u32 flags;
 	int ret;
+	int i;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (iftype != NL80211_IFTYPE_STATION)
 		return 0;
 
+	if (keyidx < 0)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(arvif->wep_keys); i++) {
-		if (arvif->wep_keys[i]) {
-			key = arvif->wep_keys[i];
-			++num;
+		if (!arvif->wep_keys[i])
+			continue;
+
+		key = arvif->wep_keys[i];
+
+		flags = 0;
+		flags |= WMI_KEY_PAIRWISE;
+
+		if (key->keyidx == keyidx)
+			flags |= WMI_KEY_TX_USAGE;
+
+		ret = ath10k_install_key(arvif, key, SET_KEY, arvif->bssid,
+					 flags);
+		if (ret) {
+			ath10k_warn(ar, "failed to install key %i on vdev %i: %d\n",
+				    key->keyidx, arvif->vdev_id, ret);
+			return ret;
 		}
 	}
 
-	if (num != 1)
-		return 0;
-
-	flags |= WMI_KEY_PAIRWISE;
-	flags |= WMI_KEY_TX_USAGE;
-
-	ret = ath10k_install_key(arvif, key, SET_KEY, arvif->bssid, flags);
-	if (ret) {
-		ath10k_warn(ar, "failed to install key %i on vdev %i: %d\n",
-			    key->keyidx, arvif->vdev_id, ret);
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -4227,7 +4230,7 @@ static void ath10k_set_default_unicast_key(struct ieee80211_hw *hw,
 
 	arvif->def_wep_key_idx = keyidx;
 
-	ret = ath10k_mac_vif_sta_fix_wep_key(arvif);
+	ret = ath10k_mac_vif_sta_fix_wep_key(arvif, keyidx);
 	if (ret) {
 		ath10k_warn(ar, "failed to fix sta wep key on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
-- 
2.1.4

