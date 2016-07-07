Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33005 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912AbcGFXIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 19:08:49 -0400
Received: by mail-oi0-f65.google.com with SMTP id w141so193776oia.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 16:08:49 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 4/5] core: Notify when wireless netdev is removed
Date: Thu,  7 Jul 2016 02:08:49 -0500
Message-Id: <1467875330-7835-5-git-send-email-denkenz@gmail.com> (sfid-20160707_010857_211671_2698CB96)
In-Reply-To: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 net/wireless/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7758c0f..d35038b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1159,6 +1159,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * remove and clean it up.
 		 */
 		if (!list_empty(&wdev->list)) {
+			nl80211_notify_iface(rdev, wdev,
+						NL80211_CMD_DEL_INTERFACE);
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_rcu(&wdev->list);
 			rdev->devlist_generation++;
-- 
2.7.3

