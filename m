Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2879 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917Ab3HMUEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:32 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 08/13] brcmsmac: fix TSSI idle estimation
Date: Tue, 13 Aug 2013 22:03:35 +0200
Message-ID: <1376424220-10765-9-git-send-email-arend@broadcom.com> (sfid-20130813_220436_786942_FC8CCA6A)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The baseband multiplier must be zero during TSSI idle estimation
and restored afterwards.

Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 8099d74..96be1ba 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -2836,6 +2836,8 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 		read_radio_reg(pi, RADIO_2064_REG007) & 1;
 	u16 SAVE_jtag_auxpga = read_radio_reg(pi, RADIO_2064_REG0FF) & 0x10;
 	u16 SAVE_iqadc_aux_en = read_radio_reg(pi, RADIO_2064_REG11F) & 4;
+	u8 SAVE_bbmult = wlc_lcnphy_get_bbmult(pi);
+
 	idleTssi = read_phy_reg(pi, 0x4ab);
 	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
 			 MCTL_EN_MAC));
@@ -2853,6 +2855,12 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, 1 << 4);
 	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 1 << 2);
 	wlc_lcnphy_tssi_setup(pi);
+
+	mod_phy_reg(pi, 0x4d7, (0x1 << 0), (1 << 0));
+	mod_phy_reg(pi, 0x4d7, (0x1 << 6), (1 << 6));
+
+	wlc_lcnphy_set_bbmult(pi, 0x0);
+
 	wlc_phy_do_dummy_tx(pi, true, OFF);
 	idleTssi = ((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
 		    >> 0);
@@ -2874,6 +2882,7 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 
 	mod_phy_reg(pi, 0x44c, (0x1 << 12), (0) << 12);
 
+	wlc_lcnphy_set_bbmult(pi, SAVE_bbmult);
 	wlc_lcnphy_set_tx_gain_override(pi, tx_gain_override_old);
 	wlc_lcnphy_set_tx_gain(pi, &old_gains);
 	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
-- 
1.7.10.4


