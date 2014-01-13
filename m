Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40643 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAMUWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:12 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so3547200eae.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:11 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/18] iwlwifi: mvm: fix tx seq_ctrl debug print
Date: Mon, 13 Jan 2014 22:21:46 +0200
Message-Id: <1389644517-22807-7-git-send-email-egrumbach@gmail.com> (sfid-20140113_213436_652158_85156423)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliadx.peller@intel.com>

Since seq_number is incremented right after using
it, so printed seq_ctrl was actually the next
one to be used.

Fix it by incrementing the seq_number only later,
before saving it.

Additionally, use the IEEE80211_SEQ_TO_SN macro
in order to print the actual sequence number.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index a4d3bce..90378c2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -390,7 +390,6 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
-		seq_number += 0x10;
 		is_data_qos = true;
 		is_ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
 	}
@@ -407,13 +406,13 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	}
 
 	IWL_DEBUG_TX(mvm, "TX to [%d|%d] Q:%d - seq: 0x%x\n", mvmsta->sta_id,
-		     tid, txq_id, seq_number);
+		     tid, txq_id, IEEE80211_SEQ_TO_SN(seq_number));
 
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
 	if (is_data_qos && !ieee80211_has_morefrags(fc))
-		mvmsta->tid_data[tid].seq_number = seq_number;
+		mvmsta->tid_data[tid].seq_number = seq_number + 0x10;
 
 	spin_unlock(&mvmsta->lock);
 
-- 
1.7.9.5

