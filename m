Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47093 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbbHMJbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 05:31:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: mvm: don't set K1/K2 for AES-CMAC
Date: Thu, 13 Aug 2015 11:31:27 +0200
Message-Id: <1439458287-22939-1-git-send-email-johannes@sipsolutions.net> (sfid-20150813_113139_150189_2E21FD63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

According to firmware engineers, the firmware has never required
these fields and the values have always been calculated, they were
just leftovers from a previous implementation.

Therefore remove the unnecessary calculation.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I'll apply this to my tree to remove the mac80211 function.
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.c        | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index 21dd5b771660..493a8bdfbc9e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -366,8 +366,8 @@ struct iwl_mvm_rm_sta_cmd {
  * ( MGMT_MCAST_KEY = 0x1f )
  * @ctrl_flags: %iwl_sta_key_flag
  * @IGTK:
- * @K1: IGTK master key
- * @K2: IGTK sub key
+ * @K1: unused
+ * @K2: unused
  * @sta_id: station ID that support IGTK
  * @key_id:
  * @receive_seq_cnt: initial RSC/PN needed for replay check
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index d68dc697a4a0..3d2fbf1bc226 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1277,8 +1277,6 @@ static int iwl_mvm_send_sta_igtk(struct iwl_mvm *mvm,
 		const u8 *pn;
 
 		memcpy(igtk_cmd.IGTK, keyconf->key, keyconf->keylen);
-		ieee80211_aes_cmac_calculate_k1_k2(keyconf,
-						   igtk_cmd.K1, igtk_cmd.K2);
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		pn = seq.aes_cmac.pn;
 		igtk_cmd.receive_seq_cnt = cpu_to_le64(((u64) pn[5] << 0) |
-- 
2.1.4

