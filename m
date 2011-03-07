Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mirapoint21.brutele.be ([212.68.199.158]:29050 "EHLO
	mirapoint21.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1CGSS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 13:18:56 -0500
Message-ID: <4D75218C.4040902@tvcablenet.be>
Date: Mon, 07 Mar 2011 19:18:52 +0100
From: =?windows-1252?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 11/11] rtlwifi: rtl8192se: Modify rtlwifi routines to
 handle rtl8192se and add Makefile and Kconfig
References: <4d732b88.lM+a0Gg928N+S/xO%Larry.Finger@lwfinger.net> <4D73EB12.3040102@tvcablenet.be> <4D73F209.8050406@lwfinger.net> <4D73F506.50609@tvcablenet.be> <4D74448E.2070504@lwfinger.net>
In-Reply-To: <4D74448E.2070504@lwfinger.net>
Content-Type: multipart/mixed;
 boundary="------------010909040002040802020507"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010909040002040802020507
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Le 07/03/11 03:35, Larry Finger a écrit :
> On 03/06/2011 02:56 PM, François Valenduc wrote:
>
>> Sorry to annoy you again but either I am doing something wrong or this
>> new patch doesn't apply on top of the 10 first patches. There seems to
>> be problems in fuse.c, pci.c and core.c (all in
>> drivers/net/wireless/rtlwifi).
>
> Did the driver build for you after those other two patches were added?
>
> What are the PCI IDs for your device? I have 3 of them, and one does
> not yet work - a problem that I'm now chasing.
>
> Larry
>
I didn't manage to build the driver yet. I still get rejects when I
apply the last patch (see attached file). So, I get the following
compile error:

drivers/net/wireless/rtlwifi/rtl8192se/dm.c:33:17: erreur: def.h : Aucun
fichier ou dossier de ce type
In file included from drivers/net/wireless/rtlwifi/rtl8192se/dm.c:34:
drivers/net/wireless/rtlwifi/rtl8192se/phy.h:95: attention : ‘enum
fwcmd_iotype’ declared inside parameter list
drivers/net/wireless/rtlwifi/rtl8192se/phy.h:95: attention : visible
uniquement depuis cette définition ou déclaration, ce qui n'est
probablement pas ce que vous désirez
drivers/net/wireless/rtlwifi/rtl8192se/dm.c: In function
‘_rtl92s_dm_txpowertracking_callback_thermalmeter’:
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:179: erreur:
‘FW_CMD_TXPWR_TRACK_THERMAL’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:179: erreur: (Each
undeclared identifier is reported only once
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:179: erreur: for each
function it appears in.)
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:179: erreur: le type du
paramètre formel 2 est incomplet
drivers/net/wireless/rtlwifi/rtl8192se/dm.c: In function
‘_rtl92s_dm_refresh_rateadaptive_mask’:
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:233: erreur:
‘FW_CMD_CTRL_DM_BY_DRIVER’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:233: erreur: le type du
paramètre formel 2 est incomplet
drivers/net/wireless/rtlwifi/rtl8192se/dm.c: In function
‘_rtl92s_dm_initial_gain_sta_beforeconnect’:
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:487: erreur:
‘FW_CMD_DIG_ENABLE’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:487: erreur: le type du
paramètre formel 2 est incomplet
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:503: erreur:
‘FW_CMD_DIG_DISABLE’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:503: erreur: le type du
paramètre formel 2 est incomplet
drivers/net/wireless/rtlwifi/rtl8192se/dm.c: In function
‘_rtl92s_dm_ctrl_initgain_bytwoport’:
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:539: erreur:
‘FW_CMD_DIG_MODE_SS’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:539: erreur: le type du
paramètre formel 2 est incomplet
make[5]: *** [drivers/net/wireless/rtlwifi/rtl8192se/dm.o] Erreur 1
make[5]: *** Attente des tâches non terminées....
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:38:17: erreur: def.h : Aucun
fichier ou dossier de ce type
In file included from drivers/net/wireless/rtlwifi/rtl8192se/hw.c:39:
drivers/net/wireless/rtlwifi/rtl8192se/phy.h:95: attention : ‘enum
fwcmd_iotype’ declared inside parameter list
drivers/net/wireless/rtlwifi/rtl8192se/phy.h:95: attention : visible
uniquement depuis cette définition ou déclaration, ce qui n'est
probablement pas ce que vous désirez
drivers/net/wireless/rtlwifi/rtl8192se/hw.c: In function
‘_rtl92se_macconfig_before_fwdownload’:
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:715: erreur: ‘RX_MPDU_QUEUE’
undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:715: erreur: (Each
undeclared identifier is reported only once
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:715: erreur: for each
function it appears in.)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:716: erreur: ‘RX_CMD_QUEUE’
undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c: In function ‘rtl92se_hw_init’:
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:1007: erreur:
‘RF_OP_BY_SW_3WIRE’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:1069: erreur:
‘FW_CMD_RA_INIT’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:1069: erreur: le type du
paramètre formel 2 est incomplet
drivers/net/wireless/rtlwifi/rtl8192se/hw.c: In function
‘_rtl8192se_get_IC_Inferiority’:
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:1630: erreur:
‘IC_INFERIORITY_A’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:1638: erreur:
‘IC_INFERIORITY_B’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c: In function
‘rtl92se_update_hal_rate_table’:
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:2088: erreur:
‘FW_CMD_RA_REFRESH_N’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:2088: erreur: le type du
paramètre formel 2 est incomplet
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:2090: erreur:
‘FW_CMD_RA_REFRESH_BG’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:2090: erreur: le type du
paramètre formel 2 est incomplet
make[5]: *** [drivers/net/wireless/rtlwifi/rtl8192se/hw.o] Erreur 1

