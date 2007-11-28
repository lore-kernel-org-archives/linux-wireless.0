Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbXK1QuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:50:22 -0500
Subject: [RFC] iwl4965: proper monitor support
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>, dragoran <drago01@gmail.com>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 17:10:30 +0100
Message-Id: <1196266230.6058.155.camel@johannes.berg> (sfid-20071128_165025_987022_9FAA5A8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the iwl4965 driver to properly support monitoring
after the filter flags change. I stayed with the "pull little endian
values through" style for now.

Somebody needs to port this to iwl3945.

There are also a few things that I'm unclear about and where I inserted
long comments in the code. One thing affects the antenna field, and the
other affects HT frame reception that I've been unable to test so far
(my HT AP hasn't arrived yet)

Not-yet-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tomas Winkler <tomasw@gmail.com<
Cc: drago01@gmail.com
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  120 ++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   24 -----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   90 ---------------------
 3 files changed, 115 insertions(+), 119 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-11-16 16:46:47.127142470 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-11-28 16:53:21.381090115 +0100
@@ -86,29 +86,6 @@ struct iwl4965_rx_mem_buffer {
 	struct list_head list;
 };
 
-struct iwl4965_rt_rx_hdr {
-	struct ieee80211_radiotap_header rt_hdr;
-	__le64 rt_tsf;		/* TSF */
-	u8 rt_flags;		/* radiotap packet flags */
-	u8 rt_rate;		/* rate in 500kb/s */
-	__le16 rt_channelMHz;	/* channel in MHz */
-	__le16 rt_chbitmask;	/* channel bitfield */
-	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
-	s8 rt_dbmnoise;
-	u8 rt_antenna;		/* antenna number */
-	u8 payload[0];		/* payload... */
-} __attribute__ ((packed));
-
-struct iwl4965_rt_tx_hdr {
-	struct ieee80211_radiotap_header rt_hdr;
-	u8 rt_rate;		/* rate in 500kb/s */
-	__le16 rt_channel;	/* channel in mHz */
-	__le16 rt_chbitmask;	/* channel bitfield */
-	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
-	u8 rt_antenna;		/* antenna number */
-	u8 payload[0];		/* payload... */
-} __attribute__ ((packed));
-
 /*
  * Generic queue structure
  *
@@ -1060,6 +1037,7 @@ struct iwl4965_priv {
 
 	u8 phymode;
 	int alloc_rxb_skb;
+	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl4965_priv *priv,
 				       struct iwl4965_rx_mem_buffer *rxb);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-11-16 16:46:47.147143501 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-11-28 17:08:15.311089898 +0100
@@ -51,7 +51,6 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
-#include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
 
 #include <asm/div64.h>
@@ -3131,93 +3130,6 @@ void iwl4965_set_decrypted_flag(struct i
 	}
 }
 
-void iwl4965_handle_data_packet_monitor(struct iwl4965_priv *priv,
-				    struct iwl4965_rx_mem_buffer *rxb,
-				    void *data, short len,
-				    struct ieee80211_rx_status *stats,
-				    u16 phy_flags)
-{
-	struct iwl4965_rt_rx_hdr *iwl4965_rt;
-
-	/* First cache any information we need before we overwrite
-	 * the information provided in the skb from the hardware */
-	s8 signal = stats->ssi;
-	s8 noise = 0;
-	int rate = stats->rate;
-	u64 tsf = stats->mactime;
-	__le16 phy_flags_hw = cpu_to_le16(phy_flags);
-
-	/* We received data from the HW, so stop the watchdog */
-	if (len > IWL_RX_BUF_SIZE - sizeof(*iwl4965_rt)) {
-		IWL_DEBUG_DROP("Dropping too large packet in monitor\n");
-		return;
-	}
-
-	/* copy the frame data to write after where the radiotap header goes */
-	iwl4965_rt = (void *)rxb->skb->data;
-	memmove(iwl4965_rt->payload, data, len);
-
-	iwl4965_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	iwl4965_rt->rt_hdr.it_pad = 0; /* always good to zero */
-
-	/* total header + data */
-	iwl4965_rt->rt_hdr.it_len = cpu_to_le16(sizeof(*iwl4965_rt));
-
-	/* Set the size of the skb to the size of the frame */
-	skb_put(rxb->skb, sizeof(*iwl4965_rt) + len);
-
-	/* Big bitfield of all the fields we provide in radiotap */
-	iwl4965_rt->rt_hdr.it_present =
-	    cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
-			(1 << IEEE80211_RADIOTAP_FLAGS) |
-			(1 << IEEE80211_RADIOTAP_RATE) |
-			(1 << IEEE80211_RADIOTAP_CHANNEL) |
-			(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
-			(1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
-			(1 << IEEE80211_RADIOTAP_ANTENNA));
-
-	/* Zero the flags, we'll add to them as we go */
-	iwl4965_rt->rt_flags = 0;
-
-	iwl4965_rt->rt_tsf = cpu_to_le64(tsf);
-
-	/* Convert to dBm */
-	iwl4965_rt->rt_dbmsignal = signal;
-	iwl4965_rt->rt_dbmnoise = noise;
-
-	/* Convert the channel frequency and set the flags */
-	iwl4965_rt->rt_channelMHz = cpu_to_le16(stats->freq);
-	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
-		iwl4965_rt->rt_chbitmask =
-		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ));
-	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
-		iwl4965_rt->rt_chbitmask =
-		    cpu_to_le16((IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ));
-	else	/* 802.11g */
-		iwl4965_rt->rt_chbitmask =
-		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ));
-
-	rate = iwl4965_rate_index_from_plcp(rate);
-	if (rate == -1)
-		iwl4965_rt->rt_rate = 0;
-	else
-		iwl4965_rt->rt_rate = iwl4965_rates[rate].ieee;
-
-	/* antenna number */
-	iwl4965_rt->rt_antenna =
-		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
-
-	/* set the preamble flag if we have it */
-	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		iwl4965_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
-
-	IWL_DEBUG_RX("Rx packet of %d bytes.\n", rxb->skb->len);
-
-	stats->flag |= RX_FLAG_RADIOTAP;
-	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
-	rxb->skb = NULL;
-}
-
 
 #define IWL_PACKET_RETRY_TIME HZ
 
