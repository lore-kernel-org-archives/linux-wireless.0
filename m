Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:47760 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3JBJvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:14 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix scheduling while atomic bug on config
Date: Wed, 2 Oct 2013 11:51:07 +0200
Message-ID: <1380707467-30387-1-git-send-email-michal.kazior@tieto.com> (sfid-20131002_115118_598787_269413DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent WMI/HTC changes introduces this bug because
now WMI commands can sleep.

Use appropriate interface iteration function.

Reported-By: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8684e03..b65df84 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1935,9 +1935,8 @@ static void ath10k_config_ps(struct ath10k *ar)
 	memset(&ar_iter, 0, sizeof(struct ath10k_generic_iter));
 	ar_iter.ar = ar;
 
-	ieee80211_iterate_active_interfaces_atomic(
-		ar->hw, IEEE80211_IFACE_ITER_NORMAL,
-		ath10k_ps_iter, &ar_iter);
+	ieee80211_iterate_active_interfaces(ar->hw, IEEE80211_IFACE_ITER_NORMAL,
+					    ath10k_ps_iter, &ar_iter);
 
 	if (ar_iter.ret)
 		ath10k_warn("failed to set ps config (%d)\n", ar_iter.ret);
@@ -2840,9 +2839,8 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	ar_iter.ar = ar;
 
 	mutex_lock(&ar->conf_mutex);
-	ieee80211_iterate_active_interfaces_atomic(
-		hw, IEEE80211_IFACE_ITER_NORMAL,
-		ath10k_set_rts_iter, &ar_iter);
+	ieee80211_iterate_active_interfaces(hw, IEEE80211_IFACE_ITER_NORMAL,
+					    ath10k_set_rts_iter, &ar_iter);
 	mutex_unlock(&ar->conf_mutex);
 
 	return ar_iter.ret;
@@ -2881,9 +2879,8 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 	ar_iter.ar = ar;
 
 	mutex_lock(&ar->conf_mutex);
-	ieee80211_iterate_active_interfaces_atomic(
-		hw, IEEE80211_IFACE_ITER_NORMAL,
-		ath10k_set_frag_iter, &ar_iter);
+	ieee80211_iterate_active_interfaces(hw, IEEE80211_IFACE_ITER_NORMAL,
+					    ath10k_set_frag_iter, &ar_iter);
 	mutex_unlock(&ar->conf_mutex);
 
 	return ar_iter.ret;
-- 
1.7.9.5

