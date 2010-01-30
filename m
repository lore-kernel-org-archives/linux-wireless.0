Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0A3A66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 19:58:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] cfg80211: avoid flushing the global workqueue for core reg hints
Date: Fri, 29 Jan 2010 19:58:56 -0500
Message-Id: <1264813137-4478-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1264813137-4478-1-git-send-email-lrodriguez@atheros.com>
References: <1264813137-4478-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cfg80211 starts it will send a core regulatory hint. This is
sent to the global workqueue but we force processing of it by
flushing the global workqueue. The flushing was done since
cfg80211 needs last_request to always be populated.

Avoid flushing the global workqueue by processing the work
required immediately instead of putting it into a linked
list and processing it after the flush.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5f8071d..5dcda28 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1920,14 +1920,12 @@ static int regulatory_hint_core(const char *alpha2)
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_CORE;
 
-	queue_regulatory_request(request);
-
 	/*
 	 * This ensures last_request is populated once modules
 	 * come swinging in and calling regulatory hints and
 	 * wiphy_apply_custom_regulatory().
 	 */
-	flush_scheduled_work();
+	reg_process_hint(request);
 
 	return 0;
 }
-- 
1.6.3.3

