Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab0G3LV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 07:21:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Oenf1-0000b7-9N
	for linux-wireless@vger.kernel.org; Fri, 30 Jul 2010 13:21:55 +0200
Subject: [PATCH] mac80211: don't check rates on PLCP error frames
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 13:23:12 +0200
Message-ID: <1280488992.3710.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Frames that failed PLCP error checks are most likely
microwave transmissions (well, maybe not ...) and
don't have a proper rate detected, so ignore it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-07-30 08:42:22.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-07-30 08:43:38.000000000 +0200
@@ -2615,28 +2615,37 @@ void ieee80211_rx(struct ieee80211_hw *h
 	if (WARN_ON(!local->started))
 		goto drop;
 
-	if (status->flag & RX_FLAG_HT) {
+	if (likely(!(status->flag & RX_FLAG_FAILED_PLCP_CRC))) {
 		/*
-		 * rate_idx is MCS index, which can be [0-76] as documented on:
-		 *
-		 * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
-		 *
-		 * Anything else would be some sort of driver or hardware error.
-		 * The driver should catch hardware errors.
+		 * Validate the rate, unless a PLCP error means that
+		 * we probably can't have a valid rate here anyway.
 		 */
-		if (WARN((status->rate_idx < 0 ||
-			 status->rate_idx > 76),
-			 "Rate marked as an HT rate but passed "
-			 "status->rate_idx is not "
-			 "an MCS index [0-76]: %d (0x%02x)\n",
-			 status->rate_idx,
-			 status->rate_idx))
-			goto drop;
-	} else {
-		if (WARN_ON(status->rate_idx < 0 ||
-			    status->rate_idx >= sband->n_bitrates))
-			goto drop;
-		rate = &sband->bitrates[status->rate_idx];
+
+		if (status->flag & RX_FLAG_HT) {
+			/*
+			 * rate_idx is MCS index, which can be [0-76]
+			 * as documented on:
+			 *
+			 * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
+			 *
+			 * Anything else would be some sort of driver or
+			 * hardware error. The driver should catch hardware
+			 * errors.
+			 */
+			if (WARN((status->rate_idx < 0 ||
+				 status->rate_idx > 76),
+				 "Rate marked as an HT rate but passed "
+				 "status->rate_idx is not "
+				 "an MCS index [0-76]: %d (0x%02x)\n",
+				 status->rate_idx,
+				 status->rate_idx))
+				goto drop;
+		} else {
+			if (WARN_ON(status->rate_idx < 0 ||
+				    status->rate_idx >= sband->n_bitrates))
+				goto drop;
+			rate = &sband->bitrates[status->rate_idx];
+		}
 	}
 
 	/*


