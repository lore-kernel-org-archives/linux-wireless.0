Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbYBAMJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:36 -0500
Message-Id: <20080131185051.637714000@sipsolutions.net> (sfid-20080201_120945_128225_29C8650A)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] mac80211: split RX_DROP
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some instances of RX_DROP mean that the frame was useless,
others mean that the frame should be visible in userspace
on "cooked" monitor interfaces. This patch splits up RX_DROP
and changes each instance appropriately.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h   |    7 ++---
 net/mac80211/ieee80211_sta.c |    4 +-
 net/mac80211/rx.c            |   59 +++++++++++++++++++++----------------------
 net/mac80211/wep.c           |    2 -
 net/mac80211/wpa.c           |   16 +++++------
 5 files changed, 45 insertions(+), 43 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-31 15:46:09.015793999 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-31 15:46:09.975794650 +0100
@@ -114,9 +114,10 @@ typedef unsigned __bitwise__ ieee80211_t
 #define TX_QUEUED	((__force ieee80211_tx_result) 2u)
 
 typedef unsigned __bitwise__ ieee80211_rx_result;
-#define RX_CONTINUE	((__force ieee80211_rx_result) 0u)
-#define RX_DROP		((__force ieee80211_rx_result) 1u)
-#define RX_QUEUED	((__force ieee80211_rx_result) 2u)
+#define RX_CONTINUE		((__force ieee80211_rx_result) 0u)
+#define RX_DROP_UNUSABLE	((__force ieee80211_rx_result) 1u)
+#define RX_DROP_MONITOR		((__force ieee80211_rx_result) 2u)
+#define RX_QUEUED		((__force ieee80211_rx_result) 3u)
 
 
 /* flags used in struct ieee80211_txrx_data.flags */
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-01-31 15:46:09.025793944 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-01-31 15:46:09.985793781 +0100
@@ -2566,7 +2566,7 @@ ieee80211_sta_rx_scan(struct net_device 
 	u16 fc;
 
 	if (skb->len < 2)
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
@@ -2575,7 +2575,7 @@ ieee80211_sta_rx_scan(struct net_device 
 		return RX_CONTINUE;
 
 	if (skb->len < 24)
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 
 	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP) {
--- everything.orig/net/mac80211/rx.c	2008-01-31 15:46:09.035794161 +0100
+++ everything/net/mac80211/rx.c	2008-01-31 15:46:09.985793781 +0100
@@ -380,7 +380,7 @@ ieee80211_rx_h_passive_scan(struct ieee8
 	if (unlikely(rx->flags & IEEE80211_TXRXD_RXIN_SCAN)) {
 		/* scanning finished during invoking of handlers */
 		I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 	}
 
 	return RX_CONTINUE;
@@ -401,14 +401,14 @@ ieee80211_rx_h_check(struct ieee80211_tx
 				rx->local->dot11FrameDuplicateCount++;
 				rx->sta->num_duplicates++;
 			}
-			return RX_DROP;
+			return RX_DROP_MONITOR;
 		} else
 			rx->sta->last_seq_ctrl[rx->u.rx.queue] = hdr->seq_ctrl;
 	}
 
 	if (unlikely(rx->skb->len < 16)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_short);
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 	}
 
 	/* Drop disallowed frame classes based on STA auth/assoc state;
@@ -430,10 +430,10 @@ ieee80211_rx_h_check(struct ieee80211_tx
 		    || !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
 			/* Drop IBSS frames and frames for other hosts
 			 * silently. */
-			return RX_DROP;
+			return RX_DROP_MONITOR;
 		}
 
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 	}
 
 	return RX_CONTINUE;
@@ -446,7 +446,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	int keyidx;
 	int hdrlen;
-	ieee80211_rx_result result = RX_DROP;
+	ieee80211_rx_result result = RX_DROP_UNUSABLE;
 	struct ieee80211_key *stakey = NULL;
 
 	/*
@@ -507,7 +507,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		hdrlen = ieee80211_get_hdrlen(rx->fc);
 
 		if (rx->skb->len < 8 + hdrlen)
-			return RX_DROP; /* TODO: count this? */
+			return RX_DROP_UNUSABLE; /* TODO: count this? */
 
 		/*
 		 * no need to call ieee80211_wep_get_keyidx,
@@ -536,7 +536,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 			printk(KERN_DEBUG "%s: RX protected frame,"
 			       " but have no key\n", rx->dev->name);
 #endif /* CONFIG_MAC80211_DEBUG */
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 	}
 
 	/* Check for weak IVs if possible */
