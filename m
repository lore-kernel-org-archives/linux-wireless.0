Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1CYObi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/12] iwlwifi: add RATE_MCS_RATE_MSK
Date: Fri, 25 Mar 2011 07:14:11 -0700
Message-Id: <1301062456-17249-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

Throughout the code we use rate_n_flags & 0xff to extract the lower byte
of the rate_n_flags u32 that contains the information about the rate.
Add a #define and remove the use of the magic number.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   15 ++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 ++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 63b58ec..e394e49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -115,13 +115,18 @@ const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
 	/* FIXME:RS:          ^^    should be INV (legacy) */
 };
 
+static inline u8 rs_extract_rate(u32 rate_n_flags)
+{
+	return (u8)(rate_n_flags & RATE_MCS_RATE_MSK);
+}
+
 static int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 {
 	int idx = 0;
 
 	/* HT rate format */
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
-		idx = (rate_n_flags & 0xff);
+		idx = rs_extract_rate(rate_n_flags);
 
 		if (idx >= IWL_RATE_MIMO3_6M_PLCP)
 			idx = idx - IWL_RATE_MIMO3_6M_PLCP;
@@ -138,7 +143,8 @@ static int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 	/* legacy rate format, search for match in table */
 	} else {
 		for (idx = 0; idx < ARRAY_SIZE(iwl_rates); idx++)
-			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
+			if (iwl_rates[idx].plcp ==
+					rs_extract_rate(rate_n_flags))
 				return idx;
 	}
 
@@ -239,11 +245,6 @@ static const struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
 
 #define MCS_INDEX_PER_STREAM	(8)
 
-static inline u8 rs_extract_rate(u32 rate_n_flags)
-{
-	return (u8)(rate_n_flags & 0xFF);
-}
-
 static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 {
 	window->data = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 4f7c9ce..39313ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -310,7 +310,7 @@ static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
 
 static inline u8 iwl_hw_get_rate(__le32 rate_n_flags)
 {
-	return le32_to_cpu(rate_n_flags) & 0xFF;
+	return le32_to_cpu(rate_n_flags) & RATE_MCS_RATE_MSK;
 }
 
 static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index ca42ffa..2883915 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -324,6 +324,8 @@ struct iwl3945_power_per_rate {
 #define RATE_MCS_SPATIAL_MSK 0x18
 #define RATE_MCS_HT_DUP_POS 5
 #define RATE_MCS_HT_DUP_MSK 0x20
+/* Both legacy and HT use bits 7:0 as the CCK/OFDM rate or HT MCS */
+#define RATE_MCS_RATE_MSK 0xff
 
 /* Bit 8: (1) HT format, (0) legacy format in bits 7:0 */
 #define RATE_MCS_FLAGS_POS 8
-- 
1.7.0.4

