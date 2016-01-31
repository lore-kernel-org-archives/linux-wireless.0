Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbcAaLGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/31] iwlwifi: mvm: change access to ieee80211_hdr
Date: Sun, 31 Jan 2016 13:06:14 +0200
Message-Id: <1454238386-27032-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120654_260276_640D0F5F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Make the code clearer.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 0c073e0..4cce372 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -294,7 +294,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct ieee80211_rx_status *rx_status;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_mpdu_desc *desc = (void *)pkt->data;
-	struct ieee80211_hdr *hdr = (void *)(desc + 1);
+	struct ieee80211_hdr *hdr = (void *)(pkt->data + sizeof(*desc));
 	u32 len = le16_to_cpu(desc->mpdu_len);
 	u32 rate_n_flags = le32_to_cpu(desc->rate_n_flags);
 	struct ieee80211_sta *sta = NULL;
-- 
2.5.0

