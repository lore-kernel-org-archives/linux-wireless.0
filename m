Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36189 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbaDMNCN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:13 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so7052164wgh.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 06:02:12 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/13] iwlwifi: mvm: BT Coex - send the new LUT upon antenna coupling change
Date: Sun, 13 Apr 2014 16:01:53 +0300
Message-Id: <1397394123-25102-3-git-send-email-egrumbach@gmail.com> (sfid-20140413_150223_757585_F206DCEE)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

I forgot to send the new Look Up Table to the firmware and
I also forgot to free the command which is kzalloc'ed.
This code is relevant for 7265 device only.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 685f7e8..f9c7b30 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1262,6 +1262,7 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 ant_isolation = le32_to_cpup((void *)pkt->data);
 	u8 __maybe_unused lower_bound, upper_bound;
+	int ret;
 	u8 lut;
 
 	struct iwl_bt_coex_cmd *bt_cmd;
@@ -1318,5 +1319,8 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[lut].lut20,
 	       sizeof(bt_cmd->bt4_corun_lut40));
 
-	return 0;
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+
+	kfree(bt_cmd);
+	return ret;
 }
-- 
1.8.3.2

