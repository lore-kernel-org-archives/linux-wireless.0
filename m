Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:43602 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752101AbeEUPbe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 11:31:34 -0400
Received: by mail-ot0-f193.google.com with SMTP id y10-v6so17288013otg.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 08:31:34 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH] nl80211: Optimize cfg80211_bss_expire invocations
Date: Mon, 21 May 2018 10:31:13 -0500
Message-Id: <20180521153113.8442-1-denkenz@gmail.com> (sfid-20180521_173138_185226_88D6681C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only invoke cfg80211_bss_expire on the first nl80211_dump_scan
invocation to avoid (likely) redundant processing.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/nl80211.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ff28f8feeb09..7458cbcf00b2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7930,7 +7930,15 @@ static int nl80211_dump_scan(struct sk_buff *skb, struct netlink_callback *cb)
 
 	wdev_lock(wdev);
 	spin_lock_bh(&rdev->bss_lock);
-	cfg80211_bss_expire(rdev);
+
+	/*
+	 * dump_scan will be called multiple times to break up the scan results
+	 * into multiple messages.  It is unlikely that any more bss-es will be
+	 * expired after the first call, so only call only call this on the
+	 * first dump_scan invocation.
+	 */
+	if (start == 0)
+		cfg80211_bss_expire(rdev);
 
 	cb->seq = rdev->bss_generation;
 
-- 
2.13.5
