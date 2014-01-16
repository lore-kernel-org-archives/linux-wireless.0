Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:35777 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaAPOAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 09:00:55 -0500
Received: by mail-la0-f44.google.com with SMTP id hm7so258873lab.31
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 06:00:51 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Reset split_start when netlink skb is exhausted
Date: Thu, 16 Jan 2014 15:00:40 +0100
Message-Id: <1389880840-27863-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20140116_150058_499267_681087E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the netlink skb is exhausted split_start is left set. In the
subsequent retry, with a larger buffer, the dump is continued from the
failing point instead of from the beginning.

This was causing my rt28xx based USB dongle to now show up when
running "iw list" with an old iw version without split dump support.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0afd82..c7ce4c7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1725,6 +1725,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 				    !skb->len &&
 				    cb->min_dump_alloc < 4096) {
 					cb->min_dump_alloc = 4096;
+					state->split_start = 0;
 					rtnl_unlock();
 					return 1;
 				}
-- 
1.8.3.2

