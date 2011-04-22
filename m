Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58101 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab1DVQfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 12:35:40 -0400
Received: by qwk3 with SMTP id 3so328192qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 09:35:39 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Fri, 22 Apr 2011 18:34:59 +0200
Message-ID: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
Subject: [PATCH v2] 802.11n frame injection
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows to set the tx rate and retries when injecting,
and report correct MCS information on received frames.
This v2 version sets IEEE80211_TX_STATUS_HEADROOM to a correct value

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/net/mac80211/tx.c	2011-04-22 11:34:08.825135198 +0200
+++ b/net/mac80211/tx.c	2011-04-22 11:34:54.037135187 +0200
@@ -1091,6 +1091,44 @@
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;

+		case IEEE80211_RADIOTAP_RATE: {
+			info->control.rates[0].idx = 0;
+			if (*iterator.this_arg) {
+				int i;
+				for (i = 0; i < sband->n_bitrates; i++)
+					if (sband->bitrates[i].bitrate ==
+						*iterator.this_arg * 5) {
+						info->control.rates[0].idx = i;
+						break;
+					}
+			}
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
+		case IEEE80211_RADIOTAP_MCS: {
+			u8 flags = iterator.this_arg[1];
+			u8 mcs = iterator.this_arg[2];
+			info->control.rates[0].idx = mcs;
+			info->control.rates[0].flags |=
+				IEEE80211_TX_RC_MCS;
+			if (flags & IEEE80211_RADIOTAP_MCS_BW_40)
+				info->control.rates[0].flags |=
+				IEEE80211_TX_RC_40_MHZ_WIDTH;
+			if (flags & IEEE80211_RADIOTAP_MCS_SGI)
+				info->control.rates[0].flags |=
+				IEEE80211_TX_RC_SHORT_GI;
+			break;
+		}
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
--- a/net/mac80211/ieee80211_i.h	2011-04-22 11:34:08.829135198 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-04-22 11:34:54.037135187 +0200
@@ -1197,6 +1197,10 @@
 	u8 padding_for_rate;
 	__le16 tx_flags;
 	u8 data_retries;
+	/*HT info*/
+	u8 ht_known;
+	u8 ht_flag;
+	u8 ht_mcs;
 } __packed;


--- a/net/mac80211/status.c	2011-04-22 11:34:08.833135198 +0200
+++ b/net/mac80211/status.c	2011-04-22 11:34:54.037135187 +0200
@@ -405,6 +405,19 @@
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
 		rthdr->rate = sband->bitrates[
 				info->status.rates[0].idx].bitrate / 5;
+	/* HT rates */
+	if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		rthdr->hdr.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->rate = 0;
+		rthdr->ht_known =	IEEE80211_RADIOTAP_MCS_HAVE_BW |
+					IEEE80211_RADIOTAP_MCS_HAVE_MCS |
+					IEEE80211_RADIOTAP_MCS_HAVE_GI;
+		rthdr->ht_mcs = info->status.rates[0].idx;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_BW_40;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+			rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_SGI;
+	}

 	/* for now report the total retry_count */
 	rthdr->data_retries = retry_count;
--- a/net/wireless/radiotap.c	2011-04-22 11:34:08.833135198 +0200
+++ b/net/wireless/radiotap.c	2011-04-22 11:34:54.037135187 +0200
@@ -40,6 +40,7 @@
 	[IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
 	[IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
 	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
 	/*
 	 * add more here as they are defined in radiotap.h
 	 */
--- a/include/net/mac80211.h	2011-04-22 11:38:01.389135142 +0200
+++ b/include/net/mac80211.h	2011-04-22 11:40:22.017135111 +0200
@@ -2228,7 +2228,7 @@
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
  */
-#define IEEE80211_TX_STATUS_HEADROOM	13
+#define IEEE80211_TX_STATUS_HEADROOM	16

 /**
  * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
