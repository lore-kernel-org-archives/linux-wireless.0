Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYFTJzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 05:55:03 -0400
Subject: [PATCH] mac80211: rename TKIP debugging Kconfig symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 11:54:24 +0200
Message-Id: <1213955664.8967.149.camel@johannes.berg> (sfid-20080620_115507_931717_053A5282)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... to MAC80211_TKIP_DEBUG rather than TKIP_DEBUG.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig |    2 +-
 net/mac80211/tkip.c  |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- everything.orig/net/mac80211/Kconfig	2008-06-20 11:52:50.000000000 +0200
+++ everything/net/mac80211/Kconfig	2008-06-20 11:52:57.000000000 +0200
@@ -158,7 +158,7 @@ config MAC80211_HT_DEBUG
 
 	  Do not select this option.
 
-config TKIP_DEBUG
+config MAC80211_TKIP_DEBUG
 	bool "Verbose TKIP debugging"
 	depends on MAC80211_DEBUG_MENU
 	help
--- everything.orig/net/mac80211/tkip.c	2008-06-20 11:53:05.000000000 +0200
+++ everything/net/mac80211/tkip.c	2008-06-20 11:53:26.000000000 +0200
@@ -167,7 +167,7 @@ void ieee80211_get_tkip_key(struct ieee8
 	tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 	ctx = &key->u.tkip.tx;
 
-#ifdef CONFIG_TKIP_DEBUG
+#ifdef CONFIG_MAC80211_TKIP_DEBUG
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
 			iv16, iv32);
 
@@ -177,7 +177,7 @@ void ieee80211_get_tkip_key(struct ieee8
 		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
 			"fragmented packet\n");
 	}
-#endif /* CONFIG_TKIP_DEBUG */
+#endif
 
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
@@ -240,7 +240,7 @@ int ieee80211_tkip_decrypt_data(struct c
 	keyid = pos[3];
 	iv32 = get_unaligned_le32(pos + 4);
 	pos += 8;
-#ifdef CONFIG_TKIP_DEBUG
+#ifdef CONFIG_MAC80211_TKIP_DEBUG
 	{
 		int i;
 		printk(KERN_DEBUG "TKIP decrypt: data(len=%zd)", payload_len);
@@ -250,7 +250,7 @@ int ieee80211_tkip_decrypt_data(struct c
 		printk(KERN_DEBUG "TKIP decrypt: iv16=%04x iv32=%08x\n",
 		       iv16, iv32);
 	}
-#endif /* CONFIG_TKIP_DEBUG */
+#endif
 
 	if (!(keyid & (1 << 5)))
 		return TKIP_DECRYPT_NO_EXT_IV;
@@ -262,14 +262,14 @@ int ieee80211_tkip_decrypt_data(struct c
 	    (iv32 < key->u.tkip.rx[queue].iv32 ||
 	     (iv32 == key->u.tkip.rx[queue].iv32 &&
 	      iv16 <= key->u.tkip.rx[queue].iv16))) {
-#ifdef CONFIG_TKIP_DEBUG
+#ifdef CONFIG_MAC80211_TKIP_DEBUG
 		DECLARE_MAC_BUF(mac);
 		printk(KERN_DEBUG "TKIP replay detected for RX frame from "
 		       "%s (RX IV (%04x,%02x) <= prev. IV (%04x,%02x)\n",
 		       print_mac(mac, ta),
 		       iv32, iv16, key->u.tkip.rx[queue].iv32,
 		       key->u.tkip.rx[queue].iv16);
-#endif /* CONFIG_TKIP_DEBUG */
+#endif
 		return TKIP_DECRYPT_REPLAY;
 	}
 
@@ -283,7 +283,7 @@ int ieee80211_tkip_decrypt_data(struct c
 	    key->u.tkip.rx[queue].iv32 != iv32) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(tk, &key->u.tkip.rx[queue], ta, iv32);
-#ifdef CONFIG_TKIP_DEBUG
+#ifdef CONFIG_MAC80211_TKIP_DEBUG
 		{
 			int i;
 			DECLARE_MAC_BUF(mac);
@@ -299,7 +299,7 @@ int ieee80211_tkip_decrypt_data(struct c
 				printk("%04x ", key->u.tkip.rx[queue].p1k[i]);
 			printk("\n");
 		}
-#endif /* CONFIG_TKIP_DEBUG */
+#endif
 		if (key->local->ops->update_tkip_key &&
 			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 			u8 bcast[ETH_ALEN] =
@@ -316,7 +316,7 @@ int ieee80211_tkip_decrypt_data(struct c
 	}
 
 	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
-#ifdef CONFIG_TKIP_DEBUG
+#ifdef CONFIG_MAC80211_TKIP_DEBUG
 	{
 		int i;
 		printk(KERN_DEBUG "TKIP decrypt: Phase2 rc4key=");
@@ -324,7 +324,7 @@ int ieee80211_tkip_decrypt_data(struct c
 			printk("%02x ", rc4key[i]);
 		printk("\n");
 	}
-#endif /* CONFIG_TKIP_DEBUG */
+#endif
 
 	res = ieee80211_wep_decrypt_data(tfm, rc4key, 16, pos, payload_len - 12);
  done:


