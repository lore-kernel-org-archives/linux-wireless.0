Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760846AbXHOP0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 11:26:35 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ILKlT-0002vH-ES
	for linux-wireless@vger.kernel.org; Wed, 15 Aug 2007 16:26:33 +0100
Message-Id: <20070815152657.809571000@sipsolutions.net>
References: <20070815152557.221351000@sipsolutions.net>
Date: Wed, 15 Aug 2007 17:25:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: allow drivers to indicate failed FCS/PLCP  checksum
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows drivers to indicate bad FCS/PLCP CRC to the stack and
have the stack drop packets like that except for monitor interfaces.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/rx.c      |   21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 15:26:31.346516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 15:27:03.766516958 +0200
@@ -241,6 +241,8 @@ struct ieee80211_rx_status {
 #define RX_FLAG_MMIC_ERROR	(1<<0)
 #define RX_FLAG_DECRYPTED	(1<<1)
 #define RX_FLAG_RADIOTAP	(1<<2)
+#define RX_FLAG_FAILED_FCS_CRC	(1<<3)
+#define RX_FLAG_FAILED_PLCP_CRC	(1<<4)
 	int flag;
 };
 
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 15:26:31.426516958 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-15 15:27:03.766516958 +0200
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
 

-- 

