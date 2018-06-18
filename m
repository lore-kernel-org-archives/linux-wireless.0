Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.neomailbox.net ([5.148.176.60]:15608 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752890AbeFREVF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 00:21:05 -0400
From: Antonio Quartulli <a@unstable.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Antonio Quartulli <a@unstable.cc>
Subject: [PATCH] iw: print 4ADDR attribute when dumping interface
Date: Mon, 18 Jun 2018 12:20:47 +0800
Message-Id: <20180618042047.30608-1-a@unstable.cc> (sfid-20180618_062109_246967_5C9D2E9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print the value of the 4ADDr attribute when dumping the interface
status.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 interface.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/interface.c b/interface.c
index 712bbdc..678955d 100644
--- a/interface.c
+++ b/interface.c
@@ -447,6 +447,11 @@ static int print_iface_handler(struct nl_msg *msg, void *arg)
 		printf("%s\tmulticast TXQ:%s\n", indent, buf);
 	}
 
+	if (tb_msg[NL80211_ATTR_4ADDR]) {
+		uint8_t use_4addr = nla_get_u8(tb_msg[NL80211_ATTR_4ADDR]);
+		printf("%s\t4addr: %d\n", indent, use_4addr);
+	}
+
 	return NL_SKIP;
 }
 
-- 
2.17.1
