Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42156 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZCKPPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 11:15:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] lib80211: silence excessive crypto debugging messages
Date: Wed, 11 Mar 2009 11:12:04 -0400
Message-Id: <1236784324-10015-1-git-send-email-linville@tuxdriver.com> (sfid-20090311_161716_147971_D5705BA7)
In-Reply-To: <20090311151102.GC8761@tuxdriver.com>
References: <20090311151102.GC8761@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When they were part of the now defunct ieee80211 component, these
messages were only visible when special debugging settings were enabled.
Let's mirror that with a new lib80211 debugging Kconfig option.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/Kconfig               |   10 ++++++++++
 net/wireless/lib80211_crypt_ccmp.c |    2 ++
 net/wireless/lib80211_crypt_tkip.c |    4 ++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index e28e2b8..092ae6f 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -102,3 +102,13 @@ config LIB80211_CRYPT_CCMP
 
 config LIB80211_CRYPT_TKIP
 	tristate
+
+config LIB80211_DEBUG
+	bool "lib80211 debugging messages"
+	depends on LIB80211
+	default n
+	---help---
+	  You can enable this if you want verbose debugging messages
+	  from lib80211.
+
+	  If unsure, say N.
diff --git a/net/wireless/lib80211_crypt_ccmp.c b/net/wireless/lib80211_crypt_ccmp.c
index db42819..2301dc1 100644
--- a/net/wireless/lib80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -337,6 +337,7 @@ static int lib80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (ccmp_replay_check(pn, key->rx_pn)) {
+#ifdef CONFIG_LIB80211_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "CCMP: replay detected: STA=%pM "
 				 "previous PN %02x%02x%02x%02x%02x%02x "
@@ -346,6 +347,7 @@ static int lib80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 				 key->rx_pn[3], key->rx_pn[4], key->rx_pn[5],
 				 pn[0], pn[1], pn[2], pn[3], pn[4], pn[5]);
 		}
+#endif
 		key->dot11RSNAStatsCCMPReplays++;
 		return -4;
 	}
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 7e8e22b..c362873 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -465,12 +465,14 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
+#ifdef CONFIG_LIB80211_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "TKIP: replay detected: STA=%pM"
 			       " previous TSC %08x%04x received TSC "
 			       "%08x%04x\n", hdr->addr2,
 			       tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
 		}
+#endif
 		tkey->dot11RSNAStatsTKIPReplays++;
 		return -4;
 	}
@@ -505,10 +507,12 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 			 * it needs to be recalculated for the next packet. */
 			tkey->rx_phase1_done = 0;
 		}
+#ifdef CONFIG_LIB80211_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "TKIP: ICV error detected: STA="
 			       "%pM\n", hdr->addr2);
 		}
+#endif
 		tkey->dot11RSNAStatsTKIPICVErrors++;
 		return -5;
 	}
-- 
1.6.0.6

