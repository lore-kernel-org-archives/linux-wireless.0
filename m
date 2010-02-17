Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0BQUFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 15:05:20 -0500
Subject: [PATCH] mac80211: deprecate RX status noise
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 21:05:14 +0100
Message-ID: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The noise value as is won't be used, isn't
filled by most drivers and doesn't really
make a whole lot of sense on a per packet
basis -- proper cfg80211 survey support in
mac80211 will need to be different.

Mark the struct member as deprecated so it
will be removed from drivers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Currently creates the following warnings:

drivers/net/wireless/mwl8k.c:756: warning: ‘noise’ is deprecated
drivers/net/wireless/mwl8k.c:858: warning: ‘noise’ is deprecated
drivers/net/wireless/ath/ar9170/main.c:928: warning: ‘noise’ is deprecated
drivers/net/wireless/ath/ath9k/common.c:215: warning: ‘noise’ is deprecated
drivers/net/wireless/ath/ath5k/base.c:1941: warning: ‘noise’ is deprecated
drivers/net/wireless/ath/ath5k/base.c:1942: warning: ‘noise’ is deprecated
drivers/net/wireless/b43/xmit.c:613: warning: ‘noise’ is deprecated
drivers/net/wireless/b43legacy/xmit.c:551: warning: ‘noise’ is deprecated
drivers/net/wireless/libertas_tf/main.c:497: warning: ‘noise’ is deprecated
drivers/net/wireless/rt2x00/rt2x00dev.c:437: warning: ‘noise’ is deprecated
drivers/net/wireless/p54/txrx.c:353: warning: ‘noise’ is deprecated
drivers/net/wireless/wl12xx/wl1251_rx.c:80: warning: ‘noise’ is deprecated
drivers/net/wireless/wl12xx/wl1271_rx.c:139: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-3945.c:682: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-3945.c:685: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-3945.c:689: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-3945.c:697: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-3945.c:711: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-rx.c:1191: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-rx.c:1193: warning: ‘noise’ is deprecated
drivers/net/wireless/iwlwifi/iwl-rx.c:1206: warning: ‘noise’ is deprecated

I'll make patches for drivers when it becomes
clear that it won't clash with any work others
have pending.

 include/net/mac80211.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-02-17 20:57:33.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2010-02-17 20:57:43.000000000 +0100
@@ -543,7 +543,7 @@ enum mac80211_rx_flags {
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
  *	unspecified depending on the hardware capabilities flags
  *	@IEEE80211_HW_SIGNAL_*
- * @noise: noise when receiving this frame, in dBm.
+ * @noise: noise when receiving this frame, in dBm (DEPRECATED).
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT rates are use (RX_FLAG_HT)
@@ -554,7 +554,7 @@ struct ieee80211_rx_status {
 	enum ieee80211_band band;
 	int freq;
 	int signal;
-	int noise;
+	int noise __deprecated;
 	int antenna;
 	int rate_idx;
 	int flag;


