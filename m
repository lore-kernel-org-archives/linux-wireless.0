Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:32887 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcBJQbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 11:31:22 -0500
Received: by mail-wm0-f53.google.com with SMTP id g62so34403854wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 08:31:22 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC 2/2] mac80211: parse VHT info in injected frames
Date: Wed, 10 Feb 2016 17:31:17 +0100
Message-Id: <1455121877-7238-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160210_173127_998927_0B3112E6)
In-Reply-To: <1455121877-7238-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1455121877-7238-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT radiotap parsing support to ieee80211_parse_tx_radiotap().
That capability has been tested on d-link dir-860l rev b1 running
OpenWrt trunk and mt76 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 Documentation/networking/mac80211-injection.txt | 10 ++++++++
 net/mac80211/tx.c                               | 31 +++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.txt
index ec8f934..ef57cc0 100644
--- a/Documentation/networking/mac80211-injection.txt
+++ b/Documentation/networking/mac80211-injection.txt
@@ -45,6 +45,16 @@ radiotap headers and used to control injection:
    number of retries when either IEEE80211_RADIOTAP_RATE or
    IEEE80211_RADIOTAP_MCS was used
 
+ * IEEE80211_RADIOTAP_VHT
+
+   VHT rate for the transmission (only for devices without own rate control).
+   Also some flags are parsed
+
+   IEEE80211_TX_RC_SHORT_GI: use short guard interval
+   IEEE80211_TX_RC_40_MHZ_WIDTH: send in HT40 mode
+   IEEE80211_TX_RC_80_MHZ_WIDTH: send in HT80 mode
+   IEEE80211_TX_RC_160_MHZ_WIDTH: send in HT160 mode
+
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7bb67fa..17db889 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1692,6 +1692,8 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 	u8 rate_retries = 0;
 	u16 rate_flags = 0;
 	u8 mcs_known, mcs_flags;
+	u16 vht_known;
+	u8 vht_mcs = 0, vht_nss = 0;
 	int i;
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
@@ -1772,6 +1774,32 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 				rate_flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 			break;
 
+		case IEEE80211_RADIOTAP_VHT:
+			vht_known = get_unaligned_le16(iterator.this_arg);
+			rate_found = true;
+
+			rate_flags = IEEE80211_TX_RC_VHT_MCS;
+			if ((vht_known & IEEE80211_RADIOTAP_VHT_KNOWN_GI) &&
+			    (iterator.this_arg[2] &
+			     IEEE80211_RADIOTAP_VHT_FLAG_SGI))
+				rate_flags |= IEEE80211_TX_RC_SHORT_GI;
+			if (vht_known &
+			    IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH) {
+				if (iterator.this_arg[3] == 1)
+					rate_flags |=
+						IEEE80211_TX_RC_40_MHZ_WIDTH;
+				else if (iterator.this_arg[3] == 4)
+					rate_flags |=
+						IEEE80211_TX_RC_80_MHZ_WIDTH;
+				else if (iterator.this_arg[3] == 11)
+					rate_flags |=
+						IEEE80211_TX_RC_160_MHZ_WIDTH;
+			}
+
+			vht_mcs = iterator.this_arg[4] >> 4;
+			vht_nss = iterator.this_arg[4] & 0xF;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1797,6 +1825,9 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 
 		if (rate_flags & IEEE80211_TX_RC_MCS) {
 			info->control.rates[0].idx = rate;
+		} else if (rate_flags & IEEE80211_TX_RC_VHT_MCS) {
+			ieee80211_rate_set_vht(info->control.rates, vht_mcs,
+					       vht_nss);
 		} else {
 			for (i = 0; i < sband->n_bitrates; i++) {
 				if (rate * 5 != sband->bitrates[i].bitrate)
-- 
2.5.0

