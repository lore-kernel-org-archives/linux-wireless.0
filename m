Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbYCUU6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 16:58:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: iwl3945 remove 4965 commands
Date: Fri, 21 Mar 2008 13:53:42 -0700
Message-Id: <1206132824-20558-4-git-send-email-reinette.chatre@intel.com> (sfid-20080321_205912_696242_C9D73E62)
In-Reply-To: <1206132824-20558-3-git-send-email-reinette.chatre@intel.com>
References: <1206132824-20558-1-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-2-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes 4965 host commands from iwl-3945-commands.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   39 ----------------------
 1 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 824a6e5..817ece7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -707,45 +707,6 @@ struct iwl3945_rx_frame {
 	struct iwl3945_rx_frame_end end;
 } __attribute__ ((packed));
 
-/* Fixed (non-configurable) rx data from phy */
-#define RX_PHY_FLAGS_ANTENNAE_OFFSET		(4)
-#define RX_PHY_FLAGS_ANTENNAE_MASK		(0x70)
-#define IWL_AGC_DB_MASK 	(0x3f80)	/* MASK(7,13) */
-#define IWL_AGC_DB_POS		(7)
-struct iwl4965_rx_non_cfg_phy {
-	__le16 ant_selection;	/* ant A bit 4, ant B bit 5, ant C bit 6 */
-	__le16 agc_info;	/* agc code 0:6, agc dB 7:13, reserved 14:15 */
-	u8 rssi_info[6];	/* we use even entries, 0/2/4 for A/B/C rssi */
-	u8 pad[0];
-} __attribute__ ((packed));
-
-/*
- * REPLY_4965_RX = 0xc3 (response only, not a command)
- * Used only for legacy (non 11n) frames.
- */
-#define RX_RES_PHY_CNT 14
-struct iwl4965_rx_phy_res {
-	u8 non_cfg_phy_cnt;     /* non configurable DSP phy data byte count */
-	u8 cfg_phy_cnt;		/* configurable DSP phy data byte count */
-	u8 stat_id;		/* configurable DSP phy data set ID */
-	u8 reserved1;
-	__le64 timestamp;	/* TSF at on air rise */
-	__le32 beacon_time_stamp; /* beacon at on-air rise */
-	__le16 phy_flags;	/* general phy flags: band, modulation, ... */
-	__le16 channel;		/* channel number */
-	__le16 non_cfg_phy[RX_RES_PHY_CNT];	/* upto 14 phy entries */
-	__le32 reserved2;
-	__le32 rate_n_flags;
-	__le16 byte_count;		/* frame's byte-count */
-	__le16 reserved3;
-} __attribute__ ((packed));
-
-struct iwl4965_rx_mpdu_res_start {
-	__le16 byte_count;
-	__le16 reserved;
-} __attribute__ ((packed));
-
-
 /******************************************************************************
  * (5)
  * Tx Commands & Responses:
-- 
1.5.3.4

