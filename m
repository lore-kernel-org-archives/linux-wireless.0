Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0FFG4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/23] iwlwifi: set MAC address in RXON from interface
Date: Sat,  5 Jun 2010 23:56:19 -0700
Message-Id: <1275807398-18184-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we do not have an interface, priv->mac_addr
is all zeroes, so the memcpy() is not useful as
the RXON buffer has been cleared previously.
Therefore, use the interface's address that we
are setting up the RXON for, if available.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4315212..245cb90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -979,7 +979,10 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 	/* clear both MIX and PURE40 mode flag */
 	priv->staging_rxon.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
 					RXON_FLG_CHANNEL_MODE_PURE_40);
-	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
+
+	if (vif)
+		memcpy(priv->staging_rxon.node_addr, vif->addr, ETH_ALEN);
+
 	priv->staging_rxon.ofdm_ht_single_stream_basic_rates = 0xff;
 	priv->staging_rxon.ofdm_ht_dual_stream_basic_rates = 0xff;
 	priv->staging_rxon.ofdm_ht_triple_stream_basic_rates = 0xff;
-- 
1.7.0.4

