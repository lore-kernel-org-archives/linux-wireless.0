Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0KPQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/18] iwlagn: fix PAN queues
Date: Tue, 16 Nov 2010 08:01:44 -0800
Message-Id: <1289923311-14920-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, when a PAN queue needs to be
stopped, we erroneously stop queue number 5
(for example) with mac80211 -- which doesn't
even exist!

To avoid that problem, recalculate the swq_id
for all queues when setting up the queues,
and don't use the default identity mapping
that is acceptable for devices which don't
support PAN.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   57 +++++++++++++++-----------
 1 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 8b129e2..411a7a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -40,30 +40,36 @@
 #include "iwl-agn.h"
 #include "iwl-agn-calib.h"
 
-static const s8 iwlagn_default_queue_to_tx_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-	IWLAGN_CMD_FIFO_NUM,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
-	IWL_TX_FIFO_UNUSED,
+#define IWL_AC_UNSET -1
+
+struct queue_to_fifo_ac {
+	s8 fifo, ac;
+};
+
+static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, 0, },
+	{ IWL_TX_FIFO_VI, 1, },
+	{ IWL_TX_FIFO_BE, 2, },
+	{ IWL_TX_FIFO_BK, 3, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
 };
 
-static const s8 iwlagn_ipan_queue_to_tx_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-	IWL_TX_FIFO_BK_IPAN,
-	IWL_TX_FIFO_BE_IPAN,
-	IWL_TX_FIFO_VI_IPAN,
-	IWL_TX_FIFO_VO_IPAN,
-	IWL_TX_FIFO_BE_IPAN,
-	IWLAGN_CMD_FIFO_NUM,
+static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, 0, },
+	{ IWL_TX_FIFO_VI, 1, },
+	{ IWL_TX_FIFO_BE, 2, },
+	{ IWL_TX_FIFO_BK, 3, },
+	{ IWL_TX_FIFO_BK_IPAN, 3, },
+	{ IWL_TX_FIFO_BE_IPAN, 2, },
+	{ IWL_TX_FIFO_VI_IPAN, 1, },
+	{ IWL_TX_FIFO_VO_IPAN, 0, },
+	{ IWL_TX_FIFO_BE_IPAN, 2, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
 };
 
 static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
@@ -429,7 +435,7 @@ void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 int iwlagn_alive_notify(struct iwl_priv *priv)
 {
-	const s8 *queue_to_fifo;
+	const struct queue_to_fifo_ac *queue_to_fifo;
 	u32 a;
 	unsigned long flags;
 	int i, chan;
@@ -510,13 +516,16 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) != 10);
 
 	for (i = 0; i < 10; i++) {
-		int fifo = queue_to_fifo[i];
+		int fifo = queue_to_fifo[i].fifo;
+		int ac = queue_to_fifo[i].ac;
 
 		iwl_txq_ctx_activate(priv, i);
 
 		if (fifo == IWL_TX_FIFO_UNUSED)
 			continue;
 
+		if (ac != IWL_AC_UNSET)
+			iwl_set_swq_id(&priv->txq[i], ac, i);
 		iwlagn_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
 	}
 
-- 
1.7.0.4

