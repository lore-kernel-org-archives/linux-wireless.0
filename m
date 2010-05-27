Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:36559 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752422Ab0E0Apn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 20:45:43 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-082001142
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 09:45:42 +0900 (JST)
Subject: [PATCH] mac80211: mark 1, 2,
	5.5 and 11Mbps as mandatory rates for 802.11b
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: juuso.oikarinen@nokia.com, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 27 May 2010 09:45:45 +0900
Message-ID: <20100527004545.11541.88667.stgit@tt-desk>
In-Reply-To: <1274883276.3658.15.camel@jlt3.sipsolutions.net>
References: <1274883276.3658.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE802.11-2007 clause 18.2.3.3 (p640) states that 1, 2, 5.5 & 11 Mbits are
mandatory rates for what they call High Rate direct sequence spread spectrum
(HR/DSSS) PHY (with long PLCP).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 net/wireless/util.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 3416373..f6f4101 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -100,17 +100,17 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 	case IEEE80211_BAND_2GHZ:
 		want = 7;
 		for (i = 0; i < sband->n_bitrates; i++) {
-			if (sband->bitrates[i].bitrate == 10) {
+			if (sband->bitrates[i].bitrate == 10 ||
+			    sband->bitrates[i].bitrate == 20 ||
+			    sband->bitrates[i].bitrate == 55 ||
+			    sband->bitrates[i].bitrate == 110) {
 				sband->bitrates[i].flags |=
 					IEEE80211_RATE_MANDATORY_B |
 					IEEE80211_RATE_MANDATORY_G;
 				want--;
 			}
 
-			if (sband->bitrates[i].bitrate == 20 ||
-			    sband->bitrates[i].bitrate == 55 ||
-			    sband->bitrates[i].bitrate == 110 ||
-			    sband->bitrates[i].bitrate == 60 ||
+			if (sband->bitrates[i].bitrate == 60 ||
 			    sband->bitrates[i].bitrate == 120 ||
 			    sband->bitrates[i].bitrate == 240) {
 				sband->bitrates[i].flags |=
@@ -125,7 +125,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 				sband->bitrates[i].flags |=
 					IEEE80211_RATE_ERP_G;
 		}
-		WARN_ON(want != 0 && want != 3 && want != 6);
+		WARN_ON(want != 0 && want != 3);
 		break;
 	case IEEE80211_NUM_BANDS:
 		WARN_ON(1);

