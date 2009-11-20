Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42954 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZKTUFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/19] iwlwifi: increase tx_queue debugfs buffer size
Date: Fri, 20 Nov 2009 12:04:59 -0800
Message-Id: <1258747510-21233-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For tx_queue, need to increase the buffer size allocated for it,
so all the queues information can be displayed

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e6194c8..4630094 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -964,7 +964,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int pos = 0;
 	int cnt;
 	int ret;
-	const size_t bufsz = sizeof(char) * 60 * priv->cfg->num_of_queues;
+	const size_t bufsz = sizeof(char) * 64 * priv->cfg->num_of_queues;
 
 	if (!priv->txq) {
 		IWL_ERR(priv, "txq not ready\n");
-- 
1.5.6.3

