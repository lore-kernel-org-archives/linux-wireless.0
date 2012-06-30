Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53915 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab2F3NSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:18:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 18/18] brcmsmac: handle non PCI devices in the phy code
Date: Sat, 30 Jun 2012 15:16:21 +0200
Message-Id: <1341062181-28071-19-git-send-email-hauke@hauke-m.de> (sfid-20120630_151818_255041_48F0B0CA)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some code in write_{radio,radio}_reg() should just be run if this is a
pci based device. Add the condition again which was removed in commit:
commit 821e4e93172e4f7d5ac1eade04665c3dc5049c4a
Author: Roland Vossen <rvossen@broadcom.com>
Date:   Mon Aug 8 15:58:58 2011 +0200

    staging: brcm80211: removed unused bus code from softmac

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 1703e7d..91937c5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -198,6 +198,8 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 
 void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
+	struct si_info *sii = container_of(pi->sh->sih, struct si_info, pub);
+
 	if ((D11REV_GE(pi->sh->corerev, 24)) ||
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
@@ -209,7 +211,8 @@ void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 		bcma_write16(pi->d11core, D11REGOFFS(phy4wdatalo), val);
 	}
 
-	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
+	if ((sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) &&
+	    (++pi->phy_wreg >= pi->phy_wreg_limit)) {
 		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		pi->phy_wreg = 0;
 	}
@@ -294,8 +297,11 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 	if (addr == 0x72)
 		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata));
 #else
+	struct si_info *sii = container_of(pi->sh->sih, struct si_info, pub);
+
 	bcma_write32(pi->d11core, D11REGOFFS(phyregaddr), addr | (val << 16));
-	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
+	if ((sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) &&
+	    (++pi->phy_wreg >= pi->phy_wreg_limit)) {
 		pi->phy_wreg = 0;
 		(void)bcma_read16(pi->d11core, D11REGOFFS(phyversion));
 	}
-- 
1.7.9.5

