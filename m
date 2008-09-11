Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYIKWqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 18:46:43 -0400
Subject: [PATCH v2] mac80211: fix virtual interfaces vs. injection
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221172545.5956.7.camel@johannes.berg> (sfid-20080912_003625_890683_38C8ADDA)
References: <1221172545.5956.7.camel@johannes.berg>
	 (sfid-20080912_003625_890683_38C8ADDA)
Content-Type: text/plain
Date: Fri, 12 Sep 2008 00:46:07 +0200
Message-Id: <1221173167.5956.16.camel@johannes.berg> (sfid-20080912_004647_949138_0EDBD3E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, virtual interface pointers passed to drivers might be
from monitor interfaces and as such completely uninitialised
because we do not tell the driver about monitor interfaces when
those are created. Instead of passing them, we should therefore
indicate to the driver that there is no information; do that by
passing a NULL value and adjust drivers to cope with it.

As a result, some mac80211 API functions also need to cope with
a NULL vif pointer so drivers can still call them unconditionally.

Also, when injecting frames we really don't want to pass NULL all
the time, if we know we are the source address of a frame and have
a local interface for that address, we can to use that interface.
This also helps with processing the frame correctly for that
interface which will help the 802.11w implementation. It's not
entirely correct for VLANs or WDS interfaces because there the MAC
address isn't unique, but it's already a lot better than what we
do now.

Finally, when injecting without a matching local interface, don't
assign sequence numbers at all.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
waiting for the compile to finish (just in case it doesn't) is often
useful... need sleep!

 drivers/net/wireless/mac80211_hwsim.c     |    3 -
 drivers/net/wireless/rt2x00/rt2x00queue.c |   21 ++++++---
 include/net/mac80211.h                    |    1 
 net/mac80211/tx.c                         |   64 ++++++++++++++++++++++++++++--
 net/mac80211/util.c                       |   37 +++++++++++------
 5 files changed, 101 insertions(+), 25 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-09-12 00:27:19.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-12 00:45:13.000000000 +0200
@@ -330,6 +330,7 @@ struct ieee80211_tx_info {
 
 	union {
 		struct {
+			/* NB: vif can be NULL for injected frames */
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
 			struct ieee80211_sta *sta;
--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-09-12 00:27:04.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-09-12 00:45:15.000000000 +0200
@@ -258,7 +258,8 @@ static int mac80211_hwsim_tx(struct ieee
 
 	txi = IEEE80211_SKB_CB(skb);
 
-	hwsim_check_magic(txi->control.vif);
+	if (txi->control.vif)
+		hwsim_check_magic(txi->control.vif);
 	if (txi->control.sta)
 		hwsim_check_sta_magic(txi->control.sta);
 
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00queue.c	2008-09-12 00:27:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00queue.c	2008-09-12 00:27:22.000000000 +0200
@@ -155,7 +155,6 @@ static void rt2x00queue_create_tx_descri
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
-	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
 	struct ieee80211_rate *rate =
 	    ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
@@ -278,16 +277,22 @@ static void rt2x00queue_create_tx_descri
 	 * sequence counter given by mac80211.
 	 */
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		spin_lock_irqsave(&intf->seqlock, irqflags);
+		if (likely(tx_info->control.vif)) {
+			struct rt2x00_intf *intf;
 
-		if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
-			intf->seqno += 0x10;
-		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
+			intf = vif_to_intf(tx_info->control.vif);
 
-		spin_unlock_irqrestore(&intf->seqlock, irqflags);
+			spin_lock_irqsave(&intf->seqlock, irqflags);
 
-		__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
+			if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
+				intf->seqno += 0x10;
+			hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+			hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
+
+			spin_unlock_irqrestore(&intf->seqlock, irqflags);
+
+			__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
+		}
 	}
 
 	/*
--- everything.orig/net/mac80211/tx.c	2008-09-12 00:27:19.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-12 00:45:23.000000000 +0200
@@ -624,7 +624,14 @@ ieee80211_tx_h_sequence(struct ieee80211
 	u8 *qc;
 	int tid;
 
-	/* only for injected frames */
+	/*
+	 * Packet injection may want to control the sequence
+	 * number, if we have no matching interface then we
+	 * neither assign one ourselves nor ask the driver to.
+	 */
+	if (unlikely(!info->control.vif))
+		return TX_CONTINUE;
+
 	if (unlikely(ieee80211_is_ctl(hdr->frame_control)))
 		return TX_CONTINUE;
 
@@ -849,7 +856,6 @@ __ieee80211_parse_tx_radiotap(struct iee
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
 	skb->do_not_encrypt = 1;
-	info->flags |= IEEE80211_TX_CTL_INJECTED;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
 	/*
@@ -981,7 +987,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 	/* process and remove the injection radiotap header */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
+	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED)) {
 		if (__ieee80211_parse_tx_radiotap(tx, skb) == TX_DROP)
 			return TX_DROP;
 
@@ -1300,6 +1306,11 @@ int ieee80211_master_start_xmit(struct s
 	struct ieee80211_sub_if_data *osdata;
 	int headroom;
 	bool may_encrypt;
+	enum {
+		NOT_MONITOR,
+		FOUND_SDATA,
+		UNKNOWN_ADDRESS,
+	} monitor_iface = NOT_MONITOR;
 	int ret;
 
 	if (skb->iif)
@@ -1335,6 +1346,50 @@ int ieee80211_master_start_xmit(struct s
 				IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
 							     fwded_frames);
 		}
+	} else if (unlikely(osdata->vif.type == NL80211_IFTYPE_MONITOR)) {
+		struct ieee80211_sub_if_data *sdata;
+		struct ieee80211_local *local = osdata->local;
+		struct ieee80211_hdr *hdr;
+		int hdrlen;
+		u16 len_rthdr;
+
+		info->flags |= IEEE80211_TX_CTL_INJECTED;
+		monitor_iface = UNKNOWN_ADDRESS;
+
+		len_rthdr = ieee80211_get_radiotap_len(skb->data);
+		hdr = (struct ieee80211_hdr *)skb->data + len_rthdr;
+		hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+		/* check the header is complete in the frame */
+		if (likely(skb->len >= len_rthdr + hdrlen)) {
+			/*
+			 * We process outgoing injected frames that have a
+			 * local address we handle as though they are our
+			 * own frames.
+			 * This code here isn't entirely correct, the local
+			 * MAC address is not necessarily enough to find
+			 * the interface to use; for that proper VLAN/WDS
+			 * support we will need a different mechanism.
+			 */
+
+			rcu_read_lock();
+			list_for_each_entry_rcu(sdata, &local->interfaces,
+						list) {
+				if (!netif_running(sdata->dev))
+					continue;
+				if (compare_ether_addr(sdata->dev->dev_addr,
+						       hdr->addr2)) {
+					dev_hold(sdata->dev);
+					dev_put(odev);
+					odev = osdata->dev;
+					osdata = sdata;
+					skb->iif = sdata->dev->ifindex;
+					monitor_iface = FOUND_SDATA;
+					break;
+				}
+			}
+			rcu_read_unlock();
+		}
 	}
 
 	may_encrypt = !skb->do_not_encrypt;
@@ -1355,7 +1410,8 @@ int ieee80211_master_start_xmit(struct s
 		osdata = container_of(osdata->bss,
 				      struct ieee80211_sub_if_data,
 				      u.ap);
-	info->control.vif = &osdata->vif;
+	if (likely(monitor_iface != UNKNOWN_ADDRESS))
+		info->control.vif = &osdata->vif;
 	ret = ieee80211_tx(odev, skb);
 	dev_put(odev);
 
--- everything.orig/net/mac80211/util.c	2008-09-12 00:27:04.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-12 00:27:22.000000000 +0200
@@ -231,16 +231,21 @@ __le16 ieee80211_generic_frame_duration(
 					struct ieee80211_rate *rate)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_sub_if_data *sdata;
 	u16 dur;
 	int erp;
+	bool short_preamble = false;
 
 	erp = 0;
-	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
-		erp = rate->flags & IEEE80211_RATE_ERP_G;
+	if (vif) {
+		sdata = vif_to_sdata(vif);
+		short_preamble = sdata->bss_conf.use_short_preamble;
+		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+			erp = rate->flags & IEEE80211_RATE_ERP_G;
+	}
 
 	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate, erp,
-				       sdata->bss_conf.use_short_preamble);
+				       short_preamble);
 
 	return cpu_to_le16(dur);
 }
@@ -252,7 +257,7 @@ __le16 ieee80211_rts_duration(struct iee
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
 	int erp;
 	u16 dur;
@@ -260,13 +265,17 @@ __le16 ieee80211_rts_duration(struct iee
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	short_preamble = sdata->bss_conf.use_short_preamble;
+	short_preamble = false;
 
 	rate = &sband->bitrates[frame_txctl->control.rts_cts_rate_idx];
 
 	erp = 0;
-	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
-		erp = rate->flags & IEEE80211_RATE_ERP_G;
+	if (vif) {
+		sdata = vif_to_sdata(vif);
+		short_preamble = sdata->bss_conf.use_short_preamble;
+		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+			erp = rate->flags & IEEE80211_RATE_ERP_G;
+	}
 
 	/* CTS duration */
 	dur = ieee80211_frame_duration(local, 10, rate->bitrate,
@@ -289,7 +298,7 @@ __le16 ieee80211_ctstoself_duration(stru
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
 	int erp;
 	u16 dur;
@@ -297,12 +306,16 @@ __le16 ieee80211_ctstoself_duration(stru
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	short_preamble = sdata->bss_conf.use_short_preamble;
+	short_preamble = false;
 
 	rate = &sband->bitrates[frame_txctl->control.rts_cts_rate_idx];
 	erp = 0;
-	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
-		erp = rate->flags & IEEE80211_RATE_ERP_G;
+	if (vif) {
+		sdata = vif_to_sdata(vif);
+		short_preamble = sdata->bss_conf.use_short_preamble;
+		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+			erp = rate->flags & IEEE80211_RATE_ERP_G;
+	}
 
 	/* Data frame duration */
 	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate,


