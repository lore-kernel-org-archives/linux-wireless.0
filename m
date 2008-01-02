Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34277 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYABSCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 13:02:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix rxheader channel parsing
Date: Wed, 2 Jan 2008 18:55:53 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Message-Id: <200801021855.53410.mb@bu3sch.de> (sfid-20080102_180210_079249_1959A337)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the parsing of the RX data header channel field.

The current code parses the header incorrectly and passes a wrong
channel number and frequency for each frame to mac80211.
The FIXMEs added by this patch don't matter for now as the code
where they live won't get executed anyway. They will be fixed later.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, as this is a bugfix, it should go into 2.6.24 if still possible.

Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2007-12-30 20:30:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2008-01-02 18:13:15.000000000 +0100
@@ -549,21 +549,32 @@ void b43_rx(struct b43_wldev *dev, struc
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
 	case B43_PHYTYPE_A:
 		status.phymode = MODE_IEEE80211A;
-		status.freq = chanid;
-		status.channel = b43_freq_to_channel_a(chanid);
-		break;
-	case B43_PHYTYPE_B:
-		status.phymode = MODE_IEEE80211B;
-		status.freq = chanid + 2400;
-		status.channel = b43_freq_to_channel_bg(chanid + 2400);
+		B43_WARN_ON(1);
+		/* FIXME: We don't really know which value the "chanid" contains.
+		 *        So the following assignment might be wrong. */
+		status.channel = chanid;
+		status.freq = b43_channel_to_freq_5ghz(status.channel);
 		break;
 	case B43_PHYTYPE_G:
 		status.phymode = MODE_IEEE80211G;
+		/* chanid is the radio channel cookie value as used
+		 * to tune the radio. */
 		status.freq = chanid + 2400;
-		status.channel = b43_freq_to_channel_bg(chanid + 2400);
+		status.channel = b43_freq_to_channel_2ghz(status.freq);
+		break;
+	case B43_PHYTYPE_N:
+		status.phymode = 0xDEAD /*FIXME MODE_IEEE80211N*/;
+		/* chanid is the SHM channel cookie. Which is the plain
+		 * channel number in b43. */
+		status.channel = chanid;
+		if (chanstat & B43_RX_CHAN_5GHZ)
+			status.freq = b43_freq_to_channel_5ghz(status.freq);
+		else
+			status.freq = b43_freq_to_channel_2ghz(status.freq);
 		break;
 	default:
 		B43_WARN_ON(1);
+		goto drop;
 	}
 
 	dev->stats.last_rx = jiffies;
Index: wireless-2.6/drivers/net/wireless/b43/xmit.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.h	2007-12-30 20:30:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.h	2008-01-02 16:42:24.000000000 +0100
@@ -142,49 +142,56 @@ struct b43_rxhdr_fw4 {
 } __attribute__ ((__packed__));
 
 /* PHY RX Status 0 */
-#define B43_RX_PHYST0_GAINCTL	0x4000	/* Gain Control */
-#define B43_RX_PHYST0_PLCPHCF	0x0200
-#define B43_RX_PHYST0_PLCPFV	0x0100
-#define B43_RX_PHYST0_SHORTPRMBL	0x0080	/* Received with Short Preamble */
+#define B43_RX_PHYST0_GAINCTL		0x4000 /* Gain Control */
+#define B43_RX_PHYST0_PLCPHCF		0x0200
+#define B43_RX_PHYST0_PLCPFV		0x0100
+#define B43_RX_PHYST0_SHORTPRMBL	0x0080 /* Received with Short Preamble */
 #define B43_RX_PHYST0_LCRS		0x0040
-#define B43_RX_PHYST0_ANT		0x0020	/* Antenna */
-#define B43_RX_PHYST0_UNSRATE	0x0010
+#define B43_RX_PHYST0_ANT		0x0020 /* Antenna */
+#define B43_RX_PHYST0_UNSRATE		0x0010
 #define B43_RX_PHYST0_CLIP		0x000C
 #define B43_RX_PHYST0_CLIP_SHIFT	2
