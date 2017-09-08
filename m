Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:37881 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdIHQHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 12:07:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by nsmtp.uni-koblenz.de (Postfix) with ESMTP id 11E9F2205EA
        for <linux-wireless@vger.kernel.org>; Fri,  8 Sep 2017 18:07:33 +0200 (CEST)
Received: from nsmtp.uni-koblenz.de ([127.0.0.1])
        by localhost (nsmtp.uni-koblenz.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yPcP4VKHiWGB for <linux-wireless@vger.kernel.org>;
        Fri,  8 Sep 2017 18:07:33 +0200 (CEST)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15])
        by nsmtp.uni-koblenz.de (Postfix) with ESMTPS
        for <linux-wireless@vger.kernel.org>; Fri,  8 Sep 2017 18:07:32 +0200 (CEST)
From: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <rschuetz@uni-koblenz.de>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <rschuetz@uni-koblenz.de>
Subject: [PATCH v2 2/2] wireless: return correct mandatory rates
Date: Fri,  8 Sep 2017 18:07:12 +0200
Message-Id: <20170908160712.8765-1-rschuetz@uni-koblenz.de> (sfid-20170908_180746_422254_8173A2C4)
In-Reply-To: <20170907154744.28357-2-rschuetz@uni-koblenz.de>
References: <20170907154744.28357-2-rschuetz@uni-koblenz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use IEEE80211_RATE_MANDATORY_G instead of IEEE80211_RATE_MANDATORY_B to get
all mandatory rates in 2.4 GHz band. It is safe to do so because ERP
mandatory rates are a superset of HR/DSSS mandatory rates. Also limit to
OFDM rates for 10 MHz and 5 MHz channels as originally intended by commit
74608aca4d82e.

Signed-off-by: Richard Schütz <rschuetz@uni-koblenz.de>
---
 net/wireless/util.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index c69b5c31caf8..386070e0035a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -51,16 +51,17 @@ u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
 	if (sband->band == NL80211_BAND_2GHZ) {
 		if (scan_width == NL80211_BSS_CHAN_WIDTH_5 ||
 		    scan_width == NL80211_BSS_CHAN_WIDTH_10)
-			mandatory_flag = IEEE80211_RATE_MANDATORY_G;
+			mandatory_flag = IEEE80211_RATE_MANDATORY_G |
+					 IEEE80211_RATE_ERP_G;
 		else
-			mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+			mandatory_flag = IEEE80211_RATE_MANDATORY_G;
 	} else {
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
 	}
 
 	bitrates = sband->bitrates;
 	for (i = 0; i < sband->n_bitrates; i++)
-		if (bitrates[i].flags & mandatory_flag)
+		if ((bitrates[i].flags & mandatory_flag) == mandatory_flag)
 			mandatory_rates |= BIT(i);
 	return mandatory_rates;
 }
-- 
2.14.1
