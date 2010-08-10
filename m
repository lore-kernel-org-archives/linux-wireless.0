Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:52463 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab0HJOtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 10:49:39 -0400
From: Daniel Haid <d.haid@gogi.tv>
To: linux-wireless@vger.kernel.org
Subject: Re: Setting MCS rate on injected packets (includes patch)
Date: Tue, 10 Aug 2010 16:48:57 +0200
Cc: =?utf-8?q?Bj=C3=B6rn_Smedman?= <bjorn.smedman@venatech.se>
References: <201008082124.33033.d.haid@gogi.tv> <201008092149.14462.d.haid@gogi.tv> <AANLkTik_78KB4QV210TbTxFRveL-e7yPwsxL-DEizRcX@mail.gmail.com>
In-Reply-To: <AANLkTik_78KB4QV210TbTxFRveL-e7yPwsxL-DEizRcX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008101648.57684.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have still not been able to successfully inject packets with a
throughput >10Mbits/s. I have included the patch that I used.
I have combined two old patches that I found on this list.

Please tell me if this can even work in principle, or if I have
to make any changes.

I am injecting packets with libpcap and use the following headers:

static const uint8_t radiotap_header[] = {
        0x00, 0x00, // <-- radiotap version
        0x0e, 0x00, // <- radiotap header length
        0x06, 0x00, 0x0b, 0x00, // <-- bitmap
        0x00, // <-- flags
        0x00, // <-- rate
        0x00, // <-- rts retries
        0x01, // <-- data retries
        0x02, 0x01 // <-- mcs index, flags 1=40MHz 2=shortgi
};

static const uint8_t ieee_header[] = {
        0x88, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x11, 0x22, 0x33, 0x44, 0x55, 0x66,
        0x11, 0x22, 0x33, 0x44, 0x55, 0x66,
        0x00, 0x00,

        0x00, 0x00,
        0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x08, 0x00
};

I also tried different MCS indexes, and using the real mac-adresses instead, but never
am I able to get more than 10MBits/s throughput.

diff -ru a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.txt
--- a/Documentation/networking/mac80211-injection.txt	2010-08-09 23:30:51.375120261 +0200
+++ b/Documentation/networking/mac80211-injection.txt	2010-08-09 23:56:11.470652572 +0200
@@ -23,6 +23,17 @@
    IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
 			      current fragmentation threshold.
 
+ * IEEE80211_RADIOTAP_RATE: Transmit rate will be set to the requested value if
+			    it's available.  Rate control will not be used for
+			    the frame.
+
+ * IEEE80211_RADIOTAP_DATA_RETRIES: Retry count will be set to the requested
+				    value.  This parameter can only be used in
+				    conjunction with IEEE80211_RADIOTAP_RATE.
+
+ * IEEE80211_RADIOTAP_RATE_MCS: Transmit rate will be set to the requested MCS
+                                index.  Rate control will not be used for the
+                                frame.
 
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
diff -ru a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
--- a/include/net/ieee80211_radiotap.h	2010-08-09 23:29:56.819125364 +0200
+++ b/include/net/ieee80211_radiotap.h	2010-08-09 23:11:33.962618255 +0200
@@ -174,6 +174,11 @@
  *
  *     Number of rts retries a transmitted frame used.
  *
+ * IEEE80211_RADIOTAP_RATE_MCS       2 x u8          data, bitmap
+ *
+ *     First byte is the MCS index of the rate,
+ *     second one has flags about channel width and guard interval
+ *
  * IEEE80211_RADIOTAP_DATA_RETRIES      u8           data
  *
  *     Number of unicast retries a transmitted frame used.
@@ -198,6 +203,7 @@
 	IEEE80211_RADIOTAP_TX_FLAGS = 15,
 	IEEE80211_RADIOTAP_RTS_RETRIES = 16,
 	IEEE80211_RADIOTAP_DATA_RETRIES = 17,
