Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1I2OHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 10:07:15 -0400
Message-Id: <20110929140503.096662080@sipsolutions.net> (sfid-20110929_160719_550162_30CA9FE0)
Date: Thu, 29 Sep 2011 16:04:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 16/16] mac80211: dont assign seqno to or aggregate QoS
 Null frames
References: <20110929140425.390322480@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

802.11 says:
"Sequence numbers for QoS (+)Null frames may be
set to any value."

However, if we use the normal counters then peers
will get confused with aggregation since there'll
be holes in the sequence number sequence.

To avoid that, neither assign a sequence number
to QoS null frames nor put them on aggregation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/tx.c	2011-09-28 19:10:21.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-28 19:10:26.000000000 +0200
@@ -804,6 +804,9 @@ ieee80211_tx_h_sequence(struct ieee80211
 	if (ieee80211_hdrlen(hdr->frame_control) < 24)
 		return TX_CONTINUE;
 
+	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
+		return TX_CONTINUE;
+
 	/*
 	 * Anything but QoS data that has a sequence number field
 	 * (is long enough) gets a sequence number from the global
@@ -1236,6 +1239,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
+	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
 	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) &&
 	    !(local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)) {
 		struct tid_ampdu_tx *tid_tx;


