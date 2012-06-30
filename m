Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53912 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab2F3NSK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:18:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 17/18] brcmsmac: fix read in write_phy_reg
Date: Sat, 30 Jun 2012 15:16:20 +0200
Message-Id: <1341062181-28071-18-git-send-email-hauke@hauke-m.de> (sfid-20120630_151815_527490_B208E5CD)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts a unintended change mad in commit.
commit 4b006b11ca18995677c5f1cd03cc9c42fbe80693
Author: Arend van Spriel <arend@broadcom.com>
Date:   Thu Dec 8 15:06:54 2011 -0800

    brcm80211: smac: use bcma functions for register access in phy code

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index d16cbec..1703e7d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -292,7 +292,7 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
 	bcma_write16(pi->d11core, D11REGOFFS(phyregdata), val);
 	if (addr == 0x72)
-		(void)bcma_read16(pi->d11core, D11REGOFFS(phyversion));
+		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata));
 #else
 	bcma_write32(pi->d11core, D11REGOFFS(phyregaddr), addr | (val << 16));
 	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
-- 
1.7.9.5

