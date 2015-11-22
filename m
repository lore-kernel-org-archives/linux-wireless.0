Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37677 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbKVJIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:16 -0500
Received: by wmww144 with SMTP id w144so69567091wmw.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:14 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/8] staging: vt6655: mac.c replace void __iomem * with struct vnt_private
Date: Sun, 22 Nov 2015 09:07:22 +0000
Message-Id: <1448183242-3397-8-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100840_352323_7A1053B3)
In-Reply-To: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving void __iomem down one level in the following functions
MACbIsRegBitsOn
MACbIsRegBitsOff
MACbIsIntDisable
MACvSetShortRetryLimit
MACvSetLongRetryLimit
MACvGetLongRetryLimit
MACvSetLoopbackMode
MACvSaveContext
MACvRestoreContext
MACbSoftwareReset
MACbSafeSoftwareReset
MACbSafeRxOff
MACbSafeTxOff
MACbSafeStop
MACbShutdown
MACvInitialize
MACvSetCurrRx0DescAddr
MACvSetCurrRx1DescAddr
MACvSetCurrTXDescAddr
MACvSetCurrTx0DescAddrEx
MACvSetCurrAC0DescAddrEx
MACvSetCurrSyncDescAddrEx
MACvSetCurrATIMDescAddrEx
MACvTimer0MicroSDelay
MACvOneShotTimer1MicroSec
MACvSetMISCFifo
MACbPSWakeup
MACvSetKeyEntry
MACvDisableKeyEntry

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  18 ++----
 drivers/staging/vt6655/device_main.c |  24 ++++----
 drivers/staging/vt6655/key.c         |   8 +--
 drivers/staging/vt6655/mac.c         | 108 ++++++++++++++++++++++-------------
 drivers/staging/vt6655/mac.h         |  58 +++++++++----------
 drivers/staging/vt6655/power.c       |   2 +-
 drivers/staging/vt6655/rf.c          |  36 ++++++------
 7 files changed, 137 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index b6730a8..6c1b973 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -535,11 +535,9 @@ CARDvSafeResetTx(
 	}
 
 	/* set MAC TD pointer */
-	MACvSetCurrTXDescAddr(TYPE_TXDMA0, priv->PortOffset,
-			      (priv->td0_pool_dma));
+	MACvSetCurrTXDescAddr(TYPE_TXDMA0, priv, priv->td0_pool_dma);
 
