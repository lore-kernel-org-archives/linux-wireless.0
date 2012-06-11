Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2FKJxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/13] iwlwifi: s/iwl_read_targ_mem_words/iwl_read_targ_mem_bytes
Date: Mon, 11 Jun 2012 11:53:03 +0200
Message-Id: <1339408392-19425-5-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115338_659477_DBC6CA96)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This macro gets the bufsize in bytes.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.h   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 656ed31..e620af3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -406,7 +406,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 
 	base = priv->device_pointers.log_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		iwl_read_targ_mem_words(priv->trans, base, &read, sizeof(read));
+		iwl_read_targ_mem_bytes(priv->trans, base, &read, sizeof(read));
 		capacity = read.capacity;
 		mode = read.mode;
 		num_wraps = read.wrap_counter;
@@ -1671,7 +1671,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	}
 
 	/*TODO: Update dbgfs with ISR error stats obtained below */
-	iwl_read_targ_mem_words(trans, base, &table, sizeof(table));
+	iwl_read_targ_mem_bytes(trans, base, &table, sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 4a9a45f..45a59c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -79,7 +79,7 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask);
 void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 			      void *buf, int words);
 
-#define iwl_read_targ_mem_words(trans, addr, buf, bufsize)	\
+#define iwl_read_targ_mem_bytes(trans, addr, buf, bufsize)	\
 	do {							\
 		BUILD_BUG_ON((bufsize) % sizeof(u32));		\
 		_iwl_read_targ_mem_words(trans, addr, buf,	\
-- 
1.7.10

