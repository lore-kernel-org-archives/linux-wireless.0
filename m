Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44983 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Avs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:48 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 12/19] brcmsmac: remove pcicore_attach()
Date: Sun, 29 Apr 2012 02:50:36 +0200
Message-Id: <1335660643-26368-13-git-send-email-hauke@hauke-m.de> (sfid-20120429_025152_652268_717A5974)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is already done by bcma in bcma_pcicore_serdes_workaround().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |  151 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h  |    1 -
 3 files changed, 155 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index b64fbc0..cafacb1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -534,9 +534,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_cc_reg(sih, offsetof(struct chipcregs, gpiotimerval),
 		  ~0, w);
 
-	if (PCIE(sih))
-		pcicore_attach(sii->pch, SI_DOATTACH);
-
 	if (ai_get_chip_id(sih) == BCM43224_CHIP_ID) {
 		/*
 		 * enable 12 mA drive strenth for 43224 and
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index c217f8d..5de506d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -211,18 +211,11 @@ struct pcicore_info {
 	struct bcma_device *core;
 	struct si_pub *sih;	/* System interconnect handle */
 	struct pci_dev *dev;
-	u8 pcie_polarity;
 
 	u8 pmecap_offset;	/* PM Capability offset in the config space */
 	bool pmecap;		/* Capable of generating PME */
 };
 
-/* delay needed between the mdio control/ mdiodata register data access */
-static void pr28829_delay(void)
-{
-	udelay(10);
-}
-
 /* Initialize the PCI core.
  * It's caller's responsibility to make sure that this is done only once
  */
@@ -351,103 +344,6 @@ static uint pcie_writereg(struct bcma_device *core, uint addrtype,
 	return 0;
 }
 
-static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
-{
-	uint mdiodata, i = 0;
-	uint pcie_serdes_spinwait = 200;
-
-	mdiodata = (MDIODATA_START | MDIODATA_WRITE | MDIODATA_TA |
-		    (MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
-		    (MDIODATA_BLK_ADDR << MDIODATA_REGADDR_SHF) |
-		    (blk << 4));
-	bcma_write32(pi->core, PCIEREGOFFS(mdiodata), mdiodata);
-
-	pr28829_delay();
-	/* retry till the transaction is complete */
-	while (i < pcie_serdes_spinwait) {
-		if (bcma_read32(pi->core, PCIEREGOFFS(mdiocontrol)) &
-		    MDIOCTL_ACCESS_DONE)
-			break;
-
-		udelay(1000);
-		i++;
-	}
-
-	if (i >= pcie_serdes_spinwait)
-		return false;
-
-	return true;
-}
-
-static int
-pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
-	    uint *val)
-{
-	uint mdiodata;
-	uint i = 0;
-	uint pcie_serdes_spinwait = 10;
-
-	/* enable mdio access to SERDES */
-	bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol),
-		     MDIOCTL_PREAM_EN | MDIOCTL_DIVISOR_VAL);
-
-	/* new serdes is slower in rw,
-	 * using two layers of reg address mapping
-	 */
-	if (!pcie_mdiosetblock(pi, physmedia))
-		return 1;
-	mdiodata = ((MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
-		    (regaddr << MDIODATA_REGADDR_SHF));
-	pcie_serdes_spinwait *= 20;
-
-	if (!write)
-		mdiodata |= (MDIODATA_START | MDIODATA_READ | MDIODATA_TA);
-	else
-		mdiodata |= (MDIODATA_START | MDIODATA_WRITE | MDIODATA_TA |
-			     *val);
-
-	bcma_write32(pi->core, PCIEREGOFFS(mdiodata), mdiodata);
-
-	pr28829_delay();
-
-	/* retry till the transaction is complete */
-	while (i < pcie_serdes_spinwait) {
-		if (bcma_read32(pi->core, PCIEREGOFFS(mdiocontrol)) &
-		    MDIOCTL_ACCESS_DONE) {
-			if (!write) {
-				pr28829_delay();
-				*val = (bcma_read32(pi->core,
-						    PCIEREGOFFS(mdiodata)) &
-					MDIODATA_MASK);
-			}
-			/* Disable mdio access to SERDES */
-			bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol), 0);
-			return 0;
-		}
-		udelay(1000);
-		i++;
-	}
-
-	/* Timed out. Disable mdio access to SERDES. */
-	bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol), 0);
-	return 1;
-}
-
-/* use the mdio interface to read from mdio slaves */
-static int
-pcie_mdioread(struct pcicore_info *pi, uint physmedia, uint regaddr,
-	      uint *regval)
-{
-	return pcie_mdioop(pi, physmedia, regaddr, false, regval);
-}
-
-/* use the mdio interface to write to mdio slaves */
-static int
-pcie_mdiowrite(struct pcicore_info *pi, uint physmedia, uint regaddr, uint val)
-{
-	return pcie_mdioop(pi, physmedia, regaddr, true, &val);
-}
-
 /* ***** Support functions ***** */
 static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 {
@@ -462,53 +358,6 @@ static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
 }
 
-/* ***** PCI core WARs ***** */
-/* Done only once at attach time */
-static void pcie_war_polarity(struct pcicore_info *pi)
-{
-	u32 w;
-
-	if (pi->pcie_polarity != 0)
-		return;
-
-	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_PLP_STATUSREG);
-
-	/* Detect the current polarity at attach and force that polarity and
-	 * disable changing the polarity
-	 */
-	if ((w & PCIE_PLP_POLARITYINV_STAT) == 0)
-		pi->pcie_polarity = SERDES_RX_CTRL_FORCE;
-	else
-		pi->pcie_polarity = (SERDES_RX_CTRL_FORCE |
-				     SERDES_RX_CTRL_POLARITY);
-}
-
-/* Apply the polarity determined at the start */
-/* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_war_serdes(struct pcicore_info *pi)
-{
-	u32 w = 0;
-
-	if (pi->pcie_polarity != 0)
-		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_CTRL,
-			       pi->pcie_polarity);
-
-	pcie_mdioread(pi, MDIODATA_DEV_PLL, SERDES_PLL_CTRL, &w);
-	if (w & PLL_CTRL_FREQDET_EN) {
-		w &= ~PLL_CTRL_FREQDET_EN;
-		pcie_mdiowrite(pi, MDIODATA_DEV_PLL, SERDES_PLL_CTRL, w);
-	}
-}
-
-/* ***** Functions called during driver state changes ***** */
-void pcicore_attach(struct pcicore_info *pi, int state)
-{
-	/* These need to happen in this order only */
-	pcie_war_polarity(pi);
-
-	pcie_war_serdes(pi);
-}
-
 void pcicore_up(struct pcicore_info *pi, int state)
 {
 	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
index 7d7e5e5..460a33e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
@@ -64,7 +64,6 @@ struct sbpcieregs;
 extern struct pcicore_info *pcicore_init(struct si_pub *sih,
 					 struct bcma_device *core);
 extern void pcicore_deinit(struct pcicore_info *pch);
-extern void pcicore_attach(struct pcicore_info *pch, int state);
 extern void pcicore_up(struct pcicore_info *pch, int state);
 extern void pcicore_down(struct pcicore_info *pch, int state);
 extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
-- 
1.7.9.5

