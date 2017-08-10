Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36052 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753060AbdHJQaD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 12:30:03 -0400
Received: by mail-wm0-f43.google.com with SMTP id t201so23925083wmt.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Aug 2017 09:30:02 -0700 (PDT)
From: Daniel Drake <drake@endlessm.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        linux-pci@vger.kernel.org
Cc: linux@endlessm.com, chiu@endlessm.com
Subject: ath9k hardware corrupts MSI Message Data, raises wrong interrupt
Date: Thu, 10 Aug 2017 17:29:39 +0100
Message-Id: <20170810162939.9880-1-drake@endlessm.com> (sfid-20170810_183007_869460_1C56B743)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The ath9k wireless driver in mainline currently does not have support for
PCI MSI interrupts, it uses legacy interrupts instead.

However we are working with a number of 3rd party laptop models based on
Intel Apollo Lake which will soon be available on the consumer market. They
all appear to have broken legacy interrupt wiring for the wifi card.
Unfortunately the hardware can't be changed so we are instead looking at
making ath9k use MSI interrupts which is what we believe they are doing on
Windows.

To recap what MSI is: The host OS can configure a Message Address value and
a Message Data value within the device's PCI configuration space. When the
device wishes to interrupt the host, instead of pulsing a logic level on the
legacy interrupt pin, it will instead write the value of Message Data into
the address specified in Message Address. This write will then trigger
interrupt handling mechanisms within the kernel.

The code below can be used to tell the ath9k hardware to use MSI interrupts
instead of legacy interrupts (sorry that it's a bit unclean). However, it
is not working, as reproduced on multiple devices. No interrupts are
counted against the ath9k MSI IRQ, and we get messages like these spammed
in the kernel logs:
  do_IRQ: 0.64 No irq handler for vector

The device does not appear to be MSI-X capable.

Configuration dump for the device at this point:

02:00.0 Network controller: Qualcomm Atheros QCA9565 / AR9565 Wireless Network Adapter (rev 01)
	Subsystem: AzureWave Device 218d
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 125
	Region 0: Memory at 91100000 (64-bit, non-prefetchable) [size=512K]
	Expansion ROM at 91180000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/4 Maskable+ 64bit+
		Address: 00000000fee0300c  Data: 4142
		Masking: 0000000e  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k

Looking closer, the Message Data value is set in arch/x86/kernel/apic/msi.c
irq_msi_compose_msg(). In this case the value is 0x4142 and the lower byte
(0x42) corresponds to the interrupt vector being used for this MSI IRQ (in
this case, 66).

The log messages from do_IRQ suggest that the MSI interrupt is being
generated and picked up by Linux, but against the wrong vector: 64, instead
of 66. On another platform we saw something similar, the assigned vector is
99 but do_IRQ reports about vector 96.

This suggests that the device is zeroing out the 2 lower bits of the
Message Data field where the vector number is stored (66 -> 64,
99 -> 96). Why might it be doing this? My guess, looking at the PCI specs:

    The Multiple Message Enable field (bits 6-4 of the Message Control
    register) defines the number of low order message data bits the
    function is permitted to modify to generate its system software
    allocated vectors. For example, a Multiple Message Enable encoding of
    “010” indicates the function has been allocated four vectors and is
    permitted to modify message data bits 1 and 0 (a function modifies the
    lower message data bits to generate the allocated number of vectors).
    If the Multiple Message Enable field is “000”, the function is not
    permitted to modify the message data.

Linux is not working with Multiple Messages and has written the 000 value
as described. However, I suspect the device is not fully following the
spec here and is effectively taking ownership of the 2 lower bits, and
setting them to 00 to indicate that it is working with the first of the
4 possible MSI IRQ vectors.

I thought about modifying Linux's vector-assignment algorithm to consider
this special case and only assign a single vector number with the low bits
already set as 00, but that seems like a hairy topic and that code is
distanced from the driver too. The algorithm in question is
 __assign_irq_vector() in arch/x86/kernel/apic/msi.c

Similarly the idea of adding support for MSI_FLAG_MULTI_PCI_MSI to the
PCI-MSI adapter would encounter similar challenges where ultimately we'd
need to allocate 4 contiguous vectors and that is not really in agreement
with the design of __assign_irq_vector().

I'd appreciate any suggestions for next steps here. Do any ath9k
developers have datasheet or vendor contacts that might shine light on
the behaviour I suspect here where the Message Data bits are being
incorrectly zeroed out? Any PCI experts that have any bright ideas for
how we could introduce a workaround for this possibly broken hardware
in upstreamable form?

Thanks
Daniel


---
 drivers/net/wireless/ath/ath9k/hw.c   | 34 ++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/hw.h   |  3 +++
 drivers/net/wireless/ath/ath9k/init.c |  4 ++++
 drivers/net/wireless/ath/ath9k/mac.c  | 42 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c  | 20 ++++++++++++++++-
 drivers/net/wireless/ath/ath9k/reg.h  | 15 +++++++++++++
 6 files changed, 110 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8c5c2dd8fa7f..8c25d14cd9fc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -922,6 +922,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		AR_IMR_RXERR |
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
+	u32 msi_cfg = 0;
 
 	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
 	    AR_SREV_9561(ah))
