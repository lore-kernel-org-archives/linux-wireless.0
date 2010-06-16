Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37248 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0FPUtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 16:49:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: backport netdev->br_port
Date: Wed, 16 Jun 2010 22:49:26 +0200
Message-Id: <1276721366-8054-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit f350a0a87374418635689471606454abc7beaa3a the br_port
attribute was replaced with a private flag.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/30-br-port-backport.patch |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 patches/30-br-port-backport.patch

diff --git a/patches/30-br-port-backport.patch b/patches/30-br-port-backport.patch
new file mode 100644
index 0000000..bb2491e
--- /dev/null
+++ b/patches/30-br-port-backport.patch
@@ -0,0 +1,31 @@
+In commit f350a0a87374418635689471606454abc7beaa3a the br_port
+attribute was replaced with a private flag.
+
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -1109,7 +1109,11 @@ static int nl80211_valid_4addr(struct cf
+ 			       enum nl80211_iftype iftype)
+ {
+ 	if (!use_4addr) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		if (netdev && (netdev->priv_flags & IFF_BRIDGE_PORT))
++#else
++		if (netdev && netdev->br_port)
++#endif
+ 			return -EBUSY;
+ 		return 0;
+ 	}
+--- a/net/wireless/util.c
++++ b/net/wireless/util.c
+@@ -770,7 +770,11 @@ int cfg80211_change_iface(struct cfg8021
+ 		return -EOPNOTSUPP;
+ 
+ 	/* if it's part of a bridge, reject changing type to station/ibss */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	if ((dev->priv_flags & IFF_BRIDGE_PORT) &&
++#else
++	if (dev->br_port &&
++#endif
+ 	    (ntype == NL80211_IFTYPE_ADHOC || ntype == NL80211_IFTYPE_STATION))
+ 		return -EBUSY;
+ 
-- 
1.7.0.4

