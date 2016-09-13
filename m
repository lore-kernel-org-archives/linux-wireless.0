Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36856 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751473AbcIMOp1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 10:45:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] nl80211: fix connect keys range check
Date: Tue, 13 Sep 2016 16:44:24 +0200
Message-Id: <1473777868-32429-2-git-send-email-johannes@sipsolutions.net> (sfid-20160913_164727_164732_5AE5F00F)
In-Reply-To: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
References: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only key index 0-3 should be accepted, 4/5 are for IGTKs and
cannot be used as connect keys. Fix the range checking to not
allow such erroneous configurations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c96e22b906af..6fe14b5d1af3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -866,7 +866,7 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
 		err = -EINVAL;
 		if (!parse.p.key)
 			goto error;
-		if (parse.idx < 0 || parse.idx > 4)
+		if (parse.idx < 0 || parse.idx > 3)
 			goto error;
 		if (parse.def) {
 			if (def)
-- 
2.8.1
