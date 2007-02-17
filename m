Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946349AbXBQBEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 20:04:13 -0500
Subject: [PATCH] fix wext_ioctl() exit path
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1171670057.28539.5.camel@dv>
References: <1171670057.28539.5.camel@dv>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 02:03:57 +0100
Message-Id: <1171674237.3938.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the wext_ioctl() exit path, it was copying things from "&ifr"
instead of "ifr", caused by now using a pointer to ifr in that new
function.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
This should fix it. Looks like I had it right for the cfg80211 exit path
but not the old one...

--- wireless-dev.orig/net/wireless/wext-common.c	2007-02-17 01:46:03.204695664 +0100
+++ wireless-dev/net/wireless/wext-common.c	2007-02-17 01:59:18.075094300 +0100
@@ -640,26 +640,24 @@ int wext_ioctl(unsigned int cmd, struct 
 
 	rtnl_unlock();
 
-	if (IW_IS_GET(cmd) && copy_to_user(arg, &ifr, sizeof(struct ifreq)))
-		ret = -EFAULT;
-
 	/* haha, I cheat here by allowing a driver or stack to have both WE and
 	 * CFG80211-WE for a little while during conversion... wext returns
 	 * -EOPNOTSUPP if a handler is not assigned, so we can in that case try
 	 * calling cfg80211's compat code instead.
 	 */
 	if (ret != -EOPNOTSUPP)
-		return ret;
+		goto out;
 #endif
 
 #ifdef CONFIG_CFG80211_WEXT_COMPAT
 	/* no need to hold rtnl lock here for the new stuff,
 	 * we properly use dev_get_by_name() and dev_put() */
 	ret = call_cfg80211_wext_ioctl(ifr, cmd);
+#endif
 
+ out:
 	if (IW_IS_GET(cmd) && copy_to_user(arg, ifr, sizeof(struct ifreq)))
 		ret = -EFAULT;
-#endif
 
 	return ret;
 }


