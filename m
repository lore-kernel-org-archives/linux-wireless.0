Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:16584 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592AbXCWTWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 15:22:03 -0400
Received: by nf-out-0910.google.com with SMTP id o25so2156552nfa
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2007 12:22:01 -0700 (PDT)
To: Jiri Benc <jbenc@suse.cz>, "Linville"@poseidon.kernel.org,
	"John" <linville@tuxdriver.com>
Subject: [PATCH v2] mac80211: Prevent unregistering of unregistered hw
Date: Fri, 23 Mar 2007 20:21:25 +0100
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703232021.26462.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the moment it is possible to call ieee80211_unregister_hw()
for an unregistered hw structure. This will cause a big panic.
This patch will add a BUG_ON() line to warn about this situation.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..e7a613d 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4765,6 +4765,9 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	/* TODO: skb_queue should be empty here, no need to do anything? */
 
 	rtnl_lock();
+
+	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
+
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
 	if (local->apdev)
 		ieee80211_if_del_mgmt(local);
