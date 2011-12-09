Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab1LIBZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/15] iwlagn: use IWL_MAX_TID_COUNT for WoWLAN
Date: Thu,  8 Dec 2011 16:26:21 -0800
Message-Id: <1323390382-1678-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022523_510119_0CC0AF56)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that I corrected IWL_MAX_TID_COUNT to be 8
instead of 9, we can use it in WoWLAN suspend.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 1d63422..057f952 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1157,7 +1157,7 @@ int iwlagn_suspend(struct iwl_priv *priv,
 	 * For QoS counters, we store the one to use next, so subtract 0x10
 	 * since the uCode will add 0x10 before using the value.
 	 */
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
 		seq = priv->shrd->tid_data[IWL_AP_ID][i].seq_number;
 		seq -= 0x10;
 		wakeup_filter_cmd.qos_seq[i] = cpu_to_le16(seq);
-- 
1.7.0.4

