Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbYEVJEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 05:04:15 -0400
Subject: [PATCH] iwl4965: remove useless network and duplicate checking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 11:03:17 +0200
Message-Id: <1211446997.3698.47.camel@johannes.berg> (sfid-20080522_110420_713803_34A6583E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwlwifi drivers go to great lengths to avoid passing packets to
mac80211 they think shouldn't go there, while mac80211 can (of course!)
handle them very well.

Especially in the case of duplicate packets this is interesting
because it's such a performance hog (especially for IBSS networks)
while mac80211 does that work on the side without much effort.

This patch removes all that and leaves only what is absolutely
necessary for the hardware.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Unless I made a mistake, obviously.

Of course, it would be good to use the 20 descriptors per skb
to be able to fill the performance gap again...

Somebody should port this to iwl3945 too.

 drivers/net/wireless/iwlwifi/iwl-4965.c     |   81 +++++-------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   19 ----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  122 ----------------------------
 4 files changed, 27 insertions(+), 199 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-05-22 10:37:41.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-05-22 10:42:41.000000000 +0200
@@ -2456,10 +2456,10 @@ static u32 iwl4965_translate_rx_status(s
 	return decrypt_out;
 }
 
-static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
-				       int include_phy,
-				       struct iwl_rx_mem_buffer *rxb,
-				       struct ieee80211_rx_status *stats)
+static void iwl4965_pass_packet_to_mac80211(struct iwl_priv *priv,
+					    int include_phy,
+					    struct iwl_rx_mem_buffer *rxb,
+					    struct ieee80211_rx_status *stats)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
@@ -2498,12 +2498,6 @@ static void iwl4965_handle_data_packet(s
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
 	skblen = ((u8 *) rx_end - (u8 *) & pkt->u.raw[0]) + sizeof(u32);
@@ -2762,6 +2756,21 @@ static inline void iwl4965_dbg_report_fr
 }
 #endif
 
+/* This is necessary only for a number of statistics, see the user. */
+static int iwl4965_is_network_packet(struct iwl_priv *priv,
+				     struct ieee80211_hdr *header)
+{
+	switch (priv->iw_mode) {
+	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
+		/* packets to our IBSS update information */
+		return !compare_ether_addr(header->addr3, priv->bssid);
+	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
+		/* packets to our BSS update information */
+		return !compare_ether_addr(header->addr2, priv->bssid);
+	default:
+		return 1;
+	}
+}
 
 
 /* Called for REPLY_RX (legacy ABG frames), or
@@ -2873,8 +2882,9 @@ static void iwl4965_rx_reply_rx(struct i
 			      (unsigned long long)rx_status.mactime);
 
 
+	/* Take shortcut when only in monitor mode */
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		iwl4965_handle_data_packet(priv, 1, include_phy,
+		iwl4965_pass_packet_to_mac80211(priv, include_phy,
 						 rxb, &rx_status);
 		return;
 	}
@@ -2889,54 +2899,15 @@ static void iwl4965_rx_reply_rx(struct i
 	fc = le16_to_cpu(header->frame_control);
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
+	case IEEE80211_FTYPE_DATA:
 		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-			iwl4965_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
-						header->addr2);
-		iwl4965_handle_data_packet(priv, 0, include_phy, rxb, &rx_status);
-		break;
-
-	case IEEE80211_FTYPE_CTL:
-#ifdef CONFIG_IWL4965_HT
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_BACK_REQ:
-			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
-			iwl4965_handle_data_packet(priv, 0, include_phy,
-						rxb, &rx_status);
-			break;
-		default:
-			break;
-		}
-#endif
-		break;
-
-	case IEEE80211_FTYPE_DATA: {
-		DECLARE_MAC_BUF(mac1);
-		DECLARE_MAC_BUF(mac2);
-		DECLARE_MAC_BUF(mac3);
-
-		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-			iwl4965_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
+			iwl4965_update_ps_mode(priv, fc & IEEE80211_FCTL_PM,
 						header->addr2);
-
-		if (unlikely(!network_packet))
-			IWL_DEBUG_DROP("Dropping (non network): "
-				       "%s, %s, %s\n",
-				       print_mac(mac1, header->addr1),
-				       print_mac(mac2, header->addr2),
-				       print_mac(mac3, header->addr3));
-		else if (unlikely(iwl4965_is_duplicate_packet(priv, header)))
-			IWL_DEBUG_DROP("Dropping (dup): %s, %s, %s\n",
-				       print_mac(mac1, header->addr1),
-				       print_mac(mac2, header->addr2),
-				       print_mac(mac3, header->addr3));
-		else
-			iwl4965_handle_data_packet(priv, 1, include_phy, rxb,
-						   &rx_status);
-		break;
-	}
+		/* fall through */
 	default:
+		iwl4965_pass_packet_to_mac80211(priv, include_phy, rxb,
+						&rx_status);
 		break;
