Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44475 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcAQKjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 05:39:47 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <liord@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>,
	Lior David <qca_liord@qca.qualcomm.com>
Subject: [PATCH 1/5] wil6210: fix privacy flag calculation in change_beacon
Date: Sun, 17 Jan 2016 12:39:06 +0200
Message-Id: <1453027150-18224-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160117_114013_829097_2B58038A)
In-Reply-To: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <liord@qti.qualcomm.com>

Currently the privacy flag calculation in change_beacon
checks for RSN IE inside proberesp_ies, but normally it
is not found there. It works today because of code inside
the function wil_fix_bcon, but wil_fix_bcon is not directly
related to change_beacon, and it may be changed or removed
in the future and break the calculation.
To fix this issue, change the privacy flag calculation
to check RSN IE inside the beacon itself. The new check is more
reliable and will not be sensitive to changes in wil_fix_bcon.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 20d07ef..182f071 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -828,9 +828,9 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 		wil_print_bcon_data(bcon);
 	}
 
-	if (bcon->proberesp_ies &&
-	    cfg80211_find_ie(WLAN_EID_RSN, bcon->proberesp_ies,
-			     bcon->proberesp_ies_len))
+	if (bcon->tail &&
+	    cfg80211_find_ie(WLAN_EID_RSN, bcon->tail,
+			     bcon->tail_len))
 		privacy = 1;
 
 	/* in case privacy has changed, need to restart the AP */
-- 
1.8.5.2

