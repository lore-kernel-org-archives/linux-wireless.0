Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0ADQhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 11:37:39 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] cfg80211: fix syntax error on user regulatory hints
Date: Mon,  4 Jan 2010 11:37:39 -0500
Message-Id: <1262623059-6216-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a syntax error when setting up the user regulatory
hint. This change yields the same exact binary object though
so it ends up just being a syntax typo fix, fortunately.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 87ea60d..80930bb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1685,7 +1685,7 @@ int regulatory_hint_user(const char *alpha2)
 	request->wiphy_idx = WIPHY_IDX_STALE;
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
-	request->initiator = NL80211_REGDOM_SET_BY_USER,
+	request->initiator = NL80211_REGDOM_SET_BY_USER;
 
 	queue_regulatory_request(request);
 
-- 
1.6.3.3

