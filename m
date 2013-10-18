Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63263 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3JRV7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 17:59:25 -0400
Received: by mail-pa0-f44.google.com with SMTP id fb1so2788005pad.17
        for <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 14:59:25 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: fix uninitialized variable
Date: Fri, 18 Oct 2013 14:57:00 -0700
Message-Id: <1382133420-1545-1-git-send-email-michal.kazior@tieto.com> (sfid-20131018_235929_719538_E4CEAF02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CSA completion could call in a driver
bss_info_changed() with a garbled `changed` flag
leading to all sorts of problems.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 629dee7..fd1f6d1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2860,7 +2860,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
-	int err, changed;
+	int err, changed = 0;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
-- 
1.8.4.rc3

