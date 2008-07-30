Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bromo.msbb.uc.edu ([129.137.3.146]:60729 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752662AbYG3Ckh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 22:40:37 -0400
Received: from bromo.msbb.uc.edu (localhost.localdomain [127.0.0.1])
	by bromo.msbb.uc.edu (Postfix) with ESMTP id 0F5DCB006D
	for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 22:40:36 -0400 (EDT)
Received: (from howarth@localhost)
	by bromo.msbb.uc.edu (8.14.2/8.14.2/Submit) id m6U2eZn6003001
	for linux-wireless@vger.kernel.org; Tue, 29 Jul 2008 22:40:35 -0400
Date: Tue, 29 Jul 2008 22:40:35 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-wireless@vger.kernel.org
Subject: ath9k and signal level
Message-ID: <20080730024035.GA2976@bromo.msbb.uc.edu> (sfid-20080730_044041_049374_65090123)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    I was finally able to get the ath9k drivers to work
under 2.6.26-rc1 by using the previous ath9k git patch,
the 16 new ath9k patches, the Berg's proposed skb->cb
patch and the following patch I constructed for ath9k
to mimic the skb->cb changes...

--- linux-2.6.26.x86_64/drivers/net/wireless/ath9k/xmit.c.orig	2008-07-29 19:32
:26.000000000 -0400
+++ linux-2.6.26.x86_64/drivers/net/wireless/ath9k/xmit.c	2008-07-29 20:04
:09.000000000 -0400
@@ -37,6 +37,10 @@
 
 #define OFDM_SIFS_TIME    	    16
 
+#ifndef ETH_P_PAE
+#define ETH_P_PAE 0x888E /* Port Access Entity (IEEE 802.1X) */
+#endif /* ETH_P_PAE */
+
 static u_int32_t bits_per_symbol[][2] = {
 	/* 20MHz 40MHz */
 	{    26,   54 },     /*  0: BPSK */
@@ -248,7 +252,7 @@
 		txctl->min_rate = tx_info_priv->min_rate;
 	} else if (ieee80211_is_data(fc)) {
 		if (ieee80211_is_nullfunc(fc) ||
-		    (tx_info->flags & IEEE80211_TX_CTL_EAPOL_FRAME)) {
+		    (skb->protocol == cpu_to_be16(ETH_P_PAE)))  {
 			txctl->use_minrate = 1;
 			txctl->min_rate = tx_info_priv->min_rate;
 		}
@@ -310,7 +314,7 @@
 	txctl->keytype = HAL_KEY_TYPE_CLEAR;
 	txctl->keyix = HAL_TXKEYIX_INVALID;
 
-	if (!(tx_info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT)) {
+	if (tx_info->control.hw_key) {
 		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
 		txctl->frmlen += tx_info->control.icv_len;

So far the ath9k driver seems to be working well with one oddity.
I find that the gnome menu applet (using the NetworkManager in Fedora 9)
shows a signal level of zero (even though it recognizes that the connection
exists to the wireless network). Is this a known issue?
                          Jack
ps Are all 16 patches now applied to the ath9k git?