-#define B43_RX_PHYST0_FTYPE		0x0003	/* Frame type */
-#define  B43_RX_PHYST0_CCK		0x0000	/* Frame type: CCK */
-#define  B43_RX_PHYST0_OFDM		0x0001	/* Frame type: OFDM */
-#define  B43_RX_PHYST0_PRE_N	0x0002	/* Pre-standard N-PHY frame */
-#define  B43_RX_PHYST0_STD_N	0x0003	/* Standard N-PHY frame */
+#define B43_RX_PHYST0_FTYPE		0x0003 /* Frame type */
+#define  B43_RX_PHYST0_CCK		0x0000 /* Frame type: CCK */
+#define  B43_RX_PHYST0_OFDM		0x0001 /* Frame type: OFDM */
+#define  B43_RX_PHYST0_PRE_N		0x0002 /* Pre-standard N-PHY frame */
+#define  B43_RX_PHYST0_STD_N		0x0003 /* Standard N-PHY frame */
 
 /* PHY RX Status 2 */
-#define B43_RX_PHYST2_LNAG		0xC000	/* LNA Gain */
+#define B43_RX_PHYST2_LNAG		0xC000 /* LNA Gain */
 #define B43_RX_PHYST2_LNAG_SHIFT	14
-#define B43_RX_PHYST2_PNAG		0x3C00	/* PNA Gain */
+#define B43_RX_PHYST2_PNAG		0x3C00 /* PNA Gain */
 #define B43_RX_PHYST2_PNAG_SHIFT	10
-#define B43_RX_PHYST2_FOFF		0x03FF	/* F offset */
+#define B43_RX_PHYST2_FOFF		0x03FF /* F offset */
 
 /* PHY RX Status 3 */
-#define B43_RX_PHYST3_DIGG		0x1800	/* DIG Gain */
+#define B43_RX_PHYST3_DIGG		0x1800 /* DIG Gain */
 #define B43_RX_PHYST3_DIGG_SHIFT	11
-#define B43_RX_PHYST3_TRSTATE	0x0400	/* TR state */
+#define B43_RX_PHYST3_TRSTATE		0x0400 /* TR state */
 
 /* MAC RX Status */
-#define B43_RX_MAC_BEACONSENT	0x00008000	/* Beacon send flag */
-#define B43_RX_MAC_KEYIDX		0x000007E0	/* Key index */
-#define B43_RX_MAC_KEYIDX_SHIFT	5
-#define B43_RX_MAC_DECERR		0x00000010	/* Decrypt error */
-#define B43_RX_MAC_DEC		0x00000008	/* Decryption attempted */
-#define B43_RX_MAC_PADDING		0x00000004	/* Pad bytes present */
-#define B43_RX_MAC_RESP		0x00000002	/* Response frame transmitted */
-#define B43_RX_MAC_FCSERR		0x00000001	/* FCS error */
+#define B43_RX_MAC_RXST_VALID		0x01000000 /* PHY RXST valid */
+#define B43_RX_MAC_TKIP_MICERR		0x00100000 /* TKIP MIC error */
+#define B43_RX_MAC_TKIP_MICATT		0x00080000 /* TKIP MIC attempted */
+#define B43_RX_MAC_AGGTYPE		0x00060000 /* Aggregation type */
+#define B43_RX_MAC_AGGTYPE_SHIFT	17
+#define B43_RX_MAC_AMSDU		0x00010000 /* A-MSDU mask */
+#define B43_RX_MAC_BEACONSENT		0x00008000 /* Beacon sent flag */
+#define B43_RX_MAC_KEYIDX		0x000007E0 /* Key index */
+#define B43_RX_MAC_KEYIDX_SHIFT		5
+#define B43_RX_MAC_DECERR		0x00000010 /* Decrypt error */
+#define B43_RX_MAC_DEC			0x00000008 /* Decryption attempted */
+#define B43_RX_MAC_PADDING		0x00000004 /* Pad bytes present */
+#define B43_RX_MAC_RESP			0x00000002 /* Response frame transmitted */
+#define B43_RX_MAC_FCSERR		0x00000001 /* FCS error */
 
 /* RX channel */
