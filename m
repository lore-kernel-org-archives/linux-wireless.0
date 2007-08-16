Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764147AbXHPOuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 10:50:23 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ILgg1-0002ZP-Df
	for linux-wireless@vger.kernel.org; Thu, 16 Aug 2007 15:50:21 +0100
Subject: [RFC 1/2 v2] mac80211: allow drivers to indicate failed FCS/PLCP   checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20070815152657.809571000@sipsolutions.net>
References: <20070815152557.221351000@sipsolutions.net>
	 <20070815152657.809571000@sipsolutions.net>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 16:53:06 +0200
Message-Id: <1187275986.23489.11.camel@johannes.berg>
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

 include/net/mac80211.h |    2 ++
 net/mac80211/rx.c      |   31 ++++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 16:48:43.296516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-16 16:51:20.173468950 +0200
@@ -241,6 +241,8 @@ struct ieee80211_rx_status {
 #define RX_FLAG_MMIC_ERROR	(1<<0)
 #define RX_FLAG_DECRYPTED	(1<<1)
 #define RX_FLAG_RADIOTAP	(1<<2)
+#define RX_FLAG_FAILED_FCS_CRC	(1<<3)
+#define RX_FLAG_FAILED_PLCP_CRC	(1<<4)
 	int flag;
 };
 
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 16:48:43.316516958 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-16 16:51:26.823468950 +0200
@@ -154,6 +154,7 @@ ieee80211_rx_monitor(struct net_device *
 		__le16 chan_freq;
 		__le16 chan_flags;
 		u8 antsignal;
+		__le16 rx_flags;
 	} __attribute__ ((packed)) *rthdr;
 
 	skb->dev = dev;
@@ -178,12 +179,21 @@ ieee80211_rx_monitor(struct net_device *
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
@@ -211,6 +221,15 @@ ieee80211_rx_h_monitor(struct ieee80211_
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
 
@@ -1465,6 +1484,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
+	int bogon;
 
 	if (status->flag & RX_FLAG_RADIOTAP) {
 		radiotap_len = ieee80211_get_radiotap_len(skb->data);
@@ -1479,10 +1499,15 @@ void __ieee80211_rx(struct ieee80211_hw 
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


