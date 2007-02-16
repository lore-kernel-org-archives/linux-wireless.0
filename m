Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946164AbXBPU4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 15:56:12 -0500
Subject: [PATCH] fix cfg80211 modular compile w/o wext-compat
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 21:56:06 +0100
Message-Id: <1171659366.3575.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The static inlines that are supposed to be used w/o wext-compat to init
wext-compat were done with the wrong #ifdef. This fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/net/wireless/wext.h	2007-02-16 21:51:26.354695664 +0100
+++ wireless-dev/net/wireless/wext.h	2007-02-16 21:55:32.794695664 +0100
@@ -29,10 +29,14 @@ int wireless_process_ioctl(struct ifreq 
 int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
 #ifdef CFG80211_MODULE
 int call_cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
+#else
+#define call_cfg80211_wext_ioctl cfg80211_wext_ioctl
+#endif
+
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
 int cfg80211_wext_init(void);
 void cfg80211_wext_exit(void);
 #else
-#define call_cfg80211_wext_ioctl cfg80211_wext_ioctl
 static inline int cfg80211_wext_init(void)
 {
 	return 0;


