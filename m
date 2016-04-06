Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35638 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbcDFOXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:23:22 -0400
Received: by mail-lf0-f41.google.com with SMTP id c126so35156021lfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 07:23:21 -0700 (PDT)
Received: from di ([80.233.186.214])
        by smtp.gmail.com with ESMTPSA id mi9sm475148lbc.27.2016.04.06.07.23.19
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 06 Apr 2016 07:23:19 -0700 (PDT)
Date: Wed, 6 Apr 2016 17:23:18 +0300
From: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] Check protocol number in nl80211 netlink socket release
 notification handler.
Message-Id: <20160406172318.f6fec91145578157c500737c@ubnt.com> (sfid-20160406_162324_890477_45237117)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch corrects the problem where non-privileged user can create
netlink socket with the same port_id as used by hostapd but different
protocol number. Upon close() or process termination, a notification is
sent  to nl80211 subsystem which will destroy virtual wireless network
interfaces created by hostapd like it just died but in fact hostapd is
still running. This is possible because port_id is unique within particular
protocol number only.

Fixes: 026331c4d9b5 ("cfg80211/mac80211: allow registering for and sending action frames")
Signed-off-by: Dmitry Ivanov <dima@ubnt.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 98c9242..056a730 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13216,7 +13216,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 	struct wireless_dev *wdev;
 	struct cfg80211_beacon_registration *reg, *tmp;
 
-	if (state != NETLINK_URELEASE)
+	if (state != NETLINK_URELEASE || notify->protocol != NETLINK_GENERIC)
 		return NOTIFY_DONE;
 
 	rcu_read_lock();
-- 
2.1.4

