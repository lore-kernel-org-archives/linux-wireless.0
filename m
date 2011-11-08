Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1KHL2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 06:28:40 -0500
Subject: [PATCH] mac80211: fix NULL dereference in radiotap code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Xiaokang Qin <xiaokang.qin@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 12:28:33 +0100
Message-ID: <1320751713.4304.27.camel@jlt3.sipsolutions.net> (sfid-20111108_122843_934932_B023EB15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When receiving failed PLCP frames is enabled, there
won't be a rate pointer when we add the radiotap
header and thus the kernel will crash. Fix this by
not assuming the rate pointer is always valid. It's
still always valid for frames that have good PLCP
though, and that is checked & enforced.

This was broken by my
commit fc88518916793af8ad6a02e05ff254d95c36d875
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Jul 30 13:23:12 2010 +0200

    mac80211: don't check rates on PLCP error frames

where I removed the check in this case but didn't
take into account that the rate info would be used.

Reported-by: Xiaokang Qin <xiaokang.qin@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mac80211/rx.c	2011-11-08 09:24:58.000000000 +0100
+++ b/net/mac80211/rx.c	2011-11-08 12:19:55.000000000 +0100
@@ -140,8 +140,9 @@ ieee80211_add_rx_radiotap_header(struct
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	if (status->flag & RX_FLAG_HT) {
+	if (!rate || status->flag & RX_FLAG_HT) {
 		/*
+		 * Without rate information don't add it. If we have,
 		 * MCS information is a separate field in radiotap,
 		 * added below. The byte here is needed as padding
 		 * for the channel though, so initialise it to 0.
@@ -162,12 +163,14 @@ ieee80211_add_rx_radiotap_header(struct
 	else if (status->flag & RX_FLAG_HT)
 		put_unaligned_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ,
 				   pos);
-	else if (rate->flags & IEEE80211_RATE_ERP_G)
+	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
 		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
 				   pos);
-	else
+	else if (rate)
 		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
 				   pos);
+	else
+		put_unaligned_le16(IEEE80211_CHAN_2GHZ, pos);
 	pos += 2;
 
 	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */


