Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbXLSI3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 03:29:08 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iwlwifi: proper monitor support
Date: Wed, 19 Dec 2007 16:28:58 +0800
Message-Id: <1198052938-25637-1-git-send-email-yi.zhu@intel.com> (sfid-20071219_082915_286640_111605D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the iwlwifi driver to properly support
monitor interfaces after the filter flags change.

The patch is originally created by Johannes Berg for iwl4965. I fixed some
of the comments and created a similar patch for iwl3945.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  118 ++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   36 +++------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  120 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   24 +-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  109 +++----------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   90 +--------------------
 6 files changed, 236 insertions(+), 261 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7d15b33..07fa363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -35,9 +35,9 @@
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <linux/firmware.h>
-#include <net/mac80211.h>
-
 #include <linux/etherdevice.h>
+#include <asm/unaligned.h>
+#include <net/mac80211.h>
 
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
@@ -238,10 +238,100 @@ void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_b
 	priv->last_statistics_time = jiffies;
 }
 
+void iwl3945_add_radiotap(struct iwl3945_priv *priv, struct sk_buff *skb,
+			  struct iwl3945_rx_frame_hdr *rx_hdr,
+			  struct ieee80211_rx_status *stats)
+{
+	/* First cache any information we need before we overwrite
+	 * the information provided in the skb from the hardware */
+	s8 signal = stats->ssi;
+	s8 noise = 0;
+	int rate = stats->rate;
+	u64 tsf = stats->mactime;
+	__le16 phy_flags_hw = rx_hdr->phy_flags;
+
+	struct iwl3945_rt_rx_hdr {
+		struct ieee80211_radiotap_header rt_hdr;
+		__le64 rt_tsf;		/* TSF */
+		u8 rt_flags;		/* radiotap packet flags */
+		u8 rt_rate;		/* rate in 500kb/s */
+		__le16 rt_channelMHz;	/* channel in MHz */
+		__le16 rt_chbitmask;	/* channel bitfield */
+		s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
+		s8 rt_dbmnoise;
+		u8 rt_antenna;		/* antenna number */
+	} __attribute__ ((packed)) *iwl3945_rt;
+
+	if (skb_headroom(skb) < sizeof(*iwl3945_rt)) {
+		if (net_ratelimit())
+			printk(KERN_ERR "not enought headroom for radiotap\n");
+		return;
+	}
+
+	/* put radiotap header in front of 802.11 header and data */
+	iwl3945_rt = (void *)skb_push(skb, sizeof(*iwl3945_rt));
+
+	/* initialise radiotap header */
+	iwl3945_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	iwl3945_rt->rt_hdr.it_pad = 0;
+
+	/* total header + data */
+	put_unaligned(cpu_to_le16(sizeof(*iwl3945_rt)),
+		      &iwl3945_rt->rt_hdr.it_len);
+
+	/* Indicate all the fields we add to the radiotap header */
+	put_unaligned(cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+				  (1 << IEEE80211_RADIOTAP_FLAGS) |
+				  (1 << IEEE80211_RADIOTAP_RATE) |
+				  (1 << IEEE80211_RADIOTAP_CHANNEL) |
+				  (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
+				  (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
+				  (1 << IEEE80211_RADIOTAP_ANTENNA)),
+		      &iwl3945_rt->rt_hdr.it_present);
+
+	/* Zero the flags, we'll add to them as we go */
+	iwl3945_rt->rt_flags = 0;
+
+	put_unaligned(cpu_to_le64(tsf), &iwl3945_rt->rt_tsf);
+
+	iwl3945_rt->rt_dbmsignal = signal;
+	iwl3945_rt->rt_dbmnoise = noise;
+
+	/* Convert the channel frequency and set the flags */
+	put_unaligned(cpu_to_le16(stats->freq), &iwl3945_rt->rt_channelMHz);
+	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
+					  IEEE80211_CHAN_5GHZ),
+			      &iwl3945_rt->rt_chbitmask);
+	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_CCK |
+					  IEEE80211_CHAN_2GHZ),
+			      &iwl3945_rt->rt_chbitmask);
+	else	/* 802.11g */
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
+					  IEEE80211_CHAN_2GHZ),
+			      &iwl3945_rt->rt_chbitmask);
+
+	rate = iwl3945_rate_index_from_plcp(rate);
+	if (rate == -1)
+		iwl3945_rt->rt_rate = 0;
+	else
+		iwl3945_rt->rt_rate = iwl3945_rates[rate].ieee;
+
+	/* antenna number */
+	iwl3945_rt->rt_antenna =
+		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+
+	/* set the preamble flag if we have it */
+	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+		iwl3945_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
+
+	stats->flag |= RX_FLAG_RADIOTAP;
+}
+
 static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 				   struct iwl3945_rx_mem_buffer *rxb,
-				   struct ieee80211_rx_status *stats,
-				   u16 phy_flags)
+				   struct ieee80211_rx_status *stats)
 {
 	struct ieee80211_hdr *hdr;
 	struct iwl3945_rx_packet *pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
@@ -261,15 +351,6 @@ static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 		    ("Dropping packet while interface is not open.\n");
 		return;
 	}
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		if (iwl3945_param_hwcrypto)
-			iwl3945_set_decrypted_flag(priv, rxb->skb,
-					       le32_to_cpu(rx_end->status),
-					       stats);
-		iwl3945_handle_data_packet_monitor(priv, rxb, IWL_RX_DATA(pkt),
-					       len, stats, phy_flags);
-		return;
-	}
 
 	skb_reserve(rxb->skb, (void *)rx_hdr->payload - (void *)pkt);
 	/* Set the size of the skb to the size of the frame */
@@ -281,6 +362,9 @@ static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 		iwl3945_set_decrypted_flag(priv, rxb->skb,
 				       le32_to_cpu(rx_end->status), stats);
 
+	if (priv->add_radiotap)
+		iwl3945_add_radiotap(priv, rxb->skb, rx_hdr, stats);
+
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	rxb->skb = NULL;
 }
@@ -295,7 +379,6 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	struct ieee80211_hdr *header;
-	u16 phy_flags = le16_to_cpu(rx_hdr->phy_flags);
 	u16 rx_stats_sig_avg = le16_to_cpu(rx_stats->sig_avg);
 	u16 rx_stats_noise_diff = le16_to_cpu(rx_stats->noise_diff);
 	struct ieee80211_rx_status stats = {
@@ -325,7 +408,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	}
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		iwl3945_handle_data_packet(priv, 1, rxb, &stats, phy_flags);
+		iwl3945_handle_data_packet(priv, 1, rxb, &stats);
 		return;
 	}
 
@@ -479,7 +562,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 			}
 		}
 
-		iwl3945_handle_data_packet(priv, 0, rxb, &stats, phy_flags);
+		iwl3945_handle_data_packet(priv, 0, rxb, &stats);
 		break;
 
 	case IEEE80211_FTYPE_CTL:
@@ -496,8 +579,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 				       print_mac(mac2, header->addr2),
 				       print_mac(mac3, header->addr3));
 		else
-			iwl3945_handle_data_packet(priv, 1, rxb, &stats,
-						   phy_flags);
+			iwl3945_handle_data_packet(priv, 1, rxb, &stats);
 		break;
 	}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index bfa2606..f1aa4dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -91,29 +91,6 @@ struct iwl3945_rx_mem_buffer {
 	struct list_head list;
 };
 
-struct iwl3945_rt_rx_hdr {
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
-struct iwl3945_rt_tx_hdr {
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
@@ -531,7 +508,7 @@ struct iwl3945_ibss_seq {
 };
 
 /**
- * struct iwl4965_driver_hw_info
+ * struct iwl3945_driver_hw_info
  * @max_txq_num: Max # Tx queues supported
  * @ac_queue_count: # Tx queues for EDCA Access Categories (AC)
  * @tx_cmd_len: Size of Tx command (but not including frame itself)
@@ -725,6 +702,7 @@ struct iwl3945_priv {
 
 	u8 phymode;
 	int alloc_rxb_skb;
+	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl3945_priv *priv,
 				       struct iwl3945_rx_mem_buffer *rxb);
@@ -980,6 +958,16 @@ static inline int is_channel_ibss(const struct iwl3945_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
+static inline int iwl3945_rate_index_from_plcp(int plcp)
+{
+	int i;
+
+	for (i = 0; i < IWL_RATE_COUNT; i++)
+		if (iwl3945_rates[i].plcp == plcp)
+			return i;
+	return -1;
+}
+
 extern const struct iwl3945_channel_info *iwl3945_get_channel_info(
 	const struct iwl3945_priv *priv, int phymode, u16 channel);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f65fd6e..2434321 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -36,6 +36,7 @@
 #include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
+#include <asm/unaligned.h>
 
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
@@ -3588,6 +3589,111 @@ void iwl4965_hw_rx_statistics(struct iwl4965_priv *priv, struct iwl4965_rx_mem_b
 		queue_work(priv->workqueue, &priv->txpower_work);
 }
 
+static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
+				 struct sk_buff *skb,
+				 struct iwl4965_rx_phy_res *rx_start,
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
+	 * We won't receive HT frames in monitor mode. For legacy frames, we do 	 * have enough headroom here.
+	 */
+	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
+		if (net_ratelimit())
+			printk(KERN_ERR "not enough headroom for radiotap\n");
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
@@ -3630,8 +3736,7 @@ static void iwl4965_handle_data_packet(struct iwl4965_priv *priv, int is_data,
 		rx_end = (__le32 *) (((u8 *) hdr) + len);
 	}
 	if (len > priv->hw_setting.max_pkt_size || len < 16) {
-		IWL_WARNING("byte count out of range [16,4K]"
-			       " : %d\n", len);
+		IWL_WARNING("byte count out of range [16,4K] : %d\n", len);
 		return;
 	}
 
@@ -3649,20 +3754,15 @@ static void iwl4965_handle_data_packet(struct iwl4965_priv *priv, int is_data,
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
+		iwl4965_add_radiotap(priv, rxb->skb, rx_start, stats, ampdu_status);
+
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	priv->alloc_rxb_skb--;
 	rxb->skb = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 267ae75..9a975ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -91,29 +91,6 @@ struct iwl4965_rx_mem_buffer {
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
@@ -1054,6 +1031,7 @@ struct iwl4965_priv {
 
 	u8 phymode;
 	int alloc_rxb_skb;
+	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl4965_priv *priv,
 				       struct iwl4965_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 88cf035..efbeeec 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1497,16 +1497,6 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-static int iwl3945_rate_index_from_plcp(int plcp)
-{
-	int i = 0;
-
-	for (i = 0; i < IWL_RATE_COUNT; i++)
-		if (iwl3945_rates[i].plcp == plcp)
-			return i;
-	return -1;
-}
-
 static u8 iwl3945_rate_get_lowest_plcp(int rate_mask)
 {
 	u8 i;
@@ -3121,94 +3111,6 @@ void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
 	}
 }
 
-void iwl3945_handle_data_packet_monitor(struct iwl3945_priv *priv,
-				    struct iwl3945_rx_mem_buffer *rxb,
-				    void *data, short len,
-				    struct ieee80211_rx_status *stats,
-				    u16 phy_flags)
-{
-	struct iwl3945_rt_rx_hdr *iwl3945_rt;
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
-	if (len > IWL_RX_BUF_SIZE - sizeof(*iwl3945_rt)) {
-		IWL_DEBUG_DROP("Dropping too large packet in monitor\n");
-		return;
-	}
-
-	/* copy the frame data to write after where the radiotap header goes */
-	iwl3945_rt = (void *)rxb->skb->data;
-	memmove(iwl3945_rt->payload, data, len);
-
-	iwl3945_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	iwl3945_rt->rt_hdr.it_pad = 0; /* always good to zero */
-
-	/* total header + data */
-	iwl3945_rt->rt_hdr.it_len = cpu_to_le16(sizeof(*iwl3945_rt));
-
-	/* Set the size of the skb to the size of the frame */
-	skb_put(rxb->skb, sizeof(*iwl3945_rt) + len);
-
-	/* Big bitfield of all the fields we provide in radiotap */
-	iwl3945_rt->rt_hdr.it_present =
-	    cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
-			(1 << IEEE80211_RADIOTAP_FLAGS) |
-			(1 << IEEE80211_RADIOTAP_RATE) |
-			(1 << IEEE80211_RADIOTAP_CHANNEL) |
-			(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
-			(1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
-			(1 << IEEE80211_RADIOTAP_ANTENNA));
-
-	/* Zero the flags, we'll add to them as we go */
-	iwl3945_rt->rt_flags = 0;
-
-	iwl3945_rt->rt_tsf = cpu_to_le64(tsf);
-
-	/* Convert to dBm */
-	iwl3945_rt->rt_dbmsignal = signal;
-	iwl3945_rt->rt_dbmnoise = noise;
-
-	/* Convert the channel frequency and set the flags */
-	iwl3945_rt->rt_channelMHz = cpu_to_le16(stats->freq);
-	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
-		iwl3945_rt->rt_chbitmask =
-		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ));
-	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
-		iwl3945_rt->rt_chbitmask =
-		    cpu_to_le16((IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ));
-	else	/* 802.11g */
-		iwl3945_rt->rt_chbitmask =
-		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ));
-
-	rate = iwl3945_rate_index_from_plcp(rate);
-	if (rate == -1)
-		iwl3945_rt->rt_rate = 0;
-	else
-		iwl3945_rt->rt_rate = iwl3945_rates[rate].ieee;
-
-	/* antenna number */
-	iwl3945_rt->rt_antenna =
-		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
-
-	/* set the preamble flag if we have it */
-	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		iwl3945_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
-
-	IWL_DEBUG_RX("Rx packet of %d bytes.\n", rxb->skb->len);
-
-	stats->flag |= RX_FLAG_RADIOTAP;
-	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
-	rxb->skb = NULL;
-}
-
-
 #define IWL_PACKET_RETRY_TIME HZ
 
 int iwl3945_is_duplicate_packet(struct iwl3945_priv *priv, struct ieee80211_hdr *header)
@@ -4147,6 +4049,15 @@ static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
 			 * more buffers it will schedule replenish */
 			break;
 		}
+
+		/* If radiotap head is required, reserve some headroom here.
+		 * The physical head count is a variable rx_stats->phy_count.
+		 * We reserve 4 bytes here. Plus these extra bytes, the
+		 * headroom of the physical head should be enough for the
+		 * radiotap head that iwl3945 supported. See iwl3945_rt.
+		 */
+		skb_reserve(rxb->skb, 4);
+
 		priv->alloc_rxb_skb++;
 		list_del(element);
 
@@ -7109,6 +7020,8 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
 
+	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
+
 	if (!iwl3945_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		ret = -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df6f3b1..61a22f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -41,7 +41,6 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
-#include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
 
 #include <asm/div64.h>
@@ -3247,93 +3246,6 @@ void iwl4965_set_decrypted_flag(struct iwl4965_priv *priv, struct sk_buff *skb,
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
-	if (len > priv->hw_setting.rx_buf_size - sizeof(*iwl4965_rt)) {
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
 
@@ -7551,6 +7463,8 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
 
+	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
+
 	if (!iwl4965_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		ret = -EIO;
-- 
1.5.3.6

