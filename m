Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44529 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0KRFqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 00:46:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 21:46:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <mark@moxienet.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] cfg80211: put core regulatory request into queue
Date: Wed, 17 Nov 2010 21:46:06 -0800
Message-ID: <1290059169-2468-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will simplify the synchronization for pending requests.
Without this we have a race between the core and when we
restore regulatory settings, although this is unlikely
its best to just avoid that race altogether.

Cc: Mark Mentovai <mark@moxienet.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3be18d9..9830db6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1530,12 +1530,7 @@ static int regulatory_hint_core(const char *alpha2)
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_CORE;
 
-	/*
-	 * This ensures last_request is populated once modules
-	 * come swinging in and calling regulatory hints and
-	 * wiphy_apply_custom_regulatory().
-	 */
-	reg_process_hint(request);
+	queue_regulatory_request(request);
 
 	return 0;
 }
-- 
1.7.3.2.90.gd4c43

