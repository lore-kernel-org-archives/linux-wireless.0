Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab3J1OIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:08:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] nl80211: check nla_nest_start() return value
Date: Mon, 28 Oct 2013 15:08:23 +0100
Message-Id: <1382969304-25611-3-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150835_733455_BF321ADE)
In-Reply-To: <1382969304-25611-1-git-send-email-johannes@sipsolutions.net>
References: <1382969304-25611-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Coverity pointed out that we might dereference NULL later
if nla_nest_start() returns a failure. This isn't really
true since we'd bomb out before, but we should check the
return value directly, so do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 22df144..99dc3f3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11094,6 +11094,8 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 		struct nlattr *reasons;
 
 		reasons = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
+		if (!reasons)
+			goto free_msg;
 
 		if (wakeup->disconnect &&
 		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_DISCONNECT))
-- 
1.8.4.rc3