@@ -929,22 +930,33 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		imr_reg |= AR_IMR_RXOK_HP;
-		if (ah->config.rx_intr_mitigation)
+		if (ah->config.rx_intr_mitigation) {
 			imr_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
-		else
+			msi_cfg |= AR_INTCFG_MSI_RXINTM | AR_INTCFG_MSI_RXMINTR;
+		}
+		else {
 			imr_reg |= AR_IMR_RXOK_LP;
-
+			msi_cfg |= AR_INTCFG_MSI_RXOK ;
+		}
 	} else {
-		if (ah->config.rx_intr_mitigation)
+		if (ah->config.rx_intr_mitigation) {
 			imr_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
-		else
+			msi_cfg |= AR_INTCFG_MSI_RXINTM | AR_INTCFG_MSI_RXMINTR;
+		}
+		else {
 			imr_reg |= AR_IMR_RXOK;
+			msi_cfg |= AR_INTCFG_MSI_RXOK ;
+		}
 	}
 
-	if (ah->config.tx_intr_mitigation)
+	if (ah->config.tx_intr_mitigation) {
 		imr_reg |= AR_IMR_TXINTM | AR_IMR_TXMINTR;
-	else
+		msi_cfg |= AR_INTCFG_MSI_TXINTM | AR_INTCFG_MSI_TXMINTR ;
+	}
+	else {
 		imr_reg |= AR_IMR_TXOK;
+		msi_cfg |= AR_INTCFG_MSI_TXOK;
+	}
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -952,6 +964,14 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 	ah->imrs2_reg |= AR_IMR_S2_GTT;
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 
+	if(ah->msi_enabled) {
+		ah->msi_reg = REG_READ(ah, AR_PCIE_MSI);
+		ah->msi_reg |= AR_PCIE_MSI_HW_DBI_WR_EN ;
+		ah->msi_reg &= AR_PCIE_MSI_HW_INT_PENDING_ADDR_MSI_64;
+		REG_WRITE(ah, AR_INTCFG, msi_cfg);
+		ath_info(ath9k_hw_common(ah), "value of AR_INTCFG=0x%X, msi_cfg=0x%X\n", REG_READ(ah, AR_INTCFG), msi_cfg);
+	}
+
 	if (!AR_SREV_9100(ah)) {
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE, 0xFFFFFFFF);
 		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, sync_default);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9cbca1229bac..7f9215976d8f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -976,6 +976,9 @@ struct ath_hw {
 	bool tpc_enabled;
 	u8 tx_power[Ar5416RateSize];
 	u8 tx_power_stbc[Ar5416RateSize];
+	bool msi_enabled;
+	u32 msi_mask;
+	u32 msi_reg;
 };
 
 struct ath_bus_ops {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fa4b3cc1ba22..1d205d961fce 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -75,6 +75,10 @@ MODULE_PARM_DESC(use_chanctx, "Enable channel context for concurrency");
 
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
+int ath9k_use_msi = 1 ;
+module_param_named(use_msi, ath9k_use_msi, int, 0444);
+MODULE_PARM_DESC(use_msi, "Use MSI instead of INTx if possible");
+
 bool is_ath9k_unloaded;
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index d937c39b3a0b..045581ede475 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -831,6 +831,38 @@ static void __ath9k_hw_enable_interrupts(struct ath_hw *ah)
 	}
 	ath_dbg(common, INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
 		REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
+
+	if(ah->msi_enabled) {
+		u32 _msi_reg = 0;
+		u32 i=0;
+		u32 msi_pend_addr_mask = AR_PCIE_MSI_HW_INT_PENDING_ADDR_MSI_64;
+
+		ath_info(ath9k_hw_common(ah), "Enabling MSI, msi_mask=0x%X\n", ah->msi_mask);
+
+		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_ENABLE, ah->msi_mask);
+		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_MASK, ah->msi_mask);
+		ath_info(ath9k_hw_common(ah), 
+				"AR_INTR_PRIO_ASYNC_ENABLE=0x%X, AR_INTR_PRIO_ASYNC_MASK=0x%X\n", 
+				REG_READ(ah, AR_INTR_PRIO_ASYNC_ENABLE),
+				REG_READ(ah, AR_INTR_PRIO_ASYNC_MASK));
+		
+		if (ah->msi_reg == 0)
+			ah->msi_reg = REG_READ(ah, AR_PCIE_MSI);
+
+		ath_info(ath9k_hw_common(ah), "AR_PCIE_MSI=0x%X, ah->msi_reg = 0x%X\n", AR_PCIE_MSI, ah->msi_reg);
+
+		i=0;
+		do {
+		    REG_WRITE(ah, AR_PCIE_MSI, (ah->msi_reg | AR_PCIE_MSI_ENABLE) & msi_pend_addr_mask);
+		    _msi_reg = REG_READ(ah, AR_PCIE_MSI);
+		    i++;
+		} while((_msi_reg & AR_PCIE_MSI_ENABLE) == 0 && i < 200);
+
+		if(i >= 200)
+			ath_err(ath9k_hw_common(ah), 
+				"%s: _msi_reg = 0x%X\n", 
+				__func__, _msi_reg);
+	}
 }
 
 void ath9k_hw_resume_interrupts(struct ath_hw *ah)
