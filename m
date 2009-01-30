Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZA3KNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 05:13:14 -0500
Subject: [PATCH] mac80211: remove HW_SIGNAL_DB
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bruno Randolf <bruno@thinktube.com>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 11:13:06 +0100
Message-Id: <1233310386.4161.25.camel@johannes.local> (sfid-20090130_111324_351082_DB510EAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Giving the signal in dB isn't much more useful to userspace
than giving the signal in unspecified units. This removes
some radiotap information for zd1211 (the only driver using
this flag), but it helps a lot for getting cfg80211-based
scanning which won't support dB, and zd1211 being dB is a
little fishy anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    2 +-
 include/net/mac80211.h                 |   22 ++++++++--------------
 net/mac80211/main.c                    |    1 -
 net/mac80211/rx.c                      |   11 +----------
 net/mac80211/wext.c                    |    3 +--
 5 files changed, 11 insertions(+), 28 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-30 10:57:26.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-30 10:57:49.000000000 +0100
@@ -860,11 +860,6 @@ enum ieee80211_tkip_key_type {
  *	expect values between 0 and @max_signal.
  *	If possible please provide dB or dBm instead.
  *
- * @IEEE80211_HW_SIGNAL_DB:
- *	Hardware gives signal values in dB, decibel difference from an
- *	arbitrary, fixed reference. We expect values between 0 and @max_signal.
- *	If possible please provide dBm instead.
- *
  * @IEEE80211_HW_SIGNAL_DBM:
  *	Hardware gives signal values in dBm, decibel difference from
  *	one milliwatt. This is the preferred method since it is standardized
@@ -900,15 +895,14 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
 	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
 	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
-	IEEE80211_HW_SIGNAL_DB				= 1<<6,
-	IEEE80211_HW_SIGNAL_DBM				= 1<<7,
-	IEEE80211_HW_NOISE_DBM				= 1<<8,
-	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
-	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
-	IEEE80211_HW_SUPPORTS_PS			= 1<<11,
-	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<12,
-	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<13,
-	IEEE80211_HW_MFP_CAPABLE			= 1<<14,
+	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
+	IEEE80211_HW_NOISE_DBM				= 1<<7,
+	IEEE80211_HW_SPECTRUM_MGMT			= 1<<8,
+	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<9,
+	IEEE80211_HW_SUPPORTS_PS			= 1<<10,
+	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
+	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
+	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 };
 
 /**
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-01-30 10:58:08.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-01-30 10:58:15.000000000 +0100
@@ -967,7 +967,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_DB;
+		    IEEE80211_HW_SIGNAL_UNSPEC;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |
--- wireless-testing.orig/net/mac80211/main.c	2009-01-30 11:04:18.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-30 11:04:28.000000000 +0100
@@ -888,7 +888,6 @@ int ieee80211_register_hw(struct ieee802
 	local->hw.conf.listen_interval = local->hw.max_listen_interval;
 
 	local->wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
-						  IEEE80211_HW_SIGNAL_DB |
 						  IEEE80211_HW_SIGNAL_DBM) ?
 			       IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
 	local->wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
--- wireless-testing.orig/net/mac80211/rx.c	2009-01-30 11:07:35.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-01-30 11:08:06.000000000 +0100
@@ -86,8 +86,7 @@ ieee80211_rx_radiotap_len(struct ieee802
 
 	if (status->flag & RX_FLAG_TSFT)
 		len += 8;
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DB ||
-	    local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
 	if (local->hw.flags & IEEE80211_HW_NOISE_DBM)
 		len += 1;
@@ -199,14 +198,6 @@ ieee80211_add_rx_radiotap_header(struct 
 	*pos = status->antenna;
 	pos++;
 
-	/* IEEE80211_RADIOTAP_DB_ANTSIGNAL */
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DB) {
-		*pos = status->signal;
-		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL);
-		pos++;
-	}
-
 	/* IEEE80211_RADIOTAP_DB_ANTNOISE is not used */
 
 	/* IEEE80211_RADIOTAP_RX_FLAGS */
--- wireless-testing.orig/net/mac80211/wext.c	2009-01-30 11:06:02.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-01-30 11:06:09.000000000 +0100
@@ -173,8 +173,7 @@ static int ieee80211_ioctl_giwrange(stru
 	range->num_encoding_sizes = 2;
 	range->max_encoding_tokens = NUM_DEFAULT_KEYS;
 
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC ||
-	    local->hw.flags & IEEE80211_HW_SIGNAL_DB)
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		range->max_qual.level = local->hw.max_signal;
 	else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		range->max_qual.level = -110;


