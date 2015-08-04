Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbbHDU7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/37] iwlwifi: mvm: add wide firmware command infrastructure for RX
Date: Tue,  4 Aug 2015 23:43:25 +0300
Message-Id: <1438721007-23283-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_595032_C83638CB)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add support for extended firmware event header that contains
a group id as well as the command id.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index c9b9c98..a424d95 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -201,13 +201,15 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 }
 
 struct iwl_rx_handlers {
-	u8 cmd_id;
+	u16 cmd_id;
 	bool async;
 	void (*fn)(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 };
 
 #define RX_HANDLER(_cmd_id, _fn, _async)	\
 	{ .cmd_id = _cmd_id , .fn = _fn , .async = _async }
+#define RX_HANDLER_GRP(_grp, _cmd, _fn, _async)	\
+	{ .cmd_id = WIDE_ID(_grp, _cmd), .fn = _fn, .async = _async }
 
 /*
  * Handlers for fw notifications
@@ -263,6 +265,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 
 };
 #undef RX_HANDLER
+#undef RX_HANDLER_GRP
 #define CMD(x) [x] = #x
 
 static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
@@ -735,7 +738,7 @@ static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 		const struct iwl_rx_handlers *rx_h = &iwl_mvm_rx_handlers[i];
 		struct iwl_async_handler_entry *entry;
 
-		if (rx_h->cmd_id != pkt->hdr.cmd)
+		if (rx_h->cmd_id != WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd))
 			continue;
 
 		if (!rx_h->async) {
-- 
2.1.4

