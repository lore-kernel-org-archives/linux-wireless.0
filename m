Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834Ab0EJW2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 36/47] iwlagn: work around rate scaling reset delay
Date: Mon, 10 May 2010 15:28:07 -0700
Message-Id: <1273530498-11876-37-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When station is using an HT channel to communicate to AP and communication
is lost then driver will first be notified that channel is not an HT
channel anymore before AP station is removed. A consequence of that is that
the driver will know that it is not communicating on HT anymore, but the
rate scaling table is still under the impression it is operating in HT. Any
time after driver has been notified channel is not HT anymore there will
thus be a firmware SYSASSERT when the current active LQ command is sent.

A workaround for this issue is to not send a LQ command in the short time between
being notified channel is not HT anymore and rate scaling table being
updated.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2173

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   38 +++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 7e51647..e95282b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1170,6 +1170,39 @@ static inline void iwl_dump_lq_cmd(struct iwl_priv *priv,
 #endif
 
 /**
+ * is_lq_table_valid() - Test one aspect of LQ cmd for validity
+ *
+ * It sometimes happens when a HT rate has been in use and we
+ * loose connectivity with AP then mac80211 will first tell us that the
+ * current channel is not HT anymore before removing the station. In such a
+ * scenario the RXON flags will be updated to indicate we are not
+ * communicating HT anymore, but the LQ command may still contain HT rates.
+ * Test for this to prevent driver from sending LQ command between the time
+ * RXON flags are updated and when LQ command is updated.
+ */
+static bool is_lq_table_valid(struct iwl_priv *priv,
+			      struct iwl_link_quality_cmd *lq)
+{
+	int i;
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+
+	if (ht_conf->is_ht)
+		return true;
+
+	IWL_DEBUG_INFO(priv, "Channel %u is not an HT channel\n",
+		       priv->active_rxon.channel);
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
+		if (le32_to_cpu(lq->rs_table[i].rate_n_flags) & RATE_MCS_HT_MSK) {
+			IWL_DEBUG_INFO(priv,
+				       "index %d of LQ expects HT channel\n",
+				       i);
+			return false;
+		}
+	}
+	return true;
+}
+
+/**
  * iwl_send_lq_cmd() - Send link quality command
  * @init: This command is sent as part of station initialization right
  *        after station has been added.
@@ -1198,7 +1231,10 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 	iwl_dump_lq_cmd(priv, lq);
 	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
-	ret = iwl_send_cmd(priv, &cmd);
+	if (is_lq_table_valid(priv, lq))
+		ret = iwl_send_cmd(priv, &cmd);
+	else
+		ret = -EINVAL;
 
 	if (cmd.flags & CMD_ASYNC)
 		return ret;
-- 
1.6.3.3

