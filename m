Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37294 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754885AbcIMPbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 11:31:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] nl80211: only allow WEP keys during connect command
Date: Tue, 13 Sep 2016 16:44:25 +0200
Message-Id: <1473777868-32429-3-git-send-email-johannes@sipsolutions.net> (sfid-20160913_173154_401002_53285AFB)
In-Reply-To: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
References: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was already documented that way in nl80211.h, but the
parsing code still accepted other key types. Change it to
really only accept WEP keys as documented.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6fe14b5d1af3..739d0a780d83 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -881,16 +881,19 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
 						     parse.idx, false, NULL);
 		if (err)
 			goto error;
+		if (parse.p.cipher != WLAN_CIPHER_SUITE_WEP40 &&
+		    parse.p.cipher != WLAN_CIPHER_SUITE_WEP104) {
+			err = -EINVAL;
+			goto error;
+		}
 		result->params[parse.idx].cipher = parse.p.cipher;
 		result->params[parse.idx].key_len = parse.p.key_len;
 		result->params[parse.idx].key = result->data[parse.idx];
 		memcpy(result->data[parse.idx], parse.p.key, parse.p.key_len);
 
-		if (parse.p.cipher == WLAN_CIPHER_SUITE_WEP40 ||
-		    parse.p.cipher == WLAN_CIPHER_SUITE_WEP104) {
-			if (no_ht)
-				*no_ht = true;
-		}
+		/* must be WEP key if we got here */
+		if (no_ht)
+			*no_ht = true;
 	}
 
 	return result;
-- 
2.8.1
