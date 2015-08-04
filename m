Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbbHDU66 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/37] iwlwifi: mvm: LRU-assign key offsets
Date: Tue,  4 Aug 2015 23:42:57 +0300
Message-Id: <1438721007-23283-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230048_423347_4B7F80BC)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current key offset assignment algorithm always uses the lowest
unused key offset, which will potentially lead to issues when the
firmware will change to take the key material for TX from the key
table rather than from the TX command.

In order to avoid those issues (and avoid forgetting about them)
change the key offset allocation algorithm now to avoid reusing key
offsets quickly.

The new algorithm always picks as the next offset the least recently
freed offset, i.e. the offset that has been unused for the longest
amount of time. This is implemented by having a generation counter
for each key offset that is incremented every time a key is deleted,
except for the one that's deleted, which is reset to zero. Thus the
highest counter is the key that's been unused longest.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/sta.c | 32 ++++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2d4bad5..40d1bd7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -686,6 +686,7 @@ struct iwl_mvm {
 	 * can hold 16 keys at most. Reflect this fact.
 	 */
 	unsigned long fw_key_table[BITS_TO_LONGS(STA_KEY_MAX_NUM)];
+	u8 fw_key_deleted[STA_KEY_MAX_NUM];
 
 	/* references taken by the driver and spinlock protecting them */
 	spinlock_t refs_lock;
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index d68dc69..806b2c2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1148,18 +1148,31 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 static int iwl_mvm_set_fw_key_idx(struct iwl_mvm *mvm)
 {
-	int i;
+	int i, max = -1, max_offs = -1;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	i = find_first_zero_bit(mvm->fw_key_table, STA_KEY_MAX_NUM);
+	/* Pick the unused key offset with the highest 'deleted'
+	 * counter. Every time a key is deleted, all the counters
+	 * are incremented and the one that was just deleted is
+	 * reset to zero. Thus, the highest counter is the one
+	 * that was deleted longest ago. Pick that one.
+	 */
+	for (i = 0; i < STA_KEY_MAX_NUM; i++) {
+		if (test_bit(i, mvm->fw_key_table))
+			continue;
+		if (mvm->fw_key_deleted[i] > max) {
+			max = mvm->fw_key_deleted[i];
+			max_offs = i;
+		}
+	}
 
-	if (i == STA_KEY_MAX_NUM)
+	if (max_offs < 0)
 		return STA_KEY_IDX_INVALID;
 
-	__set_bit(i, mvm->fw_key_table);
+	__set_bit(max_offs, mvm->fw_key_table);
 
-	return i;
+	return max_offs;
 }
 
 static u8 iwl_mvm_get_key_sta_id(struct ieee80211_vif *vif,
@@ -1478,7 +1491,7 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 {
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 	u8 sta_id;
-	int ret;
+	int ret, i;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1497,6 +1510,13 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 		return -ENOENT;
 	}
 
+	/* track which key was deleted last */
+	for (i = 0; i < STA_KEY_MAX_NUM; i++) {
+		if (mvm->fw_key_deleted[i] < U8_MAX)
+			mvm->fw_key_deleted[i]++;
+	}
+	mvm->fw_key_deleted[keyconf->hw_key_idx] = 0;
+
 	if (sta_id == IWL_MVM_STATION_COUNT) {
 		IWL_DEBUG_WEP(mvm, "station non-existent, early return.\n");
 		return 0;
-- 
2.1.4

