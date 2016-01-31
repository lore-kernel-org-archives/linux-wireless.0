Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbcAaLGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/31] iwlwifi: mvm: change the check for ADD_STA status
Date: Sun, 31 Jan 2016 13:06:16 +0200
Message-Id: <1454238386-27032-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123654_080011_9B5FBC63)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The firmware will return the baid for BA session in the
ADD_STA command response.
This requires masking the check of the status, which is
actually only 8 bits, and not the whole 32 bits.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c        | 10 +++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index 6fca4fb..1eb3983 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -253,6 +253,9 @@ struct iwl_mvm_keyinfo {
 	__le64 hw_tkip_mic_tx_key;
 } __packed;
 
+#define IWL_ADD_STA_STATUS_MASK	0xFF
+#define IWL_ADD_STA_BAID_MASK	0xFF00
+
 /**
  * struct iwl_mvm_add_sta_cmd - Add/modify a station in the fw's sta table.
  * ( REPLY_ADD_STA = 0x18 )
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index b556e33..84b7fd1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -192,7 +192,7 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (ret)
 		return ret;
 
-	switch (status) {
+	switch (status & IWL_ADD_STA_STATUS_MASK) {
 	case ADD_STA_SUCCESS:
 		IWL_DEBUG_ASSOC(mvm, "ADD_STA PASSED\n");
 		break;
@@ -362,7 +362,7 @@ int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 	if (ret)
 		return ret;
 
-	switch (status) {
+	switch (status & IWL_ADD_STA_STATUS_MASK) {
 	case ADD_STA_SUCCESS:
 		IWL_DEBUG_INFO(mvm, "Frames for staid %d will drained in fw\n",
 			       mvmsta->sta_id);
@@ -628,7 +628,7 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	switch (status) {
+	switch (status & IWL_ADD_STA_STATUS_MASK) {
 	case ADD_STA_SUCCESS:
 		IWL_DEBUG_INFO(mvm, "Internal station added.\n");
 		return 0;
@@ -851,7 +851,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (ret)
 		return ret;
 
-	switch (status) {
+	switch (status & IWL_ADD_STA_STATUS_MASK) {
 	case ADD_STA_SUCCESS:
 		IWL_DEBUG_INFO(mvm, "RX BA Session %sed in fw\n",
 			       start ? "start" : "stopp");
@@ -909,7 +909,7 @@ static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (ret)
 		return ret;
 
-	switch (status) {
+	switch (status & IWL_ADD_STA_STATUS_MASK) {
 	case ADD_STA_SUCCESS:
 		break;
 	default:
-- 
2.5.0

