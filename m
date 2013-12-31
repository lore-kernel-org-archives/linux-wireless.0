Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35487 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3LaRQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:19 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so4774706eek.20
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:18 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/28] iwlwifi: mvm: fix AC / FIFO mapping
Date: Tue, 31 Dec 2013 19:15:41 +0200
Message-Id: <1388510157-23345-12-git-send-email-egrumbach@gmail.com> (sfid-20131231_183437_301369_9FD694F5)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The AC / fifo mapping was wrong - BE packets landed in VO
FIFO. The iwl_mvm_tx_fifo enumeration isn't in the same
order as ieee80211_ac_numbers enumeration.
Since the firmware relies on fifo / ac mapping - this led
to wrong behavior. E.g. the firmware sends beacon with the
same QoS parameters as VO, and it actually took the
parameters of BK. There are probably more severe issues.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index fb93961..eaaf2db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -69,10 +69,10 @@
 #include "mvm.h"
 
 const u8 iwl_mvm_ac_to_tx_fifo[] = {
-	IWL_MVM_TX_FIFO_BK,
-	IWL_MVM_TX_FIFO_BE,
-	IWL_MVM_TX_FIFO_VI,
 	IWL_MVM_TX_FIFO_VO,
+	IWL_MVM_TX_FIFO_VI,
+	IWL_MVM_TX_FIFO_BE,
+	IWL_MVM_TX_FIFO_BK,
 };
 
 struct iwl_mvm_mac_iface_iterator_data {
@@ -586,18 +586,23 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		cpu_to_le32(vif->bss_conf.use_short_slot ?
 			    MAC_FLG_SHORT_SLOT : 0);
 
-	for (i = 0; i < AC_NUM; i++) {
-		cmd->ac[i].cw_min = cpu_to_le16(mvmvif->queue_params[i].cw_min);
-		cmd->ac[i].cw_max = cpu_to_le16(mvmvif->queue_params[i].cw_max);
-		cmd->ac[i].aifsn = mvmvif->queue_params[i].aifs;
-		cmd->ac[i].edca_txop =
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		u8 txf = iwl_mvm_ac_to_tx_fifo[i];
+
+		cmd->ac[txf].cw_min =
+			cpu_to_le16(mvmvif->queue_params[i].cw_min);
+		cmd->ac[txf].cw_max =
+			cpu_to_le16(mvmvif->queue_params[i].cw_max);
+		cmd->ac[txf].edca_txop =
 			cpu_to_le16(mvmvif->queue_params[i].txop * 32);
-		cmd->ac[i].fifos_mask = BIT(iwl_mvm_ac_to_tx_fifo[i]);
+		cmd->ac[txf].aifsn = mvmvif->queue_params[i].aifs;
+		cmd->ac[txf].fifos_mask = BIT(txf);
 	}
 
 	/* in AP mode, the MCAST FIFO takes the EDCA params from VO */
 	if (vif->type == NL80211_IFTYPE_AP)
-		cmd->ac[AC_VO].fifos_mask |= BIT(IWL_MVM_TX_FIFO_MCAST);
+		cmd->ac[IWL_MVM_TX_FIFO_VO].fifos_mask |=
+			BIT(IWL_MVM_TX_FIFO_MCAST);
 
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
-- 
1.7.9.5

