Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38717 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbbJON7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:59:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/12] cfg80211: reg: fix reg_ignore_cell_hint return type
Date: Thu, 15 Oct 2015 15:58:23 +0200
Message-Id: <1444917503-19118-12-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155913_185366_7D08D5C2)
In-Reply-To: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
References: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The return type should be enum reg_request_treatment for both
branches of the #ifdef.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ef327236e0f0..c8f43a8f850b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1353,7 +1353,8 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 	return !(wiphy->features & NL80211_FEATURE_CELL_BASE_REG_HINTS);
 }
 #else
-static int reg_ignore_cell_hint(struct regulatory_request *pending_request)
+static enum reg_request_treatment
+reg_ignore_cell_hint(struct regulatory_request *pending_request)
 {
 	return REG_REQ_IGNORE;
 }
-- 
2.5.1