+	IEEE80211_RADIOTAP_RATE_MCS = 19,
 
 	/* valid in every it_present bitmap, even vendor namespaces */
 	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
@@ -245,6 +251,10 @@
 #define IEEE80211_RADIOTAP_F_TX_CTS	0x0002	/* used cts 'protection' */
 #define IEEE80211_RADIOTAP_F_TX_RTS	0x0004	/* used rts/cts handshake */
 
+/* For IEEE80211_RADIOTAP_RATE_MCS */
+#define IEEE80211_RADIOTAP_RATE_MCS_40MHZ	0x01 /* 40 MHz channel width */
+#define IEEE80211_RADIOTAP_RATE_MCS_SHORT_GI	0x02 /* short guard interval */
+
 /* Ugly macro to convert literal channel numbers into their mhz equivalents
  * There are certianly some conditions that will break this (like feeding it '30')
  * but they shouldn't arise since nothing talks on channel 30. */
diff -ru a/include/net/mac80211.h b/include/net/mac80211.h
--- a/include/net/mac80211.h	2010-08-09 23:29:57.398627648 +0200
+++ b/include/net/mac80211.h	2010-08-09 23:59:45.182646922 +0200
@@ -287,6 +287,7 @@
  * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
  * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
  *	frame and selects the maximum number of streams that it can use.
+ * @IEEE80211_TX_CTL_RC_BYPASS: Don't use rate control on the frame.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -313,6 +314,7 @@
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
+	IEEE80211_TX_CTL_RC_BYPASS                 = BIT(25),
 };
 
 /**
@@ -1929,7 +1931,7 @@
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
  */
-#define IEEE80211_TX_STATUS_HEADROOM	13
+#define IEEE80211_TX_STATUS_HEADROOM	14
 
 /**
  * ieee80211_tx_status - transmit status callback
diff -ru a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
--- a/net/mac80211/ieee80211_i.h	2010-08-09 23:26:40.731120745 +0200
+++ b/net/mac80211/ieee80211_i.h	2010-08-09 23:13:27.235118320 +0200
@@ -1084,6 +1084,7 @@
 	u8 padding_for_rate;
 	__le16 tx_flags;
 	u8 data_retries;
+	u8 mcs; /*HT rates*/
 } __attribute__ ((packed));
 
 
diff -ru a/net/mac80211/rx.c b/net/mac80211/rx.c
--- a/net/mac80211/rx.c	2010-08-09 23:26:40.694618415 +0200
+++ b/net/mac80211/rx.c	2010-08-09 23:13:27.270630234 +0200
@@ -81,7 +81,8 @@
 		len += 8;
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
-
+	if (status->flag & RX_FLAG_HT)
+		len += 2;
 	if (len & 1) /* padding for RX_FLAGS if necessary */
 		len++;
 
@@ -137,19 +138,11 @@
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	if (status->flag & RX_FLAG_HT) {
-		/*
-		 * TODO: add following information into radiotap header once
-		 * suitable fields are defined for it:
-		 * - MCS index (status->rate_idx)
-		 * - HT40 (status->flag & RX_FLAG_40MHZ)
-		 * - short-GI (status->flag & RX_FLAG_SHORT_GI)
-		 */
+	rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+	if (status->flag & RX_FLAG_HT)
 		*pos = 0;
-	} else {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+	else
 		*pos = rate->bitrate / 5;
-	}
 	pos++;
 
 	/* IEEE80211_RADIOTAP_CHANNEL */
@@ -193,6 +186,20 @@
 		rx_flags |= IEEE80211_RADIOTAP_F_RX_BADPLCP;
 	put_unaligned_le16(rx_flags, pos);
 	pos += 2;