@@ -877,12 +909,21 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah)
 	if (!(ints & ATH9K_INT_GLOBAL))
 		ath9k_hw_disable_interrupts(ah);
 
+	if(ah->msi_enabled) {
+		ath_info(common, "Clearing AR_INTR_PRIO_ASYNC_ENABLE\n");
+		
+		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_ENABLE, 0);
+		REG_READ(ah, AR_INTR_PRIO_ASYNC_ENABLE);
+	}
+
 	ath_dbg(common, INTERRUPT, "New interrupt mask 0x%x\n", ints);
 
 	mask = ints & ATH9K_INT_COMMON;
 	mask2 = 0;
 
+	ah->msi_mask =0;
 	if (ints & ATH9K_INT_TX) {
+		ah->msi_mask |= AR_INTR_PRIO_TX;
 		if (ah->config.tx_intr_mitigation)
 			mask |= AR_IMR_TXMINTR | AR_IMR_TXINTM;
 		else {
@@ -897,6 +938,7 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah)
 			mask |= AR_IMR_TXEOL;
 	}
 	if (ints & ATH9K_INT_RX) {
+		ah->msi_mask |= AR_INTR_PRIO_RXLP | AR_INTR_PRIO_RXHP;
 		if (AR_SREV_9300_20_OR_LATER(ah)) {
 			mask |= AR_IMR_RXERR | AR_IMR_RXOK_HP;
 			if (ah->config.rx_intr_mitigation) {
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index aff473dfa10d..94cf34a62578 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -22,6 +22,8 @@
 #include <linux/module.h>
 #include "ath9k.h"
 
+extern int ath9k_use_msi ;
+
 static const struct pci_device_id ath_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x0023) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x0024) }, /* PCI-E */
@@ -879,6 +881,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	u32 val;
 	int ret = 0;
 	char hw_name[64];
+	int msi_enabled = 0;
 
 	if (pcim_enable_device(pdev))
 		return -EIO;
@@ -950,7 +953,19 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->mem = pcim_iomap_table(pdev)[0];
 	sc->driver_data = id->driver_data;
 
-	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
+	if(ath9k_use_msi) {
+		if(pci_enable_msi(pdev) == 0) {
+			msi_enabled = 1;
+			dev_err(&pdev->dev, "Using MSI\n");
+		}
+		else	dev_err(&pdev->dev, "Using INTx\n");
+	}
+
+	if(!msi_enabled)
+		ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
+	else
+		ret = request_irq(pdev->irq, ath_isr, 0, "ath9k", sc);
+
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
 		goto err_irq;
@@ -964,6 +979,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_init;
 	}
 
+	sc->sc_ah->msi_enabled = msi_enabled ;
+	sc->sc_ah->msi_reg = 0 ;
+
 	ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)sc->mem, pdev->irq);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 80ff69f99229..dc54d62495de 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -146,6 +146,14 @@
 #define AR_MACMISC_MISC_OBS_BUS_MSB_S   15
 #define AR_MACMISC_MISC_OBS_BUS_1       1
 
+#define AR_INTCFG               0x005C
+#define AR_INTCFG_MSI_RXOK      0x00000000
+#define AR_INTCFG_MSI_RXINTM    0x00000004
+#define AR_INTCFG_MSI_RXMINTR   0x00000006
+#define AR_INTCFG_MSI_TXOK      0x00000000
+#define AR_INTCFG_MSI_TXINTM    0x00000010
+#define AR_INTCFG_MSI_TXMINTR   0x00000018
+
 #define AR_DATABUF_SIZE		0x0060
 #define AR_DATABUF_SIZE_MASK	0x00000FFF
 
@@ -1256,6 +1264,13 @@ enum {
 #define AR_PCIE_MSI                             (AR_SREV_9340(ah) ? 0x40d8 : \
 						 (AR_SREV_9300_20_OR_LATER(ah) ? 0x40a4 : 0x4094))
 #define AR_PCIE_MSI_ENABLE                       0x00000001
+#define AR_PCIE_MSI_HW_DBI_WR_EN                 0x02000000
+#define AR_PCIE_MSI_HW_INT_PENDING_ADDR          0xFFA0C1FF // bits 8..11: value must be 0x5060 
+#define AR_PCIE_MSI_HW_INT_PENDING_ADDR_MSI_64   0xFFA0C9FF // bits 8..11: value must be 0x5064 
+
+#define AR_INTR_PRIO_TX               0x00000001
+#define AR_INTR_PRIO_RXLP             0x00000002
+#define AR_INTR_PRIO_RXHP             0x00000004
 
 #define AR_INTR_PRIO_SYNC_ENABLE  (AR_SREV_9340(ah) ? 0x4088 : 0x40c4)
 #define AR_INTR_PRIO_ASYNC_MASK   (AR_SREV_9340(ah) ? 0x408c : 0x40c8)
-- 
2.11.0
