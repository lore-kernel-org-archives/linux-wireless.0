Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34672 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbeGYUJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 16:09:47 -0400
From: Varsha Rao <rvarsha016@gmail.com>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] net: wireless: brcmsmac: Remove extra parentheses
Date: Wed, 25 Jul 2018 20:56:22 +0200
Message-Id: <20180725185625.4220-1-rvarsha016@gmail.com> (sfid-20180725_205701_012428_30AA3E09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the unnecessary parentheses to fix the clang warning of
extraneous parentheses.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index 1a187557982e..4deba3075083 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -25453,12 +25453,12 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 			(pi->cal_type_override ==
 			 PHY_PERICAL_FULL) ? true : false;
 
-	if ((pi->mphase_cal_phase_id > MPHASE_CAL_STATE_INIT)) {
+	if (pi->mphase_cal_phase_id > MPHASE_CAL_STATE_INIT) {
 		if (pi->nphy_txiqlocal_chanspec != pi->radio_chanspec)
 			wlc_phy_cal_perical_mphase_restart(pi);
 	}
 
-	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_RXCAL))
+	if (pi->mphase_cal_phase_id == MPHASE_CAL_STATE_RXCAL)
 		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
 
 	wlapi_suspend_mac_and_wait(pi->sh->physhim);
-- 
2.17.0
