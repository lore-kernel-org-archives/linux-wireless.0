Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0LVJPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 04:15:37 -0500
Subject: [PATCH] mac80211: remove stray extern
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 10:15:52 +0100
Message-ID: <1293009352.3531.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Somehow this snuck into my earlier patch, and
only now did I see a compiler warning:

net/mac80211/led.c:218:13: warning: function '__ieee80211_create_tpt_led_trigger' with external linkage has definition

Remove the stray extern.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/led.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/led.c	2010-12-22 09:57:09.000000000 +0100
+++ wireless-testing/net/mac80211/led.c	2010-12-22 10:06:05.000000000 +0100
@@ -215,8 +215,8 @@ static void tpt_trig_timer(unsigned long
 	read_unlock(&tpt_trig->trig.leddev_list_lock);
 }
 
-extern char *__ieee80211_create_tpt_led_trigger(
-				struct ieee80211_hw *hw, unsigned int flags,
+char *__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
+				unsigned int flags,
 				const struct ieee80211_tpt_blink *blink_table,
 				unsigned int blink_table_len)
 {


