Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49911 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbaKXOfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:38 -0500
Received: by mail-wi0-f178.google.com with SMTP id hi2so5935486wib.17
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:37 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/75] iwlwifi: mvm: rs: consider a missing BA as a single tx failure
Date: Mon, 24 Nov 2014 16:34:01 +0200
Message-Id: <1416839691-28533-25-git-send-email-egrumbach@gmail.com> (sfid-20141124_154322_583281_2BFD4B56)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The fw now indicates missing BA with ampdu_ack_len=0.

This will make the whole aggregation being marked
as failed, although it's most likely not the case (and
only the BA itself was failed).

Consider this case as a single tx failure.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index c05f5a5..30ceb67 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1204,6 +1204,13 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	 * first index into rate scale table.
 	 */
 	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
+		/* ampdu_ack_len = 0 marks no BA was received. In this case
+		 * treat it as a single frame loss as we don't want the success
+		 * ratio to dip too quickly because a BA wasn't received
+		 */
+		if (info->status.ampdu_ack_len == 0)
+			info->status.ampdu_len = 1;
+
 		ucode_rate = le32_to_cpu(table->rs_table[0]);
 		rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
 		rs_collect_tx_data(lq_sta, curr_tbl, rate.index,
-- 
1.9.1

