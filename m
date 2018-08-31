Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45638 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727633AbeHaODK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:02 +0300
Message-Id: <20180831095614.14099-5-luca@coelho.fi> (sfid-20180831_115635_854119_AF86926F)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 04/16] iwlwifi: RX API: remove unnecessary anonymous struct
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no value in having an anonymous struct for holding
a few fields, remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 28 +++++++++----------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 2078ef425f8c..415b8842b426 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -601,23 +601,21 @@ struct iwl_rx_mpdu_desc {
 	 */
 	u8 mac_phy_idx;
 	/* DW4 - carries csum data only when rpa_en == 1 */
-	struct {
+	/**
+	 * @raw_csum: raw checksum (alledgedly unreliable)
+	 */
+	__le16 raw_csum;
+
+	union {
+		/**
+		 * @l3l4_flags: &enum iwl_rx_l3l4_flags
+		 */
+		__le16 l3l4_flags;
+
 		/**
-		 * @raw_csum: raw checksum (alledgedly unreliable)
+		 * @sigb_common2: for HE sniffer, HE-SIG-B common part 2
 		 */
-		__le16 raw_csum;
-
-		union {
-			/**
-			 * @l3l4_flags: &enum iwl_rx_l3l4_flags
-			 */
-			__le16 l3l4_flags;
-
-			/**
-			 * @sigb_common2: for HE sniffer, HE-SIG-B common part 2
-			 */
-			__le16 sigb_common2;
-		};
+		__le16 sigb_common2;
 	};
 	/* DW5 */
 	/**
-- 
2.18.0
