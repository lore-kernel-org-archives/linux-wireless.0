Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZGYArf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 20:47:35 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: do not queue work after suspend in the dynamic ps timer
Date: Fri, 24 Jul 2009 20:47:32 -0400
Message-Id: <1248482853-17032-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
References: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes this warning during suspend <--> resume:

WARNING: at net/mac80211/util.c:511 ieee80211_queue_work+0x3a/0x40 [mac80211]()
Hardware name: 6460DWU
queueing ieee80211 work while going to suspend
Modules linked in: <--snip-->
Pid: 0, comm: swapper Not tainted 2.6.31-rc3-wl #4
Call Trace:
 <IRQ>  [<ffffffffa0139d0a>] ? ieee80211_queue_work+0x3a/0x40 [mac80211]
 [<ffffffff810552b8>] warn_slowpath_common+0x78/0xd0
 [<ffffffffa012a580>] ? ieee80211_dynamic_ps_timer+0x0/0x30 [mac80211]
 [<ffffffff81055394>] warn_slowpath_fmt+0x64/0x70
 [<ffffffff810188a9>] ? sched_clock+0x9/0x10
 [<ffffffff8107800c>] ? getnstimeofday+0x5c/0xf0
 [<ffffffff810188a9>] ? sched_clock+0x9/0x10
 [<ffffffff81074625>] ? sched_clock_cpu+0x75/0x240
 [<ffffffffa0139d0a>] ieee80211_queue_work+0x3a/0x40 [mac80211]
 [<ffffffffa012a59c>] ieee80211_dynamic_ps_timer+0x1c/0x30 [mac80211]
 ... etc

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a9d717e..98df70d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -760,7 +760,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
 
-	if (local->quiescing)
+	if (local->quiescing || local->suspended)
 		return;
 
 	ieee80211_queue_work(&local->hw, &local->dynamic_ps_enable_work);
-- 
1.6.0.4

