Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:39837 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZHKVDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 17:03:15 -0400
Received: by fxm28 with SMTP id 28so1781511fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 14:03:14 -0700 (PDT)
Message-ID: <4A81DC91.8020208@gmail.com>
Date: Tue, 11 Aug 2009 23:03:13 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Subject: [RFC] b43: LP-PHY: Initialize SW TX power control
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure at all if writing to offset 0 in the TX gain table
is the right thing to do... please clarify.

Not-yet-signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

---
If this is indeed the right thing to do, please inform me,
and I will resubmit this as a formal patch.

 phy_lp.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 689c932..93451c9 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -847,15 +847,23 @@ static void lpphy_calibration(struct b43_wldev *dev)
 /* Initialize TX power control */
 static void lpphy_tx_pctl_init(struct b43_wldev *dev)
 {
+	lpphy_tx_gain_table_entry txgain;
 	if (0/*FIXME HWPCTL capable */) {
 		//TODO
 	} else { /* This device is only software TX power control capable. */
+		txgain.bb_mult = 0x96;
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-			//TODO
+			txgain.gm = 4;
+			txgain.pad = 12;
+			txgain.pga = 12;
+			txgain.dac = 0;
 		} else {
-			//TODO
-		}
-		//TODO set BB multiplier to 0x0096
+			txgain.gm = 7;
+			txgain.pad = 15;
+			txgain.pga = 14;
+			txgain.dac = 0;
+		} // FIXME offset 0 is just a guess!
+		lpphy_write_gain_table(dev, 0, txgain);
 	}
 }
 