-	MACvSetCurrTXDescAddr(TYPE_AC0DMA, priv->PortOffset,
-			      (priv->td1_pool_dma));
+	MACvSetCurrTXDescAddr(TYPE_AC0DMA, priv, priv->td1_pool_dma);
 
 	/* set MAC Beacon TX pointer */
 	MACvSetCurrBCNTxDescAddr(priv->PortOffset,
@@ -590,11 +588,9 @@ CARDvSafeResetRx(
 	MACvRx0PerPktMode(priv->PortOffset);
 	MACvRx1PerPktMode(priv->PortOffset);
 	/* set MAC RD pointer */
-	MACvSetCurrRx0DescAddr(priv->PortOffset,
-			       priv->rd0_pool_dma);
+	MACvSetCurrRx0DescAddr(priv, priv->rd0_pool_dma);
 
-	MACvSetCurrRx1DescAddr(priv->PortOffset,
-			       priv->rd1_pool_dma);
+	MACvSetCurrRx1DescAddr(priv, priv->rd1_pool_dma);
 }
 
 /*
@@ -839,8 +835,6 @@ unsigned char CARDbyGetPktType(struct vnt_private *priv)
  */
 void CARDvSetLoopbackMode(struct vnt_private *priv, unsigned short wLoopbackMode)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
-
 	switch (wLoopbackMode) {
 	case CARD_LB_NONE:
 	case CARD_LB_MAC:
@@ -850,7 +844,7 @@ void CARDvSetLoopbackMode(struct vnt_private *priv, unsigned short wLoopbackMode
 		break;
 	}
 	/* set MAC loopback */
-	MACvSetLoopbackMode(dwIoBase, LOBYTE(wLoopbackMode));
+	MACvSetLoopbackMode(priv, LOBYTE(wLoopbackMode));
 	/* set Baseband loopback */
 }
 
@@ -869,7 +863,7 @@ bool CARDbSoftwareReset(struct vnt_private *priv)
 {
 
 	/* reset MAC */
-	if (!MACbSafeSoftwareReset(priv->PortOffset))
+	if (!MACbSafeSoftwareReset(priv))
 		return false;
 
 	return true;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index fefbf82..ad0fb84 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -211,11 +211,11 @@ static void device_init_registers(struct vnt_private *priv)
 	unsigned char byCCKPwrdBm = 0;
 	unsigned char byOFDMPwrdBm = 0;
 
-	MACbShutdown(priv->PortOffset);
+	MACbShutdown(priv);
 	BBvSoftwareReset(priv);
 
 	/* Do MACbSoftwareReset in MACvInitialize */
-	MACbSoftwareReset(priv->PortOffset);
+	MACbSoftwareReset(priv);
 
 	priv->bAES = false;
 
@@ -229,7 +229,7 @@ static void device_init_registers(struct vnt_private *priv)
 	priv->byTopCCKBasicRate = RATE_1M;
 
 	/* init MAC */
-	MACvInitialize(priv->PortOffset);
+	MACvInitialize(priv);
 
 	/* Get Local ID */
 	VNSvInPortB(priv->PortOffset + MAC_REG_LOCALID, &priv->byLocalID);
@@ -357,8 +357,8 @@ static void device_init_registers(struct vnt_private *priv)
 			  MAC_REG_CFG, (CFG_TKIPOPT | CFG_NOTXTIMEOUT));
 
 	/* set performance parameter by registry */
-	MACvSetShortRetryLimit(priv->PortOffset, priv->byShortRetryLimit);
-	MACvSetLongRetryLimit(priv->PortOffset, priv->byLongRetryLimit);
+	MACvSetShortRetryLimit(priv, priv->byShortRetryLimit);
+	MACvSetLongRetryLimit(priv, priv->byLongRetryLimit);
 
 	/* reset TSF counter */
 	VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
@@ -884,7 +884,7 @@ static void device_error(struct vnt_private *priv, unsigned short status)
 	if (status & ISR_FETALERR) {
 		dev_err(&priv->pcid->dev, "Hardware fatal error\n");
 
-		MACbShutdown(priv->PortOffset);
+		MACbShutdown(priv);
 		return;
 	}
 }
@@ -1012,7 +1012,7 @@ static void vnt_interrupt_process(struct vnt_private *priv)
 			if ((priv->op_mode == NL80211_IFTYPE_AP ||
 			    priv->op_mode == NL80211_IFTYPE_ADHOC) &&
 			    priv->vif->bss_conf.enable_beacon) {
-				MACvOneShotTimer1MicroSec(priv->PortOffset,
+				MACvOneShotTimer1MicroSec(priv,
 							  (priv->vif->bss_conf.beacon_int - MAKE_BEACON_RESERVED) << 10);
 			}
 
@@ -1197,8 +1197,8 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&priv->interrupt_work);
 
-	MACbShutdown(priv->PortOffset);
-	MACbSoftwareReset(priv->PortOffset);
+	MACbShutdown(priv);
+	MACbSoftwareReset(priv);
 	CARDbRadioPowerOff(priv);
 
 	device_free_td0_ring(priv);
@@ -1636,13 +1636,13 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	INIT_WORK(&priv->interrupt_work, vnt_interrupt_work);
 
 	/* do reset */
-	if (!MACbSoftwareReset(priv->PortOffset)) {
+	if (!MACbSoftwareReset(priv)) {
 		dev_err(&pcid->dev, ": Failed to access MAC hardware..\n");
 		device_free_info(priv);
 		return -ENODEV;
 	}
 	/* initial to reload eeprom */
-	MACvInitialize(priv->PortOffset);
+	MACvInitialize(priv);
 	MACvReadEtherAddress(priv->PortOffset, priv->abyCurrentNetAddr);
 
 	/* Get RFType */
@@ -1690,7 +1690,7 @@ static int vt6655_suspend(struct pci_dev *pcid, pm_message_t state)
 
 	pci_save_state(pcid);
 
-	MACbShutdown(priv->PortOffset);
+	MACbShutdown(priv);
 
 	pci_disable_device(pcid);
 	pci_set_power_state(pcid, pci_choose_state(pcid, state));
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index f2b3fea..ffcaf25 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -36,7 +36,7 @@ int vnt_key_init_table(struct vnt_private *priv)
 	u32 i;
 
 	for (i = 0; i < MAX_KEY_TABLE; i++)
-		MACvDisableKeyEntry(priv->PortOffset, i);
+		MACvDisableKeyEntry(priv, i);
 
 	return 0;
 }