@@ -821,7 +821,7 @@ ieee80211_rx_h_defragment(struct ieee802
 					  rx->u.rx.queue, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 	}
 
 	/* Verify that MPDUs within one MSDU have sequential PN values.
@@ -830,7 +830,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		int i;
 		u8 pn[CCMP_PN_LEN], *rpn;
 		if (!rx->key || rx->key->conf.alg != ALG_CCMP)
-			return RX_DROP;
+			return RX_DROP_UNUSABLE;
 		memcpy(pn, entry->last_pn, CCMP_PN_LEN);
 		for (i = CCMP_PN_LEN - 1; i >= 0; i--) {
 			pn[i]++;
@@ -848,7 +848,7 @@ ieee80211_rx_h_defragment(struct ieee802
 				       rpn[0], rpn[1], rpn[2], rpn[3], rpn[4],
 				       rpn[5], pn[0], pn[1], pn[2], pn[3],
 				       pn[4], pn[5]);
-			return RX_DROP;
+			return RX_DROP_UNUSABLE;
 		}
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
 	}
@@ -869,7 +869,7 @@ ieee80211_rx_h_defragment(struct ieee802
 					      GFP_ATOMIC))) {
 			I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
 			__skb_queue_purge(&entry->skb_list);
-			return RX_DROP;
+			return RX_DROP_UNUSABLE;
 		}
 	}
 	while ((skb = __skb_dequeue(&entry->skb_list))) {
@@ -906,7 +906,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 
 	if ((sdata->vif.type != IEEE80211_IF_TYPE_AP) &&
 	    (sdata->vif.type != IEEE80211_IF_TYPE_VLAN))
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	skb = skb_dequeue(&rx->sta->tx_filtered);
 	if (!skb) {
@@ -1257,14 +1257,14 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 		return RX_CONTINUE;
 
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 
 	if (!(rx->flags & IEEE80211_TXRXD_RX_AMSDU))
 		return RX_CONTINUE;
 
 	err = ieee80211_data_to_8023(rx);
 	if (unlikely(err))
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	skb->dev = dev;
 
@@ -1274,7 +1274,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 	/* skip the wrapping header */
 	eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
 	if (!eth)
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	while (skb != frame) {
 		u8 padding;
@@ -1289,7 +1289,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 		/* the last MSDU has no padding */
 		if (subframe_len > remaining) {
 			printk(KERN_DEBUG "%s: wrong buffer size", dev->name);
-			return RX_DROP;
+			return RX_DROP_UNUSABLE;
 		}
 
 		skb_pull(skb, sizeof(struct ethhdr));
@@ -1301,7 +1301,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 					      subframe_len);
 
 			if (frame == NULL)
-				return RX_DROP;
+				return RX_DROP_UNUSABLE;
 
 			skb_reserve(frame, local->hw.extra_tx_headroom +
 				    sizeof(struct ethhdr));
@@ -1314,7 +1314,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 				printk(KERN_DEBUG "%s: wrong buffer size ",
 				       dev->name);
 				dev_kfree_skb(frame);
-				return RX_DROP;
+				return RX_DROP_UNUSABLE;
 			}
 		}
 
@@ -1344,7 +1344,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 
 		if (!ieee80211_frame_allowed(rx)) {
 			if (skb == frame) /* last frame */
-				return RX_DROP;
+				return RX_DROP_UNUSABLE;
 			dev_kfree_skb(frame);
 			continue;
 		}
@@ -1367,14 +1367,14 @@ ieee80211_rx_h_data(struct ieee80211_txr
 		return RX_CONTINUE;
 
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 
 	err = ieee80211_data_to_8023(rx);
 	if (unlikely(err))
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	if (!ieee80211_frame_allowed(rx))
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 
 	rx->skb->dev = dev;
 
@@ -1423,7 +1423,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_txr
 		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
 						 start_seq_num, 1);
 		rcu_read_unlock();
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 	}
 
 	return RX_CONTINUE;
