Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2885 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876Ab3HMUEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:32 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 09/13] brcmsmac: avoid calling set_txpwr_by_index()
 twice
Date: Tue, 13 Aug 2013 22:03:36 +0200
Message-ID: <1376424220-10765-10-git-send-email-arend@broadcom.com> (sfid-20130813_220452_118907_29C691B0)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For lcnphy revision 1 or when hardware supports i/q calibration the
function wlc_lcnphy_set_txpwr_by_index() was called twice.

Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 96be1ba..e02729d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -3897,7 +3897,6 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 	target_gains.pad_gain = 21;
 	target_gains.dac_gain = 0;
 	wlc_lcnphy_set_tx_gain(pi, &target_gains);
-	wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1) || pi_lcn->lcnphy_hw_iqcal_en) {
 
@@ -3908,6 +3907,7 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 					lcnphy_recal ? LCNPHY_CAL_RECAL :
 					LCNPHY_CAL_FULL), false);
 	} else {
+		wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
 		wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
 	}
 
-- 
1.7.10.4


