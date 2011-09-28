Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1I1NDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 09:03:50 -0400
Subject: [PATCH 16/15] mac80211: don't assign seqno to or aggregate QoS
 Null frames
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
In-Reply-To: <20110928120849.882884360@sipsolutions.net> (sfid-20110928_141249_243564_22D2F86A)
References: <20110928120849.882884360@sipsolutions.net>
	 (sfid-20110928_141249_243564_22D2F86A)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 15:03:42 +0200
Message-ID: <1317215022.3986.15.camel@jlt3.sipsolutions.net> (sfid-20110928_150401_992239_24FA7B8E)
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

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
chr pointed this out to me ... thanks!

Cc stable since I'm changing hostapd to use QoS null frames...

 net/mac80211/tx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/tx.c	2011-09-28 14:13:19.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-28 14:51:13.000000000 +0200
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


