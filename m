Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXCWUJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:09:46 -0400
Subject: [PATCH] mac80211: BUG_ON unregistering unregistered device
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070323183652.1f472f7e@griffin.suse.cz>
References: <200703091614.04526.IvDoorn@gmail.com>
	 <200703091646.05292.mb@bu3sch.de> <200703091730.06796.IvDoorn@gmail.com>
	 <1174559874.3944.83.camel@johannes.berg>
	 <20070323183652.1f472f7e@griffin.suse.cz>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 21:08:31 +0100
Message-Id: <1174680511.4470.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a BUG_ON when you unregister a device that wasn't registered.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Applies on top of Michael's tasklet fixes or something. Maybe applies
anyway, fuzz should be minimal in any case.

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-23 21:07:00.354239808 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-23 21:07:33.184239808 +0100
@@ -4729,6 +4729,8 @@ void ieee80211_unregister_hw(struct ieee
 	struct ieee80211_sub_if_data *sdata, *tmp;
 	int i;
 
+	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
+
 	tasklet_disable(&local->tasklet);
 	/* TODO: skb_queue should be empty here, no need to do anything? */
 


