Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18882 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZG0Pi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:38:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 08:38:27 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: do not queue work after suspend in the dynamic ps timer
Date: Mon, 27 Jul 2009 08:38:25 -0700
Message-ID: <1248709105-12722-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f60a831..ee83125 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -760,7 +760,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
 
-	if (local->quiescing)
+	if (local->quiescing || local->suspended)
 		return;
 
 	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
-- 
1.6.3.3

