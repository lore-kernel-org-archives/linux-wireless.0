Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63488 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308Ab1ELRJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 13:09:52 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 10:09:23 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] mac80211: cancel scan_work in ieee80211_unregister_hw
Date: Thu, 12 May 2011 22:39:48 +0530
Message-ID: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com> (sfid-20110512_190956_234715_5927071F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

scan_work is never stopped if the device was unplugged during
s/w scan.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 30e6a68..d2aa0be 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -964,6 +964,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	unregister_inetaddr_notifier(&local->ifa_notifier);
 #endif
 
+	cancel_delayed_work_sync(&local->scan_work);
+
 	rtnl_lock();
 
 	/*
-- 
1.7.5.1

