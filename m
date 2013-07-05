Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:55639 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 02/16] ath10k: fix possible deadlock
Date: Fri,  5 Jul 2013 16:15:03 +0300
Message-Id: <1373030117-18077-3-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_152039_550165_7B65653C)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

It was possible to have a deadlock due to inverted
locking of local->iflist_mtx and
ath10k->conf_mutex.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1285554..9943ee9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2578,8 +2578,9 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	ar_iter.ar = ar;
 
 	mutex_lock(&ar->conf_mutex);
-	ieee80211_iterate_active_interfaces(hw, IEEE80211_IFACE_ITER_RESUME_ALL,
-					    ath10k_set_rts_iter, &ar_iter);
+	ieee80211_iterate_active_interfaces_atomic(
+		hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath10k_set_rts_iter, &ar_iter);
 	mutex_unlock(&ar->conf_mutex);
 
 	return ar_iter.ret;
@@ -2619,8 +2620,9 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 	ar_iter.ar = ar;
 
 	mutex_lock(&ar->conf_mutex);
-	ieee80211_iterate_active_interfaces(hw, IEEE80211_IFACE_ITER_RESUME_ALL,
-					    ath10k_set_frag_iter, &ar_iter);
+	ieee80211_iterate_active_interfaces_atomic(
+		hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath10k_set_frag_iter, &ar_iter);
 	mutex_unlock(&ar->conf_mutex);
 
 	return ar_iter.ret;
-- 
1.7.9.5

