Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:35299 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZGWKOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:14:20 -0400
Received: by mail-bw0-f228.google.com with SMTP id 28so709536bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:14:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 7/7] cfg80211: increase scan result expire time
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jul 2009 12:14:29 +0200
Message-ID: <20090723101428.5147.53956.stgit@localhost.localdomain>
In-Reply-To: <20090723100732.5147.73989.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using background scanning in mac80211 the time a scan needs to
finish can exceed 10 seconds. Hence, increase the scan results
expire time to 15 seconds which should be sufficient.
    
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/wireless/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 4ad8b4b..0850b98 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -15,7 +15,7 @@
 #include "core.h"
 #include "nl80211.h"
 
-#define IEEE80211_SCAN_RESULT_EXPIRE	(10 * HZ)
+#define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
 
 void __cfg80211_scan_done(struct work_struct *wk)
 {