@@ -104,7 +104,7 @@ static int vnt_set_keymode(struct ieee80211_hw *hw, u8 *mac_addr,
 			key->key[15] |= 0x80;
 	}
 
-	MACvSetKeyEntry(priv->PortOffset, key_mode, entry, key_inx,
+	MACvSetKeyEntry(priv, key_mode, entry, key_inx,
 			bssid, (u32 *)key->key, priv->byLocalID);
 
 	return 0;
@@ -126,13 +126,13 @@ int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	switch (key->cipher) {
 	case 0:
 		for (u = 0 ; u < MAX_KEY_TABLE; u++)
-			MACvDisableKeyEntry(priv->PortOffset, u);
+			MACvDisableKeyEntry(priv, u);
 		return ret;
 
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		for (u = 0; u < MAX_KEY_TABLE; u++)
-			MACvDisableKeyEntry(priv->PortOffset, u);
+			MACvDisableKeyEntry(priv, u);
 
 		vnt_set_keymode(hw, mac_addr,
 				key, VNT_KEY_DEFAULTKEY, KEY_CTL_WEP, true);
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 688c3be..e74782a 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -70,9 +70,10 @@
  * Return Value: true if all test bits On; otherwise false
  *
  */
-bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs,
+bool MACbIsRegBitsOn(struct vnt_private *priv, unsigned char byRegOfs,
 		     unsigned char byTestBits)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byData;
 
 	VNSvInPortB(dwIoBase + byRegOfs, &byData);
@@ -94,9 +95,10 @@ bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs,
  * Return Value: true if all test bits Off; otherwise false
  *
  */
-bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs,
+bool MACbIsRegBitsOff(struct vnt_private *priv, unsigned char byRegOfs,
 		      unsigned char byTestBits)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byData;
 
 	VNSvInPortB(dwIoBase + byRegOfs, &byData);
@@ -116,8 +118,9 @@ bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs,
  * Return Value: true if interrupt is disable; otherwise false
  *
  */
-bool MACbIsIntDisable(void __iomem *dwIoBase)
+bool MACbIsIntDisable(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned long dwData;
 
 	VNSvInPortD(dwIoBase + MAC_REG_IMR, &dwData);
@@ -141,8 +144,9 @@ bool MACbIsIntDisable(void __iomem *dwIoBase)
  * Return Value: none
  *
  */
-void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
+void MACvSetShortRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	/* set SRT */
 	VNSvOutPortB(dwIoBase + MAC_REG_SRT, byRetryLimit);
 }
@@ -162,8 +166,9 @@ void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
  * Return Value: none
  *
  */
-void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
+void MACvSetLongRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	/* set LRT */
 	VNSvOutPortB(dwIoBase + MAC_REG_LRT, byRetryLimit);
 }
@@ -182,8 +187,9 @@ void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
  * Return Value: none
  *
  */
-void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode)
+void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byOrgValue;
 
 	byLoopbackMode <<= 6;
@@ -207,8 +213,9 @@ void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode)
  * Return Value: none
  *
  */
-void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
+void MACvSaveContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	int         ii;
 
 	/* read page0 register */
@@ -239,8 +246,9 @@ void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
  * Return Value: none
  *
  */
-void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
+void MACvRestoreContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	int         ii;
 
 	MACvSelectPage1(dwIoBase);
@@ -293,8 +301,9 @@ void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
  * Return Value: true if Reset Success; otherwise false
  *
  */
