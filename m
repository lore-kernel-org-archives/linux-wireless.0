Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZCMLww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 07:52:52 -0400
Subject: [PATCH] wireless: radiotap updates
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 12:52:10 +0100
Message-Id: <1236945130.5235.35.camel@johannes.local> (sfid-20090313_125256_268432_1CA91841)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radiotap was updated to include a "bad PLCP" flag and standardise
the "bad FCS" flag in the "flags" rather than "RX flags" field,
this patch updates Linux to that standard.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/libertas/radiotap.h |   10 ----------
 drivers/net/wireless/libertas/rx.c       |   12 ++----------
 include/net/ieee80211_radiotap.h         |    4 +++-
 net/mac80211/rx.c                        |    7 ++++---
 4 files changed, 9 insertions(+), 24 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/libertas/radiotap.h	2009-02-11 18:00:53.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/radiotap.h	2009-03-13 12:49:09.000000000 +0100
@@ -33,22 +33,12 @@ struct rx_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
 	u8 flags;
 	u8 rate;
-	u16 chan_freq;
-	u16 chan_flags;
-	u8 antenna;
 	u8 antsignal;
-	u16 rx_flags;
-#if 0
-	u8 pad[IEEE80211_RADIOTAP_HDRLEN - 18];
-#endif
 } __attribute__ ((packed));
 
 #define RX_RADIOTAP_PRESENT (			\
 	(1 << IEEE80211_RADIOTAP_FLAGS) |	\
 	(1 << IEEE80211_RADIOTAP_RATE) |	\
-	(1 << IEEE80211_RADIOTAP_CHANNEL) |	\
-	(1 << IEEE80211_RADIOTAP_ANTENNA) |	\
 	(1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL) |\
-	(1 << IEEE80211_RADIOTAP_RX_FLAGS) |	\
 	0)
 
--- wireless-testing.orig/include/net/ieee80211_radiotap.h	2009-02-11 18:00:53.000000000 +0100
+++ wireless-testing/include/net/ieee80211_radiotap.h	2009-03-13 12:49:09.000000000 +0100
@@ -230,8 +230,10 @@ enum ieee80211_radiotap_type {
 						 * 802.11 header and payload
 						 * (to 32-bit boundary)
 						 */
+#define IEEE80211_RADIOTAP_F_BADFCS	0x40	/* bad FCS */
+
 /* For IEEE80211_RADIOTAP_RX_FLAGS */
-#define IEEE80211_RADIOTAP_F_RX_BADFCS	0x0001	/* frame failed crc check */
+#define IEEE80211_RADIOTAP_F_RX_BADPLCP	0x0002	/* frame has bad PLCP */
 
 /* For IEEE80211_RADIOTAP_TX_FLAGS */
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001	/* failed due to excessive
--- wireless-testing.orig/drivers/net/wireless/libertas/rx.c	2009-02-11 18:00:53.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/rx.c	2009-03-13 12:49:09.000000000 +0100
@@ -351,19 +351,11 @@ static int process_rxed_802_11_packet(st
 	radiotap_hdr.hdr.it_pad = 0;
 	radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
 	radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
-	/* unknown values */
-	radiotap_hdr.flags = 0;
-	radiotap_hdr.chan_freq = 0;
-	radiotap_hdr.chan_flags = 0;
-	radiotap_hdr.antenna = 0;
-	/* known values */
+	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
+		radiotap_hdr.flags |= IEEE80211_RADIOTAP_F_BADFCS;
 	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
 	/* XXX must check no carryout */
 	radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
-	radiotap_hdr.rx_flags = 0;
-	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
-		radiotap_hdr.rx_flags |= IEEE80211_RADIOTAP_F_RX_BADFCS;
-	//memset(radiotap_hdr.pad, 0x11, IEEE80211_RADIOTAP_HDRLEN - 18);
 
 	/* chop the rxpd */
 	skb_pull(skb, sizeof(struct rxpd));
--- wireless-testing.orig/net/mac80211/rx.c	2009-02-17 22:07:37.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-03-13 12:49:09.000000000 +0100
@@ -142,6 +142,8 @@ ieee80211_add_rx_radiotap_header(struct 
 	/* IEEE80211_RADIOTAP_FLAGS */
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		*pos |= IEEE80211_RADIOTAP_F_FCS;
+	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
+		*pos |= IEEE80211_RADIOTAP_F_BADFCS;
 	if (status->flag & RX_FLAG_SHORTPRE)
 		*pos |= IEEE80211_RADIOTAP_F_SHORTPRE;
 	pos++;
@@ -204,9 +206,8 @@ ieee80211_add_rx_radiotap_header(struct 
 	/* ensure 2 byte alignment for the 2 byte field as required */
 	if ((pos - (unsigned char *)rthdr) & 1)
 		pos++;
-	/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
-	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
-		*(__le16 *)pos |= cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
+	if (status->flag & RX_FLAG_FAILED_PLCP_CRC)
+		*(__le16 *)pos |= cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADPLCP);
 	pos += 2;
 }
 


