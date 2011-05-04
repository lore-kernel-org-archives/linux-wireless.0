Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:33835 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211Ab1EDGrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 02:47:43 -0400
Date: Tue, 3 May 2011 22:50:15 -0700
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Remove unused wiphy flag
Message-ID: <20110504055015.GB10455@jm.kir.nu> (sfid-20110504_084749_431159_A0100DE4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only user of WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS was removed
and consequently, this flag can be removed, too. In addition, a single
capability flag was not enough to indicate this capability clearly since
the device behavior may be different based on which operating mode is
being used.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/net/cfg80211.h |    3 ---
 net/mac80211/main.c    |    3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

Note: This depends on the previous patch (removal of nl80211 set_key
check using this flag) to be applied first.


Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h	2011-05-03 10:05:09.000866371 -0700
+++ wireless-testing/include/net/cfg80211.h	2011-05-03 10:06:12.187650404 -0700
@@ -1455,8 +1455,6 @@
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
- * @WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS: The device supports separate
- *	unicast and multicast TX keys.
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
  */
@@ -1470,7 +1468,6 @@
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
-	WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS= BIT(9),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 };
 
Index: wireless-testing/net/mac80211/main.c
===================================================================
--- wireless-testing.orig/net/mac80211/main.c	2011-05-03 10:06:31.769190352 -0700
+++ wireless-testing/net/mac80211/main.c	2011-05-03 10:06:45.087679000 -0700
@@ -580,8 +580,7 @@
 
 	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
 			WIPHY_FLAG_4ADDR_AP |
-			WIPHY_FLAG_4ADDR_STATION |
-			WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS;
+			WIPHY_FLAG_4ADDR_STATION;
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;

-- 
Jouni Malinen                                            PGP id EFC895FA
