Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40828 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbcEJUan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:22 +0300
Message-Id: <1462910797-20303-26-git-send-email-luca@coelho.fi> (sfid-20160510_223045_634591_060AD8BB)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 26/41] iwlwifi: mvm: loosen nssn comparison to reorder buffer head
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Up till now, the reorder buffer uses standard spec based comparison
when comparing the buffer status to NSSN. This indeed works for the
regular case, since we shouldn't cross the 2048 boundary without
getting a frame release notification.
However, this is problematic due to packet filtering that may be
performed by the FW while we are in d0i3. Theoretically we may
filter over 2048 packets, and then the check of the NSSN will get
incorrect.
Change the comparison to always trust nssn unless it is 64 or less
frames behind the head - which might happen due to a timeout.
This new comparison is to be used only when comparing reorder buffer
head with nssn, and not when comparing the packet SN to nssn or
reorder buffer head.
Put this in a separate commit as the logic is a bit tricky and
stands for its own commit message.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 5fe7a0e..ac2c571 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -395,6 +395,18 @@ int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
 	return ret;
 }
 
+/*
+ * Returns true if sn2 - buffer_size < sn1 < sn2.
+ * To be used only in order to compare reorder buffer head with NSSN.
+ * We fully trust NSSN unless it is behind us due to reorder timeout.
+ * Reorder timeout can only bring us up to buffer_size SNs ahead of NSSN.
+ */
+static bool iwl_mvm_is_sn_less(u16 sn1, u16 sn2, u16 buffer_size)
+{
+	return ieee80211_sn_less(sn1, sn2) &&
+	       !ieee80211_sn_less(sn1, sn2 - buffer_size);
+}
+
 #define RX_REORDER_BUF_TIMEOUT_MQ (HZ / 10)
 
 static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
@@ -408,10 +420,10 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 	lockdep_assert_held(&reorder_buf->lock);
 
 	/* ignore nssn smaller than head sn - this can happen due to timeout */
-	if (ieee80211_sn_less(nssn, ssn))
+	if (iwl_mvm_is_sn_less(nssn, ssn, reorder_buf->buf_size))
 		return;
 
-	while (ieee80211_sn_less(ssn, nssn)) {
+	while (iwl_mvm_is_sn_less(ssn, nssn, reorder_buf->buf_size)) {
 		int index = ssn % reorder_buf->buf_size;
 		struct sk_buff_head *skb_list = &reorder_buf->entries[index];
 		struct sk_buff *skb;
@@ -625,7 +637,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	 * rest of the function will take of storing it and releasing up to the
 	 * nssn
 	 */
-	if (!ieee80211_sn_less(nssn, buffer->head_sn + buffer->buf_size)) {
+	if (!iwl_mvm_is_sn_less(nssn, buffer->head_sn + buffer->buf_size,
+				buffer->buf_size)) {
 		u16 min_sn = ieee80211_sn_less(sn, nssn) ? sn : nssn;
 
 		iwl_mvm_release_frames(mvm, sta, napi, buffer, min_sn);
@@ -637,7 +650,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 
 	/* release immediately if allowed by nssn and no stored frames */
 	if (!buffer->num_stored && ieee80211_sn_less(sn, nssn)) {
-		if (ieee80211_sn_less(buffer->head_sn, nssn))
+		if (iwl_mvm_is_sn_less(buffer->head_sn, nssn,
+				       buffer->buf_size))
 			buffer->head_sn = nssn;
 		/* No need to update AMSDU last SN - we are moving the head */
 		spin_unlock_bh(&buffer->lock);
-- 
2.8.1

