Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970712AbXHMI6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:58:04 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IKVkP-0007SB-3H
	for linux-wireless@vger.kernel.org; Mon, 13 Aug 2007 09:58:01 +0100
Message-Id: <20070813074643.269370000@sipsolutions.net>
References: <20070813074504.416717000@sipsolutions.net>
Date: Mon, 13 Aug 2007 09:45:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: allow tx handlers on injected packets
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we specify the F_WEP flag for injection, then we have
indicated that we want encryption. Since that is handled
by the tx handlers we need to run the packet through them
with the additional benefit that everything else is also
done. This is important for hostapd when it sends EAPOL
frames, it needs to do that to avoid the qdisc.

I'm not entirely convinced this is the right thing, but
it's what I needed to get it all running for now.

Not-Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/tx.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- wireless-dev.orig/net/mac80211/tx.c	2007-08-12 13:03:43.719561279 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-12 13:52:20.775894433 +0200
@@ -835,8 +835,7 @@ __ieee80211_parse_tx_radiotap(
 	control->key_idx = -1; /* no encryption key */
 	control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
 			    IEEE80211_TXCTL_USE_CTS_PROTECT);
-	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT |
-			  IEEE80211_TXCTL_NO_ACK;
+	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	control->antenna_sel_tx = 0; /* default to default antenna */
 
 	/*
@@ -1115,7 +1114,12 @@ static int ieee80211_tx(struct net_devic
 	tx.u.tx.mgmt_interface = mgmt;
 	tx.u.tx.mode = local->hw.conf.mode;
 
-	if (res_prepare == TXRX_QUEUED) { /* if it was an injected packet */
+	/*
+	 * if it was an injected packet and "don't encrypt"
+	 * was specified, then skip everthing. quite hackish
+	 */
+	if (res_prepare == TXRX_QUEUED &&
+	    (control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
 		res = TXRX_CONTINUE;
 	} else {
 		for (handler = local->tx_handlers; *handler != NULL;

-- 

