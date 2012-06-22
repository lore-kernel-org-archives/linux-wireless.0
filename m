Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab2FVRSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:18:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/6] mac80211: remove TKIP debug
Date: Fri, 22 Jun 2012 19:18:40 +0200
Message-Id: <1340385525-14487-2-git-send-email-johannes@sipsolutions.net> (sfid-20120622_191852_471622_A00F53ED)
In-Reply-To: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The TKIP code hasn't been changed in a very long
time, so it seems unlikely that anyone really has
a need for the TKIP debug code. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig |   11 -----------
 net/mac80211/tkip.c  |   43 +------------------------------------------
 2 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 8d249d7..323aa19 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -152,17 +152,6 @@ config MAC80211_HT_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_TKIP_DEBUG
-	bool "Verbose TKIP debugging"
-	depends on MAC80211_DEBUG_MENU
-	---help---
-	  Selecting this option causes mac80211 to print out
-	  very verbose TKIP debugging messages. It should not
-	  be selected on production systems as those messages
-	  are remotely triggerable.
-
-	  Do not select this option.
-
 config MAC80211_IBSS_DEBUG
 	bool "Verbose IBSS debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 68be47c..57e14d5 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -260,16 +260,6 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	keyid = pos[3];
 	iv32 = get_unaligned_le32(pos + 4);
 	pos += 8;
-#ifdef CONFIG_MAC80211_TKIP_DEBUG
-	{
-		int i;
-		pr_debug("TKIP decrypt: data(len=%zd)", payload_len);
-		for (i = 0; i < payload_len; i++)
-			printk(" %02x", payload[i]);
-		printk("\n");
-		pr_debug("TKIP decrypt: iv16=%04x iv32=%08x\n", iv16, iv32);
-	}
-#endif
 
 	if (!(keyid & (1 << 5)))
 		return TKIP_DECRYPT_NO_EXT_IV;
@@ -280,15 +270,8 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	if (key->u.tkip.rx[queue].state != TKIP_STATE_NOT_INIT &&
 	    (iv32 < key->u.tkip.rx[queue].iv32 ||
 	     (iv32 == key->u.tkip.rx[queue].iv32 &&
-	      iv16 <= key->u.tkip.rx[queue].iv16))) {
-#ifdef CONFIG_MAC80211_TKIP_DEBUG
-		pr_debug("TKIP replay detected for RX frame from %pM (RX IV (%04x,%02x) <= prev. IV (%04x,%02x)\n",
-			 ta, iv32, iv16,
-			 key->u.tkip.rx[queue].iv32,
-			 key->u.tkip.rx[queue].iv16);
-#endif
+	      iv16 <= key->u.tkip.rx[queue].iv16)))
 		return TKIP_DECRYPT_REPLAY;
-	}
 
 	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
@@ -300,21 +283,6 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	    key->u.tkip.rx[queue].iv32 != iv32) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(tk, &key->u.tkip.rx[queue], ta, iv32);
-#ifdef CONFIG_MAC80211_TKIP_DEBUG
-		{
-			int i;
-			u8 key_offset = NL80211_TKIP_DATA_OFFSET_ENCR_KEY;
-			pr_debug("TKIP decrypt: Phase1 TA=%pM TK=", ta);
-			for (i = 0; i < 16; i++)
-				printk("%02x ",
-				       key->conf.key[key_offset + i]);
-			printk("\n");
-			pr_debug("TKIP decrypt: P1K=");
-			for (i = 0; i < 5; i++)
-				printk("%04x ", key->u.tkip.rx[queue].p1k[i]);
-			printk("\n");
-		}
-#endif
 	}
 	if (key->local->ops->update_tkip_key &&
 	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
@@ -330,15 +298,6 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	}
 
 	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
-#ifdef CONFIG_MAC80211_TKIP_DEBUG
-	{
-		int i;
-		pr_debug("TKIP decrypt: Phase2 rc4key=");
-		for (i = 0; i < 16; i++)
-			printk("%02x ", rc4key[i]);
-		printk("\n");
-	}
-#endif
 
 	res = ieee80211_wep_decrypt_data(tfm, rc4key, 16, pos, payload_len - 12);
  done:
-- 
1.7.10