@@ -1435,7 +1435,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	struct ieee80211_sub_if_data *sdata;
 
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
@@ -1443,7 +1443,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
 	else
-		return RX_DROP;
+		return RX_DROP_MONITOR;
 
 	return RX_QUEUED;
 }
@@ -1455,7 +1455,7 @@ static inline ieee80211_rx_result __ieee
 				struct sta_info *sta)
 {
 	ieee80211_rx_handler *handler;
-	ieee80211_rx_result res = RX_DROP;
+	ieee80211_rx_result res = RX_DROP_MONITOR;
 
 	for (handler = handlers; *handler != NULL; handler++) {
 		res = (*handler)(rx);
@@ -1463,7 +1463,8 @@ static inline ieee80211_rx_result __ieee
 		switch (res) {
 		case RX_CONTINUE:
 			continue;
-		case RX_DROP:
+		case RX_DROP_UNUSABLE:
+		case RX_DROP_MONITOR:
 			I802_DEBUG_INC(local->rx_handlers_drop);
 			if (sta)
 				sta->rx_dropped++;
@@ -1475,7 +1476,7 @@ static inline ieee80211_rx_result __ieee
 		break;
 	}
 
-	if (res == RX_DROP)
+	if (res == RX_DROP_UNUSABLE || res == RX_DROP_MONITOR)
 		dev_kfree_skb(rx->skb);
 	return res;
 }
--- everything.orig/net/mac80211/wep.c	2008-01-31 15:46:09.015793999 +0100
+++ everything/net/mac80211/wep.c	2008-01-31 15:46:09.985793781 +0100
@@ -320,7 +320,7 @@ ieee80211_crypto_wep_decrypt(struct ieee
 				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
 				       "failed\n", rx->dev->name);
 #endif /* CONFIG_MAC80211_DEBUG */
-			return RX_DROP;
+			return RX_DROP_UNUSABLE;
 		}
 	} else if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED)) {
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
--- everything.orig/net/mac80211/wpa.c	2008-01-31 15:46:09.025793944 +0100
+++ everything/net/mac80211/wpa.c	2008-01-31 15:46:09.995793673 +0100
@@ -148,7 +148,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 
 	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len)
 	    || data_len < MICHAEL_MIC_LEN)
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	data_len -= MICHAEL_MIC_LEN;
 
@@ -162,14 +162,14 @@ ieee80211_rx_h_michael_mic_verify(struct
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
 		if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-			return RX_DROP;
+			return RX_DROP_UNUSABLE;
 
 		printk(KERN_DEBUG "%s: invalid Michael MIC in data frame from "
 		       "%s\n", rx->dev->name, print_mac(mac, sa));
 
 		mac80211_ev_michael_mic_failure(rx->dev, rx->key->conf.keyidx,
 						(void *) skb->data);
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 	}
 
 	/* remove Michael MIC from payload */
@@ -293,7 +293,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 		return RX_CONTINUE;
 
 	if (!rx->sta || skb->len - hdrlen < 12)
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	if (rx->u.rx.status->flag & RX_FLAG_DECRYPTED) {
 		if (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) {
@@ -322,7 +322,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 			       "frame from %s (res=%d)\n", rx->dev->name,
 			       print_mac(mac, rx->sta->addr), res);
 #endif /* CONFIG_MAC80211_DEBUG */
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 	}
 
 	/* Trim ICV */
@@ -545,7 +545,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 
 	data_len = skb->len - hdrlen - CCMP_HDR_LEN - CCMP_MIC_LEN;
 	if (!rx->sta || data_len < 0)
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
 	    (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED))
@@ -565,7 +565,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 		       ppn[0], ppn[1], ppn[2], ppn[3], ppn[4], ppn[5]);
 #endif /* CONFIG_MAC80211_DEBUG */
 		key->u.ccmp.replays++;
-		return RX_DROP;
+		return RX_DROP_UNUSABLE;
 	}
 
 	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
@@ -589,7 +589,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 				       "for RX frame from %s\n", rx->dev->name,
 				       print_mac(mac, rx->sta->addr));
 #endif /* CONFIG_MAC80211_DEBUG */
-			return RX_DROP;
+			return RX_DROP_UNUSABLE;
 		}
 	}
 

-- 

