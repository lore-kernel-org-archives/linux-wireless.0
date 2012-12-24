Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.sysproserver.de ([78.138.89.176]:34537 "EHLO
	srv5.sysproserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2LXMHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2012 07:07:44 -0500
From: Niels Ole Salscheider <niels_ole@salscheider-online.de>
To: linux-wireless@vger.kernel.org
Cc: Niels Ole Salscheider <niels_ole@salscheider-online.de>
Subject: [PATCH] brcmsmac: Use udelay instead of usleep_range
Date: Mon, 24 Dec 2012 13:07:36 +0100
Message-Id: <1356350856-3389-1-git-send-email-niels_ole@salscheider-online.de> (sfid-20121224_130747_914875_C75B6A23)
In-Reply-To: <1356350538-3243-1-git-send-email-niels_ole@salscheider-online.de>
References: <1356350538-3243-1-git-send-email-niels_ole@salscheider-online.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlc_lcnphy_rx_iq_cal_gain is called during initialization, i. e. when
executing brcms_up.
But brcms_up is called from brcms_ops_start while the latter holds a spin lock.
Thus, we cannot use usleep_range but have to use udelay.

This fixes:
BUG: scheduling while atomic: NetworkManager/1652/0x00000200
[...]
Call Trace:
 [<ffffffff81582522>] __schedule_bug+0x48/0x54
 [<ffffffff815892b6>] __schedule+0x596/0x6d0
 [<ffffffff81589719>] schedule+0x29/0x70
 [<ffffffff8158893c>] schedule_hrtimeout_range_clock+0xfc/0x140
 [<ffffffff81060f10>] ? update_rmtp+0x70/0x70
 [<ffffffff81588993>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff810495e0>] usleep_range+0x40/0x50
 [<ffffffffa05dedcb>] wlc_lcnphy_rx_iq_cal.constprop.10+0x59b/0xa90 [brcmsmac]
 [<ffffffffa05df4ce>] wlc_lcnphy_periodic_cal+0x20e/0x220 [brcmsmac]
 [<ffffffffa05dce8d>] ? wlc_lcnphy_set_tx_pwr_ctrl+0x21d/0x3c0 [brcmsmac]
 [<ffffffffa05e0cfc>] wlc_phy_init_lcnphy+0xacc/0x1100 [brcmsmac]
 [<ffffffffa05e0230>] ? wlc_phy_txpower_recalc_target_lcnphy+0x90/0x90 [brcmsmac]
 [<ffffffffa05d7c7d>] wlc_phy_init+0xcd/0x170 [brcmsmac]
 [<ffffffffa05c9dfe>] brcms_b_bsinit.isra.65+0x12e/0x310 [brcmsmac]
 [<ffffffffa05d061b>] brcms_c_init+0x8fb/0x1170 [brcmsmac]
 [<ffffffffa05c3a0a>] brcms_init+0x5a/0x70 [brcmsmac]
 [<ffffffffa05ce76c>] brcms_c_up+0x1ac/0x4a0 [brcmsmac]
 [<ffffffffa05c3c65>] brcms_up+0x25/0x30 [brcmsmac]
 [<ffffffffa05c44c0>] brcms_ops_start+0xd0/0x100 [brcmsmac]
[...]

Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 606b534..21a8242 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1343,13 +1343,13 @@ static bool wlc_lcnphy_rx_iq_cal_gain(struct brcms_phy *pi, u16 biq1_gain,
 
 	wlc_lcnphy_rx_gain_override_enable(pi, true);
 	wlc_lcnphy_start_tx_tone(pi, 2000, (40 >> 1), 0);
-	usleep_range(500, 500);
+	udelay(500);
 	write_radio_reg(pi, RADIO_2064_REG112, 0);
 	if (!wlc_lcnphy_rx_iq_est(pi, 1024, 32, &iq_est_l))
 		return false;
 
 	wlc_lcnphy_start_tx_tone(pi, 2000, 40, 0);
-	usleep_range(500, 500);
+	udelay(500);
 	write_radio_reg(pi, RADIO_2064_REG112, 0);
 	if (!wlc_lcnphy_rx_iq_est(pi, 1024, 32, &iq_est_h))
 		return false;
-- 
1.8.0.2

