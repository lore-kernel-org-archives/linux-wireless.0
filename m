Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0047.outbound.protection.outlook.com ([104.47.42.47]:25312
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750761AbdH3Uwc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 16:52:32 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com
Subject: [PATCH] nl80211: look for HT/VHT capabilities in beacon's tail
Date: Wed, 30 Aug 2017 13:52:25 -0700
Message-Id: <20170830205225.17228-1-igor.mitsyanko.os@quantenna.com> (sfid-20170830_225237_473549_D1647CAE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

There are no HT/VHT capabilities in cfg80211_ap_settings::beacon_ies,
these should be looked for in beacon's tail instead.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---

This is true for hostapd (at least the one in mainline): it does not
include HT/VHT caps and WLAN_EID_SUPP_RATES into beacon_ies.
But worth noting that there is no clear documentation that I could find
on what IEs could and could not be included into beacon_ies.

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
