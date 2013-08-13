Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2881 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758989Ab3HMUEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 12/13] brcmsmac: reinitialize TSSI power control upon
 channel switch
Date: Tue, 13 Aug 2013 22:03:39 +0200
Message-ID: <1376424220-10765-13-git-send-email-arend@broadcom.com> (sfid-20130813_220445_725688_B7FDF0C2)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When changing channels the TSSI based power control needs to be
reinitialized.

Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index a0a268d..6e6bc28 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -5019,6 +5019,8 @@ void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
 		wlc_lcnphy_load_tx_iir_filter(pi, true, 3);
 
 	mod_phy_reg(pi, 0x4eb, (0x7 << 3), (1) << 3);
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
+		wlc_lcnphy_tssi_setup(pi);
 }
 
 void wlc_phy_detach_lcnphy(struct brcms_phy *pi)
-- 
1.7.10.4


