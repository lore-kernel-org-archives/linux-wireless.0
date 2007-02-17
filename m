Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946350AbXBQArm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 19:47:42 -0500
Subject: [PATCH] fix cfg80211 modular compile w/o wext-compat
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1171659366.3575.27.camel@johannes.berg>
References: <1171659366.3575.27.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 01:47:32 +0100
Message-Id: <1171673252.31890.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The static inlines that are supposed to be used w/o wext-compat to init
wext-compat were done with the wrong #ifdef. This fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
or rather, this fixes it.

--- wireless-dev.orig/net/wireless/wext.h	2007-02-16 21:51:26.354695664 +0100
+++ wireless-dev/net/wireless/wext.h	2007-02-17 01:46:34.514695664 +0100
@@ -29,10 +29,14 @@ int wireless_process_ioctl(struct ifreq 
 int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
 #ifdef CFG80211_MODULE
 int call_cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
+#else
+#define call_cfg80211_wext_ioctl cfg80211_wext_ioctl
+#endif
+
+#if defined(CONFIG_CFG80211_WEXT_COMPAT) && defined(CFG80211_MODULE)
 int cfg80211_wext_init(void);
 void cfg80211_wext_exit(void);
 #else
-#define call_cfg80211_wext_ioctl cfg80211_wext_ioctl
 static inline int cfg80211_wext_init(void)
 {
 	return 0;


