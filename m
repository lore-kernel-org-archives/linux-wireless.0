Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53973 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3LSUxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 15:53:35 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so1665181pbb.28
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 12:53:34 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux@eikelenboom.it, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
Date: Thu, 19 Dec 2013 12:53:18 -0800
Message-Id: <1387486399-4053-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131219_215337_892186_ABFD3853)
In-Reply-To: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows processing of the last regulatory request when
we determine its still pending. This fixes the issue reported
by Sander of when cfg80211 is built-in and no further regulatory
domain processing can happen. This occurred because if the
filesystem was not mounted upon kicking off the udev rule
to run CRDA then the last request will always be left
unprocessed.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5be2d7c..ecf364e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1737,7 +1737,7 @@ static void reg_process_pending_hints(void)
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
+		reg_process_hint(lr);
 		return;
 	}
 
-- 
1.8.4.3

