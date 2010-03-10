Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0CJFWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/24] iwlwifi: clear up AC/FIFO debug output
Date: Tue,  9 Mar 2010 21:21:40 -0800
Message-Id: <1268198512-6572-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Not all queues are mapped for frame transmission,
so saying "AC" is misleading. They are all mapped
to FIFOs, obviously, though, so use that term and
also say AC/CMD instead of just AC for the queue
type.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f59628c..4c0ef01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -580,9 +580,9 @@ static void iwl5000_tx_queue_set_status(struct iwl_priv *priv,
 
 	txq->sched_retry = scd_retry;
 
-	IWL_DEBUG_INFO(priv, "%s %s Queue %d on AC %d\n",
+	IWL_DEBUG_INFO(priv, "%s %s Queue %d on FIFO %d\n",
 		       active ? "Activate" : "Deactivate",
-		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
+		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
 
 int iwl5000_alive_notify(struct iwl_priv *priv)
-- 
1.6.3.3

