Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355AbXHHHhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:39 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 15/28] iwlwifi: Endianity fix for rxon host commands
Date: Wed,  8 Aug 2007 15:33:32 +0800
Message-Id: <11865584603865-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584583336-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes left over endianity issues in rxon host command.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965-hw.h |   21 +++++++++++----------
 drivers/net/wireless/iwl-4965.c    |   10 ++++++----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965-hw.h b/drivers/net/wireless/iwl-4965-hw.h
index 106f7c0..bb814cf 100644
--- a/drivers/net/wireless/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwl-4965-hw.h
@@ -229,20 +229,21 @@ struct iwl_channel_switch_notif {
 /********************* END TXPOWER *****************************************/
 
 /* HT flags */
-#define RXON_FLG_CONTROL_CHANNEL_LOCATION_MSK	0x400000
-#define RXON_FLG_CONTROL_CHANNEL_LOC_LOW_MSK	0x000000
-#define RXON_FLG_CONTROL_CHANNEL_LOC_HIGH_MSK	0x400000
+#define RXON_FLG_CONTROL_CHANNEL_LOCATION_POS	(22)
+#define RXON_FLG_CONTROL_CHANNEL_LOCATION_MSK	__constant_cpu_to_le32(0x1<<22)
+#define RXON_FLG_CONTROL_CHANNEL_LOC_LOW_MSK	__constant_cpu_to_le32(0x0<<22)
+#define RXON_FLG_CONTROL_CHANNEL_LOC_HIGH_MSK	__constant_cpu_to_le32(0x1<<22)
 
 #define RXON_FLG_HT_OPERATING_MODE_POS		(23)
-/*yshevet - bug fix */
-#define RXON_FLG_HT_PROT_MSK			0x800000
-#define RXON_FLG_FAT_PROT_MSK			0x1000000
+
+#define RXON_FLG_HT_PROT_MSK			__constant_cpu_to_le32(0x1<<23)
+#define RXON_FLG_FAT_PROT_MSK			__constant_cpu_to_le32(0x2<<23)
 
 #define RXON_FLG_CHANNEL_MODE_POS		(25)
-#define RXON_FLG_CHANNEL_MODE_MSK		0x06000000
-#define RXON_FLG_CHANNEL_MODE_LEGACY_MSK	0x00000000
-#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	0x02000000
-#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		0x04000000
+#define RXON_FLG_CHANNEL_MODE_MSK		__constant_cpu_to_le32(0x3<<25)
+#define RXON_FLG_CHANNEL_MODE_LEGACY_MSK	__constant_cpu_to_le32(0x0<<25)
+#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	__constant_cpu_to_le32(0x1<<25)
+#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		__constant_cpu_to_le32(0x2<<25)
 
 #define RXON_RX_CHAIN_DRIVER_FORCE_MSK		__constant_cpu_to_le16(0x1<<0)
 #define RXON_RX_CHAIN_VALID_MSK			__constant_cpu_to_le16(0x7<<1)
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 0cbe798..5999be5 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -79,7 +79,7 @@ const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
 };
 
-static int is_fat_channel(u32 rxon_flags)
+static int is_fat_channel(__le32 rxon_flags)
 {
 	return (rxon_flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) ||
 		(rxon_flags & RXON_FLG_CHANNEL_MODE_MIXED_MSK);
@@ -2859,12 +2859,14 @@ void iwl4965_set_rxon_chain(struct iwl_priv *priv)
 	 * Just after first association, iwl4965_noise_calibration()
 	 *    checks which antennas actually *are* connected. */
 	priv->staging_rxon.rx_chain |=
-	    (priv->valid_antenna << RXON_RX_CHAIN_VALID_POS);
+	    cpu_to_le16(priv->valid_antenna << RXON_RX_CHAIN_VALID_POS);
 
 	/* How many receivers should we use? */
 	iwl4965_get_rx_chain_counter(priv, &idle_state, &rx_state);
-	priv->staging_rxon.rx_chain |= (rx_state << RXON_RX_CHAIN_MIMO_CNT_POS);
-	priv->staging_rxon.rx_chain |= (idle_state << RXON_RX_CHAIN_CNT_POS);
+	priv->staging_rxon.rx_chain |=
+		cpu_to_le16(rx_state << RXON_RX_CHAIN_MIMO_CNT_POS);
+	priv->staging_rxon.rx_chain |=
+		cpu_to_le16(idle_state << RXON_RX_CHAIN_CNT_POS);
 
 	if (!is_single && !(priv->status & STATUS_POWER_PMI) && (rx_state >= 2))
 		priv->staging_rxon.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
-- 
1.5.2
