Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbcCBH5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/43] iwlwifi: support tracing wide commands
Date: Wed,  2 Mar 2016 09:56:20 +0200
Message-Id: <1456905404-14435-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085739_811745_35BD1A99)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Current iwlwifi_trace_dev_rx prints only the cmd without the
group, which might be misleading. Change it to print the wide
id. While at it add the DATA_PATH group and sub commands to the
trace of the command names, sine it is missing due to patches
submitted in parallel.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
index 22786d7..2a0703f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
@@ -73,12 +73,12 @@ TRACE_EVENT(iwlwifi_dev_rx,
 	TP_ARGS(dev, trans, pkt, len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-		__field(u8, cmd)
+		__field(u16, cmd)
 		__dynamic_array(u8, rxbuf, iwl_rx_trace_len(trans, pkt, len))
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
-		__entry->cmd = pkt->hdr.cmd;
+		__entry->cmd = WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd);
 		memcpy(__get_dynamic_array(rxbuf), pkt,
 		       iwl_rx_trace_len(trans, pkt, len));
 	),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index c5b6e86..bfa6da1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -398,6 +398,13 @@ static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
 /* Please keep this array *SORTED* by hex value.
  * Access is done through binary search
  */
+static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
+	HCMD_NAME(UPDATE_MU_GROUPS_CMD),
+};
+
+/* Please keep this array *SORTED* by hex value.
+ * Access is done through binary search
+ */
 static const struct iwl_hcmd_names iwl_mvm_prot_offload_names[] = {
 	HCMD_NAME(STORED_BEACON_NTF),
 };
@@ -406,6 +413,7 @@ static const struct iwl_hcmd_arr iwl_mvm_groups[] = {
 	[LEGACY_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
 	[LONG_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
 	[PHY_OPS_GROUP] = HCMD_ARR(iwl_mvm_phy_names),
+	[DATA_PATH_GROUP] = HCMD_ARR(iwl_mvm_data_path_names),
 	[PROT_OFFLOAD_GROUP] = HCMD_ARR(iwl_mvm_prot_offload_names),
 };
 
-- 
2.5.0

