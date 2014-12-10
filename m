Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58662 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaLJMoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 07:44:24 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so3482216wgg.39
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2014 04:44:23 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/5] ath10k: enable per-vif sta powersave
Date: Wed, 10 Dec 2014 13:31:53 +0100
Message-Id: <1418214714-29689-5-git-send-email-michal.kazior@tieto.com> (sfid-20141210_134429_453927_3F08F94F)
In-Reply-To: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
References: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per-vif bss_conf.ps should be used to configure
powersave.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d41e3d5..e84397d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1073,9 +1073,6 @@ static int ath10k_mac_vif_recalc_ps_wake_threshold(struct ath10k_vif *arvif)
 	return 0;
 }
 
-/*
- * Review this when mac80211 gains per-interface powersave support.
- */
 static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
@@ -1091,7 +1088,7 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 	if (arvif->vif->type != NL80211_IFTYPE_STATION)
 		return 0;
 
-	if (conf->flags & IEEE80211_CONF_PS) {
+	if (vif->bss_conf.ps) {
 		psmode = WMI_STA_PS_MODE_ENABLED;
 		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
@@ -3355,6 +3352,13 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to recalc tx power: %d\n", ret);
 	}
 
+	if (changed & BSS_CHANGED_PS) {
+		ret = ath10k_mac_vif_setup_ps(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to setup ps on vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
-- 
1.8.5.3

