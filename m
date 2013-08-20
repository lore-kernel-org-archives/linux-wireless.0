Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3238 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3HTOA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 10:00:59 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/12] brcmsmac: avoid calling set_txpwr_by_index()
 twice
Date: Tue, 20 Aug 2013 16:00:42 +0200
Message-ID: <1377007246-9957-9-git-send-email-arend@broadcom.com> (sfid-20130820_160105_921257_C0BD656F)
In-Reply-To: <1377007246-9957-1-git-send-email-arend@broadcom.com>
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For lcnphy revision 1 or when hardware supports i/q calibration the
function wlc_lcnphy_set_txpwr_by_index() was called twice.

Tested-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index e08b73a..caced82 100644
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


