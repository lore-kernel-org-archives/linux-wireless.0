Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:44465 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbYFXRXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 13:23:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so38252nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 10:23:09 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Add RTNL warning for workqueue
Date: Tue, 24 Jun 2008 19:23:36 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806241923.36230.IvDoorn@gmail.com> (sfid-20080624_192315_497562_3F98CE21)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The workqueue provided by mac80211 should not be used for
scheduled tasks that acquire the RTNL lock. This could be done
when the driver uses the function ieee80211_iterate_active_interfaces()
within the scheduled work. Such behavior will end in locking
dependencies problems when an interface is being removed.

This patch will add a notification about the RTNL locking and
the mac80211 workqueue to prevent driver developers from
blindly using it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 19f1e41..02c79e6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -738,8 +738,11 @@ enum ieee80211_hw_flags {
  * @conf: &struct ieee80211_conf, device configuration, don't use.
  *
  * @workqueue: single threaded workqueue available for driver use,
- *	allocated by mac80211 on registration and flushed on
- *	unregistration.
+ *	allocated by mac80211 on registration and flushed when an
+ *	interface is removed.
+ *	NOTICE: All work performed on this workqueue should NEVER
+ *	acquire the RTNL lock (i.e. Don't use the function
+ *	ieee80211_iterate_active_interfaces())
  *
  * @priv: pointer to private area that was allocated for driver use
  *	along with this structure.
