Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbXIFNpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:45:54 -0400
Message-Id: <20070905234622.072853000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 02/21] mac80211: allow drivers to indicate failed FCS/PLCP  checksum
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows drivers to indicate bad FCS/PLCP CRC to the stack and
have the stack drop packets like that except for monitor interfaces.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Changes since v1:
 * filter bad frames early in the RX code and don't count
   them nor try to get a STA for them

 include/net/mac80211.h |    6 ++++++
 net/mac80211/rx.c      |   32 +++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-09-06 01:35:00.204453431 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-06 01:35:11.644453431 +0200
@@ -156,6 +156,8 @@ ieee80211_rx_monitor(struct net_device *
 		__le16 chan_freq;
 		__le16 chan_flags;
 		u8 antsignal;
+		u8 padding_for_rxflags;
+		__le16 rx_flags;
 	} __attribute__ ((packed)) *rthdr;
 
 	skb->dev = dev;
@@ -180,12 +182,21 @@ ieee80211_rx_monitor(struct net_device *
 		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
 			    (1 << IEEE80211_RADIOTAP_RATE) |
 			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
-			    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL));
+			    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL) |
+			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
 	rthdr->flags = local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS ?
 		       IEEE80211_RADIOTAP_F_FCS : 0;
+
+	/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
+	rthdr->rx_flags = 0;
+	if (status->flag &
+	    (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
+		rthdr->rx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
+
 	rate = ieee80211_get_rate(local, status->phymode, status->rate);
 	if (rate)
 		rthdr->rate = rate->rate / 5;
+
 	rthdr->chan_freq = cpu_to_le16(status->freq);
 	rthdr->chan_flags =
 		status->phymode == MODE_IEEE80211A ?
@@ -213,6 +224,15 @@ ieee80211_rx_h_monitor(struct ieee80211_
 		return TXRX_QUEUED;
 	}
 
+	/*
+	 * Drop frames with failed FCS/PLCP checksums here, they are only
+	 * relevant for monitor mode, the rest of the stack should never
+	 * see them.
+	 */
+	if (rx->u.rx.status->flag &
+	    (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
+		return TXRX_DROP;
+
 	if (rx->u.rx.status->flag & RX_FLAG_RADIOTAP)
 		skb_pull(rx->skb, ieee80211_get_radiotap_len(rx->skb->data));
 
@@ -1505,6 +1525,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
+	int bogon;
 
 	if (status->flag & RX_FLAG_RADIOTAP) {
 		radiotap_len = ieee80211_get_radiotap_len(skb->data);
@@ -1525,10 +1546,15 @@ void __ieee80211_rx(struct ieee80211_hw 
 	rx.u.rx.status = status;
 	rx.fc = skb->len >= 2 ? le16_to_cpu(hdr->frame_control) : 0;
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
-	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
+
+	bogon = status->flag & (RX_FLAG_FAILED_FCS_CRC |
+				RX_FLAG_FAILED_PLCP_CRC);
+
+	if (!bogon && (type == IEEE80211_FTYPE_DATA ||
+		       type == IEEE80211_FTYPE_MGMT))
 		local->dot11ReceivedFragmentCount++;
 
-	if (skb->len >= 16) {
+	if (!bogon && skb->len >= 16) {
 		sta = rx.sta = sta_info_get(local, hdr->addr2);
 		if (sta) {
 			rx.dev = rx.sta->dev;
--- wireless-dev.orig/include/net/mac80211.h	2007-09-06 01:35:00.244453431 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-06 01:35:11.644453431 +0200
@@ -235,6 +235,10 @@ struct ieee80211_tx_control {
  * @RX_FLAG_IV_STRIPPED: The IV/ICV are stripped from this frame.
  *	If this flag is set, the stack cannot do any replay detection
  *	hence the driver or hardware will have to do that.
+ * @RX_FLAG_FAILED_FCS_CRC: Set this flag if the FCS check failed on
+ *	the frame.
+ * @RX_FLAG_FAILED_PLCP_CRC: Set this flag if the PCLP check failed on
+ *	the frame.
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -242,6 +246,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_RADIOTAP	= 1<<2,
 	RX_FLAG_MMIC_STRIPPED	= 1<<3,
 	RX_FLAG_IV_STRIPPED	= 1<<4,
+	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
+	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
 };
 
 /**

-- 

