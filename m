Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56749 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab1HFK4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 06:56:00 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so5329995iye.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Aug 2011 03:56:00 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/2] rtlwifi: Eliminate raw reads and writes from PCIe portion
Date: Sat,  6 Aug 2011 05:55:18 -0500
Message-Id: <1312628119-12640-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110806_125607_515549_5C486676)
In-Reply-To: <1312628119-12640-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1312628119-12640-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCIe driver used raw reads and writes on the PCIe hardware.
As all of these are only affecting the configuration space, all of
then can be converted to pci_{read,write}_config_XX calls.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c |   37 +++++++++--------------------------
 1 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 56f1235..9983fa1 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -218,7 +218,6 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
-	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
 	u8 num4bytes = pcipriv->ndis_adapter.num4bytes;
 	/*Retrieve original configuration settings. */
 	u8 linkctrl_reg = pcipriv->ndis_adapter.linkctrl_reg;
@@ -254,9 +253,8 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 	udelay(50);
 
 	/*4 Disable Pci Bridge ASPM */
-	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bytes << 2));
-	rtl_pci_raw_write_port_uchar(PCI_CONF_DATA, pcibridge_linkctrlreg);
+	pci_write_config_byte(rtlpci->pdev, (num4bytes << 2),
+			      pcibridge_linkctrlreg);
 
 	udelay(50);
 }
@@ -277,7 +275,6 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 	u8 pcibridge_devnum = pcipriv->ndis_adapter.pcibridge_devnum;
 	u8 pcibridge_funcnum = pcipriv->ndis_adapter.pcibridge_funcnum;
 	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
-	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
 	u8 num4bytes = pcipriv->ndis_adapter.num4bytes;
 	u16 aspmlevel;
 	u8 u_pcibridge_aspmsetting;
@@ -293,8 +290,6 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 	}
 
 	/*4 Enable Pci Bridge ASPM */
-	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bytes << 2));
 
 	u_pcibridge_aspmsetting =
 	    pcipriv->ndis_adapter.pcibridge_linkctrlreg |
@@ -303,7 +298,8 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL)
 		u_pcibridge_aspmsetting &= ~BIT(0);
 
-	rtl_pci_raw_write_port_uchar(PCI_CONF_DATA, u_pcibridge_aspmsetting);
+	pci_write_config_byte(rtlpci->pdev, (num4bytes << 2),
+			      u_pcibridge_aspmsetting);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 ("PlatformEnableASPM():PciBridge busnumber[%x], "
@@ -335,25 +331,18 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 
 static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	bool status = false;
 	u8 offset_e0;
 	unsigned offset_e4;
 
-	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-			pcicfg_addrport + 0xE0);
-	rtl_pci_raw_write_port_uchar(PCI_CONF_DATA, 0xA0);
+	pci_write_config_byte(rtlpci->pdev, 0xe0, 0xa0);
 
-	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-			pcicfg_addrport + 0xE0);
-	rtl_pci_raw_read_port_uchar(PCI_CONF_DATA, &offset_e0);
+	pci_read_config_byte(rtlpci->pdev, 0xe0, &offset_e0);
 
 	if (offset_e0 == 0xA0) {
-		rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-					     pcicfg_addrport + 0xE4);
-		rtl_pci_raw_read_port_ulong(PCI_CONF_DATA, &offset_e4);
+		pci_read_config_dword(rtlpci->pdev, 0xe4, &offset_e4);
 		if (offset_e4 & BIT(23))
 			status = true;
 	}
@@ -364,17 +353,15 @@ static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
 static void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_pci *rtlpci = rtl_pcidev(pcipriv);
 	u8 capabilityoffset = pcipriv->ndis_adapter.pcibridge_pciehdr_offset;
-	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
 	u8 linkctrl_reg;
 	u8 num4bbytes;
 
 	num4bbytes = (capabilityoffset + 0x10) / 4;
 
 	/*Read  Link Control Register */
-	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bbytes << 2));
-	rtl_pci_raw_read_port_uchar(PCI_CONF_DATA, &linkctrl_reg);
+	pci_read_config_byte(rtlpci->pdev, (num4bbytes << 2), &linkctrl_reg);
 
 	pcipriv->ndis_adapter.pcibridge_linkctrlreg = linkctrl_reg;
 }
@@ -1718,10 +1705,6 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		    PCI_SLOT(bridge_pdev->devfn);
 		pcipriv->ndis_adapter.pcibridge_funcnum =
 		    PCI_FUNC(bridge_pdev->devfn);
-		pcipriv->ndis_adapter.pcicfg_addrport =
-		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
-		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
-		    (pcipriv->ndis_adapter.pcibridge_funcnum << 8) | (1 << 31);
 		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
 		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.num4bytes =
-- 
1.7.3.4

