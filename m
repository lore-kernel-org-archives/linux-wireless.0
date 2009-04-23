Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42783 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbZDWUvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 16:51:47 -0400
Date: Thu, 23 Apr 2009 23:51:27 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Make nl80211_send_mlme_timeout() static
Message-ID: <20090423205127.GA32208@jm.kir.nu> (sfid-20090423_225151_835215_FB01D849)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211_send_mlme_timeout() is supposed to be used only within
nl80211.c, so it can be made static.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/wireless/nl80211.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- uml.orig/net/wireless/nl80211.c	2009-04-23 23:47:11.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-04-23 23:47:36.000000000 +0300
@@ -3696,9 +3696,9 @@ void nl80211_send_disassoc(struct cfg802
 				NL80211_CMD_DISASSOCIATE);
 }
 
-void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
-			       struct net_device *netdev, int cmd,
-			       const u8 *addr)
+static void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
+				      struct net_device *netdev, int cmd,
+				      const u8 *addr)
 {
 	struct sk_buff *msg;
 	void *hdr;

-- 
Jouni Malinen                                            PGP id EFC895FA