-
 	}
 }
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-05-22 10:37:41.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-05-22 10:37:42.000000000 +0200
@@ -532,8 +532,6 @@ struct iwl4965_ucode {
 	u8 data[0];		/* data in same order as "size" elements */
 };
 
-#define IWL_IBSS_MAC_HASH_SIZE 32
-
 struct iwl4965_ibss_seq {
 	u8 mac[ETH_ALEN];
 	u16 seq_num;
@@ -633,16 +631,7 @@ extern int iwl_send_add_sta(struct iwl_p
 			    struct iwl_addsta_cmd *sta, u8 flags);
 u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 			 u8 flags, struct ieee80211_ht_info *ht_info);
-extern int iwl4965_is_network_packet(struct iwl_priv *priv,
-				 struct ieee80211_hdr *header);
 extern int iwl4965_power_init_handle(struct iwl_priv *priv);
-extern void iwl4965_handle_data_packet_monitor(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb,
-					   void *data, short len,
-					   struct ieee80211_rx_status *stats,
-					   u16 phy_flags);
-extern int iwl4965_is_duplicate_packet(struct iwl_priv *priv,
-				       struct ieee80211_hdr *header);
 extern int iwl4965_calc_db_from_ratio(int sig_ratio);
 extern int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
@@ -1129,14 +1118,6 @@ struct iwl_priv {
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
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-22 10:37:40.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-22 10:42:27.000000000 +0200
@@ -927,36 +927,6 @@ static void iwl4965_activate_qos(struct 
 	}
 }
 
-int iwl4965_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
-{
-	/* Filter incoming packets to determine if they are targeted toward
-	 * this network, discarding packets coming from ourselves */
-	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
-		/* packets from our adapter are dropped (echo) */
-		if (!compare_ether_addr(header->addr2, priv->mac_addr))
-			return 0;
-		/* {broad,multi}cast packets to our IBSS go through */
-		if (is_multicast_ether_addr(header->addr1))
-			return !compare_ether_addr(header->addr3, priv->bssid);
-		/* packets to our adapter go through */
-		return !compare_ether_addr(header->addr1, priv->mac_addr);
-	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
-		/* packets from our adapter are dropped (echo) */
-		if (!compare_ether_addr(header->addr3, priv->mac_addr))
-			return 0;
-		/* {broad,multi}cast packets to our BSS go through */
-		if (is_multicast_ether_addr(header->addr1))
-			return !compare_ether_addr(header->addr2, priv->bssid);
-		/* packets to our adapter go through */
-		return !compare_ether_addr(header->addr1, priv->mac_addr);
-	default:
-		break;
-	}
-
-	return 1;
-}
-
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
 static const char *iwl4965_get_tx_fail_reason(u32 status)
@@ -1037,20 +1007,6 @@ static int iwl4965_scan_cancel_timeout(s
 	return ret;
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
-	iwl4965_scan_cancel(priv);
-}
-
 #define MAX_UCODE_BEACON_INTERVAL	4096
 #define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
 
@@ -1404,72 +1360,6 @@ void iwl4965_radio_kill_sw(struct iwl_pr
 	return;
 }
 
-#define IWL_PACKET_RETRY_TIME HZ
-
-int iwl4965_is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
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
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
@@ -4074,7 +3964,7 @@ static void iwl4965_post_associate(struc
 		break;
 	}
 
-	iwl4965_sequence_reset(priv);
+	iwl4965_scan_cancel(priv);
 
 	/* Enable Rx differential gain and sensitivity calibrations */
 	iwl_chain_noise_reset(priv);
@@ -5835,8 +5725,6 @@ static int iwl4965_pci_probe(struct pci_
 static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	struct list_head *p, *q;
-	int i;
 	unsigned long flags;
 
 	if (!priv)
@@ -5862,14 +5750,6 @@ static void __devexit iwl4965_pci_remove
 
 	iwl_synchronize_irq(priv);
 
-	/* Free MAC hash list for ADHOC */
-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
-		list_for_each_safe(p, q, &priv->ibss_mac_hash[i]) {
-			list_del(p);
-			kfree(list_entry(p, struct iwl4965_ibss_seq, list));
-		}
-	}
-
 	iwlcore_low_level_notify(priv, IWLCORE_REMOVE_EVT);
 	iwl_dbgfs_unregister(priv);
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-05-22 10:37:40.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-05-22 10:42:27.000000000 +0200
@@ -801,7 +801,6 @@ EXPORT_SYMBOL(iwl_setup_mac);
 int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
-	int i;
 
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
@@ -812,9 +811,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	spin_lock_init(&priv->hcmd_lock);
 	spin_lock_init(&priv->lq_mngr.lock);
 
-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
-		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
-
 	INIT_LIST_HEAD(&priv->free_frames);
 
 	mutex_init(&priv->mutex);


