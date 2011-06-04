Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46476 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1FDRn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 13:43:27 -0400
Received: by qyk7 with SMTP id 7so217297qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jun 2011 10:43:26 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Sat, 4 Jun 2011 19:42:46 +0200
Message-ID: <BANLkTim_YzVXG5g+92AkvJhhQ4OkeW4wMw@mail.gmail.com> (sfid-20110604_194333_802760_1207A93C)
Subject: [PATCH v3] 802.11n frame injection
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to set the tx rate and retries when injecting:
read the information from the radiotap header and populate the retry chain

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/net/mac80211/tx.c	2011-06-01 21:04:32.000000000 +0200
+++ b/net/mac80211/tx.c	2011-06-04 19:38:36.356443309 +0200
@@ -1092,6 +1092,46 @@
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;

+		case IEEE80211_RADIOTAP_RATE: {
+			struct ieee80211_supported_band *sband =
+				tx->local->hw.wiphy->bands[tx->channel->band];
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
--- a/net/wireless/radiotap.c	2011-06-01 21:04:24.000000000 +0200
+++ b/net/wireless/radiotap.c	2011-06-04 19:00:49.453007027 +0200
@@ -40,6 +40,7 @@
 	[IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
 	[IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
 	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
 	/*
 	 * add more here as they are defined in radiotap.h
 	 */

-- 
Matteo Croce
OpenWrt Developer
 _______                     ________        __
|       |.-----.-----.-----.|  |  |  |.----.|  |_
|   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
|_______||   __|_____|__|__||________||__|  |____|
         |__| W I R E L E S S   F R E E D O M
ATTITUDE ADJUSTMENT (bleeding edge) --------------
 * 1/4 oz Vodka      Pour all ingredents into mixing
 * 1/4 oz Gin        tin with ice, strain into glass.
 * 1/4 oz Amaretto
 * 1/4 oz Triple sec
 * 1/4 oz Peach schnapps
 * 1/4 oz Sour mix
 * 1 splash Cranberry juice
-----------------------------------------------------