-bool MACbSoftwareReset(void __iomem *dwIoBase)
+bool MACbSoftwareReset(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byData;
 	unsigned short ww;
 
@@ -324,7 +333,7 @@ bool MACbSoftwareReset(void __iomem *dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeSoftwareReset(void __iomem *dwIoBase)
+bool MACbSafeSoftwareReset(struct vnt_private *priv)
 {
 	unsigned char abyTmpRegData[MAC_MAX_CONTEXT_SIZE_PAGE0+MAC_MAX_CONTEXT_SIZE_PAGE1];
 	bool bRetVal;
@@ -334,11 +343,11 @@ bool MACbSafeSoftwareReset(void __iomem *dwIoBase)
 	 * reset, then restore register's value
 	 */
 	/* save MAC context */
-	MACvSaveContext(dwIoBase, abyTmpRegData);
+	MACvSaveContext(priv, abyTmpRegData);
 	/* do reset */
-	bRetVal = MACbSoftwareReset(dwIoBase);
+	bRetVal = MACbSoftwareReset(priv);
 	/* restore MAC context, except CR0 */
-	MACvRestoreContext(dwIoBase, abyTmpRegData);
+	MACvRestoreContext(priv, abyTmpRegData);
 
 	return bRetVal;
 }
@@ -356,8 +365,9 @@ bool MACbSafeSoftwareReset(void __iomem *dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeRxOff(void __iomem *dwIoBase)
+bool MACbSafeRxOff(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned long dwData;
 	unsigned char byData;
@@ -414,8 +424,9 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeTxOff(void __iomem *dwIoBase)
+bool MACbSafeTxOff(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned long dwData;
 	unsigned char byData;
@@ -474,18 +485,19 @@ bool MACbSafeTxOff(void __iomem *dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeStop(void __iomem *dwIoBase)
+bool MACbSafeStop(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	MACvRegBitsOff(dwIoBase, MAC_REG_TCR, TCR_AUTOBCNTX);
 
-	if (!MACbSafeRxOff(dwIoBase)) {
+	if (!MACbSafeRxOff(priv)) {
 		pr_debug(" MACbSafeRxOff == false)\n");
-		MACbSafeSoftwareReset(dwIoBase);
+		MACbSafeSoftwareReset(priv);
 		return false;
 	}
-	if (!MACbSafeTxOff(dwIoBase)) {
+	if (!MACbSafeTxOff(priv)) {
 		pr_debug(" MACbSafeTxOff == false)\n");
-		MACbSafeSoftwareReset(dwIoBase);
+		MACbSafeSoftwareReset(priv);
 		return false;
 	}
 
@@ -507,17 +519,18 @@ bool MACbSafeStop(void __iomem *dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbShutdown(void __iomem *dwIoBase)
+bool MACbShutdown(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	/* disable MAC IMR */
 	MACvIntDisable(dwIoBase);
-	MACvSetLoopbackMode(dwIoBase, MAC_LB_INTERNAL);
+	MACvSetLoopbackMode(priv, MAC_LB_INTERNAL);
 	/* stop the adapter */
-	if (!MACbSafeStop(dwIoBase)) {
-		MACvSetLoopbackMode(dwIoBase, MAC_LB_NONE);
+	if (!MACbSafeStop(priv)) {
+		MACvSetLoopbackMode(priv, MAC_LB_NONE);
 		return false;
 	}
-	MACvSetLoopbackMode(dwIoBase, MAC_LB_NONE);
+	MACvSetLoopbackMode(priv, MAC_LB_NONE);
 	return true;
 }
 
@@ -534,8 +547,9 @@ bool MACbShutdown(void __iomem *dwIoBase)
  * Return Value: none
  *
  */
-void MACvInitialize(void __iomem *dwIoBase)
+void MACvInitialize(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	/* clear sticky bits */
 	MACvClearStckDS(dwIoBase);
 	/* disable force PME-enable */
@@ -543,7 +557,7 @@ void MACvInitialize(void __iomem *dwIoBase)
 	/* only 3253 A */
 
 	/* do reset */
-	MACbSoftwareReset(dwIoBase);
+	MACbSoftwareReset(priv);
 
 	/* reset TSF counter */
 	VNSvOutPortB(dwIoBase + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
@@ -565,8 +579,9 @@ void MACvInitialize(void __iomem *dwIoBase)
  * Return Value: none
  *
  */
-void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr)
+void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAddr)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
@@ -600,8 +615,9 @@ void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr
  * Return Value: none
  *
  */
-void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr)
+void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAddr)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
@@ -636,9 +652,10 @@ void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr
  * Return Value: none
  *
  */
-void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase,
+void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 			      unsigned long dwCurrDescAddr)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
@@ -673,9 +690,10 @@ void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase,
  *
  */
 /* TxDMA1 = AC0DMA */
-void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase,
+void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 			      unsigned long dwCurrDescAddr)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
@@ -696,13 +714,13 @@ void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase,
 		VNSvOutPortB(dwIoBase + MAC_REG_AC0DMACTL, DMACTL_RUN);
 }
 
-void MACvSetCurrTXDescAddr(int iTxType, void __iomem *dwIoBase,
+void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *priv,
 			   unsigned long dwCurrDescAddr)
 {
 	if (iTxType == TYPE_AC0DMA)
-		MACvSetCurrAC0DescAddrEx(dwIoBase, dwCurrDescAddr);
+		MACvSetCurrAC0DescAddrEx(priv, dwCurrDescAddr);
 	else if (iTxType == TYPE_TXDMA0)
-		MACvSetCurrTx0DescAddrEx(dwIoBase, dwCurrDescAddr);
+		MACvSetCurrTx0DescAddrEx(priv, dwCurrDescAddr);
 }
 
 /*
@@ -719,8 +737,9 @@ void MACvSetCurrTXDescAddr(int iTxType, void __iomem *dwIoBase,
  * Return Value: none
  *
  */
-void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay)
+void MACvTimer0MicroSDelay(struct vnt_private *priv, unsigned int uDelay)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byValue;
 	unsigned int uu, ii;
 
@@ -754,16 +773,20 @@ void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay)
  * Return Value: none
  *
  */
-void MACvOneShotTimer1MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime)
+void MACvOneShotTimer1MicroSec(struct vnt_private *priv, unsigned int uDelayTime)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
+
 	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL1, 0);
 	VNSvOutPortD(dwIoBase + MAC_REG_TMDATA1, uDelayTime);
 	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL1, (TMCTL_TMD | TMCTL_TE));
 }
 
