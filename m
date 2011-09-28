Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1I1MNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:13:14 -0400
Message-Id: <20110928121130.177186599@sipsolutions.net> (sfid-20110928_141317_728814_913CBD88)
Date: Wed, 28 Sep 2011 14:08:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/15] mac80211: clear more-data bit on filtered frames
References: <20110928120849.882884360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It doesn't seem likely, but maybe possible, that the
more-data bit needs to be recomputed due to changes
in the queued frames. Clear it for filtered frames
to ensure that we never send it incorrectly. It'll
be set again as necessary when we retransmit this
frame.

The more likely case is maybe where the station woke
up after the filtered frame in which case more-data
should be clear when the frame is transmitted to the
station since it is now awake.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/status.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/mac80211/status.c	2011-09-28 13:22:04.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-28 13:22:27.000000000 +0200
@@ -65,6 +65,16 @@ static void ieee80211_handle_filtered_fr
 
 	sta->tx_filtered_count++;
 
+	/*
+	 * Clear more-data bit on filtered frames, it might be set
+	 * but later frames might time out so it might have to be
+	 * clear again ... It's all rather unlikely (this frame
+	 * should time out first, right?) but let's not confuse
+	 * peers unnecessarily.
+	 */
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_MOREDATA))
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		int tid = *ieee80211_get_qos_ctl(hdr) &
 					IEEE80211_QOS_CTL_TID_MASK;