+
+	/* IEEE80211_RADIOTAP_RATE_MCS */
+	if (status->flag & RX_FLAG_HT) {
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE_MCS);
+		*pos = status->rate_idx;
+		pos++;
+		*pos = 0;
+		if (status->flag & RX_FLAG_40MHZ)
+			*pos |= IEEE80211_RADIOTAP_RATE_MCS_40MHZ;
+		if (status->flag & RX_FLAG_SHORT_GI)
+			*pos |= IEEE80211_RADIOTAP_RATE_MCS_SHORT_GI;
+		pos++;
+	}
 }
 
 /*
diff -ru a/net/mac80211/status.c b/net/mac80211/status.c
--- a/net/mac80211/status.c	2010-08-09 23:26:40.714691704 +0200
+++ b/net/mac80211/status.c	2010-08-09 23:13:26.422694046 +0200
@@ -352,6 +352,16 @@
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
 		rthdr->rate = sband->bitrates[
 				info->status.rates[0].idx].bitrate / 5;
+	/* HT rates */
+	if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		rthdr->hdr.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE_MCS);
+		rthdr->rate = 0;
+		rthdr->mcs = info->status.rates[0].idx;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_RATE_MCS_40MHZ);
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+			rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_RATE_MCS_SHORT_GI);
+	}
 
 	/* for now report the total retry_count */
 	rthdr->data_retries = retry_count;
diff -ru a/net/mac80211/tx.c b/net/mac80211/tx.c
--- a/net/mac80211/tx.c	2010-08-09 23:26:40.558625717 +0200
+++ b/net/mac80211/tx.c	2010-08-09 23:58:17.347120109 +0200
@@ -1068,6 +1068,49 @@
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
+		case IEEE80211_RADIOTAP_RATE: {
+			info->control.rates[0].idx = 0;
+			if (*iterator.this_arg) {
+				int i;
+				for (i = 0; i < sband->n_bitrates; i++)
+					if (sband->bitrates[i].bitrate <=
+						*iterator.this_arg * 5) {
+						info->control.rates[0].idx = i;
+						break;
+					}
+			}
+			info->flags |= IEEE80211_TX_CTL_RC_BYPASS;
+			info->control.rates[0].flags = 0;
+			info->control.rates[1].idx = -1;
+			info->control.rates[2].idx = -1;
+			info->control.rates[3].idx = -1;
+			info->control.rates[4].idx = -1;
+			break;
+		}
+
+		case IEEE80211_RADIOTAP_DATA_RETRIES:
+			info->control.rates[0].count = *iterator.this_arg;
+			break;
+
+		case IEEE80211_RADIOTAP_RATE_MCS: {
+			u8 flags;
+			if (info->control.rates[0].idx)
+				break;
+			flags = *(iterator.this_arg + 1);
+			info->control.rates[0].idx = *iterator.this_arg;
+
+			info->flags |= IEEE80211_TX_CTL_RC_BYPASS;
+			info->control.rates[0].flags |=
+				IEEE80211_TX_RC_MCS;
+			if (flags & IEEE80211_RADIOTAP_RATE_MCS_40MHZ)
+				info->control.rates[0].flags |=
+				IEEE80211_TX_RC_40_MHZ_WIDTH;
+			if (flags & IEEE80211_RADIOTAP_RATE_MCS_SHORT_GI)
+				info->control.rates[0].flags |=
+				IEEE80211_TX_RC_SHORT_GI;
+			break;
+		}
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1314,7 +1357,8 @@
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_select_key);
 	CALL_TXH(ieee80211_tx_h_sta);
-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+	    !(info->flags & IEEE80211_TX_CTL_RC_BYPASS))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION))
diff -ru a/net/wireless/radiotap.c b/net/wireless/radiotap.c
--- a/net/wireless/radiotap.c	2010-08-09 23:26:28.263132773 +0200
+++ b/net/wireless/radiotap.c	2010-08-09 23:12:46.366644666 +0200
@@ -39,6 +39,7 @@
 	[IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
 	[IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
 	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_RATE_MCS] = { .align = 1, .size = 2, }
 	/*
 	 * add more here as they are defined in radiotap.h
 	 */
