Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:61747 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbXBNA6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 19:58:42 -0500
Date: Tue, 13 Feb 2007 18:58:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ieee80211softmac: Fix setting of initial transmit rates
Message-ID: <45d25e9b.otGTejHOp8dOGSbd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a bug in ieee80211softmac that always sets the user rate to 11Mbs,
no matter the capabilities of the device. This bug was probably beneficial
as long as the bcm43xx cards were rate limited; however, most are now capable
of relatively high speeds. This patch fixes that bug and eliminates an assert
that is no longer needed. 

Once the cards are capable of full OFDM speeds, the 24 Mbs rate will be changed
to 54 Mbs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/net/ieee80211/softmac/ieee80211softmac_module.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/softmac/ieee80211softmac_module.c
+++ wireless-2.6/net/ieee80211/softmac/ieee80211softmac_module.c
@@ -265,17 +265,10 @@ void ieee80211softmac_init_bss(struct ie
 	/* Change the default txrate to the highest possible value.
 	 * The txrate machine will lower it, if it is too high.
 	 */
-	/* FIXME: We don't correctly handle backing down to lower
-	   rates, so 801.11g devices start off at 11M for now. People
-	   can manually change it if they really need to, but 11M is
-	   more reliable. Note similar logic in
-	   ieee80211softmac_wx_set_rate() */	 
-	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
+	if (ieee->modulation & IEEE80211_OFDM_MODULATION)
+		txrates->user_rate = IEEE80211_OFDM_RATE_24MB;
+	else
 		txrates->user_rate = IEEE80211_CCK_RATE_11MB;
-	} else if (ieee->modulation & IEEE80211_OFDM_MODULATION) {
-		txrates->user_rate = IEEE80211_OFDM_RATE_54MB;
-	} else
-		assert(0);
 
 	txrates->default_rate = IEEE80211_CCK_RATE_1MB;
 	change |= IEEE80211SOFTMAC_TXRATECHG_DEFAULT;
Index: wireless-2.6/net/ieee80211/softmac/ieee80211softmac_wx.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ wireless-2.6/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -177,15 +177,10 @@ ieee80211softmac_wx_set_rate(struct net_
 	int err = -EINVAL;
 
 	if (in_rate == -1) {
-		/* FIXME: We don't correctly handle backing down to lower
-		   rates, so 801.11g devices start off at 11M for now. People
-		   can manually change it if they really need to, but 11M is
-		   more reliable. Note similar logic in
-		   ieee80211softmac_wx_set_rate() */	 
-		if (ieee->modulation & IEEE80211_CCK_MODULATION)
-			in_rate = 11000000;
+		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
+			in_rate = 24000000;
 		else
-			in_rate = 54000000;
+			in_rate = 11000000;
 	}
 
 	switch (in_rate) {
