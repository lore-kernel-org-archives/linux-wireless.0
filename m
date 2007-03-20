Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:49704 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbXCTKlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2007 06:41:07 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id A15A58D0F4
	for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2007 11:41:05 +0100 (CET)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id EE8BD10091
	for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2007 10:41:07 +0000 (UTC)
Message-Id: <20070320104104.112865979@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
Date: Tue, 20 Mar 2007 10:39:56 +0000
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mac80211: Coding style cleanups
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stop existing code in ieee80211.c giving me panic attacks that I let my edits
go over 80 cols

From: Andy Green <andy@warmcat.com>

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..c598c9d 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -275,7 +275,8 @@ EXPORT_SYMBOL(ieee80211_get_hdrlen);
 
 int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 {
-	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
+	const struct ieee80211_hdr *hdr =
+		(const struct ieee80211_hdr *) skb->data;
 	int hdrlen;
 
 	if (unlikely(skb->len < 10))
@@ -489,7 +490,8 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 		fhdr = (struct ieee80211_hdr *) skb_put(frag, hdrlen);
 		memcpy(fhdr, first->data, hdrlen);
 		if (i == num_fragm - 2)
-			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
+			fhdr->frame_control &=
+				cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
 		fhdr->seq_ctrl = cpu_to_le16(i + 1);
 		copylen = left > per_fragm ? per_fragm : left;
 		memcpy(skb_put(frag, copylen), pos, copylen);
@@ -545,7 +547,8 @@ void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
 		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
 			fhdr = (struct ieee80211_hdr *)
 				tx->u.tx.extra_frag[i]->data;
-			fhdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+			fhdr->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 		}
 	}
 }
@@ -861,7 +864,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	if (likely(tx->u.tx.unicast)) {
 		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
 			     tx->sdata->type != IEEE80211_IF_TYPE_IBSS &&
-			     (tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
+			     (tx->fc & IEEE80211_FCTL_FTYPE)
+==			      IEEE80211_FTYPE_DATA)) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			printk(KERN_DEBUG "%s: dropped data frame to not "
 			       "associated station " MAC_FMT "\n",
@@ -871,7 +875,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 			return TXRX_DROP;
 		}
 	} else {
-		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
+		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) ==
+		             IEEE80211_FTYPE_DATA &&
 			     tx->local->num_sta == 0 &&
 			     !tx->local->allow_broadcast_always &&
 			     tx->sdata->type != IEEE80211_IF_TYPE_IBSS)) {
@@ -982,7 +987,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_txrx_data *tx)
 
 	if (unlikely(!sta ||
 		     ((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
-		      (tx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP)))
+		      (tx->fc & IEEE80211_FCTL_STYPE) ==
+		       IEEE80211_STYPE_PROBE_RESP)))
 		return TXRX_CONTINUE;
 
 	if (unlikely((sta->flags & WLAN_STA_PS) && !sta->pspoll)) {
@@ -1012,7 +1018,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_txrx_data *tx)
 				tx->local->ops->set_tim(local_to_hw(tx->local),
 						       sta->aid, 1);
 			if (tx->sdata->bss)
-				bss_tim_set(tx->local, tx->sdata->bss, sta->aid);
+				bss_tim_set(tx->local, tx->sdata->bss,
+				            sta->aid);
 		}
 		pkt_data = (struct ieee80211_tx_packet_data *)tx->skb->cb;
 		pkt_data->jiffies = jiffies;
