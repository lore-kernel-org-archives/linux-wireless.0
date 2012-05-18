Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50902 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2EUTMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 15:12:33 -0400
Received: by lbbgp10 with SMTP id gp10so314477lbb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 12:12:32 -0700 (PDT)
From: Gary Morain <gmorain@chromium.org>
Date: Fri, 18 May 2012 13:49:36 -0700
Subject: [PATCH] CHROMIUMOS: mac80211: Increase retry attempts for nullfunc
 probes
To: linux-wireless@vger.kernel.org
Cc: pstew@chromium.org
Message-Id: <20120521190547.3E23A8061C@gary-pc2.mtv.corp.google.com> (sfid-20120521_211238_622219_A4B464A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a nullfunc probe fails for lack of an ACK, it is retried
almost immediately.  The current setting of 2 retries completes
in about 4 ms.  If an AP is off-channel scanning, this is not
enough time for the AP to return to the operating channel and
ACK the nullfunc.  As a result, the client disconnects when the
AP is still there and operating.

Signed-off-by: Gary Morain <gmorain@chromium.org>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dbd4bd9..dd1d901 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -36,7 +36,7 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 
-static int max_nullfunc_tries = 2;
+static int max_nullfunc_tries = 100;
 module_param(max_nullfunc_tries, int, 0644);
 MODULE_PARM_DESC(max_nullfunc_tries,
 		 "Maximum nullfunc tx tries before disconnecting (reason 4).");
-- 
1.7.7.3

