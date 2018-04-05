Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.146.195]:46512 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752582AbeDEAep (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 20:34:45 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 00D621CC00C9
        for <linux-wireless@vger.kernel.org>; Wed,  4 Apr 2018 19:09:47 -0500 (CDT)
Date: Wed, 4 Apr 2018 19:09:44 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] brcm80211: brcmsmac: phy_lcn: remove duplicate code
Message-ID: <20180405000944.GA22743@embeddedor.com> (sfid-20180405_023449_750981_A73E7F46)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove and refactor some code in order to avoid having identical code
for different branches.

Notice that this piece of code hasn't been modified since 2011.

Addresses-Coverity-ID: 1226756 ("Identical code for different branches")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index 93d4cde..9d830d2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -3388,13 +3388,8 @@ void wlc_lcnphy_deaf_mode(struct brcms_phy *pi, bool mode)
 	u8 phybw40;
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
-	if (LCNREV_LT(pi->pubpi.phy_rev, 2)) {
-		mod_phy_reg(pi, 0x4b0, (0x1 << 5), (mode) << 5);
-		mod_phy_reg(pi, 0x4b1, (0x1 << 9), 0 << 9);
-	} else {
-		mod_phy_reg(pi, 0x4b0, (0x1 << 5), (mode) << 5);
-		mod_phy_reg(pi, 0x4b1, (0x1 << 9), 0 << 9);
-	}
+	mod_phy_reg(pi, 0x4b0, (0x1 << 5), (mode) << 5);
+	mod_phy_reg(pi, 0x4b1, (0x1 << 9), 0 << 9);
 
 	if (phybw40 == 0) {
 		mod_phy_reg((pi), 0x410,
-- 
2.7.4
