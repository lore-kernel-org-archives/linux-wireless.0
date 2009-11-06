Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945AbZKFWxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:01 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/20] iwlwifi: don't double-activate queue 4
Date: Fri,  6 Nov 2009 14:52:50 -0800
Message-Id: <1257547983-12590-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The fourth queue (command queue) is already activated in
the loop above that also maps it to the command FIFO and
therefore doesn't need to be marked as activated again.
Also change the TODO comment to be accurate -- we need
to initialise the _queues_, not FIFOs, and map them to
device FIFOs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a97d93d..f6cbbfa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -662,9 +662,13 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 		iwl_txq_ctx_activate(priv, i);
 		iwl5000_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
-	/* TODO - need to initialize those FIFOs inside the loop above,
-	 * not only mark them as active */
-	iwl_txq_ctx_activate(priv, 4);
+
+	/*
+	 * TODO - need to initialize these queues and map them to FIFOs
+	 * in the loop above, not only mark them as active. We do this
+	 * because we want the first aggregation queue to be queue #10,
+	 * but do not use 8 or 9 otherwise yet.
+	 */
 	iwl_txq_ctx_activate(priv, 7);
 	iwl_txq_ctx_activate(priv, 8);
 	iwl_txq_ctx_activate(priv, 9);
-- 
1.5.6.3

