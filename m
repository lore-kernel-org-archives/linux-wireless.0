Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59492 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733000AbeHWMRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 08:17:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] netlink: add nl_set_extack_cookie_u64()
Date: Thu, 23 Aug 2018 10:48:13 +0200
Message-Id: <20180823084813.5727-1-johannes@sipsolutions.net> (sfid-20180823_105758_022800_F1BBA367)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add a helper function nl_set_extack_cookie_u64() to use a u64 as
the netlink extended ACK cookie, to avoid having to open-code it
in any users of the cookie.

A u64 should be sufficient for most subsystems though we allow
for up to 20 bytes right now. This also matches the cookies in
nl80211 where I intend to use this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/netlink.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 71f121b66ca8..dc3c21dc4ba2 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -110,6 +110,15 @@ struct netlink_ext_ack {
 	}						\
 } while (0)
 
+static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
+					    u64 cookie)
+{
+	u64 __cookie = cookie;
+
+	memcpy(extack->cookie, &__cookie, sizeof(__cookie));
+	extack->cookie_len = sizeof(__cookie);
+}
+
 extern void netlink_kernel_release(struct sock *sk);
 extern int __netlink_change_ngroups(struct sock *sk, unsigned int groups);
 extern int netlink_change_ngroups(struct sock *sk, unsigned int groups);
-- 
2.14.4
