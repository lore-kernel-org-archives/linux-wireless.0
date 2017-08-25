Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:63780
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754484AbdHYCbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:11 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 25/27] nl80211: look for HT/VHT capabilities in beacon's tail
Date: Thu, 24 Aug 2017 19:30:22 -0700
Message-Id: <20170825023024.10565-26-igor.mitsyanko.os@quantenna.com> (sfid-20170825_044309_360193_919D6EFC)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

There are no HT/VHT capabilities in cfg80211_ap_settings::beacon_ies,
these should be looked for in beacon's tail instead.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8ce8542..0df8023 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3791,8 +3791,8 @@ static void nl80211_check_ap_rate_selectors(struct cfg80211_ap_settings *params,
 static void nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 {
 	const struct cfg80211_beacon_data *bcn = &params->beacon;
-	size_t ies_len = bcn->beacon_ies_len;
-	const u8 *ies = bcn->beacon_ies;
+	size_t ies_len = bcn->tail_len;
+	const u8 *ies = bcn->tail;
 	const u8 *rates;
 	const u8 *cap;
 
-- 
2.9.5
