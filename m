Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbXKWMQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:16:03 -0500
Subject: [PATCH] mac80211: include MAC timestamp in radiotap header
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 11:45:54 +0100
Message-Id: <1195814754.4149.86.camel@johannes.berg> (sfid-20071123_121608_153874_56B09512)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes mac80211 include the low-level MAC timestamp
in the radiotap header.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/rx.c	2007-11-22 23:33:46.058691568 +0100
+++ everything/net/mac80211/rx.c	2007-11-23 11:45:10.422091198 +0100
@@ -82,6 +82,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 	int needed_headroom = 0;
 	struct ieee80211_rtap_hdr {
 		struct ieee80211_radiotap_header hdr;
+		__le64 tsft;
 		u8 flags;
 		u8 rate;
 		__le16 chan_freq;
@@ -157,7 +158,8 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		memset(rthdr, 0, sizeof(*rthdr));
 		rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
 		rthdr->hdr.it_present =
-			cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+				    (1 << IEEE80211_RADIOTAP_FLAGS) |
 				    (1 << IEEE80211_RADIOTAP_RATE) |
 				    (1 << IEEE80211_RADIOTAP_CHANNEL) |
 				    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL) |
@@ -165,6 +167,8 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		rthdr->flags = local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS ?
 			       IEEE80211_RADIOTAP_F_FCS : 0;
 
+		rthdr->tsft = cpu_to_le64(status->mactime);
+
 		/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
 		rthdr->rx_flags = 0;
 		if (status->flag &


