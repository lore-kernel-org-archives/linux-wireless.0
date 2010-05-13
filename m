Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab0EMVtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:49:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlagn: work around rate scaling reset delay
Date: Thu, 13 May 2010 14:49:45 -0700
Message-Id: <1273787385-9248-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
References: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
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
 drivers/net/wireless/iwlwifi/iwl-sta.c |   37 +++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 4a6686f..702672d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -948,6 +948,39 @@ static inline void iwl_dump_lq_cmd(struct iwl_priv *priv,
 }
 #endif
 
+/**
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
 int iwl_send_lq_cmd(struct iwl_priv *priv,
 		    struct iwl_link_quality_cmd *lq, u8 flags)
 {
@@ -967,7 +1000,9 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 
 	iwl_dump_lq_cmd(priv, lq);
 
-	if (iwl_is_associated(priv) && priv->assoc_station_added)
+	if (iwl_is_associated(priv) &&
+	    priv->assoc_station_added &&
+	    is_lq_table_valid(priv, lq))
 		return  iwl_send_cmd(priv, &cmd);
 
 	return 0;
-- 
1.6.3.3

