Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47372 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbZEPMJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:09:53 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so3051294ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 05:09:54 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 1/3] cfg80211: mark ops as pointer to const
Date: Sat, 16 May 2009 13:22:55 +0100
Message-Id: <1242476577-26320-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
References: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to mark their cfg80211_ops tables const.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 include/net/cfg80211.h |    2 +-
 net/wireless/core.c    |    2 +-
 net/wireless/core.h    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9e17a83..7702715 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1070,7 +1070,7 @@ static inline const char *wiphy_name(struct wiphy *wiphy)
  * The returned pointer must be assigned to each netdev's
  * ieee80211_ptr for proper operation.
  */
-struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv);
+struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv);
 
 /**
  * wiphy_register - register a wiphy with cfg80211
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 47c20eb..98bfd4d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -228,7 +228,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 
 /* exported functions */
 
-struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
+struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 {
 	static int wiphy_counter;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index f14b6c5..725c22e 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -15,7 +15,7 @@
 #include "reg.h"
 
 struct cfg80211_registered_device {
-	struct cfg80211_ops *ops;
+	const struct cfg80211_ops *ops;
 	struct list_head list;
 	/* we hold this mutex during any call so that
 	 * we cannot do multiple calls at once, and also
-- 
1.6.0.6

