Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0HRQSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/16] iwlwifi: additional parameter in REPLY_RX_PHY_CMD
Date: Wed, 18 Aug 2010 09:22:46 -0700
Message-Id: <1282148571-9258-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding additional parameter in REPLY_RX_PHY_CMD, frame_time indicate the
frame's time on the air based on byte count and frame rate calculation

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 14a7a8c..13893a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1401,7 +1401,7 @@ struct iwl_rx_phy_res {
 	u8 non_cfg_phy_buf[32]; /* for various implementations of non_cfg_phy */
 	__le32 rate_n_flags;	/* RATE_MCS_* */
 	__le16 byte_count;	/* frame's byte-count */
-	__le16 reserved3;
+	__le16 frame_time;	/* frame's time on the air */
 } __packed;
 
 struct iwl_rx_mpdu_res_start {
-- 
1.7.0.4

