Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34361 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755789AbcHYUq1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 16:46:27 -0400
Received: by mail-oi0-f68.google.com with SMTP id t127so5481205oie.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 13:44:42 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH] nl80211: Fix unfiltered GET_INTERFACE dumps
Date: Thu, 25 Aug 2016 15:44:44 -0500
Message-Id: <1472157884-3174-1-git-send-email-denkenz@gmail.com> (sfid-20160825_224636_108212_521AFE0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dump_wiphy_parse only assigns filter_wiphy if one of the supported
NL80211 attributes is present.  So for unfiltered dumps, filter_wiphy
was always initialized to 0, and only interface 0 was dumped.

This was introduced in commit 2d75da13fbb957e955d212555b91101cef36f0ce.

Reported-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 95d55d2..ddc994a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2534,6 +2534,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 		struct nl80211_dump_wiphy_state state = {};
 		int ret;
 
+		state.filter_wiphy = -1;
 		ret = nl80211_dump_wiphy_parse(skb, cb, &state);
 		if (ret)
 			return ret;
-- 
2.7.3
