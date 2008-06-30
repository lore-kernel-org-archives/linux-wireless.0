Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbYF3J1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/33] iwlwifi: remove useless network and duplicate checking
Date: Mon, 30 Jun 2008 17:23:10 +0800
Message-Id: <1214817813-17639-11-git-send-email-yi.zhu@intel.com> (sfid-20080630_113812_191261_F4315C94)
In-Reply-To: <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The iwlwifi drivers go to great lengths to avoid passing packets to
mac80211 they think shouldn't go there, while mac80211 can (of course!)
handle them very well.

Especially in the case of duplicate packets this is interesting
because it's such a performance hog (especially for IBSS networks)
while mac80211 does that work on the side without much effort.

This patch removes all that and leaves only what is absolutely
necessary for the hardware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 --
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  148 +++------------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   26 -----
 4 files changed, 13 insertions(+), 173 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6ca9460..95f7320 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -846,7 +846,6 @@ EXPORT_SYMBOL(iwl_setup_mac);
 int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
-	int i;
 
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
@@ -857,9 +856,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	spin_lock_init(&priv->hcmd_lock);
 	spin_lock_init(&priv->lq_mngr.lock);
 
-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
-		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
-
 	INIT_LIST_HEAD(&priv->free_frames);
 
 	mutex_init(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8017e57..79a6941 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1017,14 +1017,6 @@ struct iwl_priv {
 	u32 last_beacon_time;
 	u64 last_tsf;
 
-	/* Duplicate packet detection */
-	u16 last_seq_num;
-	u16 last_frag_num;
-	unsigned long last_packet_time;
-
-	/* Hash table for finding stations in IBSS network */
-	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
-
 	/* eeprom */
 	u8 *eeprom;
 	struct iwl_eeprom_calib_info *calib_info;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index e0d3e2d..9c346cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -957,7 +957,7 @@ static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 	return decrypt_out;
 }
 
-static void iwl_handle_data_packet(struct iwl_priv *priv, int is_data,
+static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 				       int include_phy,
 				       struct iwl_rx_mem_buffer *rxb,
 				       struct ieee80211_rx_status *stats)
@@ -999,12 +999,6 @@ static void iwl_handle_data_packet(struct iwl_priv *priv, int is_data,
 		rx_start->byte_count = amsdu->byte_count;
 		rx_end = (__le32 *) (((u8 *) hdr) + len);
 	}
-	/* In monitor mode allow 802.11 ACk frames (10 bytes) */
-	if (len > priv->hw_params.max_pkt_size ||
-	    len < ((priv->iw_mode == IEEE80211_IF_TYPE_MNTR) ? 10 : 16)) {
-		IWL_WARNING("byte count out of range [16,4K] : %d\n", len);
-		return;
-	}
 
 	ampdu_status = le32_to_cpu(*rx_end);
 	skblen = ((u8 *) rx_end - (u8 *) &pkt->u.raw[0]) + sizeof(u32);
@@ -1110,73 +1104,7 @@ static void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
 	}
 }
 
-#define IWL_PACKET_RETRY_TIME HZ
-
-static int iwl_is_duplicate_packet(struct iwl_priv *priv,
-		struct ieee80211_hdr *header)
-{
-	u16 sc = le16_to_cpu(header->seq_ctrl);
-	u16 seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
-	u16 frag = sc & IEEE80211_SCTL_FRAG;
-	u16 *last_seq, *last_frag;
-	unsigned long *last_time;
-
-	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_IBSS:{
-		struct list_head *p;
-		struct iwl4965_ibss_seq *entry = NULL;
-		u8 *mac = header->addr2;
-		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
-
-		__list_for_each(p, &priv->ibss_mac_hash[index]) {
-			entry = list_entry(p, struct iwl4965_ibss_seq, list);
-			if (!compare_ether_addr(entry->mac, mac))
-				break;
-		}
-		if (p == &priv->ibss_mac_hash[index]) {
-			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
-			if (!entry) {
-				IWL_ERROR("Cannot malloc new mac entry\n");
-				return 0;
-			}
-			memcpy(entry->mac, mac, ETH_ALEN);
-			entry->seq_num = seq;
-			entry->frag_num = frag;
-			entry->packet_time = jiffies;
-			list_add(&entry->list, &priv->ibss_mac_hash[index]);
-			return 0;
-		}
-		last_seq = &entry->seq_num;
-		last_frag = &entry->frag_num;
-		last_time = &entry->packet_time;
-		break;
-	}
-	case IEEE80211_IF_TYPE_STA:
-		last_seq = &priv->last_seq_num;
-		last_frag = &priv->last_frag_num;
-		last_time = &priv->last_packet_time;
-		break;
-	default:
-		return 0;
-	}
-	if ((*last_seq == seq) &&
-	    time_after(*last_time + IWL_PACKET_RETRY_TIME, jiffies)) {
-		if (*last_frag == frag)
-			goto drop;
-		if (*last_frag + 1 != frag)
-			/* out-of-order fragment */
-			goto drop;
-	} else
-		*last_seq = seq;
-
-	*last_frag = frag;
-	*last_time = jiffies;
-	return 0;
-
- drop:
-	return 1;
-}
-
+/* This is necessary only for a number of statistics, see the caller. */
 static int iwl_is_network_packet(struct iwl_priv *priv,
 		struct ieee80211_hdr *header)
 {
@@ -1184,28 +1112,14 @@ static int iwl_is_network_packet(struct iwl_priv *priv,
 	 * this network, discarding packets coming from ourselves */
 	switch (priv->iw_mode) {
 	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
-		/* packets from our adapter are dropped (echo) */
-		if (!compare_ether_addr(header->addr2, priv->mac_addr))
-			return 0;
-		/* {broad,multi}cast packets to our IBSS go through */
-		if (is_multicast_ether_addr(header->addr1))
-			return !compare_ether_addr(header->addr3, priv->bssid);
-		/* packets to our adapter go through */
-		return !compare_ether_addr(header->addr1, priv->mac_addr);
+		/* packets to our IBSS update information */
+		return !compare_ether_addr(header->addr3, priv->bssid);
 	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
-		/* packets from our adapter are dropped (echo) */
-		if (!compare_ether_addr(header->addr3, priv->mac_addr))
-			return 0;
-		/* {broad,multi}cast packets to our BSS go through */
-		if (is_multicast_ether_addr(header->addr1))
-			return !compare_ether_addr(header->addr2, priv->bssid);
-		/* packets to our adapter go through */
-		return !compare_ether_addr(header->addr1, priv->mac_addr);
+		/* packets to our IBSS update information */
+		return !compare_ether_addr(header->addr2, priv->bssid);
 	default:
-		break;
+		return 1;
 	}
-
-	return 1;
 }
 
 /* Called for REPLY_RX (legacy ABG frames), or
@@ -1316,9 +1230,9 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		rx_status.signal, rx_status.noise, rx_status.signal,
 		(unsigned long long)rx_status.mactime);
 
-
+	/* Take shortcut when only in monitor mode */
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		iwl_handle_data_packet(priv, 1, include_phy,
+		iwl_pass_packet_to_mac80211(priv, include_phy,
 						 rxb, &rx_status);
 		return;
 	}
@@ -1333,50 +1247,14 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	fc = le16_to_cpu(header->frame_control);
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
+	case IEEE80211_FTYPE_DATA:
 		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
 			iwl_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
 						header->addr2);
