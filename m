Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYDQRVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 13:21:31 -0400
Subject: [PATCH] mac80211: a few code cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 19:21:22 +0200
Message-Id: <1208452882.4066.29.camel@johannes.berg> (sfid-20080417_182136_900555_47C18416)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has some code cleanups (some inspired by checkpatch), I got
bored at probably a third of the output though so if somebody
else wants to...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net
---
 net/mac80211/aes_ccm.c        |    2 +-
 net/mac80211/aes_ccm.h        |    2 +-
 net/mac80211/debugfs_netdev.c |    2 +-
 net/mac80211/ieee80211_i.h    |    6 +++---
 net/mac80211/iface.c          |    6 +-----
 net/mac80211/main.c           |    6 +++---
 net/mac80211/mlme.c           |   31 ++++++++++++++-----------------
 net/mac80211/tkip.h           |    4 ++--
 net/mac80211/wep.h            |    2 +-
 9 files changed, 27 insertions(+), 34 deletions(-)

--- everything.orig/net/mac80211/aes_ccm.c	2008-04-17 18:33:13.000000000 +0200
+++ everything/net/mac80211/aes_ccm.c	2008-04-17 19:13:50.000000000 +0200
@@ -134,7 +134,7 @@ int ieee80211_aes_ccm_decrypt(struct cry
 }
 
 
-struct crypto_cipher * ieee80211_aes_key_setup_encrypt(const u8 key[])
+struct crypto_cipher *ieee80211_aes_key_setup_encrypt(const u8 key[])
 {
 	struct crypto_cipher *tfm;
 
--- everything.orig/net/mac80211/aes_ccm.h	2008-04-17 18:33:13.000000000 +0200
+++ everything/net/mac80211/aes_ccm.h	2008-04-17 19:13:50.000000000 +0200
@@ -14,7 +14,7 @@
 
 #define AES_BLOCK_LEN 16
 
-struct crypto_cipher * ieee80211_aes_key_setup_encrypt(const u8 key[]);
+struct crypto_cipher *ieee80211_aes_key_setup_encrypt(const u8 key[]);
 void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
 			       u8 *b_0, u8 *aad, u8 *data, size_t data_len,
 			       u8 *cdata, u8 *mic);
--- everything.orig/net/mac80211/ieee80211_i.h	2008-04-17 18:57:17.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-04-17 19:13:50.000000000 +0200
@@ -919,9 +919,9 @@ ieee80211_rx_result ieee80211_sta_rx_sca
 void ieee80211_rx_bss_list_init(struct net_device *dev);
 void ieee80211_rx_bss_list_deinit(struct net_device *dev);
 int ieee80211_sta_set_extra_ie(struct net_device *dev, char *ie, size_t len);
-struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
-					 struct sk_buff *skb, u8 *bssid,
-					 u8 *addr);
+struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
+					struct sk_buff *skb, u8 *bssid,
+					u8 *addr);
 int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
--- everything.orig/net/mac80211/iface.c	2008-04-17 18:33:12.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-04-17 19:13:50.000000000 +0200
@@ -33,9 +33,8 @@ static void ieee80211_if_sdata_deinit(st
 {
 	int i;
 
-	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++) {
+	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		__skb_queue_purge(&sdata->fragments[i].skb_list);
-	}
 }
 
 /* Must be called with rtnl lock held. */
@@ -175,9 +174,6 @@ void ieee80211_if_set_type(struct net_de
 		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
 				      MONITOR_FLAG_OTHER_BSS;
 		break;
-	default:
-		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",
-		       dev->name, __FUNCTION__, type);
 	}
 	ieee80211_debugfs_change_if_type(sdata, oldtype);
 }
--- everything.orig/net/mac80211/tkip.h	2008-04-17 18:33:12.000000000 +0200
+++ everything/net/mac80211/tkip.h	2008-04-17 19:13:50.000000000 +0200
@@ -13,8 +13,8 @@
 #include <linux/crypto.h>
 #include "key.h"
 
-u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
-			   u8 iv0, u8 iv1, u8 iv2);
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
+			  u8 iv0, u8 iv1, u8 iv2);
 void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
 				  u16 *phase1key);
 void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
--- everything.orig/net/mac80211/wep.h	2008-04-17 18:33:13.000000000 +0200
+++ everything/net/mac80211/wep.h	2008-04-17 19:13:50.000000000 +0200
@@ -26,7 +26,7 @@ int ieee80211_wep_encrypt(struct ieee802
 			  struct ieee80211_key *key);
 int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
 			  struct ieee80211_key *key);
