Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55261 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbeBBPcL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 10:32:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Martin Sebor <msebor@gcc.gnu.org>, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        =?UTF-8?q?Peter=20Gro=C3=9Fe?= <pegro@friiks.de>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Benjamin Berg <benjamin@sipsolutions.net>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211: fix cfg80211_beacon_dup
Date: Fri,  2 Feb 2018 16:31:23 +0100
Message-Id: <20180202153142.1142229-1-arnd@arndb.de> (sfid-20180202_163240_065420_972E2EE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc-8 warns about some obviously incorrect code:

net/mac80211/cfg.c: In function 'cfg80211_beacon_dup':
net/mac80211/cfg.c:2896:3: error: 'memcpy' source argument is the same as destination [-Werror=restrict]

>From the context, I conclude that we want to copy from beacon into
new_beacon, as we do in the rest of the function.

Cc: stable@vger.kernel.org
Fixes: 73da7d5bab79 ("mac80211: add channel switch command and beacon callbacks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46028e12e216..f4195a0f0279 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2892,7 +2892,7 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	}
 	if (beacon->probe_resp_len) {
 		new_beacon->probe_resp_len = beacon->probe_resp_len;
-		beacon->probe_resp = pos;
+		new_beacon->probe_resp = pos;
 		memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
 		pos += beacon->probe_resp_len;
 	}
-- 
2.9.0
