Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54345 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765600AbYCSXtv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 7/7] iwlwifi-2.6: enables RX TKIP decryption in HW
Date: Wed, 19 Mar 2008 16:41:46 -0700
Message-Id: <1205970106-22196-8-git-send-email-reinette.chatre@intel.com> (sfid-20080319_235023_487160_75C58FF1)
In-Reply-To: <1205970106-22196-7-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-2-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-4-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-5-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-6-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch enables RX TKIP decryption in HW.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   51 +++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2449e00..4af365f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1390,6 +1390,7 @@ static int iwl4965_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+	keyconf->flags |= IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY;
 	keyconf->hw_key_idx = keyconf->keyidx;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
@@ -7179,6 +7180,55 @@ out_unlock:
 	return rc;
 }
 
+static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
+			struct ieee80211_key_conf *keyconf, const u8 *addr,
+			u32 iv32, u16 *phase1key)
+{
+	struct iwl_priv *priv = hw->priv;
+	u8 sta_id = IWL_INVALID_STATION;
+	unsigned long flags;
+	__le16 key_flags = 0;
+	int i;
+	DECLARE_MAC_BUF(mac);
+
+	IWL_DEBUG_MAC80211("enter\n");
+
+	sta_id = iwl4965_hw_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
+				   print_mac(mac, addr));
+		return;
+	}
+
+	iwl4965_scan_cancel_timeout(priv, 100);
+
+	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == priv->hw_setting.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].sta.key.key_offset = (sta_id % 8);/* FIXME */
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
+
+	for (i = 0; i < 5; i++)
+		priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
+			cpu_to_le16(phase1key[i]);
+
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	IWL_DEBUG_MAC80211("leave\n");
+}
+
 static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
@@ -8120,6 +8170,7 @@ static struct ieee80211_ops iwl4965_hw_ops = {
 	.config_interface = iwl4965_mac_config_interface,
 	.configure_filter = iwl4965_configure_filter,
 	.set_key = iwl4965_mac_set_key,
+	.update_tkip_key = iwl4965_mac_update_tkip_key,
 	.get_stats = iwl4965_mac_get_stats,
 	.get_tx_stats = iwl4965_mac_get_tx_stats,
 	.conf_tx = iwl4965_mac_conf_tx,
-- 
1.5.3.4

