Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36838 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbcGFXIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 19:08:45 -0400
Received: by mail-oi0-f66.google.com with SMTP id m11so175179oik.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 16:08:40 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 5/5] nl80211: Emit DEL_INTERFACE only in special cases
Date: Thu,  7 Jul 2016 02:08:50 -0500
Message-Id: <1467875330-7835-6-git-send-email-denkenz@gmail.com> (sfid-20160707_010856_560340_CB72F6E9)
In-Reply-To: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For wireless device objects with an associated netdev, the DEL_INTERFACE
event is generated inside the netdev notifier.  The event is generated
regardless of whether it was due to a NL80211_CMD_DEL_INTERFACE call
from userspace or if the netdev was destroyed by other means.

If NL80211_CMD_DEL_INTERFACE handler is called, then a duplicate
DEL_INTERFACE event will be multicast.  This change modifies the logic
inside nl80211_del_interface to avoid this.
---
 net/wireless/nl80211.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ec8eb88..a65c271 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2913,7 +2913,17 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_virtual_intf)
 		return -EOPNOTSUPP;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	/*
+	 * For wdevs which have no associated netdev object (e.g. of type
+	 * NL80211_IFTYPE_P2P_DEVICE), emit the DEL_INTERFACE event here.
+	 * For all other types, the event will be generated from the
+	 * netdev notifier
+	 */
+	if (!wdev->netdev)
+		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	else
+		msg = NULL;
+
 	if (msg && nl80211_send_iface(msg, 0, 0, 0, rdev, wdev, true) < 0) {
 		nlmsg_free(msg);
 		msg = NULL;
-- 
2.7.3

