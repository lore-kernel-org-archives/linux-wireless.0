Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbbHXUAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 16:00:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/6] iwlwifi: correctly size command string arrays
Date: Mon, 24 Aug 2015 23:00:34 +0300
Message-Id: <1440446437-29188-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150824_220048_266586_24DD8C1D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The command string array is assumed to be indexable by a full u8, so it
must have 256 entries (0-255), not just 255. A recent firmware change
(apparently) started using the command 0xff for a notification to the
host, causing the driver to crash in debug message/tracing code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h | 2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c  | 2 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index edc3dd4..991def8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -473,7 +473,7 @@ do {									\
 } while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
-extern const char *const iwl_dvm_cmd_strings[REPLY_MAX];
+extern const char *const iwl_dvm_cmd_strings[REPLY_MAX + 1];
 
 static inline const char *iwl_dvm_get_cmd_string(u8 cmd)
 {
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index 4785203..4a45b0b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -39,7 +39,7 @@
 
 #define IWL_CMD_ENTRY(x) [x] = #x
 
-const char *const iwl_dvm_cmd_strings[REPLY_MAX] = {
+const char *const iwl_dvm_cmd_strings[REPLY_MAX + 1] = {
 	IWL_CMD_ENTRY(REPLY_ALIVE),
 	IWL_CMD_ENTRY(REPLY_ERROR),
 	IWL_CMD_ENTRY(REPLY_ECHO),
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 07e6892..a37de3f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -268,7 +268,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 #undef RX_HANDLER_GRP
 #define CMD(x) [x] = #x
 
-static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
+static const char *const iwl_mvm_cmd_strings[REPLY_MAX + 1] = {
 	CMD(MVM_ALIVE),
 	CMD(REPLY_ERROR),
 	CMD(INIT_COMPLETE_NOTIF),
-- 
2.1.4

