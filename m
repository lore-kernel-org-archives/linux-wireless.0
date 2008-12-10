Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50127 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYLJFN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 00:13:57 -0500
Message-ID: <493F5010.7030500@trash.net> (sfid-20081210_061401_587920_C283DF2C)
Date: Wed, 10 Dec 2008 06:13:52 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jiri Slaby <jirislaby@gmail.com>, mickflemm@gmail.com,
	mcgrof@gmail.com, me@bobcopeland.com
Subject: [RFC]: ath5k: enable TXOK IRQ
Content-Type: multipart/mixed;
 boundary="------------030808060902030109070106"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030808060902030109070106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I tried to use ath5k in AP mode with hostapd, but hostapd never
added the authenticated and associated stations to the kernel.
The reason is that ath5k didn't invoke the tx tasklet, so it
did not call the ieee80211_tx_status() function and userspace
didn't receive the radiotap message indicating success.

The root cause appears to be that the TXOK interrupt is not
enabled, so the tasklet is never scheduled. I'm not sure whether
TXOK is really the correct one to handle ! IEEE80211_TX_CTL_NO_ACK,
but it fixes the problem for me.



--------------030808060902030109070106
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit 5ecbb104a7202a6ed9bcfa8b8ef46474d1003600
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Dec 9 21:54:51 2008 +0100

    ath5k: enable TXOK IRQ
    
    Without the IRQ, the tx tasklet is not scheduled, which is necessary
    to invoke ieee80211_tx_status() to notify userspace of successfully
    sent frames.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 940c724..291a334 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1348,7 +1348,8 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 	 * up in which case the top half of the kernel may backup
 	 * due to a lack of tx descriptors.
 	 */
-	qi.tqi_flags = AR5K_TXQ_FLAG_TXEOLINT_ENABLE |
+	qi.tqi_flags = AR5K_TXQ_FLAG_TXOKINT_ENABLE |
+				AR5K_TXQ_FLAG_TXEOLINT_ENABLE |
 				AR5K_TXQ_FLAG_TXDESCINT_ENABLE;
 	qnum = ath5k_hw_setup_tx_queue(ah, qtype, &qi);
 	if (qnum < 0) {

--------------030808060902030109070106--