-u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
+u8 *ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
 ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx);
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-04-17 18:33:12.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-04-17 19:13:50.000000000 +0200
@@ -528,7 +528,7 @@ void ieee80211_debugfs_change_if_type(st
 	add_files(sdata);
 }
 
-static int netdev_notify(struct notifier_block * nb,
+static int netdev_notify(struct notifier_block *nb,
 			 unsigned long state,
 			 void *ndev)
 {
--- everything.orig/net/mac80211/main.c	2008-04-17 18:57:17.000000000 +0200
+++ everything/net/mac80211/main.c	2008-04-17 19:13:50.000000000 +0200
@@ -381,8 +381,8 @@ static int ieee80211_open(struct net_dev
 	 * yet be effective. Trigger execution of ieee80211_sta_work
 	 * to fix this.
 	 */
-	if(sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	   sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		queue_work(local->hw.workqueue, &ifsta->work);
 	}
@@ -1471,7 +1471,7 @@ void ieee80211_tx_status(struct ieee8021
 		return;
 	}
 
-	rthdr = (struct ieee80211_tx_status_rtap_hdr*)
+	rthdr = (struct ieee80211_tx_status_rtap_hdr *)
 				skb_push(skb, sizeof(*rthdr));
 
 	memset(rthdr, 0, sizeof(*rthdr));
--- everything.orig/net/mac80211/mlme.c	2008-04-17 18:57:17.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-04-17 19:13:50.000000000 +0200
@@ -306,28 +306,24 @@ static void ieee80211_sta_wmm_params(str
 		switch (aci) {
 		case 1:
 			queue = IEEE80211_TX_QUEUE_DATA3;
-			if (acm) {
+			if (acm)
 				local->wmm_acm |= BIT(0) | BIT(3);
-			}
 			break;
 		case 2:
 			queue = IEEE80211_TX_QUEUE_DATA1;
-			if (acm) {
+			if (acm)
 				local->wmm_acm |= BIT(4) | BIT(5);
-			}
 			break;
 		case 3:
 			queue = IEEE80211_TX_QUEUE_DATA0;
-			if (acm) {
+			if (acm)
 				local->wmm_acm |= BIT(6) | BIT(7);
-			}
 			break;
 		case 0:
 		default:
 			queue = IEEE80211_TX_QUEUE_DATA2;
-			if (acm) {
+			if (acm)
 				local->wmm_acm |= BIT(1) | BIT(2);
-			}
 			break;
 		}
 
@@ -705,9 +701,8 @@ static void ieee80211_send_assoc(struct 
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
-		if (bss->wmm_ie) {
+		if (bss->wmm_ie)
 			wmm = 1;
-		}
 		ieee80211_rx_bss_put(dev, bss);
 	}
 
@@ -1804,9 +1799,8 @@ static void ieee80211_rx_mgmt_deauth(str
 	       " (reason=%d)\n",
 	       dev->name, print_mac(mac, mgmt->sa), reason_code);
 
-	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED) {
+	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
 		printk(KERN_DEBUG "%s: deauthenticated\n", dev->name);
-	}
 
 	if (ifsta->state == IEEE80211_AUTHENTICATE ||
 	    ifsta->state == IEEE80211_ASSOCIATE ||
@@ -3494,10 +3488,12 @@ static int ieee80211_sta_create_ibss(str
 	bss->beacon_int = local->hw.conf.beacon_int;
 	bss->last_update = jiffies;
 	bss->capability = WLAN_CAPABILITY_IBSS;
-	if (sdata->default_key) {
+
+	if (sdata->default_key)
 		bss->capability |= WLAN_CAPABILITY_PRIVACY;
-	} else
+	else
 		sdata->drop_unencrypted = 0;
+
 	bss->supp_rates_len = sband->n_bitrates;
 	pos = bss->supp_rates;
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -4180,6 +4176,7 @@ int ieee80211_sta_set_extra_ie(struct ne
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
 	kfree(ifsta->extra_ie);
 	if (len == 0) {
 		ifsta->extra_ie = NULL;
@@ -4197,9 +4194,9 @@ int ieee80211_sta_set_extra_ie(struct ne
 }
 
 
-struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
-					 struct sk_buff *skb, u8 *bssid,
-					 u8 *addr)
+struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
+					struct sk_buff *skb, u8 *bssid,
+					u8 *addr)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;


