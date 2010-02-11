Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843Ab0BKSmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/12] iwlwifi: clear all the stop_queue flag after load firmware
Date: Thu, 11 Feb 2010 10:42:04 -0800
Message-Id: <1265913725-4279-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

All the queues are awake and ready to use after loading firmware,
for firmware reload case, if any queues was stopped before
reload, mac80211 will wake those queues after restart hardware, so make
sure all the flag used to keep track of the queue status are
reset correctly.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e479488..17e91ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -581,6 +581,11 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
+	/* make sure all queue are not stopped */
+	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
+	for (i = 0; i < 4; i++)
+		atomic_set(&priv->queue_stop_count[i], 0);
+
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 	/* Map each Tx/cmd queue to its corresponding fifo */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a7fa1ad..94fc836 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -648,6 +648,11 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 
 	iwl5000_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
+	/* make sure all queue are not stopped */
+	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
+	for (i = 0; i < 4; i++)
+		atomic_set(&priv->queue_stop_count[i], 0);
+
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 	/* map qos queues to fifos one-to-one */
-- 
1.6.3.3

