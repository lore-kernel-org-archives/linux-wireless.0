Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34433 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaDUEzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:19 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so3330026pab.41
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:19 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 09/12] cfg80211: change return value of notifier function
Date: Mon, 21 Apr 2014 12:53:04 +0800
Message-Id: <a2f03499a7cc33a86a7454e9824bf803f75d1916.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065559_680852_283E514A)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return NOTIFY_DONE if we don't care this time's notification, return
NOTIFY_OK if we successfully handled this time's notification. That's
the formal way to do it.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/core.c    | 4 +++-
 net/wireless/nl80211.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8045ef9..7ceb5dd 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1004,9 +1004,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
 		break;
+	default:
+		return NOTIFY_DONE;
 	}
 
-	return NOTIFY_DONE;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block cfg80211_netdev_notifier = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6550e20..fce423a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11672,7 +11672,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	rcu_read_unlock();
 
-	return NOTIFY_DONE;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block nl80211_netlink_notifier = {
-- 
1.9.0

