Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.openmailbox.org ([62.4.1.33]:42199 "EHLO
	mail2.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbcDGWbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 18:31:23 -0400
Received: from www.openmailbox.org (openmailbox-b2 [10.91.69.220])
	by mail2.openmailbox.org (Postfix) with ESMTP id 591F62ACB0FD
	for <linux-wireless@vger.kernel.org>; Fri,  8 Apr 2016 00:24:20 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 07 Apr 2016 22:24:19 +0000
From: lkml2017@openmailbox.org
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Revert regression in ath9k on AR9281
Message-ID: <998e52a27823047910627da08e917c06@openmailbox.org> (sfid-20160408_003127_843155_DA1585A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, the following commit introduced what looks like a regression on 
AR9281 and supposedly other wireless chipsets using the AR9002 part of 
the ath9k driver.

After this commit the network interface's "Bit Rate" as shown in 
"iwconfig" drops from the usual 65Mbps in N mode to 11Mbps also in N 
mode.
Throughput tests confirm the slowdown. Applying and removing the commit 
toggles the problem.

I did not write the code in the provided patch, just reversed the 
changes to the latest known good state.
Reusing the existing common functions instead would be better.

disclaimer: First time contributor, I hope the formatting is OK, just 
trying to fix my laptop here.

Signed-off-by: John Doe <lkml2017@openmailbox.org>


bisection.log
---
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[f911085ffa8863c62344876e0ab6073e4258c246] ath9k: split 
ar5008_hw_spur_mitigate and reuse common code in 
ar9002_hw_spur_mitigate.
f911085ffa8863c62344876e0ab6073e4258c246 is the first bad commit
commit f911085ffa8863c62344876e0ab6073e4258c246
Author: Oleksij Rempel <linux@rempel-privat.de>
Date: Sun May 17 21:49:19 2015 +0200

     ath9k: split ar5008_hw_spur_mitigate and reuse common code in 
ar9002_hw_spur_mitigate.

     [ar5008 and ar9002]_hw_spur_mitigate have big portion of identical 
code.
     This patch will move common part of ar5008_hw_spur_mitigate to
     ar5008_hw_cmn_spur_mitigate and reuse it in ar9002_hw_spur_mitigate.

     As noticed by Joe Perches I reuse ar9002_hw_spur_mitigate (const) 
version of
     declarations for pilot_mask_reg and chan_mask_reg.

     There should be no other difference with original code.

     Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
     Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---

iwconfig W/ commit: 11Mbps
---
wlan0 IEEE 802.11bgn ESSID:"TEST_AP"
           Mode:Managed Frequency:2.462 GHz Access Point: A4:C7:*
           Bit Rate=65 Mb/s Tx-Power=15 dBm
           Retry short limit:7 RTS thr:off Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=58/70 Signal level=-52 dBm
           Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
           Tx excessive retries:0 Invalid misc:0 Missed beacon:0
---

iwconfig W/o commit: 65Mbps
---
wlan0 IEEE 802.11bgn ESSID:"TEST_AP"
           Mode:Managed Frequency:2.462 GHz Access Point: A4:C7:*
           Bit Rate=65 Mb/s Tx-Power=15 dBm
           Retry short limit:7 RTS thr:off Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=58/70 Signal level=-52 dBm
           Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
           Tx excessive retries:0 Invalid misc:0 Missed beacon:0
---

lspci
---
03:00.0 Network controller: Qualcomm Atheros AR928X Wireless Network 
Adapter (PCI-Express) (rev 01)
         Subsystem: AzureWave AW-NE771 802.11bgn Wireless Mini PCIe Card 
[AR9281]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at fdff0000 (64-bit, non-prefetchable) 
[size=64K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA 
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: 00000000 Data: 0000
         Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L1, Exit 
Latency L0s <512ns, L1 <64us
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM L1 Enabled; RCB 128 bytes Disabled- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [90] MSI-X: Enable- Count=1 Masked-
                 Vector table: BAR=0 offset=00000000
                 PBA: BAR=0 offset=00000000
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                 UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ 
ChkEn-
         Capabilities: [140 v1] Virtual Channel
                 Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb: Fixed- WRR32- WRR64- WRR128-
                 Ctrl: ArbSelect=Fixed
                 Status: InProgress-
                 VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [160 v1] Device Serial Number 
00-00-00-00-00-00-00-00
         Kernel driver in use: ath9k
---

patch
---
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c 
b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -169,17 +169,29 @@ static void ar9002_hw_spur_mitigate(struct ath_hw 
*ah,
  {
         int bb_spur = AR_NO_SPUR;
         int freq;
- int bin;
+ int bin, cur_bin;
         int bb_spur_off, spur_subchannel_sd;
         int spur_freq_sd;
         int spur_delta_phase;
         int denominator;
+ int upper, lower, cur_vit_mask;
         int tmp, newVal;
         int i;
+ static const int pilot_mask_reg[4] = {
+ AR_PHY_TIMING7, AR_PHY_TIMING8,
+ AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
+ };
+ static const int chan_mask_reg[4] = {
+ AR_PHY_TIMING9, AR_PHY_TIMING10,
+ AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
+ };
+ static const int inc[4] = { 0, 100, 0, 0 };
         struct chan_centers centers;

         int8_t mask_m[123];
         int8_t mask_p[123];
+ int8_t mask_amt;
+ int tmp_mask;
         int cur_bb_spur;
         bool is2GHz = IS_CHAN_2GHZ(chan);

@@ -276,7 +288,135 @@ static void ar9002_hw_spur_mitigate(struct ath_hw 
*ah,
         newVal = spur_subchannel_sd << AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S;
         REG_WRITE(ah, AR_PHY_SFCORR_EXT, newVal);

- ar5008_hw_cmn_spur_mitigate(ah, chan, bin);
+ cur_bin = -6000;
+ upper = bin + 100;
+ lower = bin - 100;
+
+ for (i = 0; i < 4; i++) {
+ int pilot_mask = 0;
+ int chan_mask = 0;
+ int bp = 0;
+ for (bp = 0; bp < 30; bp++) {
+ if ((cur_bin > lower) && (cur_bin < upper)) {
+ pilot_mask = pilot_mask | 0x1 << bp;
+ chan_mask = chan_mask | 0x1 << bp;
+ }
+ cur_bin += 100;
+ }
+ cur_bin += inc[i];
+ REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
+ REG_WRITE(ah, chan_mask_reg[i], chan_mask);
+ }
+
+ cur_vit_mask = 6100;
+ upper = bin + 120;
+ lower = bin - 120;
+
+ for (i = 0; i < 123; i++) {
+ if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
+
+ /* workaround for gcc bug #37014 */
+ volatile int tmp_v = abs(cur_vit_mask - bin);
+
+ if (tmp_v < 75)
+ mask_amt = 1;
+ else
+ mask_amt = 0;
+ if (cur_vit_mask < 0)
+ mask_m[abs(cur_vit_mask / 100)] = mask_amt;
+ else
+ mask_p[cur_vit_mask / 100] = mask_amt;
+ }
+ cur_vit_mask -= 100;
+ }
+
+ tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
+ | (mask_m[48] << 26) | (mask_m[49] << 24)
+ | (mask_m[50] << 22) | (mask_m[51] << 20)
+ | (mask_m[52] << 18) | (mask_m[53] << 16)
+ | (mask_m[54] << 14) | (mask_m[55] << 12)
+ | (mask_m[56] << 10) | (mask_m[57] << 8)
+ | (mask_m[58] << 6) | (mask_m[59] << 4)
+ | (mask_m[60] << 2) | (mask_m[61] << 0);
+ REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
+ REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
+
+ tmp_mask = (mask_m[31] << 28)
+ | (mask_m[32] << 26) | (mask_m[33] << 24)
+ | (mask_m[34] << 22) | (mask_m[35] << 20)
+ | (mask_m[36] << 18) | (mask_m[37] << 16)
+ | (mask_m[48] << 14) | (mask_m[39] << 12)
+ | (mask_m[40] << 10) | (mask_m[41] << 8)
+ | (mask_m[42] << 6) | (mask_m[43] << 4)
+ | (mask_m[44] << 2) | (mask_m[45] << 0);
+ REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
+ REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
+
+ tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
+ | (mask_m[18] << 26) | (mask_m[18] << 24)
+ | (mask_m[20] << 22) | (mask_m[20] << 20)
+ | (mask_m[22] << 18) | (mask_m[22] << 16)
+ | (mask_m[24] << 14) | (mask_m[24] << 12)
+ | (mask_m[25] << 10) | (mask_m[26] << 8)
+ | (mask_m[27] << 6) | (mask_m[28] << 4)
+ | (mask_m[29] << 2) | (mask_m[30] << 0);
+ REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
+ REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
+
+ tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
+ | (mask_m[2] << 26) | (mask_m[3] << 24)
+ | (mask_m[4] << 22) | (mask_m[5] << 20)
+ | (mask_m[6] << 18) | (mask_m[7] << 16)
+ | (mask_m[8] << 14) | (mask_m[9] << 12)
+ | (mask_m[10] << 10) | (mask_m[11] << 8)
+ | (mask_m[12] << 6) | (mask_m[13] << 4)
+ | (mask_m[14] << 2) | (mask_m[15] << 0);
+ REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
+ REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
+
+ tmp_mask = (mask_p[15] << 28)
+ | (mask_p[14] << 26) | (mask_p[13] << 24)
+ | (mask_p[12] << 22) | (mask_p[11] << 20)
+ | (mask_p[10] << 18) | (mask_p[9] << 16)
+ | (mask_p[8] << 14) | (mask_p[7] << 12)
+ | (mask_p[6] << 10) | (mask_p[5] << 8)
+ | (mask_p[4] << 6) | (mask_p[3] << 4)
+ | (mask_p[2] << 2) | (mask_p[1] << 0);
+ REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
+ REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
+
+ tmp_mask = (mask_p[30] << 28)
+ | (mask_p[29] << 26) | (mask_p[28] << 24)
+ | (mask_p[27] << 22) | (mask_p[26] << 20)
+ | (mask_p[25] << 18) | (mask_p[24] << 16)
+ | (mask_p[23] << 14) | (mask_p[22] << 12)
+ | (mask_p[21] << 10) | (mask_p[20] << 8)
+ | (mask_p[19] << 6) | (mask_p[18] << 4)
+ | (mask_p[17] << 2) | (mask_p[16] << 0);
+ REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
+ REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
+
+ tmp_mask = (mask_p[45] << 28)
+ | (mask_p[44] << 26) | (mask_p[43] << 24)
+ | (mask_p[42] << 22) | (mask_p[41] << 20)
+ | (mask_p[40] << 18) | (mask_p[39] << 16)
+ | (mask_p[38] << 14) | (mask_p[37] << 12)
+ | (mask_p[36] << 10) | (mask_p[35] << 8)
+ | (mask_p[34] << 6) | (mask_p[33] << 4)
+ | (mask_p[32] << 2) | (mask_p[31] << 0);
+ REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
+ REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
+
+ tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
+ | (mask_p[59] << 26) | (mask_p[58] << 24)
+ | (mask_p[57] << 22) | (mask_p[56] << 20)
+ | (mask_p[55] << 18) | (mask_p[54] << 16)
+ | (mask_p[53] << 14) | (mask_p[52] << 12)
+ | (mask_p[51] << 10) | (mask_p[50] << 8)
+ | (mask_p[49] << 6) | (mask_p[48] << 4)
+ | (mask_p[47] << 2) | (mask_p[46] << 0);
+ REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
+ REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);

         REGWRITE_BUFFER_FLUSH(ah);
  }
---
