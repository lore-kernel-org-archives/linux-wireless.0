Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:3193 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992839AbXCIPOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 10:14:19 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1104331nfa
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2007 07:14:18 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Prevent unregistering of unregistered hw
Date: Fri, 9 Mar 2007 16:14:04 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703091614.04526.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the moment it is possible to call ieee80211_unregister_hw()
for an unregistered hw structure. This will cause a big panic.
This patch will add a check to check if IEEE80211_DEV_REGISTERED
has been set before attempting to unregister hw.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..7494280 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4765,6 +4765,12 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	/* TODO: skb_queue should be empty here, no need to do anything? */
 
 	rtnl_lock();
+
+	if (local->reg_state != IEEE80211_DEV_REGISTERED) {
+		rtnl_unlock();
+		return;
+	}
+
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
 	if (local->apdev)
 		ieee80211_if_del_mgmt(local);
