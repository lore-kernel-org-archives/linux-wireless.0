Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3080 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/15] brcm80211: smac: fix compilation issue with
 CONFIG_BCM47XX set
Date: Mon, 12 Dec 2011 15:15:13 -0800
Message-ID: <1323731713-14942-16-git-send-email-frankyl@broadcom.com> (sfid-20111213_002944_856550_8AE35EED)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

With the BCMA support patches a compilation issue was introduced
with CONFIG_BCM47XX set. This patch fixes that issue.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 687aafa..d2c7fb1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -292,7 +292,7 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
 	bcma_write16(pi->d11core, D11REGOFFS(phyregdata), val);
 	if (addr == 0x72)
-		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata), val);
+		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata));
 #else
 	bcma_write32(pi->d11core, D11REGOFFS(phyregaddr), addr | (val << 16));
 	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
-- 
1.7.5.4


