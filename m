Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:59581 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755161AbdIGPzE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 11:55:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by nsmtp.uni-koblenz.de (Postfix) with ESMTP id 57BA5220502
        for <linux-wireless@vger.kernel.org>; Thu,  7 Sep 2017 17:47:52 +0200 (CEST)
Received: from nsmtp.uni-koblenz.de ([127.0.0.1])
        by localhost (nsmtp.uni-koblenz.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TTlVAafVUWID for <linux-wireless@vger.kernel.org>;
        Thu,  7 Sep 2017 17:47:52 +0200 (CEST)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15])
        by nsmtp.uni-koblenz.de (Postfix) with ESMTPS
        for <linux-wireless@vger.kernel.org>; Thu,  7 Sep 2017 17:47:52 +0200 (CEST)
From: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <rschuetz@uni-koblenz.de>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <rschuetz@uni-koblenz.de>
Subject: [PATCH 1/2] wireless: set correct mandatory rate flags
Date: Thu,  7 Sep 2017 17:47:43 +0200
Message-Id: <20170907154744.28357-1-rschuetz@uni-koblenz.de> (sfid-20170907_175508_102149_80D1890A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE Std 802.11-2016 (16.2.3.4 Long PHY SIGNAL field) all of
the following rates are mandatory for a HR/DSSS PHY: 1 Mb/s, 2 Mb/s,
5.5 Mb/s and 11 Mb/s. Set IEEE80211_RATE_MANDATORY_B flag for all of these
instead of just 1 Mb/s to correctly reflect this.

Signed-off-by: Richard Schütz <rschuetz@uni-koblenz.de>
---
 net/wireless/util.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index bcb1284c3415..c69b5c31caf8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -157,32 +157,28 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband)
 	case NL80211_BAND_2GHZ:
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
+			} else {
+				sband->bitrates[i].flags |=
+					IEEE80211_RATE_ERP_G;
 			}
 
-			if (sband->bitrates[i].bitrate == 20 ||
-			    sband->bitrates[i].bitrate == 55 ||
-			    sband->bitrates[i].bitrate == 110 ||
-			    sband->bitrates[i].bitrate == 60 ||
+			if (sband->bitrates[i].bitrate == 60 ||
 			    sband->bitrates[i].bitrate == 120 ||
 			    sband->bitrates[i].bitrate == 240) {
 				sband->bitrates[i].flags |=
 					IEEE80211_RATE_MANDATORY_G;
 				want--;
 			}
-
-			if (sband->bitrates[i].bitrate != 10 &&
-			    sband->bitrates[i].bitrate != 20 &&
-			    sband->bitrates[i].bitrate != 55 &&
-			    sband->bitrates[i].bitrate != 110)
-				sband->bitrates[i].flags |=
-					IEEE80211_RATE_ERP_G;
 		}
-		WARN_ON(want != 0 && want != 3 && want != 6);
+		WARN_ON(want != 0 && want != 3);
 		break;
 	case NL80211_BAND_60GHZ:
 		/* check for mandatory HT MCS 1..4 */
-- 
2.14.1