-void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset,
+void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
 		     unsigned long dwData)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
+
 	if (wOffset > 273)
 		return;
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
@@ -771,12 +794,13 @@ void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset,
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
 
-bool MACbPSWakeup(void __iomem *dwIoBase)
+bool MACbPSWakeup(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byOrgValue;
 	unsigned int ww;
 	/* Read PSCTL */
-	if (MACbIsRegBitsOff(dwIoBase, MAC_REG_PSCTL, PSCTL_PS))
+	if (MACbIsRegBitsOff(priv, MAC_REG_PSCTL, PSCTL_PS))
 		return true;
 
 	/* Disable PS */
@@ -810,11 +834,12 @@ bool MACbPSWakeup(void __iomem *dwIoBase)
  *
  */
 
-void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl,
+void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		     unsigned int uEntryIdx, unsigned int uKeyIdx,
 		     unsigned char *pbyAddr, u32 *pdwKey,
 		     unsigned char byLocalID)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short wOffset;
 	u32 dwData;
 	int     ii;
@@ -878,8 +903,9 @@ void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl,
  * Return Value: none
  *
  */
-void MACvDisableKeyEntry(void __iomem *dwIoBase, unsigned int uEntryIdx)
+void MACvDisableKeyEntry(struct vnt_private *priv, unsigned int uEntryIdx)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short wOffset;
 
 	wOffset = MISCFIFO_KEYETRY0;
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 8e0200a..192f466 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -890,57 +890,57 @@ do {								\
 #define MACvSetRFLE_LatchBase(dwIoBase)                                 \
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_RFLEOPT)
 
-bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs,
+bool MACbIsRegBitsOn(struct vnt_private *, unsigned char byRegOfs,
 		     unsigned char byTestBits);
-bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs,
+bool MACbIsRegBitsOff(struct vnt_private *, unsigned char byRegOfs,
 		      unsigned char byTestBits);
 
