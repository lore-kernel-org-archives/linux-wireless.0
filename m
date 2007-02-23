Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203AbXBWULg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 15:11:36 -0500
Subject: Re: [PATCH] create net/wireless/Kconfig and make nl80211 optional
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45DF176E.9090509@linux.intel.com>
References: <45DDF22D.9000003@linux.intel.com>
	 <1172229914.3870.13.camel@johannes.berg> <45DF176E.9090509@linux.intel.com>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 21:11:12 +0100
Message-Id: <1172261472.3870.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-02-23 at 08:33 -0800, James Ketrenos wrote:
> Johannes Berg wrote:
> > On Thu, 2007-02-22 at 11:42 -0800, James Ketrenos wrote:
> >> Move the wireless Kconfig options into their own wireless/Kconfig and
> >> add a CONFIG_NL80211 configuration option to allow nl80211 support to be
> >> optionally included (default =y)
> > 
> > Ack, but we'll need to modify core.h to stub out nl80211_init() and
> > nl80211_exit() in case nl80211 isn't compiled in. The reason this worked
> > for you is that I forgot to hook up nl80211 completely ;)
> > 
> > Do you want me to take care of that?`
> 
> Something like this?

Yup. I'd prefer this instead, and then rolled into your original patch
so it applies after my hookup patch.

johannes

--- wireless-dev.orig/net/wireless/nl80211.h	2007-02-23 21:08:45.353476868 +0100
+++ wireless-dev/net/wireless/nl80211.h	2007-02-23 21:09:58.543476868 +0100
@@ -1,7 +1,17 @@
 #ifndef __NET_WIRELESS_NL80211_H
 #define __NET_WIRELESS_NL80211_H
 
+#ifdef CONFIG_CFG80211_NL80211
 extern int nl80211_init(void);
 extern void nl80211_exit(void);
+#else
+static inline int nl80211_init(void)
+{
+	return 0;
+}
+static inline void nl80211_exit(void)
+{
+}
+#endif /* CONFIG_CFG80211_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */


