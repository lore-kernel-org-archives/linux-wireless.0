Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62051 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbaDMTVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:08 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so3134622wib.5
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:07 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/47] iwlwifi: mvm: BT Coex - don't use comma operator
Date: Sun, 13 Apr 2014 22:19:54 +0300
Message-Id: <1397416802-32403-39-git-send-email-egrumbach@gmail.com> (sfid-20140413_213517_324682_29721EDB)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is really not needed. This is a remainder from a C99
initialiser.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 92a005c..3755ad4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -576,10 +576,10 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	cmd.data[0] = bt_cmd;
 
 	bt_cmd->max_kill = 5;
-	bt_cmd->bt4_antenna_isolation_thr = BT_ANTENNA_COUPLING_THRESHOLD,
-	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling,
-	bt_cmd->bt4_tx_tx_delta_freq_thr = 15,
-	bt_cmd->bt4_tx_rx_max_freq0 = 15,
+	bt_cmd->bt4_antenna_isolation_thr = BT_ANTENNA_COUPLING_THRESHOLD;
+	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling;
+	bt_cmd->bt4_tx_tx_delta_freq_thr = 15;
+	bt_cmd->bt4_tx_rx_max_freq0 = 15;
 
 	flags = iwlwifi_mod_params.bt_coex_active ?
 			BT_COEX_NW : BT_COEX_DISABLE;
-- 
1.8.3.2

