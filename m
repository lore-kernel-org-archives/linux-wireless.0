Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36362 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbaJUQFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 12:05:01 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so1429981wib.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 09:04:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/8] iwlwifi: mvm: BT coex - fix BT prio for probe requests
Date: Tue, 21 Oct 2014 19:04:35 +0300
Message-Id: <1413907479-9073-4-git-send-email-egrumbach@gmail.com> (sfid-20141021_180512_019459_57F7DF45)
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The probe requests sent during scan must get BT prio 3.
Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index cb85e63..b280d5d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -459,7 +459,8 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 				basic_ssid ? 1 : 0);
 
 	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
-					   TX_CMD_FLG_BT_DIS);
+					   3 << TX_CMD_FLG_BT_PRIO_POS);
+
 	cmd->tx_cmd.sta_id = mvm->aux_sta.sta_id;
 	cmd->tx_cmd.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	cmd->tx_cmd.rate_n_flags =
-- 
1.9.1

