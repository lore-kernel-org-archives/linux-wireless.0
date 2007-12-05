Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbXLETA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 14:00:58 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: remove HT code from iwl-3945.h
Date: Wed,  5 Dec 2007 20:59:57 +0200
Message-Id: <1196881199774-git-send-email-tomas.winkler@intel.com> (sfid-20071205_190112_817312_EBA66E8B)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This pach removes HT code from iwl-3945.h - it is not needed here as 3945
does not support HT. The code ended up here during the header file split

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 709203a..bfa2606 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -453,30 +453,6 @@ union iwl3945_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWL3945_HT
-#define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
-#define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
-#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
-
-struct sta_ht_info {
-	u8 is_ht;
-	u16 rx_mimo_ps_mode;
-	u16 tx_mimo_ps_mode;
-	u16 control_channel;
-	u8 max_amsdu_size;
-	u8 ampdu_factor;
-	u8 mpdu_density;
-	u8 operating_mode;
-	u8 supported_chan_width;
-	u8 extension_chan_offset;
-	u8 is_green_field;
-	u8 sgf;
-	u8 supp_rates[16];
-	u8 tx_chan_width;
-	u8 chan_width_cap;
-};
-#endif				/*CONFIG_IWL3945_HT */
-
 #ifdef CONFIG_IWL3945_QOS
 
 union iwl3945_qos_capabity {
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
