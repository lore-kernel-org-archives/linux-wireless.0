Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:57333 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966141AbXDIQZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 12:25:17 -0400
Date: Mon, 09 Apr 2007 11:24:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error logging  conditional on IEEE80211_DEBUG_DROP
Message-ID: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are messages arising from ieee80211_crypt that spam the logs of
casual users. These are changed to be logged only if the user specifically
requests the IEEE80211_DEBUG_DROP messages. In either case, the error/drop count
is incremented.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_crypt_tkip.c
+++ wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
@@ -465,7 +465,7 @@ static int ieee80211_tkip_decrypt(struct
 
 	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: replay detected: STA=" MAC_FMT
+			IEEE80211_DEBUG_DROP("TKIP: replay detected: STA=" MAC_FMT
 			       " previous TSC %08x%04x received TSC "
 			       "%08x%04x\n", MAC_ARG(hdr->addr2),
 			       tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
@@ -507,7 +507,7 @@ static int ieee80211_tkip_decrypt(struct
 			tkey->rx_phase1_done = 0;
 		}
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: ICV error detected: STA="
+			IEEE80211_DEBUG_DROP("TKIP: ICV error detected: STA="
 			       MAC_FMT "\n", MAC_ARG(hdr->addr2));
 		}
 		tkey->dot11RSNAStatsTKIPICVErrors++;
Index: wireless-2.6/net/ieee80211/ieee80211_crypt_ccmp.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_crypt_ccmp.c
+++ wireless-2.6/net/ieee80211/ieee80211_crypt_ccmp.c
@@ -338,7 +338,7 @@ static int ieee80211_ccmp_decrypt(struct
 
 	if (ccmp_replay_check(pn, key->rx_pn)) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: replay detected: STA=" MAC_FMT
+			IEEE80211_DEBUG_DROP("CCMP: replay detected: STA=" MAC_FMT
 			       " previous PN %02x%02x%02x%02x%02x%02x "
 			       "received PN %02x%02x%02x%02x%02x%02x\n",
 			       MAC_ARG(hdr->addr2), MAC_ARG(key->rx_pn),
