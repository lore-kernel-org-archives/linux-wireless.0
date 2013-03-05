Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3CEKFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 05:05:41 -0500
Message-ID: <1362477938.8224.1.camel@jlt4.sipsolutions.net> (sfid-20130305_110544_270489_A68C8CA4)
Subject: [PATCH] nl80211/compat: netlink_callback min_dump_alloc only exists
 since 3.1
From: Johannes Berg <johannes@sipsolutions.net>
To: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 05 Mar 2013 11:05:38 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On older kernels, we can't do this workaround, so if you use
an old 64-bit kernel with compat you'd better upgrade.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/0006-disable-dump-adjust-on-old-kernels.patch | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 patches/0006-disable-dump-adjust-on-old-kernels.patch

diff --git a/patches/0006-disable-dump-adjust-on-old-kernels.patch b/patches/0006-disable-dump-adjust-on-old-kernels.patch
new file mode 100644
index 0000000..1712b6a
--- /dev/null
+++ b/patches/0006-disable-dump-adjust-on-old-kernels.patch
@@ -0,0 +1,18 @@
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -1333,6 +1333,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
+ 					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
+ 					 dev);
+ 		if (ret < 0) {
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0)
+ 			/*
+ 			 * If sending the wiphy data didn't fit (ENOBUFS or
+ 			 * EMSGSIZE returned), this SKB is still empty (so
+@@ -1352,6 +1353,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
+ 				mutex_unlock(&cfg80211_mutex);
+ 				return 1;
+ 			}
++#endif
+ 			idx--;
+ 			break;
+ 		}
-- 
1.8.0



