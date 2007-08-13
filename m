Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:52266 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937945AbXHMWOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 18:14:12 -0400
Date: Mon, 13 Aug 2007 17:13:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V3] mac80211: Turn off meaningless TKIP message when  software WEP encryption is used
Message-ID: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For drivers that do no hardware encryption/decryption, WEP encryption
works as long as IEEE80211_HW_INCLUDE_IV is not set in the flags variable.
With WPA encryption and IEEE80211_HW_INCLUDE_IV not set, the logs are full
of TKIP decrypt failure messages. Despite the messages, RX is working.
This patch turns off the message for this case.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Your suggestion to net_ratelimit the output is a good one. I hope the 3rd
time is a charm. I cannot believe that I'm still getting & and && confused.
At least I'm now getting = and == right (most of the time). FORTRAN IV didn't
have these complications!!

Larry
 
 wpa.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: wireless-legacy/net/mac80211/wpa.c
===================================================================
--- wireless-legacy.orig/net/mac80211/wpa.c
+++ wireless-legacy/net/mac80211/wpa.c
@@ -516,9 +516,12 @@ ieee80211_rx_h_tkip_decrypt(struct ieee8
 					  skb->len - hdrlen, rx->sta->addr,
 					  hwaccel, rx->u.rx.queue);
 	if (res != TKIP_DECRYPT_OK || wpa_test) {
-		printk(KERN_DEBUG "%s: TKIP decrypt failed for RX frame from "
-		       MAC_FMT " (res=%d)\n",
-		       rx->dev->name, MAC_ARG(rx->sta->addr), res);
+		if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)
+		     && net_ratelimit()) {
+			printk(KERN_DEBUG "%s: TKIP decrypt failed for RX frame from "
+			       MAC_FMT " (res=%d)\n",
+			       rx->dev->name, MAC_ARG(rx->sta->addr), res);
+		}
 		return TXRX_DROP;
 	}
 
