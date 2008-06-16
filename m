Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:54390 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYFPIJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 04:09:38 -0400
Received: by ik-out-1112.google.com with SMTP id c28so4058145ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 01:09:35 -0700 (PDT)
Message-ID: <f6ca9fed0806160109k10014458ib946410341b0e24e@mail.gmail.com> (sfid-20080616_100946_595055_08DC0CBF)
Date: Mon, 16 Jun 2008 10:09:35 +0200
From: drago01 <drago01@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] iwl3965: remove useless network and duplicate checking
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Tomas Winkler" <tomasw@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <f6ca9fed0806151105l3ddd72b9r5a4ad5f112cc8599@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806151105l3ddd72b9r5a4ad5f112cc8599@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry previous patch was incomplete.

------
mac802 can handle duplicate packages on its own, so let it do it.
Based on patch from Johannes Berg for iwl4965.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c
b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 63f2037..8014de6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -514,6 +514,21 @@ static inline void
iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 }
 #endif

+/* This is necessary only for a number of statistics, see the user. */
+static int iwl3945_is_network_packet(struct iwl3945_priv *priv,
+					struct ieee80211_hdr *header)
+{
+	switch (priv->iw_mode) {
+	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
+	/* packets to our IBSS update information */
+	return !compare_ether_addr(header->addr3, priv->bssid);
+	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
+	/* packets to our BSS update information */
+	return !compare_ether_addr(header->addr2, priv->bssid);
+	default:
+		return 1;
+	}
+}

 static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
 				 struct sk_buff *skb,
@@ -604,9 +619,10 @@ static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
 	stats->flag |= RX_FLAG_RADIOTAP;
 }

-static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
-				   struct iwl3945_rx_mem_buffer *rxb,
-				   struct ieee80211_rx_status *stats)
+static void iwl3945_pass_packet_to_mac80211(struct iwl3945_priv *priv,
+					int is_data,
+					struct iwl3945_rx_mem_buffer *rxb,
+					struct ieee80211_rx_status *stats)
 {
 	struct ieee80211_hdr *hdr;
 	struct iwl3945_rx_packet *pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
@@ -690,7 +706,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	}

 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		iwl3945_handle_data_packet(priv, 1, rxb, &rx_status);
+		iwl3945_pass_packet_to_mac80211(priv, 1, rxb, &rx_status);
 		return;
 	}

@@ -756,6 +772,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,

 	switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
+	case IEEE80211_FTYPE_DATA:
 		switch (le16_to_cpu(header->frame_control) &
 			IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_PROBE_RESP:
@@ -838,26 +855,13 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 			}
 		}

-		iwl3945_handle_data_packet(priv, 0, rxb, &rx_status);
-		break;
-
-	case IEEE80211_FTYPE_CTL:
+	/* fall through */
+	default:
+		iwl3945_pass_packet_to_mac80211(priv,
+				ieee80211_is_data(header->frame_control),
+				rxb, &rx_status);
 		break;

-	case IEEE80211_FTYPE_DATA: {
-		DECLARE_MAC_BUF(mac1);
-		DECLARE_MAC_BUF(mac2);
-		DECLARE_MAC_BUF(mac3);
-
-		if (unlikely(iwl3945_is_duplicate_packet(priv, header)))
-			IWL_DEBUG_DROP("Dropping (dup): %s, %s, %s\n",
-				       print_mac(mac1, header->addr1),
-				       print_mac(mac2, header->addr2),
-				       print_mac(mac3, header->addr3));
-		else
-			iwl3945_handle_data_packet(priv, 1, rxb, &rx_status);
-		break;
-	}
 	}
 }

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a9b3eda..58828e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -565,17 +565,8 @@ extern int iwl3945_send_add_station(struct
iwl3945_priv *priv,
 				struct iwl3945_addsta_cmd *sta, u8 flags);
 extern u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *bssid,
 			  int is_ap, u8 flags);