@@ -7356,6 +7268,8 @@ static int iwl4965_mac_config(struct iee
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
 
+	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
+
 	if (!iwl4965_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		mutex_unlock(&priv->mutex);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-11-16 16:46:47.127142470 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-11-28 17:07:25.251092611 +0100
@@ -36,6 +36,7 @@
 #include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
+#include <asm/unaligned.h>
 
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
@@ -3478,6 +3479,114 @@ void iwl4965_hw_rx_statistics(struct iwl
 		queue_work(priv->workqueue, &priv->txpower_work);
 }
 
+static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
+				 struct sk_buff *skb,
+				 struct iwl4965_rx_phy_res *rx_start,
+				 void *data, short len,
+				 struct ieee80211_rx_status *stats,
+				 u32 ampdu_status)
+{
+	s8 signal = stats->ssi;
+	s8 noise = 0;
+	int rate = stats->rate;
+	u64 tsf = stats->mactime;
+	__le16 phy_flags_hw = rx_start->phy_flags;
+	struct iwl4965_rt_rx_hdr {
+		struct ieee80211_radiotap_header rt_hdr;
+		__le64 rt_tsf;		/* TSF */
+		u8 rt_flags;		/* radiotap packet flags */
+		u8 rt_rate;		/* rate in 500kb/s */
+		__le16 rt_channelMHz;	/* channel in MHz */
+		__le16 rt_chbitmask;	/* channel bitfield */
+		s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
+		s8 rt_dbmnoise;
+		u8 rt_antenna;		/* antenna number */
+	} __attribute__ ((packed)) *iwl4965_rt;
+
+	/*
+	 * If we receive an 11n frame (non-legacy) do we have enough
+	 * headroom here? The original code copied all the data which
+	 * is too expensive. If we don't have enough headroom we need
+	 * to reserve some headroom in the RX descriptor.
+	 */
+	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
+		printk(KERN_DEBUG "not enough headroom for radiotap\n");
+		return;
+	}
+
+	/* put radiotap header in front of 802.11 header and data */
+	iwl4965_rt = (void *)skb_push(skb, sizeof(*iwl4965_rt));
+
+	/* initialise radiotap header */
+	iwl4965_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	iwl4965_rt->rt_hdr.it_pad = 0;
+
+	/* total header + data */
+	put_unaligned(cpu_to_le16(sizeof(*iwl4965_rt)),
+		      &iwl4965_rt->rt_hdr.it_len);
+
+	/* Indicate all the fields we add to the radiotap header */
+	put_unaligned(cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+				  (1 << IEEE80211_RADIOTAP_FLAGS) |
+				  (1 << IEEE80211_RADIOTAP_RATE) |
+				  (1 << IEEE80211_RADIOTAP_CHANNEL) |
+				  (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
+				  (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
+				  (1 << IEEE80211_RADIOTAP_ANTENNA)),
+		      &iwl4965_rt->rt_hdr.it_present);
+
+	/* Zero the flags, we'll add to them as we go */
+	iwl4965_rt->rt_flags = 0;
+
+	put_unaligned(cpu_to_le64(tsf), &iwl4965_rt->rt_tsf);
+
+	iwl4965_rt->rt_dbmsignal = signal;
+	iwl4965_rt->rt_dbmnoise = noise;
+
+	/* Convert the channel frequency and set the flags */
+	put_unaligned(cpu_to_le16(stats->freq), &iwl4965_rt->rt_channelMHz);
+	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
+					  IEEE80211_CHAN_5GHZ),
+			      &iwl4965_rt->rt_chbitmask);
+	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_CCK |
+					  IEEE80211_CHAN_2GHZ),
+			      &iwl4965_rt->rt_chbitmask);
+	else	/* 802.11g */
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
+					  IEEE80211_CHAN_2GHZ),
+			      &iwl4965_rt->rt_chbitmask);
+
+	rate = iwl4965_rate_index_from_plcp(rate);
+	if (rate == -1)
+		iwl4965_rt->rt_rate = 0;
+	else
+		iwl4965_rt->rt_rate = iwl4965_rates[rate].ieee;
+
+	/*
+	 * "antenna number"
+	 *
+	 * It seems that the antenna field in the phy flags value
+	 * is actually a bitfield. This is undefined by radiotap,
+	 * it wants an actual antenna number but I always get "7"
+	 * for most legacy frames I receive indicating that the
+	 * same frame was received on all three RX chains.
+	 *
+	 * I think this field should be removed in favour of a
+	 * new 802.11n radiotap field "RX chains" that is defined
+	 * as a bitmask.
+	 */
+	iwl4965_rt->rt_antenna =
+		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+
+	/* set the preamble flag if appropriate */
+	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+		iwl4965_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
+
+	stats->flag |= RX_FLAG_RADIOTAP;
+}
+
 static void iwl4965_handle_data_packet(struct iwl4965_priv *priv, int is_data,
 				       int include_phy,
 				       struct iwl4965_rx_mem_buffer *rxb,
@@ -3539,20 +3648,15 @@ static void iwl4965_handle_data_packet(s
 		return;
 	}
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		if (iwl4965_param_hwcrypto)
-			iwl4965_set_decrypted_flag(priv, rxb->skb,
-					       ampdu_status, stats);
-		iwl4965_handle_data_packet_monitor(priv, rxb, hdr, len, stats, 0);
-		return;
-	}
-
 	stats->flag = 0;
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
 	if (iwl4965_param_hwcrypto)
 		iwl4965_set_decrypted_flag(priv, rxb->skb, ampdu_status, stats);
 
+	if (priv->add_radiotap)
+		iwl4965_add_radiotap(priv, rxb->skb, rx_start, hdr, len, stats, ampdu_status);
+
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	priv->alloc_rxb_skb--;
 	rxb->skb = NULL;


