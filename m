Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52922 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab3GENPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 04/16] ath10k: do not setup rts/frag thresholds for suspended interfaces
Date: Fri,  5 Jul 2013 16:15:05 +0300
Message-Id: <1373030117-18077-5-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_152039_897140_82CA1574)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

mac80211 calls for rts/frag threshold hooks before
any interface is brought back up again when
resuming.

We would set vdev parameters before given vdev is
created lading to a FW crash.

rts/frag thresholds will be re-set accordingly in
add_interface() hook anyway.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ff0bb38..cdee800 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2597,7 +2597,7 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&ar->conf_mutex);
 	ieee80211_iterate_active_interfaces_atomic(
-		hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		hw, IEEE80211_IFACE_ITER_NORMAL,
 		ath10k_set_rts_iter, &ar_iter);
 	mutex_unlock(&ar->conf_mutex);
 
@@ -2639,7 +2639,7 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&ar->conf_mutex);
 	ieee80211_iterate_active_interfaces_atomic(
-		hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		hw, IEEE80211_IFACE_ITER_NORMAL,
 		ath10k_set_frag_iter, &ar_iter);
 	mutex_unlock(&ar->conf_mutex);
 
-- 
1.7.9.5