@@ -1146,7 +1153,8 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 	int ret, i;
 
 	if (skb) {
-		ieee80211_dump_frame(local->mdev->name, "TX to low-level driver", skb);
+		ieee80211_dump_frame(local->mdev->name,
+		                     "TX to low-level driver", skb);
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
@@ -1170,7 +1178,8 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 						IEEE80211_TXCTL_RATE_CTRL_PROBE;
 				else
 					control->flags &=
-						~IEEE80211_TXCTL_RATE_CTRL_PROBE;
+						~IEEE80211_TXCTL_RATE_CTRL_PROBE
+					;
 			}
 
 			ieee80211_dump_frame(local->mdev->name,
@@ -1783,7 +1792,8 @@ struct sk_buff * ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
 		rate = rate_control_get_rate(local, local->mdev, skb, &extra);
 		if (!rate) {
 			if (net_ratelimit()) {
-				printk(KERN_DEBUG "%s: ieee80211_beacon_get: no rate "
+				printk(KERN_DEBUG
+				       "%s: ieee80211_beacon_get: no rate "
 				       "found\n", local->mdev->name);
 			}
 			dev_kfree_skb(skb);
@@ -1835,7 +1845,8 @@ EXPORT_SYMBOL(ieee80211_rts_duration);
 
 __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 				    size_t frame_len,
-				    const struct ieee80211_tx_control *frame_txctl)
+				    const struct ieee80211_tx_control
+					*frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
@@ -1885,7 +1896,8 @@ void ieee80211_ctstoself_get(struct ieee80211_hw *hw,
 
 	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS;
 	cts->frame_control = cpu_to_le16(fctl);
-	cts->duration = ieee80211_ctstoself_duration(hw, frame_len, frame_txctl);
+	cts->duration = ieee80211_ctstoself_duration(hw, frame_len,
+			                             frame_txctl);
 	memcpy(cts->ra, hdr->addr1, sizeof(cts->ra));
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_get);
@@ -2942,10 +2954,12 @@ ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
 		/* Use MoreData flag to indicate whether there are more
 		 * buffered frames for this STA */
 		if (no_pending_pkts) {
-			hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
+			hdr->frame_control &=
+				cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
 			rx->sta->flags &= ~WLAN_STA_TIM;
 		} else
-			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+			hdr->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 
 		dev_queue_xmit(skb);
 
@@ -2954,7 +2968,8 @@ ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
 				rx->local->ops->set_tim(local_to_hw(rx->local),
 						       rx->sta->aid, 0);
 			if (rx->sdata->bss)
-				bss_tim_clear(rx->local, rx->sdata->bss, rx->sta->aid);
+				bss_tim_clear(rx->local, rx->sdata->bss,
+					rx->sta->aid);
 		}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	} else if (!rx->u.rx.sent_ps_buffered) {
@@ -3040,7 +3055,8 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 		f_hdr = (struct ieee80211_hdr *) entry->skb_list.next->data;
 		f_fc = le16_to_cpu(f_hdr->frame_control);
 
-		if ((fc & IEEE80211_FCTL_FTYPE) != (f_fc & IEEE80211_FCTL_FTYPE) ||
+		if ((fc & IEEE80211_FCTL_FTYPE) !=
+		    (f_fc & IEEE80211_FCTL_FTYPE) ||
 		    compare_ether_addr(hdr->addr1, f_hdr->addr1) != 0 ||
 		    compare_ether_addr(hdr->addr2, f_hdr->addr2) != 0)
 			continue;
@@ -3231,7 +3247,8 @@ ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 	 */
 	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
-		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
+		       (rx->fc & IEEE80211_FCTL_STYPE) ==
+		        IEEE80211_STYPE_PSPOLL)) &&
 		     rx->sdata->type != IEEE80211_IF_TYPE_IBSS &&
 		     (!rx->sta || !(rx->sta->flags & WLAN_STA_ASSOC)))) {
 		if ((!(rx->fc & IEEE80211_FCTL_FROMDS) &&
@@ -3445,7 +3462,8 @@ ieee80211_rx_h_802_1x_pae(struct ieee80211_txrx_data *rx)
 
 	if (unlikely(rx->sdata->ieee802_1x &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
+		     (rx->fc & IEEE80211_FCTL_STYPE) !=
+		      IEEE80211_STYPE_NULLFUNC &&
 		     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)) &&
 		     !ieee80211_is_eapol(rx->skb))) {
 #ifdef CONFIG_MAC80211_DEBUG
@@ -3472,7 +3490,8 @@ ieee80211_rx_h_drop_unencrypted(struct ieee80211_txrx_data *rx)
 	/* Drop unencrypted frames if key is set. */
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
+		     (rx->fc & IEEE80211_FCTL_STYPE) !=
+		      IEEE80211_STYPE_NULLFUNC &&
 		     (rx->key || rx->sdata->drop_unencrypted) &&
 		     (rx->sdata->eapol == 0 ||
 		      !ieee80211_is_eapol(rx->skb)))) {
@@ -3537,7 +3556,8 @@ ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
 			local->scan.rx_beacon++;
 			/* Need to trim FCS here because it is normally
 			 * removed only after this passive scan handler. */
-			if ((rx->local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) &&
+			if ((rx->local->hw.flags &
+			     IEEE80211_HW_RX_INCLUDES_FCS) &&
 			    rx->skb->len > FCS_LEN)
 				skb_trim(rx->skb, rx->skb->len - FCS_LEN);
 
@@ -3800,8 +3820,9 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 						continue;
 					rx.u.rx.ra_match = 0;
 				} else if (!multicast &&
-					   compare_ether_addr(sdata->dev->dev_addr,
-							      hdr->addr1) != 0) {
+					   compare_ether_addr(
+						sdata->dev->dev_addr,
+						hdr->addr1) != 0) {
 					if (!sdata->promisc)
 						continue;
 					rx.u.rx.ra_match = 0;
@@ -3816,22 +3837,27 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 						continue;
 					rx.u.rx.ra_match = 0;
 				} else if (!multicast &&
-					   compare_ether_addr(sdata->dev->dev_addr,
-							      hdr->addr1) != 0) {
+					   compare_ether_addr(
+						sdata->dev->dev_addr,
+						hdr->addr1) != 0) {
 					if (!sdata->promisc)
 						continue;
 					rx.u.rx.ra_match = 0;
 				} else if (!sta)
 					sta = rx.sta =
-						ieee80211_ibss_add_sta(local->mdev,
-								       skb, bssid,
-								       hdr->addr2);
-						/* FIXME: call with sdata->dev */
+						ieee80211_ibss_add_sta(
+							local->mdev,
+							skb, bssid,
+							hdr->addr2);
+						/* FIXME: call with
+						 * sdata->dev
+						 */
 				break;
 			case IEEE80211_IF_TYPE_AP:
 				if (!bssid) {
-					if (compare_ether_addr(sdata->dev->dev_addr,
-							       hdr->addr1) != 0)
+					if (compare_ether_addr(
+						sdata->dev->dev_addr,
+						hdr->addr1) != 0)
 						continue;
 				} else if (!ieee80211_bssid_match(bssid,
 							sdata->dev->dev_addr)) {
@@ -3847,7 +3873,8 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 				break;
 			case IEEE80211_IF_TYPE_WDS:
 				if (bssid ||
-				    (rx.fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+				    (rx.fc & IEEE80211_FCTL_FTYPE) !=
+				     IEEE80211_FTYPE_DATA)
 					continue;
 				if (compare_ether_addr(sdata->u.wds.remote_addr,
 						       hdr->addr2) != 0)
@@ -3859,9 +3886,11 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 				skb_new = skb_copy(skb, GFP_ATOMIC);
 				if (!skb_new) {
 					if (net_ratelimit())
-						printk(KERN_DEBUG "%s: failed to copy "
+						printk(KERN_DEBUG
+						       "%s: failed to copy "
 						       "multicast frame for %s",
-						       local->mdev->name, prev->dev->name);
+						       local->mdev->name,
+						       prev->dev->name);
 					continue;
 				}
 				rx.skb = skb_new;
@@ -4149,9 +4178,12 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	pkt_data->ifindex = control->ifindex;
 	pkt_data->mgmt_iface = (control->type == IEEE80211_IF_TYPE_MGMT);
-	pkt_data->req_tx_status = !!(control->flags & IEEE80211_TXCTL_REQ_TX_STATUS);
-	pkt_data->do_not_encrypt = !!(control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT);
-	pkt_data->requeue = !!(control->flags & IEEE80211_TXCTL_REQUEUE);
+	pkt_data->req_tx_status = !!(control->flags &
+				     IEEE80211_TXCTL_REQ_TX_STATUS);
+	pkt_data->do_not_encrypt = !!(control->flags &
+				      IEEE80211_TXCTL_DO_NOT_ENCRYPT);
+	pkt_data->requeue = !!(control->flags &
+			       IEEE80211_TXCTL_REQUEUE);
 	pkt_data->queue = control->queue;
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
@@ -4223,7 +4255,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 				 * that this TX packet failed because of that.
 				 */
 				status->excessive_retries = 0;
-				status->flags |= IEEE80211_TX_STATUS_TX_FILTERED;
+				status->flags |=
+					IEEE80211_TX_STATUS_TX_FILTERED;
 			}
 			sta_info_put(sta);
 		}
@@ -4254,9 +4287,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 							  &status->control);
 				skb_queue_tail(&sta->tx_filtered, skb);
 			} else if (!(sta->flags & WLAN_STA_PS) &&
-				   !(status->control.flags & IEEE80211_TXCTL_REQUEUE)) {
+				   !(status->control.flags &
+				     IEEE80211_TXCTL_REQUEUE)) {
 				/* Software retry the packet once */
-				status->control.flags |= IEEE80211_TXCTL_REQUEUE;
+				status->control.flags |=
+					IEEE80211_TXCTL_REQUEUE;
 				ieee80211_remove_tx_extra(local, sta->key,
 							  skb,
 							  &status->control);

-- 
