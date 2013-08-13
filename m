Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2880 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758837Ab3HMUEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:32 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 11/13] brcmsmac: correct phy registers for TSSI-based
 power control
Date: Tue, 13 Aug 2013 22:03:38 +0200
Message-ID: <1376424220-10765-12-git-send-email-arend@broadcom.com> (sfid-20130813_220438_447441_F6E0CE81)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of additional phy registers needs to be programmed when
using TSSI-based power control.

Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 732371c..a0a268d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -2020,6 +2020,16 @@ wlc_lcnphy_set_tssi_mux(struct brcms_phy *pi, enum lcnphy_tssi_mode pos)
 		} else {
 			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0x1);
 			mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
+			mod_radio_reg(pi, RADIO_2064_REG028, 0x1, 0x0);
+			mod_radio_reg(pi, RADIO_2064_REG11A, 0x4, 1<<2);
+			mod_radio_reg(pi, RADIO_2064_REG036, 0x10, 0x0);
+			mod_radio_reg(pi, RADIO_2064_REG11A, 0x10, 1<<4);
+			mod_radio_reg(pi, RADIO_2064_REG036, 0x3, 0x0);
+			mod_radio_reg(pi, RADIO_2064_REG035, 0xff, 0x77);
+			mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, 0xe<<1);
+			mod_radio_reg(pi, RADIO_2064_REG112, 0x80, 1<<7);
+			mod_radio_reg(pi, RADIO_2064_REG005, 0x7, 1<<1);
+			mod_radio_reg(pi, RADIO_2064_REG029, 0xf0, 0<<4);
 		}
 	} else {
 		mod_phy_reg(pi, 0x4d9, (0x1 << 2), (0x1) << 2);
@@ -2106,6 +2116,7 @@ static void wlc_lcnphy_pwrctrl_rssiparams(struct brcms_phy *pi)
 		    (auxpga_vmid_temp << 0) | (auxpga_gain_temp << 12));
 
 	mod_radio_reg(pi, RADIO_2064_REG082, (1 << 5), (1 << 5));
+	mod_radio_reg(pi, RADIO_2064_REG07C, (1 << 0), (1 << 0));
 }
 
 static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
@@ -2218,6 +2229,10 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 
 	mod_phy_reg(pi, 0x4d7, (0xf << 8), (0) << 8);
 
+	mod_radio_reg(pi, RADIO_2064_REG035, 0xff, 0x0);
+	mod_radio_reg(pi, RADIO_2064_REG036, 0x3, 0x0);
+	mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
+
 	wlc_lcnphy_pwrctrl_rssiparams(pi);
 }
 
@@ -3096,6 +3111,11 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 			wlc_lcnphy_write_table(pi, &tab);
 			tab.tbl_offset++;
 		}
+		mod_phy_reg(pi, 0x4d0, (0x1 << 0), (0) << 0);
+		mod_phy_reg(pi, 0x4d3, (0xff << 0), (0) << 0);
+		mod_phy_reg(pi, 0x4d3, (0xff << 8), (0) << 8);
+		mod_phy_reg(pi, 0x4d0, (0x1 << 4), (0) << 4);
+		mod_phy_reg(pi, 0x4d0, (0x1 << 2), (0) << 2);
 
 		mod_phy_reg(pi, 0x410, (0x1 << 7), (0) << 7);
 
-- 
1.7.10.4


