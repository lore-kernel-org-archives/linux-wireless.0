Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34245 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaBCUjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:39:40 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so3874793eek.31
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:39:39 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/8] iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan
Date: Mon,  3 Feb 2014 22:39:21 +0200
Message-Id: <1391459962-7381-7-git-send-email-egrumbach@gmail.com> (sfid-20140203_214000_018623_D56597C5)
In-Reply-To: <52EFFCE8.6070505@gmail.com>
References: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Not doing so will let BT kill our probe requests leading to
failures in scan.

Cc: <stable@vger.kernel.org> [3.10+]
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index c35f35c..742afc4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -344,7 +344,8 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 
 	iwl_mvm_scan_fill_ssids(cmd, req, basic_ssid ? 1 : 0);
 
-	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL);
+	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
+					   TX_CMD_FLG_BT_DIS);
 	cmd->tx_cmd.sta_id = mvm->aux_sta.sta_id;
 	cmd->tx_cmd.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	cmd->tx_cmd.rate_n_flags =
-- 
1.7.9.5

