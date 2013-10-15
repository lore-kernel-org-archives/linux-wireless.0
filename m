Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:59150 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JOSrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 14:47:10 -0400
Subject: [PATCH 5/7] ath10k: remove unnecessary checks
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:47:08 +0300
Message-ID: <20131015184708.14123.49715.stgit@localhost6.localdomain6> (sfid-20131015_204713_728296_2D3C3363)
In-Reply-To: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

mac80211 interface iteration functions that were
used originally iterated over interfaces that
weren't re-added to the driver during recovery.

Since internal vif list is now used it's safe to
remove the safe-guard as internal vif list is
based on add/remove_interface function which
guarantees that vdev is created in FW before it is
iterated over.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bd42a14..4273eef 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1964,13 +1964,6 @@ static int ath10k_config_ps(struct ath10k *ar)
 
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
@@ -2888,13 +2881,6 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
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
@@ -2918,13 +2904,6 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
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

