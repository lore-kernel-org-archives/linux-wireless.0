Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58851 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab0GTQaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 12:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: correct sparse warning in wext-compat.c
Date: Tue, 20 Jul 2010 12:26:55 -0400
Message-Id: <1279643215-13498-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   net/wireless/wext-compat.c
net/wireless/wext-compat.c:1434:5: warning: symbol 'cfg80211_wext_siwpmksa' was not declared. Should it be static?

Add declaration in cfg80211.h.  Also add an EXPORT_SYMBOL_GPL, since all
the peer functions have it.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/cfg80211.h     |    4 ++++
 net/wireless/wext-compat.c |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9b8b3f4..f68ae54 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1963,6 +1963,10 @@ int cfg80211_wext_giwap(struct net_device *dev,
 			struct iw_request_info *info,
 			struct sockaddr *ap_addr, char *extra);
 
+int cfg80211_wext_siwpmksa(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 1ff1e9f..bb5e0a5 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1471,6 +1471,7 @@ int cfg80211_wext_siwpmksa(struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 }
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwpmksa);
 
 static const iw_handler cfg80211_handlers[] = {
 	[IW_IOCTL_IDX(SIOCGIWNAME)]	= (iw_handler) cfg80211_wext_giwname,
-- 
1.7.1.1

