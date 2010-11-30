Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62589 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0K3Vdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 16:33:39 -0500
Received: by wwb28 with SMTP id 28so40675wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 13:33:38 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: N-PHY: fix code path on PHY init
Date: Tue, 30 Nov 2010 22:33:16 +0100
Message-Id: <1291152796-18700-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291152796-18700-1-git-send-email-zajec5@gmail.com>
References: <1291152796-18700-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: this introduces 2 lines over 80 chars, but I really dislike idea of
breaking line between argument, and so having start of function name in one
line and comparing result to zero in another.
Are you OK with this?
---
 drivers/net/wireless/b43/phy_n.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f26b60b..905f1d7 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3498,19 +3498,16 @@ int b43_phy_initn(struct b43_wldev *dev)
 					/* TODO N PHY Pre Calibrate TX Gain */
 					target = b43_nphy_get_tx_gains(dev);
 				}
-			}
+				if (!b43_nphy_cal_tx_iq_lo(dev, target, true, false))
+					if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
+						b43_nphy_save_cal(dev);
+			} else if (nphy->mphase_cal_phase_id == 0)
+				;/* N PHY Periodic Calibration with arg 3 */
+		} else {
+			b43_nphy_restore_cal(dev);
 		}
 	}
 
-	if (!b43_nphy_cal_tx_iq_lo(dev, target, true, false)) {
-		if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
-			b43_nphy_save_cal(dev);
-		else if (nphy->mphase_cal_phase_id == 0)
-			;/* N PHY Periodic Calibration with argument 3 */
-	} else {
-		b43_nphy_restore_cal(dev);
-	}
-
 	b43_nphy_tx_pwr_ctrl_coef_setup(dev);
 	b43_nphy_tx_power_ctrl(dev, tx_pwr_state);
 	b43_phy_write(dev, B43_NPHY_TXMACIF_HOLDOFF, 0x0015);
-- 
1.6.3.3

