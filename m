Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab0KYBia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/12] iwlwifi: use mac80211 AC defines
Date: Wed, 24 Nov 2010 17:32:42 -0800
Message-Id: <1290648768-10075-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of hardcoding the numbers that must
match mac80211, use the constants. Not that
this means we could change the constants,
but at least this way it's clearer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   24 ++++++++++++------------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index c114c3a..72b1f26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -67,8 +67,14 @@
  */
 
 static const u8 tid_to_ac[] = {
-	/* this matches the mac80211 numbers */
-	2, 3, 3, 2, 1, 1, 0, 0
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VO
 };
 
 static inline int get_ac_from_tid(u16 tid)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 411a7a2..0bdd2bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -47,10 +47,10 @@ struct queue_to_fifo_ac {
 };
 
 static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, 0, },
-	{ IWL_TX_FIFO_VI, 1, },
-	{ IWL_TX_FIFO_BE, 2, },
-	{ IWL_TX_FIFO_BK, 3, },
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
 	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
 	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
 	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
@@ -60,14 +60,14 @@ static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
 };
 
 static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, 0, },
-	{ IWL_TX_FIFO_VI, 1, },
-	{ IWL_TX_FIFO_BE, 2, },
-	{ IWL_TX_FIFO_BK, 3, },
-	{ IWL_TX_FIFO_BK_IPAN, 3, },
-	{ IWL_TX_FIFO_BE_IPAN, 2, },
-	{ IWL_TX_FIFO_VI_IPAN, 1, },
-	{ IWL_TX_FIFO_VO_IPAN, 0, },
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
 	{ IWL_TX_FIFO_BE_IPAN, 2, },
 	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
 };
-- 
1.7.0.4