It seems there is a missing header file (def.h). Finally, the output of
lspci -v is the following:

06:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB
Wireless LAN Controller (rev 10)
Subsystem: Realtek Semiconductor Co., Ltd. Device 8184
Flags: bus master, fast devsel, latency 0, IRQ 17
I/O ports at 2000 [size=256]
Memory at d1500000 (32-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
Capabilities: [70] Express Legacy Endpoint, MSI 00
Capabilities: [100] Advanced Error Reporting
Capabilities: [140] Virtual Channel <?>
Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
Kernel driver in use: rtl819xSE
Kernel modules: r8192se_pci




--------------010909040002040802020507
Content-Type: text/plain;
 name="pci.c.rej"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pci.c.rej"

***************
*** 1454,1467 ****
  	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
  	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
  	struct pci_dev *bridge_pdev = pdev->bus->self;
- 	u16 venderid;
- 	u16 deviceid;
  	u16 irqline;
  	u8 tmp;
  
- 	venderid = pdev->vendor;
- 	deviceid = pdev->device;
- 	pci_read_config_word(pdev, 0x3C, &irqline);
  
  	if (deviceid == RTL_PCI_8192_DID ||
  	    deviceid == RTL_PCI_0044_DID ||
--- 1625,1637 ----
  	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
  	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
  	struct pci_dev *bridge_pdev = pdev->bus->self;
+ 	u16 venderid = pdev->vendor;
+ 	u16 deviceid = pdev->device;
+ 	u8 revisionid = pdev->revision;
  	u16 irqline;
  	u8 tmp;
  
+ 	pci_read_config_word(pdev, PCI_INTERRUPT_LINE, &irqline);
  
  	if (deviceid == RTL_PCI_8192_DID ||
  	    deviceid == RTL_PCI_0044_DID ||
***************
*** 1471,1477 ****
  	    deviceid == RTL_PCI_8173_DID ||
  	    deviceid == RTL_PCI_8172_DID ||
  	    deviceid == RTL_PCI_8171_DID) {
- 		switch (pdev->revision) {
  		case RTL_PCI_REVISION_ID_8192PCIE:
  			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
  				 ("8192 PCI-E is found - "
--- 1641,1647 ----
  	    deviceid == RTL_PCI_8173_DID ||
  	    deviceid == RTL_PCI_8172_DID ||
  	    deviceid == RTL_PCI_8171_DID) {
+ 		switch (revisionid) {
  		case RTL_PCI_REVISION_ID_8192PCIE:
  			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
  				 ("8192 PCI-E is found - "

--------------010909040002040802020507--

