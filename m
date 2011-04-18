Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab1DRRFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlagn: verify that huge commands are synchronous
Date: Mon, 18 Apr 2011 09:44:10 -0700
Message-Id: <1303145057-6545-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since huge commands all share a single buffer,
there can only be a single one in flight at a
time since otherwise they'd overwrite each
other. This is true in the driver now, but it
seems like a possible source of bugs, so add
a test to verify that huge commands are always
sent synchronously.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index e7faba5..1b69507 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -470,6 +470,14 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
+	/*
+	 * As we only have a single huge buffer, check that the command
+	 * is synchronous (otherwise buffers could end up being reused).
+	 */
+
+	if (WARN_ON((cmd->flags & CMD_ASYNC) && (cmd->flags & CMD_SIZE_HUGE)))
+		return -EINVAL;
+
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-- 
1.7.0.4

