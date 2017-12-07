Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48085 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbdLGKUv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 05:20:51 -0500
From: Colin King <colin.king@canonical.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmsmac: use ARRAY_SIZE on rfseq_updategainu_events
Date: Thu,  7 Dec 2017 10:20:47 +0000
Message-Id: <20171207102047.21635-1-colin.king@canonical.com> (sfid-20171207_112202_204316_355364CF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Use the ARRAY_SIZE macro on rfseq_updategainu_events to determine
size of the array. Improvement suggested by coccinelle.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index 763e8ba6b178..7e01981bc5c8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -16049,8 +16049,7 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_UPDATEGAINU,
 				       rfseq_updategainu_events,
 				       rfseq_updategainu_dlys,
-				       sizeof(rfseq_updategainu_events) /
-				       sizeof(rfseq_updategainu_events[0]));
+				       ARRAY_SIZE(rfseq_updategainu_events));
 
 		mod_phy_reg(pi, 0x153, (0xff << 8), (90 << 8));
 
-- 
2.14.1