-bool MACbIsIntDisable(void __iomem *dwIoBase);
+bool MACbIsIntDisable(struct vnt_private *);
 
-void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
+void MACvSetShortRetryLimit(struct vnt_private *, unsigned char byRetryLimit);
 
-void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
-void MACvGetLongRetryLimit(void __iomem *dwIoBase,
+void MACvSetLongRetryLimit(struct vnt_private *, unsigned char byRetryLimit);
+void MACvGetLongRetryLimit(struct vnt_private *,
 			   unsigned char *pbyRetryLimit);
 
-void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode);
+void MACvSetLoopbackMode(struct vnt_private *, unsigned char byLoopbackMode);
 
-void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
-void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
+void MACvSaveContext(struct vnt_private *, unsigned char *pbyCxtBuf);
+void MACvRestoreContext(struct vnt_private *, unsigned char *pbyCxtBuf);
 
-bool MACbSoftwareReset(void __iomem *dwIoBase);
-bool MACbSafeSoftwareReset(void __iomem *dwIoBase);
-bool MACbSafeRxOff(void __iomem *dwIoBase);
-bool MACbSafeTxOff(void __iomem *dwIoBase);
-bool MACbSafeStop(void __iomem *dwIoBase);
-bool MACbShutdown(void __iomem *dwIoBase);
-void MACvInitialize(void __iomem *dwIoBase);
-void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase,
+bool MACbSoftwareReset(struct vnt_private *);
+bool MACbSafeSoftwareReset(struct vnt_private *);
+bool MACbSafeRxOff(struct vnt_private *);
+bool MACbSafeTxOff(struct vnt_private *);
+bool MACbSafeStop(struct vnt_private *);
+bool MACbShutdown(struct vnt_private *);
+void MACvInitialize(struct vnt_private *);
+void MACvSetCurrRx0DescAddr(struct vnt_private *,
 			    unsigned long dwCurrDescAddr);
-void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase,
+void MACvSetCurrRx1DescAddr(struct vnt_private *,
 			    unsigned long dwCurrDescAddr);
-void MACvSetCurrTXDescAddr(int iTxType, void __iomem *dwIoBase,
+void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *,
 			   unsigned long dwCurrDescAddr);
-void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase,
+void MACvSetCurrTx0DescAddrEx(struct vnt_private *,
 			      unsigned long dwCurrDescAddr);
-void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase,
+void MACvSetCurrAC0DescAddrEx(struct vnt_private *,
 			      unsigned long dwCurrDescAddr);
-void MACvSetCurrSyncDescAddrEx(void __iomem *dwIoBase,
+void MACvSetCurrSyncDescAddrEx(struct vnt_private *,
 			       unsigned long dwCurrDescAddr);
-void MACvSetCurrATIMDescAddrEx(void __iomem *dwIoBase,
+void MACvSetCurrATIMDescAddrEx(struct vnt_private *,
 			       unsigned long dwCurrDescAddr);
-void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay);
-void MACvOneShotTimer1MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime);
+void MACvTimer0MicroSDelay(struct vnt_private *, unsigned int uDelay);
+void MACvOneShotTimer1MicroSec(struct vnt_private *, unsigned int uDelayTime);
 
-void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset,
+void MACvSetMISCFifo(struct vnt_private *, unsigned short wOffset,
 		     unsigned long dwData);
 
-bool MACbPSWakeup(void __iomem *dwIoBase);
+bool MACbPSWakeup(struct vnt_private *);
 
-void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl,
+void MACvSetKeyEntry(struct vnt_private *, unsigned short wKeyCtl,
 		     unsigned int uEntryIdx, unsigned int uKeyIdx,
 		     unsigned char *pbyAddr, u32 *pdwKey,
 		     unsigned char byLocalID);
