Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35980 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZGATfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:43 -0400
Message-Id: <20090701193419.265924815@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/20 v4] nl80211: clean up function definitions
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't like the 'extern' keyword much when it's not
necessary, it makes lines rather long.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.h |   58 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.h	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2009-07-01 08:59:44.000000000 +0200
@@ -3,41 +3,41 @@
 
 #include "core.h"
 
-extern int nl80211_init(void);
-extern void nl80211_exit(void);
-extern void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
-extern void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
-				    struct net_device *netdev);
-extern void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-				   struct net_device *netdev);
-extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
-				      struct net_device *netdev);
-extern void nl80211_send_reg_change_event(struct regulatory_request *request);
-extern void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
-				 struct net_device *netdev,
-				 const u8 *buf, size_t len);
-extern void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
-				  struct net_device *netdev,
-				  const u8 *buf, size_t len);
-extern void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
+int nl80211_init(void);
+void nl80211_exit(void);
+void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
+void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev);
+void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev);
+void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev);
+void nl80211_send_reg_change_event(struct regulatory_request *request);
+void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
+			  struct net_device *netdev,
+			  const u8 *buf, size_t len);
+void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev,
+			   const u8 *buf, size_t len);
+void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
+			 struct net_device *netdev,
+			 const u8 *buf, size_t len);
+void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev,
+			   const u8 *buf, size_t len);
+void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev,
+			       const u8 *addr);
+void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev,
-				const u8 *buf, size_t len);
-extern void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
-				  struct net_device *netdev,
-				  const u8 *buf, size_t len);
-extern void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
-				      struct net_device *netdev,
-				      const u8 *addr);
-extern void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
-				       struct net_device *netdev,
-				       const u8 *addr);
-extern void
+				const u8 *addr);
+void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,
 			    enum nl80211_key_type key_type,
 			    int key_id, const u8 *tsc);
 
-extern void
+void
 nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 			       struct ieee80211_channel *channel_before,
 			       struct ieee80211_channel *channel_after);

-- 

