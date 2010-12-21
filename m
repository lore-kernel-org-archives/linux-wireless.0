Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:62890 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0LUOCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 09:02:54 -0500
From: luciano.coelho@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: check for CONFIG_MAC80211_LEDS in the tpt_led_trigger declaration
Date: Tue, 21 Dec 2010 16:02:17 +0200
Message-Id: <1292940137-21850-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

If CONFIG_MAC80211_LEDS is not set, ieee80211_i.h was failing to compile,
because struct led_trigger is only declared when CONFIG_LEDS_TRIGGERS is
set.

This patch adds ifdefs around the tpt_led_trigger declaration in
ieee80211_i.h to avoid the problem.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0817ec6..7541d42 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -631,6 +631,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 };
 
+#ifdef CONFIG_MAC80211_LEDS
 struct tpt_led_trigger {
 	struct led_trigger trig;
 	char name[32];
@@ -642,6 +643,7 @@ struct tpt_led_trigger {
 	unsigned int active, want;
 	bool running;
 };
+#endif
 
 /**
  * mac80211 scan flags - currently active scan mode
-- 
1.7.0.4