-#define B43_RX_CHAN_GAIN		0xFC00	/* Gain */
-#define B43_RX_CHAN_GAIN_SHIFT	10
-#define B43_RX_CHAN_ID		0x03FC	/* Channel ID */
-#define B43_RX_CHAN_ID_SHIFT	2
-#define B43_RX_CHAN_PHYTYPE		0x0003	/* PHY type */
+#define B43_RX_CHAN_40MHZ		0x1000 /* 40 Mhz channel width */
+#define B43_RX_CHAN_5GHZ		0x0800 /* 5 Ghz band */
+#define B43_RX_CHAN_ID			0x07F8 /* Channel ID */
+#define B43_RX_CHAN_ID_SHIFT		3
+#define B43_RX_CHAN_PHYTYPE		0x0007 /* PHY type */
+
 
 u8 b43_plcp_get_ratecode_cck(const u8 bitrate);
 u8 b43_plcp_get_ratecode_ofdm(const u8 bitrate);
Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-12-28 23:38:44.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2008-01-02 17:23:18.000000000 +0100
@@ -277,6 +277,8 @@ enum {
 #define B43_PHYTYPE_A			0x00
 #define B43_PHYTYPE_B			0x01
 #define B43_PHYTYPE_G			0x02
+#define B43_PHYTYPE_N			0x04
+#define B43_PHYTYPE_LP			0x05
 
 /* PHYRegisters */
 #define B43_PHY_ILT_A_CTRL		0x0072
Index: wireless-2.6/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.h	2007-12-28 23:38:43.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.h	2008-01-02 18:08:39.000000000 +0100
@@ -39,11 +39,11 @@
 #define PAD_BYTES(nr_bytes)		P4D_BYTES( __LINE__ , (nr_bytes))
 
 /* Lightweight function to convert a frequency (in Mhz) to a channel number. */
-static inline u8 b43_freq_to_channel_a(int freq)
+static inline u8 b43_freq_to_channel_5ghz(int freq)
 {
 	return ((freq - 5000) / 5);
 }
-static inline u8 b43_freq_to_channel_bg(int freq)
+static inline u8 b43_freq_to_channel_2ghz(int freq)
 {
 	u8 channel;
 
@@ -54,19 +54,13 @@ static inline u8 b43_freq_to_channel_bg(
 
 	return channel;
 }
-static inline u8 b43_freq_to_channel(struct b43_wldev *dev, int freq)
-{
-	if (dev->phy.type == B43_PHYTYPE_A)
-		return b43_freq_to_channel_a(freq);
-	return b43_freq_to_channel_bg(freq);
-}
 
 /* Lightweight function to convert a channel number to a frequency (in Mhz). */
-static inline int b43_channel_to_freq_a(u8 channel)
+static inline int b43_channel_to_freq_5ghz(u8 channel)
 {
 	return (5000 + (5 * channel));
 }
-static inline int b43_channel_to_freq_bg(u8 channel)
+static inline int b43_channel_to_freq_2ghz(u8 channel)
 {
 	int freq;
 
@@ -77,12 +71,6 @@ static inline int b43_channel_to_freq_bg
 
 	return freq;
 }
-static inline int b43_channel_to_freq(struct b43_wldev *dev, u8 channel)
-{
-	if (dev->phy.type == B43_PHYTYPE_A)
-		return b43_channel_to_freq_a(channel);
-	return b43_channel_to_freq_bg(channel);
-}
 
 static inline int b43_is_cck_rate(int rate)
 {