-extern int iwl3945_is_network_packet(struct iwl3945_priv *priv,
-				 struct ieee80211_hdr *header);
 extern int iwl3945_power_init_handle(struct iwl3945_priv *priv);
 extern int iwl3945_eeprom_init(struct iwl3945_priv *priv);
-extern void iwl3945_handle_data_packet_monitor(struct iwl3945_priv *priv,
-					   struct iwl3945_rx_mem_buffer *rxb,
-					   void *data, short len,
-					   struct ieee80211_rx_status *stats,
-					   u16 phy_flags);
-extern int iwl3945_is_duplicate_packet(struct iwl3945_priv *priv,
-				       struct ieee80211_hdr *header);
 extern int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv);
 extern void iwl3945_rx_queue_reset(struct iwl3945_priv *priv,
 			       struct iwl3945_rx_queue *rxq);
@@ -839,14 +830,6 @@ struct iwl3945_priv {
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
 	struct iwl3945_eeprom eeprom;

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 47cf4b9..eb0a0fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2025,36 +2025,6 @@ static int iwl3945_send_power_mode(struct
iwl3945_priv *priv, u32 mode)
 	return rc;
 }

-int iwl3945_is_network_packet(struct iwl3945_priv *priv, struct
ieee80211_hdr *header)
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
-		return 1;
-	}
-
-	return 1;
-}
-
 /**
  * iwl3945_scan_cancel - Cancel any currently executing HW scan
  *
@@ -2107,20 +2077,6 @@ static int iwl3945_scan_cancel_timeout(struct
iwl3945_priv *priv, unsigned long
 	return ret;
 }

-static void iwl3945_sequence_reset(struct iwl3945_priv *priv)
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
-	iwl3945_scan_cancel(priv);
-}
-
 #define MAX_UCODE_BEACON_INTERVAL	1024
 #define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)

@@ -2911,72 +2867,6 @@ void iwl3945_set_decrypted_flag(struct
iwl3945_priv *priv, struct sk_buff *skb,
 	}
 }

-#define IWL_PACKET_RETRY_TIME HZ
-
-int iwl3945_is_duplicate_packet(struct iwl3945_priv *priv, struct
ieee80211_hdr *header)
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
-		struct iwl3945_ibss_seq *entry = NULL;
-		u8 *mac = header->addr2;
-		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
-
-		__list_for_each(p, &priv->ibss_mac_hash[index]) {
-			entry = list_entry(p, struct iwl3945_ibss_seq, list);
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
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT

 #include "iwl-spectrum.h"
@@ -6509,7 +6399,7 @@ static void iwl3945_bg_post_associate(struct
work_struct *data)
 		break;
 	}

-	iwl3945_sequence_reset(priv);
+	iwl3945_scan_cancel(priv);

 	iwl3945_activate_qos(priv, 0);

@@ -7965,7 +7855,6 @@ static int iwl3945_pci_probe(struct pci_dev
*pdev, const struct pci_device_id *e
 	struct iwl3945_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_3945_cfg *cfg = (struct iwl_3945_cfg *)(ent->driver_data);
-	int i;
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);

@@ -8026,9 +7915,6 @@ static int iwl3945_pci_probe(struct pci_dev
*pdev, const struct pci_device_id *e
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);

-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
-		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
-
 	INIT_LIST_HEAD(&priv->free_frames);

 	mutex_init(&priv->mutex);
@@ -8196,8 +8082,6 @@ static int iwl3945_pci_probe(struct pci_dev
*pdev, const struct pci_device_id *e
 static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
-	struct list_head *p, *q;
-	int i;
 	unsigned long flags;

 	if (!priv)
@@ -8218,14 +8102,6 @@ static void __devexit iwl3945_pci_remove(struct
pci_dev *pdev)

 	iwl_synchronize_irq(priv);

-	/* Free MAC hash list for ADHOC */
-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
-		list_for_each_safe(p, q, &priv->ibss_mac_hash[i]) {
-			list_del(p);
-			kfree(list_entry(p, struct iwl3945_ibss_seq, list));
-		}
-	}
-
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);

 	iwl3945_dealloc_ucode_pci(priv);
