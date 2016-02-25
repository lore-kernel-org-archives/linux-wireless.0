Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14143 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbcBYU5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 15:57:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: mvm: inc pending frames counter also when txing non-sta
Date: Thu, 25 Feb 2016 22:57:08 +0200
Message-Id: <1456433829-20285-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160225_215717_993051_6E159925)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Until this patch, when TXing non-sta the pending_frames counter
wasn't increased, but it WAS decreased in
iwl_mvm_rx_tx_cmd_single(), what makes it negative in certain
conditions. This in turn caused much trouble when we need to
remove the station since we won't be waiting forever until
pending_frames gets 0. In certain cases, we were exhausting
the station table even in BSS mode, because we had a lot of
stale stations.

Increase the counter also in iwl_mvm_tx_skb_non_sta() after a
successful TX to avoid this outcome.

CC: <stable@vger.kernel.org> [3.18+]
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 0914ec2..a040edc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -423,6 +423,15 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		return -1;
 	}
 
+	/*
+	 * Increase the pending frames counter, so that later when a reply comes
+	 * in and the counter is decreased - we don't start getting negative
+	 * values.
+	 * Note that we don't need to make sure it isn't agg'd, since we're
+	 * TXing non-sta
+	 */
+	atomic_inc(&mvm->pending_frames[sta_id]);
+
 	return 0;
 }
 
-- 
2.5.0

