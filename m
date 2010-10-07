Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0JGXIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/22] iwlwifi: remove iwl_check_bits
Date: Thu,  7 Oct 2010 16:07:57 -0700
Message-Id: <1286492881-15743-19-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function is used exactly once, and the caller
doesn't even need the special check, it can be
simplified to a simple bit check.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    5 -----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b06a7bd..7d74ae5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -348,7 +348,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 	IWL_DEBUG_TX_REPLY(priv, "Tx queue reclaim %d\n", index);
 	iwl3945_tx_queue_reclaim(priv, txq_id, index);
 
-	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
+	if (status & TX_ABORT_REQUIRED_MSK)
 		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 621abe3..1aaef70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -44,11 +44,6 @@ static inline struct ieee80211_conf *ieee80211_get_hw_conf(
 	return &hw->conf;
 }
 
-static inline int iwl_check_bits(unsigned long field, unsigned long mask)
-{
-	return ((field & mask) == mask) ? 1 : 0;
-}
-
 static inline unsigned long elapsed_jiffies(unsigned long start,
 					    unsigned long end)
 {
-- 
1.7.0.4

