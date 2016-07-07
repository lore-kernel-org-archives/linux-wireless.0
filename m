Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34799 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890AbcGFXIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 19:08:38 -0400
Received: by mail-oi0-f67.google.com with SMTP id s17so187813oih.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 16:08:38 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 2/5] core: Notify of new wireless netdevs
Date: Thu,  7 Jul 2016 02:08:47 -0500
Message-Id: <1467875330-7835-3-git-send-email-denkenz@gmail.com> (sfid-20160707_010854_800753_CCC40313)
In-Reply-To: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 net/wireless/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7645e97..7758c0f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1079,6 +1079,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 			dev->priv_flags |= IFF_DONT_BRIDGE;
+
+		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 		break;
 	case NETDEV_GOING_DOWN:
 		cfg80211_leave(rdev, wdev);
-- 
2.7.3

