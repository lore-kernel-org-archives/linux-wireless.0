Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762101AbXHCVnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 17:43:09 -0400
Subject: [PATCH] mac80211: allow drivers to indicate failed FCS/PLCP  checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 23:44:35 +0200
Message-Id: <1186177475.13315.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows drivers to indicate bad FCS/PLCP CRC to the stack and
have the stack drop packets like that except for monitor interfaces.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Compiles, but otherwise untested. Patch against Jiri's tree, applies to
John's tree (with some fuzz) if you change rx.c to ieee80211.c in the
patch.

 include/net/mac80211.h |    2 ++
 net/mac80211/rx.c      |   21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

--- mac80211.orig/include/net/mac80211.h	2007-08-03 23:06:33.357869508 +0200
+++ mac80211/include/net/mac80211.h	2007-08-03 23:10:01.267869508 +0200
@@ -241,6 +241,8 @@ struct ieee80211_rx_status {
 #define RX_FLAG_MMIC_ERROR	(1<<0)
 #define RX_FLAG_DECRYPTED	(1<<1)
 #define RX_FLAG_RADIOTAP	(1<<2)
+#define RX_FLAG_FAILED_FCS_CRC	(1<<3)
+#define RX_FLAG_FAILED_PLCP_CRC	(1<<4)
 	int flag;
 };
 
--- mac80211.orig/net/mac80211/rx.c	2007-08-03 23:06:54.187869508 +0200
+++ mac80211/net/mac80211/rx.c	2007-08-03 23:39:41.717869508 +0200
@@ -155,6 +155,7 @@ ieee80211_rx_monitor(struct net_device *
 		__le16 chan_freq;
 		__le16 chan_flags;
 		u8 antsignal;
+		__le16 rx_flags;
 	} __attribute__ ((packed)) *rthdr;
 
 	skb->dev = dev;
@@ -179,12 +180,21 @@ ieee80211_rx_monitor(struct net_device *
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
@@ -212,6 +222,15 @@ ieee80211_rx_h_monitor(struct ieee80211_
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
 


