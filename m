Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44555 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3JDFnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 01:43:52 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT v2 4/4] ath10k: remove unnecessary checks
Date: Fri, 4 Oct 2013 07:43:45 +0200
Message-ID: <1380865425-3791-5-git-send-email-michal.kazior@tieto.com> (sfid-20131004_074400_705393_76E54F6F)
In-Reply-To: <1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
References: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
 <1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 interface iteration functions that were
used originally iterated over interfaces that
weren't re-added to the driver during recovery.

Since internal vif list is now used it's safe to
remove the safe-guard as internal vif list is
based on add/remove_interface function which
guarantees that vdev is created in FW before it is
iterated over.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 583f065..7567db0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1924,13 +1924,6 @@ static int ath10k_config_ps(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	/* During HW reconfiguration mac80211 reports all interfaces that were
-	 * running until reconfiguration was started. Since FW doesn't have any
-	 * vdevs at this point we must not iterate over this interface list.
-	 * This setting will be updated upon add_interface(). */
-	if (ar->state == ATH10K_STATE_RESTARTED)
-		return 0;
-
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		ret = ath10k_mac_vif_setup_ps(arvif);
 		if (ret) {
@@ -2840,13 +2833,6 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	struct ath10k_vif *arvif;
 	int ret = 0;
 
-	/* During HW reconfiguration mac80211 reports all interfaces that were
-	 * running until reconfiguration was started. Since FW doesn't have any
-	 * vdevs at this point we must not iterate over this interface list.
-	 * This setting will be updated upon add_interface(). */
-	if (ar->state == ATH10K_STATE_RESTARTED)
-		return 0;
-
 	mutex_lock(&ar->conf_mutex);
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d rts threshold %d\n",
@@ -2870,13 +2856,6 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 	struct ath10k_vif *arvif;
 	int ret = 0;
 
-	/* During HW reconfiguration mac80211 reports all interfaces that were
-	 * running until reconfiguration was started. Since FW doesn't have any
-	 * vdevs at this point we must not iterate over this interface list.
-	 * This setting will be updated upon add_interface(). */
-	if (ar->state == ATH10K_STATE_RESTARTED)
-		return 0;
-
 	mutex_lock(&ar->conf_mutex);
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d fragmentation threshold %d\n",
-- 
1.7.9.5