-void MACvDisableKeyEntry(void __iomem *dwIoBase, unsigned int uEntryIdx);
+void MACvDisableKeyEntry(struct vnt_private *, unsigned int uEntryIdx);
 
 #endif /* __MAC_H__ */
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 5e968c9..bc8ca98 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -120,7 +120,7 @@ PSvDisablePowerSaving(
 )
 {
 	/* disable power saving hw function */
-	MACbPSWakeup(priv->PortOffset);
+	MACbPSWakeup(priv);
 	/* clear AutoSleep */
 	MACvRegBitsOff(priv->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 	/* clear HWUTSF */
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 1c0691d..3df430b 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -438,13 +438,13 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
 	/* Calibration */
-	MACvTimer0MicroSDelay(dwIoBase, 150);/* 150us */
+	MACvTimer0MicroSDelay(priv, 150);/* 150us */
 	/* TXDCOC:active, RCK:disable */
 	ret &= IFRFbWriteEmbedded(priv, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
-	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
+	MACvTimer0MicroSDelay(priv, 30);/* 30us */
 	/* TXDCOC:disable, RCK:active */
 	ret &= IFRFbWriteEmbedded(priv, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
-	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
+	MACvTimer0MicroSDelay(priv, 30);/* 30us */
 	/* TXDCOC:disable, RCK:disable */
 	ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]);
 
@@ -483,7 +483,7 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
 
 	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel & 0x7F));
-	MACvTimer0MicroSDelay(dwIoBase, SWITCH_CHANNEL_DELAY_AL7230);
+	MACvTimer0MicroSDelay(priv, SWITCH_CHANNEL_DELAY_AL7230);
 	/* Set Channel[7] = 1 to tell H/W channel change is done. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel | 0x80));
 
@@ -557,16 +557,16 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 
 	for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
 		ret &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[ii]);
-	MACvTimer0MicroSDelay(dwIoBase, 30); /* delay 30 us */
+	MACvTimer0MicroSDelay(priv, 30); /* delay 30 us */
 
 	/* PLL On */
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
-	MACvTimer0MicroSDelay(dwIoBase, 150);/* 150us */
+	MACvTimer0MicroSDelay(priv, 150);/* 150us */
 	ret &= IFRFbWriteEmbedded(priv, (0x00d80f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
-	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
+	MACvTimer0MicroSDelay(priv, 30);/* 30us */
 	ret &= IFRFbWriteEmbedded(priv, (0x00780f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
-	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
+	MACvTimer0MicroSDelay(priv, 30);/* 30us */
 	ret &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[CB_AL2230_INIT_SEQ-1]);
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
@@ -592,7 +592,7 @@ static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byCha
 
 	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel & 0x7F));
-	MACvTimer0MicroSDelay(dwIoBase, SWITCH_CHANNEL_DELAY_AL2230);
+	MACvTimer0MicroSDelay(priv, SWITCH_CHANNEL_DELAY_AL2230);
 	/* Set Channel[7] = 1 to tell H/W channel change is done. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel | 0x80));
 
@@ -711,11 +711,11 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType,
 			return false;
 
 		for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
-			MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230InitTable[ii]);
+			MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230InitTable[ii]);
 
-		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable0[uChannel-1]);
+		MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable0[uChannel-1]);
 		ii++;
-		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable1[uChannel-1]);
+		MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable1[uChannel-1]);
 		break;
 
 		/* Need to check, PLLON need to be low for channel setting */
@@ -728,17 +728,17 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType,
 
 		if (uChannel <= CB_MAX_CHANNEL_24G) {
 			for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
-				MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230InitTable[ii]);
+				MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230InitTable[ii]);
 		} else {
 			for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
-				MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230InitTableAMode[ii]);
+				MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230InitTableAMode[ii]);
 		}
 
-		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable0[uChannel-1]);
+		MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable0[uChannel-1]);
 		ii++;
-		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable1[uChannel-1]);
+		MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable1[uChannel-1]);
 		ii++;
-		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable2[uChannel-1]);
+		MACvSetMISCFifo(priv, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable2[uChannel-1]);
 		break;
 
 	case RF_NOTHING:
@@ -748,7 +748,7 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType,
 		return false;
 	}
 
-	MACvSetMISCFifo(dwIoBase, MISCFIFO_SYNINFO_IDX, (unsigned long)MAKEWORD(bySleepCount, byInitCount));
+	MACvSetMISCFifo(priv, MISCFIFO_SYNINFO_IDX, (unsigned long)MAKEWORD(bySleepCount, byInitCount));
 
 	return true;
 }
-- 
2.6.2

