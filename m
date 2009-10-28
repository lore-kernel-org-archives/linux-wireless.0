Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682AbZJ1I71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 04:59:27 -0400
Subject: [PATCH] mac80211: fix radiotap header generation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bruno Randolf <br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 09:58:52 +0100
Message-ID: <1256720333.4237.106.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In

  commit 601ae7f25aea58f208a7f640f6174aac0652403a
  Author: Bruno Randolf <br1@einfach.org>
  Date:   Thu May 8 19:22:43 2008 +0200

      mac80211: make rx radiotap header more flexible

code was added that tried to align the radiotap header
position in memory based on the radiotap header length.
Quite obviously, that is completely useless.

Instead of trying to do that, use unaligned accesses
to generate the radiotap header. To properly do that,
we also need to mark struct ieee80211_radiotap_header
packed, but that is fine since it's already packed
(and it should be marked packed anyway since its a
wire format).

Cc: Bruno Randolf <br1@einfach.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I'm not sure it should be sent to stable, it only affects platforms that
don't do unaligned accesses well.

 include/net/ieee80211_radiotap.h |    2 +-
 net/mac80211/rx.c                |   26 ++++++++++++--------------
 2 files changed, 13 insertions(+), 15 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-10-28 08:43:27.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-10-28 08:58:24.000000000 +0100
@@ -95,10 +95,6 @@ ieee80211_rx_radiotap_len(struct ieee802
 	if (len & 1) /* padding for RX_FLAGS if necessary */
 		len++;
 
-	/* make sure radiotap starts at a naturally aligned address */
-	if (len % 8)
-		len = roundup(len, 8);
-
 	return len;
 }
 
@@ -116,6 +112,7 @@ ieee80211_add_rx_radiotap_header(struct 
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_radiotap_header *rthdr;
 	unsigned char *pos;
+	u16 rx_flags = 0;
 
 	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
 	memset(rthdr, 0, rtap_len);
@@ -134,7 +131,7 @@ ieee80211_add_rx_radiotap_header(struct 
 
 	/* IEEE80211_RADIOTAP_TSFT */
 	if (status->flag & RX_FLAG_TSFT) {
-		*(__le64 *)pos = cpu_to_le64(status->mactime);
+		put_unaligned_le64(status->mactime, pos);
 		rthdr->it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
 		pos += 8;
@@ -166,17 +163,17 @@ ieee80211_add_rx_radiotap_header(struct 
 	pos++;
 
 	/* IEEE80211_RADIOTAP_CHANNEL */
-	*(__le16 *)pos = cpu_to_le16(status->freq);
+	put_unaligned_le16(status->freq, pos);
 	pos += 2;
 	if (status->band == IEEE80211_BAND_5GHZ)
-		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_OFDM |
-					     IEEE80211_CHAN_5GHZ);
+		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
+				   pos);
 	else if (rate->flags & IEEE80211_RATE_ERP_G)
-		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_OFDM |
-					     IEEE80211_CHAN_2GHZ);
+		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
+				   pos);
 	else
-		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_CCK |
-					     IEEE80211_CHAN_2GHZ);
+		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
+				   pos);
 	pos += 2;
 
 	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
@@ -205,10 +202,11 @@ ieee80211_add_rx_radiotap_header(struct 
 
 	/* IEEE80211_RADIOTAP_RX_FLAGS */
 	/* ensure 2 byte alignment for the 2 byte field as required */
-	if ((pos - (unsigned char *)rthdr) & 1)
+	if ((pos - (u8 *)rthdr) & 1)
 		pos++;
 	if (status->flag & RX_FLAG_FAILED_PLCP_CRC)
-		*(__le16 *)pos |= cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADPLCP);
+		rx_flags |= IEEE80211_RADIOTAP_F_RX_BADPLCP;
+	put_unaligned_le16(rx_flags, pos);
 	pos += 2;
 }
 
--- wireless-testing.orig/include/net/ieee80211_radiotap.h	2009-10-28 08:46:35.000000000 +0100
+++ wireless-testing/include/net/ieee80211_radiotap.h	2009-10-28 08:51:49.000000000 +0100
@@ -80,7 +80,7 @@ struct ieee80211_radiotap_header {
 				 * Additional extensions are made
 				 * by setting bit 31.
 				 */
-};
+} __packed;
 
 /* Name                                 Data type    Units
  * ----                                 ---------    -----


