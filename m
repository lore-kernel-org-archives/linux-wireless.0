Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbXLEKQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:16:32 -0500
Subject: [NOTE] ath5k vs. mactime
From: Johannes Berg <johannes@sipsolutions.net>
To: ath5k-devel <ath5k-devel@lists.ath5k.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 20:29:40 +0100
Message-Id: <1196796580.10274.36.camel@johannes.berg> (sfid-20071205_101635_789853_01CE295C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/ath5k/base.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- everything.orig/drivers/net/wireless/ath5k/base.c	2007-12-04 20:23:27.246950249 +0100
+++ everything/drivers/net/wireless/ath5k/base.c	2007-12-04 20:24:44.936949598 +0100
@@ -1717,6 +1717,13 @@ accept:
 			skb_pull(skb, pad);
 		}
 
+		/*
+		 * FIXME: opmode cannot be MNTR ever since the filter
+		 * 	  flags were introduced. make this depend on the
+		 *	  "want radiotap" flag (which should be named
+		 *	  "want monitor".)
+		 *	  Then, set RX_FLAG_TSFT in rxs.flags.
+		 */
 		if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
 			rxs.mactime = ath5k_extend_tsf(sc->ah,
 					ds->ds_rxstat.rs_tstamp);


