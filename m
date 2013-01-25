Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:39522 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618Ab3AYKy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:54:27 -0500
Date: Fri, 25 Jan 2013 16:17:56 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Move tx/rx antenna configuration to mwl8k_probe_hw
Message-ID: <20130125104756.GA9180@markyou.marvell.com> (sfid-20130125_115430_116576_CA8169FE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids calling mwl8k_cmd_rf_antenna functions every
time mwl8k_config function is called.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a48b137..b53f9fc 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4814,12 +4814,6 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 				goto out;
 		}
 
-		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_RX, 0x3);
-		if (rc)
-			wiphy_warn(hw->wiphy, "failed to set # of RX antennas");
-		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_TX, 0x7);
-		if (rc)
-			wiphy_warn(hw->wiphy, "failed to set # of TX antennas");
 
 	} else {
 		rc = mwl8k_cmd_rf_tx_power(hw, conf->power_level);
@@ -5709,6 +5703,15 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 		goto err_free_irq;
 	}
 
+	/* Configure Antennas */
+	rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_RX, 0x3);
+	if (rc)
+		wiphy_warn(hw->wiphy, "failed to set # of RX antennas");
+	rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_TX, 0x7);
+	if (rc)
+		wiphy_warn(hw->wiphy, "failed to set # of TX antennas");
+
+
 	/* Disable interrupts */
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 	free_irq(priv->pdev->irq, hw);
-- 
1.8.0.3