-		iwl_handle_data_packet(priv, 0, include_phy, rxb, &rx_status);
-		break;
-
-	case IEEE80211_FTYPE_CTL:
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_BACK_REQ:
-			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
-			iwl_handle_data_packet(priv, 0, include_phy,
-						rxb, &rx_status);
-			break;
-		default:
-			break;
-		}
-		break;
-
-	case IEEE80211_FTYPE_DATA: {
-		DECLARE_MAC_BUF(mac1);
-		DECLARE_MAC_BUF(mac2);
-		DECLARE_MAC_BUF(mac3);
-
-		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-			iwl_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
-						header->addr2);
-
-		if (unlikely(!network_packet))
-			IWL_DEBUG_DROP("Dropping (non network): "
-				       "%s, %s, %s\n",
-				       print_mac(mac1, header->addr1),
-				       print_mac(mac2, header->addr2),
-				       print_mac(mac3, header->addr3));
-		else if (unlikely(iwl_is_duplicate_packet(priv, header)))
-			IWL_DEBUG_DROP("Dropping (dup): %s, %s, %s\n",
-				       print_mac(mac1, header->addr1),
-				       print_mac(mac2, header->addr2),
-				       print_mac(mac3, header->addr3));
-		else
-			iwl_handle_data_packet(priv, 1, include_phy, rxb,
-						   &rx_status);
-		break;
-	}
+		/* fall through */
 	default:
+			iwl_pass_packet_to_mac80211(priv, include_phy, rxb,
+				   &rx_status);
 		break;
 
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 499705f..4129e90 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -613,20 +613,6 @@ static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
 	}
 }
 
-static void iwl4965_sequence_reset(struct iwl_priv *priv)
-{
-	/* Reset ieee stats */
-
-	/* We don't reset the net_device_stats (ieee->stats) on
-	 * re-association */
-
-	priv->last_seq_num = -1;
-	priv->last_frag_num = -1;
-	priv->last_packet_time = 0;
-
-	iwl_scan_cancel(priv);
-}
-
 #define MAX_UCODE_BEACON_INTERVAL	4096
 #define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
 
@@ -2515,8 +2501,6 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 		break;
 	}
 
-	iwl4965_sequence_reset(priv);
-
 	/* Enable Rx differential gain and sensitivity calibrations */
 	iwl_chain_noise_reset(priv);
 	priv->start_calib = 1;
@@ -4337,8 +4321,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	struct list_head *p, *q;
-	int i;
 	unsigned long flags;
 
 	if (!priv)
@@ -4367,14 +4349,6 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 
 	iwl_synchronize_irq(priv);
 
-	/* Free MAC hash list for ADHOC */
-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
-		list_for_each_safe(p, q, &priv->ibss_mac_hash[i]) {
-			list_del(p);
-			kfree(list_entry(p, struct iwl4965_ibss_seq, list));
-		}
-	}
-
 	iwl_rfkill_unregister(priv);
 	iwl4965_dealloc_ucode_pci(priv);
 
-- 
1.5.3.6

