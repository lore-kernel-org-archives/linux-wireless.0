Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1AEAbw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 19:31:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlwifi: fix 4965 notification wait setup
Date: Tue,  4 Jan 2011 16:22:03 -0800
Message-Id: <1294186923-4582-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The notification wait support code is shared
between 4965 and other AGN devices, so 4965
also has to initialize the data structures
for it, otherwise it crashes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3f1e5f1..d9a7d93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2316,6 +2316,11 @@ static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_RX] = iwlagn_rx_reply_rx;
 	/* Tx response */
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
+
+	/* set up notification wait support */
+	spin_lock_init(&priv->_agn.notif_wait_lock);
+	INIT_LIST_HEAD(&priv->_agn.notif_waits);
+	init_waitqueue_head(&priv->_agn.notif_waitq);
 }
 
 static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
-- 
1.7.0.4

