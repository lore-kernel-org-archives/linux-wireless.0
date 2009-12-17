Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZLQIpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 03:45:50 -0500
Subject: [PATCH 2.6.33] mac80211: fix peer HT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 09:45:45 +0100
Message-ID: <1261039545.10356.94.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed yesterday, because Jeff had noticed
a speed regression, cf. bug
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2138
that the SM PS settings for peers were wrong.
Instead of overwriting the SM PS settings with
the local bits, we need to keep the remote bits.

The bug was part of the original HT code from
over two years ago, but unfortunately nobody
noticed that it makes no sense -- we shouldn't
be overwriting the peer's setting with our own
but rather keep it intact when masking the peer
capabilities with our own.

While fixing that, I noticed that the masking of
capabilities is completely useless for most of
the bits, so also fix those other bits.

Finally, I also noticed that PSMP_SUPPORT no
longer exists in the final 802.11n version, so
also remove that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Even though this was introduced a long time ago, it didn't really matter
until now. In 2.6.33, iwlwifi might use dynamic SM PS so we'd be getting
the wrong data for peers from then on.

 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
 include/linux/ieee80211.h               |    2 +-
 net/mac80211/ht.c                       |   26 +++++++++++++++++++++++---
 3 files changed, 25 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/ht.c	2009-12-17 09:00:06.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-12-17 09:39:56.000000000 +0100
@@ -24,6 +24,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 {
 	u8 ampdu_info, tx_mcs_set_cap;
 	int i, max_tx_streams;
+	u16 tmp_cap;
 
 	BUG_ON(!ht_cap);
 
@@ -34,9 +35,28 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 
 	ht_cap->ht_supported = true;
 
-	ht_cap->cap = le16_to_cpu(ht_cap_ie->cap_info) & sband->ht_cap.cap;
-	ht_cap->cap &= ~IEEE80211_HT_CAP_SM_PS;
-	ht_cap->cap |= sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS;
+	/*
+	 * The bits listed in this expression should be
+	 * the same for the peer and us, if the station
+	 * advertises more then we can't use those thus
+	 * we mask them out.
+	 */
+	ht_cap->cap = le16_to_cpu(ht_cap_ie->cap_info) &
+		(sband->ht_cap.cap |
+		 ~(IEEE80211_HT_CAP_LDPC_CODING |
+		   IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+		   IEEE80211_HT_CAP_GRN_FLD |
+		   IEEE80211_HT_CAP_SGI_20 |
+		   IEEE80211_HT_CAP_SGI_40 |
+		   IEEE80211_HT_CAP_DSSSCCK40));
+	/*
+	 * The STBC bits are asymmetric -- if we don't have
+	 * TX then mask out the peer's RX and vice versa.
+	 */
+	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
+		ht_cap->cap &= ~IEEE80211_HT_CAP_RX_STBC;
+	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC))
+		ht_cap->cap &= ~IEEE80211_HT_CAP_TX_STBC;
 
 	ampdu_info = ht_cap_ie->ampdu_params_info;
 	ht_cap->ampdu_factor =
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800lib.c	2009-12-17 09:29:48.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2800lib.c	2009-12-17 09:29:54.000000000 +0100
@@ -2074,8 +2074,7 @@ int rt2800_probe_hw_mode(struct rt2x00_d
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_SGI_40 |
 	    IEEE80211_HT_CAP_TX_STBC |
-	    IEEE80211_HT_CAP_RX_STBC |
-	    IEEE80211_HT_CAP_PSMP_SUPPORT;
+	    IEEE80211_HT_CAP_RX_STBC;
 	spec->ht.ampdu_factor = 3;
 	spec->ht.ampdu_density = 4;
 	spec->ht.mcs.tx_params =
--- wireless-testing.orig/include/linux/ieee80211.h	2009-12-17 09:29:33.000000000 +0100
+++ wireless-testing/include/linux/ieee80211.h	2009-12-17 09:29:40.000000000 +0100
@@ -837,7 +837,7 @@ struct ieee80211_ht_cap {
 #define IEEE80211_HT_CAP_DELAY_BA		0x0400
 #define IEEE80211_HT_CAP_MAX_AMSDU		0x0800
 #define IEEE80211_HT_CAP_DSSSCCK40		0x1000
-#define IEEE80211_HT_CAP_PSMP_SUPPORT		0x2000
+#define IEEE80211_HT_CAP_RESERVED		0x2000
 #define IEEE80211_HT_CAP_40MHZ_INTOLERANT	0x4000
 #define IEEE80211_HT_CAP_LSIG_TXOP_PROT		0x8000
 


