Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbZAWVmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:46 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Rick Farrington <rickdic@hotmail.com>,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 02/15] iwlagn: reduce off channel reception for 4965
Date: Fri, 23 Jan 2009 13:45:10 -0800
Message-Id: <1232747123-7261-3-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224252_605357_21D9CFFD)
In-Reply-To: <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rick Farrington <rickdic@hotmail.com>

Force use of chains B and C (0x6) for Rx for 4965
Avoid A (0x1) because of its off-channel reception on A-band.

Signed-off-by: Rick Farrington <rickdic@hotmail.com>
Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 +++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 +++++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c72a99a..61788a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2698,6 +2698,9 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	iwl_set_rate(priv);
 
+	/* call to ensure that 4965 rx_chain is set properly in monitor mode */
+	iwl_set_rxon_chain(priv);
+
 	if (memcmp(&priv->active_rxon,
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
 		iwl_commit_rxon(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 3ced5e5..7571110 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -563,6 +563,7 @@ enum {
 
 
 #define RXON_RX_CHAIN_DRIVER_FORCE_MSK		cpu_to_le16(0x1 << 0)
+#define RXON_RX_CHAIN_DRIVER_FORCE_POS		(0)
 #define RXON_RX_CHAIN_VALID_MSK			cpu_to_le16(0x7 << 1)
 #define RXON_RX_CHAIN_VALID_POS			(1)
 #define RXON_RX_CHAIN_FORCE_SEL_MSK		cpu_to_le16(0x7 << 4)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ef4a7c5..b64377e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -753,6 +753,19 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
 	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
 
+	/* copied from 'iwl_bg_request_scan()' */
+	/* Force use of chains B and C (0x6) for Rx for 4965
+	 * Avoid A (0x1) because of its off-channel reception on A-band.
+	 * MIMO is not used here, but value is required */
+	if (iwl_is_monitor_mode(priv) &&
+	    !(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) &&
+	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)) {
+		rx_chain = 0x07 << RXON_RX_CHAIN_VALID_POS;
+		rx_chain |= 0x06 << RXON_RX_CHAIN_FORCE_SEL_POS;
+		rx_chain |= 0x07 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
+		rx_chain |= 0x01 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
+	}
+
 	priv->staging_rxon.rx_chain = cpu_to_le16(rx_chain);
 
 	if (!is_single && (active_rx_cnt >= IWL_NUM_RX_CHAINS_SINGLE) && is_cam)
-- 
1.5.4.3

