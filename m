Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62229 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678Ab1ESXNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 19:13:42 -0400
Received: by qyk7 with SMTP id 7so3622401qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 16:13:41 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Fri, 20 May 2011 01:13:01 +0200
Message-ID: <BANLkTin6ettB1nhnrAjDncX1MrahfS4Z6g@mail.gmail.com> (sfid-20110520_011405_835059_85A96447)
Subject: [PATCH 1/2]: mac80211: set tx rate and retries when injecting
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to set the tx rate and retries when injecting:
read the information from the radiotap header and populate the retry chain

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/net/mac80211/tx.c	2011-05-20 00:22:56.250640264 +0200
+++ b/net/mac80211/tx.c	2011-05-20 00:24:14.010640270 +0200
@@ -1092,6 +1092,44 @@
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
--- a/net/mac80211/ieee80211_i.h	2011-05-20 00:22:56.240640264 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-05-20 00:24:14.010640270 +0200
@@ -1217,6 +1217,10 @@
 	u8 padding_for_rate;
 	__le16 tx_flags;
 	u8 data_retries;
+	/*HT info*/
+	u8 ht_known;
+	u8 ht_flag;
+	u8 ht_mcs;
 } __packed;


--- a/net/wireless/radiotap.c	2011-05-20 00:22:56.270640264 +0200
+++ b/net/wireless/radiotap.c	2011-05-20 00:24:14.010640270 +0200
@@ -40,6 +40,7 @@
 	[IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
 	[IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
 	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
 	/*
 	 * add more here as they are defined in radiotap.h
 	 */
--- a/include/net/mac80211.h	2011-05-20 00:22:56.210640264 +0200
+++ b/include/net/mac80211.h	2011-05-20 00:24:14.020640270 +0200
@@ -2278,7 +2278,7 @@
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
  */
-#define IEEE80211_TX_STATUS_HEADROOM	13
+#define IEEE80211_TX_STATUS_HEADROOM	16

 /**
  * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
