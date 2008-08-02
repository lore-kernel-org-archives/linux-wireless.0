Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [116.90.133.99] ([116.90.133.99]:51207 "EHLO mars.unix.geek.nz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYHBXaq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:30:46 -0400
Received: from [192.168.68.2] (unknown [202.6.117.130])
	(Authenticated sender: jasper)
	by mars.unix.geek.nz (Postfix) with ESMTPSA id DAE1E11D958
	for <linux-wireless@vger.kernel.org>; Sun,  3 Aug 2008 11:30:44 +1200 (NZST)
Subject: [PATCH] move ETH_P_PAE from ieee80211_i.h to if_ether.h
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 03 Aug 2008 11:30:55 +1200
Message-Id: <1217719855.14226.5.camel@luna.unix.geek.nz> (sfid-20080803_013052_034741_F88529F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ETH_P_PAE belongs in if_ether.h with the other ETH_P_* definitions. This
patch moves it there.

Signed-off-by: Jasper Bryant-Greene <jasper@amiton.co.nz>
---

diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index e157c13..5028e0b 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -74,6 +74,7 @@
 #define ETH_P_ATMFATE	0x8884		/* Frame-based ATM Transport
 					 * over Ethernet
 					 */
+#define ETH_P_PAE	0x888E		/* Port Access Entity (IEEE 802.1X) */
 #define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
 #define ETH_P_TIPC	0x88CA		/* TIPC 			*/
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a4f9a83..be4d99e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -32,10 +32,6 @@
 /* ieee80211.o internal definitions, etc. These are not included into
  * low-level drivers. */
 
-#ifndef ETH_P_PAE
-#define ETH_P_PAE 0x888E /* Port Access Entity (IEEE 802.1X) */
-#endif /* ETH_P_PAE */
-
 #define WLAN_FC_DATA_PRESENT(fc) (((fc) & 0x4c) == 0x08)
 
 #define IEEE80211_FC(type, subtype) cpu_to_le16(type | subtype)


