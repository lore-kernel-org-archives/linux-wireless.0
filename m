Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62654 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0ANWnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 17:43:23 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so56513fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 14:43:22 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 23:43:21 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 5/6] b43: N-PHY: correct condition blocks in init
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6jn2jfp9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   16 +++++++++-------
  1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d5a2dc8..356b89f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1842,17 +1842,19 @@ int b43_phy_initn(struct b43_wldev *dev)
  					//TODO N PHY Pre Calibrate TX Gain
  					target = b43_nphy_get_tx_gains(dev);
  				}
-				/* TODO: If the output of N PHY Cal TX Iqlo with target, 1 0 as arguments is 0
-					if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
-						Call N PHY Save Cal */
-			} else if (nphy->mphase_cal_phase_id == 0) {
-				//TODO N PHY Periodic Calibration with argument 3
  			}
-		} else {
-			b43_nphy_restore_cal(dev);
  		}
  	}

+	/* TODO: If the output of N PHY Cal TX Iqlo with target, 1 0 as arguments is 0 {
+		if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
+			Call N PHY Save Cal
+		else if (nphy->mphase_cal_phase_id == 0)
+			//TODO: N PHY Periodic Calibration with argument 3
+	} else {
+		b43_nphy_restore_cal(dev);
+	} */
+
  	b43_nphy_tx_pwr_ctrl_coef_setup(dev);
  	//TODO N PHY TX Power Control Enable with argument tx_pwr_state
  	b43_phy_write(dev, B43_NPHY_TXMACIF_HOLDOFF, 0x0015);
-- 
1.6.4.2

