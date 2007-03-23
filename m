Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:37114 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992537AbXCWT01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 15:26:27 -0400
Date: Fri, 23 Mar 2007 20:21:39 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH] bcm43xx: fix radio_set_tx_iq
Message-ID: <20070323202139.7f37b32a@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a duplicated leftshift in bcm43xx_radio_set_tx_iq. data_high values are
already leftshifted. Thanks to Michael Buesch for spotting this.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
index 32beb91..d153b58 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -1579,7 +1579,7 @@ void bcm43xx_radio_set_tx_iq(struct bcm4
 	
 	for (i = 0; i < 5; i++) {
 		for (j = 0; j < 5; j++) {
-			if (tmp == (data_high[i] << 4 | data_low[j])) {
+			if (tmp == (data_high[i] | data_low[j])) {
 				bcm43xx_phy_write(bcm, 0x0069, (i - j) << 8 | 0x00C0);
 				return;
 			}
