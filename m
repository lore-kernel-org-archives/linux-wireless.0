Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:34033 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab0F2Kux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 06:50:53 -0400
From: Yuri Ershov <ext-yuri.ershov@nokia.com>
To: johannes@sipsolutions.net
Cc: ext-yuri.kululin@nokia.com, linux-wireless@vger.kernel.org
Subject: [RFC 3/3] cfg80211: Update of regulatory request initiator handling
Date: Tue, 29 Jun 2010 15:08:08 +0400
Message-Id: <cf988b7054a5c2449b2824c628c7bd3a5ac82ee4.1277808543.git.ext-yuri.ershov@nokia.com>
In-Reply-To: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
References: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
In-Reply-To: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
References: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases there could be possible dereferencing freed pointer. The
update is intended to avoid this issue.

Signed-off-by: Yuri Ershov <ext-yuri.ershov@nokia.com>
---
 net/wireless/reg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ac2bdd..9ee2be9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1831,6 +1831,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 {
 	int r = 0;
 	struct wiphy *wiphy = NULL;
+	enum nl80211_reg_initiator initiator = reg_request->initiator;
 
 	BUG_ON(!reg_request->alpha2);
 
@@ -1850,7 +1851,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	/* This is required so that the orig_* parameters are saved */
 	if (r == -EALREADY && wiphy &&
 	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
-		wiphy_update_regulatory(wiphy, reg_request->initiator);
+		wiphy_update_regulatory(wiphy, initiator);
 out:
 	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
-- 
1.7.0.4

