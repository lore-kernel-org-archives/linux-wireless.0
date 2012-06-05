Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36296 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab2FEXIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:47 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 17/18] brcmsmac: fix read in write_phy_reg
Date: Wed,  6 Jun 2012 01:07:20 +0200
Message-Id: <1338937641-8519-18-git-send-email-hauke@hauke-m.de> (sfid-20120606_012943_768101_76008F22)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts a unintended change mad in commit.
commit 4b006b11ca18995677c5f1cd03cc9c42fbe80693
Author: Arend van Spriel <arend@broadcom.com>
Date:   Thu Dec 8 15:06:54 2011 -0800

    brcm80211: smac: use bcma functions for register access in phy code

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 5cfbe5c..25a17eb 100644
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

