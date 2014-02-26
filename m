Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44035 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaBZBKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 20:10:00 -0500
Received: by mail-pa0-f50.google.com with SMTP id kp14so221367pab.9
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 17:10:00 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
Date: Tue, 25 Feb 2014 17:09:41 -0800
Message-Id: <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_021008_484306_AEEDC8EC)
In-Reply-To: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows processing of the last regulatory request when
we determine its still pending. Without this if a regulatory
request failed to get processed by userspace we wouldn't
be able to re-process it later. An example situation that can
lead to an unprocessed last_request is enabling cfg80211 to
be built-in to the kernel, not enabling CFG80211_INTERNAL_REGDB
and the CRDA binary not being available at the time the udev
rule that kicks of CRDA triggers.

In such a situation we want to let some cfg80211 triggers
eventually kick CRDA for us again. Without this if the first
cycle attempt to kick off CRDA failed we'd be stuck without
the ability to change process any further regulatory domains.

cfg80211 will trigger re-processing of the regulatory queue
whenever schedule_work(&reg_work) is called, currently this
happens when:

  * suspend / resume
  * disconnect
  * a beacon hint gets triggered (non DFS 5 GHz AP found)
  * a regulatory request gets added to the queue

We don't have any specific opportunistic late boot triggers
to address a late mount of where CRDA resides though, adding
that should be done separately through another patch.
Without an opportunistic fix then this fix relies at least
one of the triggeres above to happen.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f5b120f..7203b74 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1857,7 +1857,7 @@ static void reg_process_pending_hints(void)
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
+		reg_process_hint(lr);
 		return;
 	}
 
-- 
1.8.5.3

