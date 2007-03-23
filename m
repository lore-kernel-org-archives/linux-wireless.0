Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:40614 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933541AbXCWT2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 15:28:22 -0400
Date: Fri, 23 Mar 2007 20:23:43 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH] bcm43xx-mac80211: fix radio_set_tx_iq
Message-ID: <20070323202343.0e7ea0e7@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a duplicated leftshift in bcm43xx_radio_set_tx_iq. data_high values are
already leftshifted. Thanks to Michael Buesch for spotting this.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

diff --git a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
index 10a82b1..a2c52f6 100644
--- a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
@@ -3802,7 +3802,7 @@ void bcm43xx_radio_set_tx_iq(struct bcm4
 
 	for (i = 0; i < 5; i++) {
 		for (j = 0; j < 5; j++) {
-			if (tmp == (data_high[i] << 4 | data_low[j])) {
+			if (tmp == (data_high[i] | data_low[j])) {
 				bcm43xx_phy_write(dev, 0x0069, (i - j) << 8 | 0x00C0);
 				return;
 			}
