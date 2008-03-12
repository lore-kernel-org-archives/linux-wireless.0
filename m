Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51371 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbYCMAEF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:04:05 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwlwifi: Add TX/RX statistcs to driver
Date: Wed, 12 Mar 2008 16:58:51 -0700
Message-Id: <1205366332-12652-5-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000416_224063_B575AADF)
In-Reply-To: <1205366332-12652-4-git-send-email-reinette.chatre@intel.com>
References: <1205366332-12652-1-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-2-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-3-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch supports collecting of TX and RX statistics in the driver.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 +++++++++-
 3 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 7b0ad72..b2ea4d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3337,6 +3337,14 @@ static void iwl4965_add_radiotap(struct iwl_priv *priv,
 	stats->flag |= RX_FLAG_RADIOTAP;
 }
 
+static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
+{
+	/* 0 - mgmt, 1 - cnt, 2 - data */
+	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
+	priv->rx_stats[idx].cnt++;
+	priv->rx_stats[idx].bytes += len;
+}
+
 static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 				       int include_phy,
 				       struct iwl4965_rx_mem_buffer *rxb,
@@ -3406,6 +3414,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	if (priv->add_radiotap)
 		iwl4965_add_radiotap(priv, rxb->skb, rx_start, stats, ampdu_status);
 
+	iwl_update_rx_stats(priv, le16_to_cpu(hdr->frame_control), len);
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	priv->alloc_rxb_skb--;
 	rxb->skb = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 60353b2..aded601 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1107,6 +1107,12 @@ struct iwl_priv {
 	int last_rx_rssi;	/* From Rx packet statisitics */
 	int last_rx_noise;	/* From beacon statistics */
 
+	/* counts mgmt, ctl, and data packets */
+	struct traffic_stats {
+		u32 cnt;
+		u64 bytes;
+	} tx_stats[3], rx_stats[3];
+
 	struct iwl4965_power_mgr power_data;
 
 	struct iwl4965_notif_statistics statistics;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4e899ce..4f6ed69 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2529,7 +2529,13 @@ static void iwl4965_build_tx_cmd_basic(struct iwl_priv *priv,
 	cmd->cmd.tx.tx_flags = tx_flags;
 	cmd->cmd.tx.next_frame_len = 0;
 }
-
+static void iwl_update_tx_stats(struct iwl_priv *priv, u16 fc, u16 len)
+{
+	/* 0 - mgmt, 1 - cnt, 2 - data */
+	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
+	priv->tx_stats[idx].cnt++;
+	priv->tx_stats[idx].bytes += len;
+}
 /**
  * iwl4965_get_sta_id - Find station's index within station table
  *
@@ -2776,6 +2782,8 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl4965_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
 
+	iwl_update_tx_stats(priv, fc, len);
+
 	scratch_phys = txcmd_phys + sizeof(struct iwl4965_cmd_header) +
 		offsetof(struct iwl4965_tx_cmd, scratch);
 	out_cmd->cmd.tx.dram_lsb_ptr = cpu_to_le32(scratch_phys);
-- 
1.5.3.4

