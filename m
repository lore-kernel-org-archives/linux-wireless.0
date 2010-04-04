Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64705 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab0DDKMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 06:12:50 -0400
Received: by fxm27 with SMTP id 27so371719fxm.28
        for <linux-wireless@vger.kernel.org>; Sun, 04 Apr 2010 03:12:48 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] mac80211: fix ieee80211_meshconf_ie::meshconf_cap type to be u16
Date: Sun,  4 Apr 2010 14:12:44 +0400
Message-Id: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the current 802.11s draft mesh capability field
is 16 bits wide.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 include/linux/ieee80211.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1998495..910b4bc 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -604,7 +604,7 @@ struct ieee80211_meshconf_ie {
 	u8 meshconf_synch;
 	u8 meshconf_auth;
 	u8 meshconf_form;
-	u8 meshconf_cap;
+	u16 meshconf_cap;
 } __attribute__ ((packed));
 
 /**
-- 
1.6.2.5

