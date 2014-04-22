Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60700 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbaDVDjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 23:39:53 -0400
Received: by mail-pd0-f176.google.com with SMTP id r10so4368660pdi.35
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 20:39:53 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, lkml20140418@newton.leun.net,
	arik@wizery.com, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 2/2] cfg80211: fix processing world regdomain when non modular
Date: Mon, 21 Apr 2014 20:39:35 -0700
Message-Id: <1398137975-14275-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20140422_054000_236315_8D306BAF)
In-Reply-To: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

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
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 081c571..625c41e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1912,7 +1912,7 @@ static void reg_process_pending_hints(void)
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
+		reg_process_hint(lr);
 		return;
 	}
 
-- 
1.9.0

