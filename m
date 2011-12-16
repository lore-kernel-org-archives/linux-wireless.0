Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760179Ab1LPQht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:49 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/24] iwlwifi: don't accept Tx packets when draining HW queues
Date: Fri, 16 Dec 2011 07:37:23 -0800
Message-Id: <1324049849-831-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173814_952368_7CD22C29)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If the agg SM is in IWL_EMPTYING_HW_QUEUE_ADDBA or in
IWL_EMPTYING_HW_QUEUE_DELBA, we are not supposed to get Tx packets
from mac80211. mac80211 is supposed to buffer these packets for us.
A few issues have been identified in this mechanism, not all of them
were fixed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ae35c53..c664c27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -388,6 +388,14 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			goto drop_unlock_sta;
 		}
 
+		/* We can receive packets from the stack in IWL_AGG_{ON,OFF}
+		 * only. Check this here.
+		 */
+		if (WARN_ONCE(tid_data->agg.state != IWL_AGG_ON &&
+		    tid_data->agg.state != IWL_AGG_OFF,
+		    "Tx while agg.state = %d", tid_data->agg.state))
+			goto drop_unlock_sta;
+
 		seq_number = tid_data->seq_number;
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-- 
1.7.0.4

