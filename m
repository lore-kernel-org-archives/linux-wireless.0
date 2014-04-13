Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57576 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbaDMTVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:11 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so7403266wgh.10
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:10 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/47] iwlwifi: mvm: BT Coex - send priority tables from iwl_send_bt_init_conf
Date: Sun, 13 Apr 2014 22:19:56 +0300
Message-Id: <1397416802-32403-41-git-send-email-egrumbach@gmail.com> (sfid-20140413_213516_331951_9FFFFFA6)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Calling iwl_send_bt_init_conf for INIT firmware is not a
problem, and calling iwl_send_bt_prio_tbl from
iwl_send_bt_init_conf allows us to prepare for new API.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 6 +++++-
 drivers/net/wireless/iwlwifi/mvm/fw.c   | 6 +-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h  | 1 -
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index a1403d4..0918635 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -104,7 +104,7 @@ static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 #define BT_DISABLE_REDUCED_TXPOWER_THRESHOLD	(-65)
 #define BT_ANTENNA_COUPLING_THRESHOLD		(30)
 
-int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
+static int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
 {
 	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, CMD_SYNC,
 				    sizeof(struct iwl_bt_coex_prio_tbl_cmd),
@@ -570,6 +570,10 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	int ret;
 	u32 flags;
 
+	ret = iwl_send_bt_prio_tbl(mvm);
+	if (ret)
+		return ret;
+
 	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
 	if (!bt_cmd)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index e7a2639..3d99cf5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -288,7 +288,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		goto error;
 	}
 
-	ret = iwl_send_bt_prio_tbl(mvm);
+	ret = iwl_send_bt_init_conf(mvm);
 	if (ret)
 		goto error;
 
@@ -424,10 +424,6 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
-	ret = iwl_send_bt_prio_tbl(mvm);
-	if (ret)
-		goto error;
-
 	ret = iwl_send_bt_init_conf(mvm);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index afca542..ed22201 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -923,7 +923,6 @@ void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq);
 
 /* BT Coex */
-int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm);
 int iwl_send_bt_init_conf(struct iwl_mvm *mvm);
 int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 			     struct iwl_rx_cmd_buffer *rxb,
-- 
1.8.3.2

