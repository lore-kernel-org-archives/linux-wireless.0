Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:59582 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754887AbdIGPzE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 11:55:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by nsmtp.uni-koblenz.de (Postfix) with ESMTP id 8C86022045F
        for <linux-wireless@vger.kernel.org>; Thu,  7 Sep 2017 17:47:52 +0200 (CEST)
Received: from nsmtp.uni-koblenz.de ([127.0.0.1])
        by localhost (nsmtp.uni-koblenz.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MkkQ9zBgQA1R for <linux-wireless@vger.kernel.org>;
        Thu,  7 Sep 2017 17:47:52 +0200 (CEST)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15])
        by nsmtp.uni-koblenz.de (Postfix) with ESMTPS
        for <linux-wireless@vger.kernel.org>; Thu,  7 Sep 2017 17:47:52 +0200 (CEST)
From: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <rschuetz@uni-koblenz.de>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <rschuetz@uni-koblenz.de>
Subject: [PATCH 2/2] wireless: return correct mandatory rates
Date: Thu,  7 Sep 2017 17:47:44 +0200
Message-Id: <20170907154744.28357-2-rschuetz@uni-koblenz.de> (sfid-20170907_175517_817760_1C44F457)
In-Reply-To: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use IEEE80211_RATE_MANDATORY_G instead of IEEE80211_RATE_MANDATORY_B for
comparison to get all mandatory rates in 2.4 GHz band. It is safe to do so
because ERP mandatory rates are a superset of HR/DSSS mandatory rates. Also
force IEEE80211_RATE_MANDATORY_A for 10 MHz and 5 MHz channels as they use
"half-clocked" respectively "quarter-clocked" operation of the OFDM rates
(IEEE Std 802.11-2016, 17.1.1).

Signed-off-by: Richard Schütz <rschuetz@uni-koblenz.de>
---
 net/wireless/util.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index c69b5c31caf8..8cac453302f7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -48,15 +48,12 @@ u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
 	if (WARN_ON(!sband))
 		return 1;
 
-	if (sband->band == NL80211_BAND_2GHZ) {
-		if (scan_width == NL80211_BSS_CHAN_WIDTH_5 ||
-		    scan_width == NL80211_BSS_CHAN_WIDTH_10)
-			mandatory_flag = IEEE80211_RATE_MANDATORY_G;
-		else
-			mandatory_flag = IEEE80211_RATE_MANDATORY_B;
-	} else {
+	if (sband->band == NL80211_BAND_2GHZ &&
+	    scan_width != NL80211_BSS_CHAN_WIDTH_5 &&
+	    scan_width != NL80211_BSS_CHAN_WIDTH_10)
+		mandatory_flag = IEEE80211_RATE_MANDATORY_G;
+	else
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
-	}
 
 	bitrates = sband->bitrates;
 	for (i = 0; i < sband->n_bitrates; i++)
-- 
2.14.1
