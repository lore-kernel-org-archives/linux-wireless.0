Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34691 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbcDHAx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 20:53:27 -0400
Received: by mail-ob0-f175.google.com with SMTP id bg3so63796945obb.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 17:53:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <998e52a27823047910627da08e917c06@openmailbox.org>
References: <998e52a27823047910627da08e917c06@openmailbox.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 8 Apr 2016 10:53:07 +1000
Message-ID: <CAGRGNgVtD8PS7BePJ=RTbxOOYjqE39kChuhZxtOUO-S9Y95p6w@mail.gmail.com> (sfid-20160408_025339_264856_C016F562)
Subject: Re: [PATCH] Revert regression in ath9k on AR9281
To: lkml2017@openmailbox.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Apr 8, 2016 at 8:24 AM,  <lkml2017@openmailbox.org> wrote:
> Hello, the following commit introduced what looks like a regression on
> AR9281 and supposedly other wireless chipsets using the AR9002 part of the
> ath9k driver.
>
> After this commit the network interface's "Bit Rate" as shown in "iwconfig"
> drops from the usual 65Mbps in N mode to 11Mbps also in N mode.
> Throughput tests confirm the slowdown. Applying and removing the commit
> toggles the problem.
>
> I did not write the code in the provided patch, just reversed the changes to
> the latest known good state.
> Reusing the existing common functions instead would be better.

It's a revert, you not being the "original" author is implied. A
followup patch to reuse existing functions would be welcomed.

> disclaimer: First time contributor, I hope the formatting is OK, just trying
> to fix my laptop here.

If you're really worried about this, put this disclaimer below the "---".

You should also add a Fixes: tag here too.

> Signed-off-by: John Doe <lkml2017@openmailbox.org>

I strongly suspect that this isn't your real name. That isn't allowed.
The developer certificate of origin requires that you sign here with
your real name and email address.

> bisection.log
> ---

"bisection.log" should be here, after the "---".

> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [f911085ffa8863c62344876e0ab6073e4258c246] ath9k: split
> ar5008_hw_spur_mitigate and reuse common code in ar9002_hw_spur_mitigate.
> f911085ffa8863c62344876e0ab6073e4258c246 is the first bad commit
> commit f911085ffa8863c62344876e0ab6073e4258c246
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date: Sun May 17 21:49:19 2015 +0200
>
>     ath9k: split ar5008_hw_spur_mitigate and reuse common code in
> ar9002_hw_spur_mitigate.
>
>     [ar5008 and ar9002]_hw_spur_mitigate have big portion of identical code.
>     This patch will move common part of ar5008_hw_spur_mitigate to
>     ar5008_hw_cmn_spur_mitigate and reuse it in ar9002_hw_spur_mitigate.
>
>     As noticed by Joe Perches I reuse ar9002_hw_spur_mitigate (const)
> version of
>     declarations for pilot_mask_reg and chan_mask_reg.
>
>     There should be no other difference with original code.
>
>     Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>     Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>
> iwconfig W/ commit: 11Mbps
> ---
> wlan0 IEEE 802.11bgn ESSID:"TEST_AP"
>           Mode:Managed Frequency:2.462 GHz Access Point: A4:C7:*
>           Bit Rate=65 Mb/s Tx-Power=15 dBm
>           Retry short limit:7 RTS thr:off Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=58/70 Signal level=-52 dBm
>           Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
>           Tx excessive retries:0 Invalid misc:0 Missed beacon:0
> ---
>
> iwconfig W/o commit: 65Mbps
> ---
> wlan0 IEEE 802.11bgn ESSID:"TEST_AP"
>           Mode:Managed Frequency:2.462 GHz Access Point: A4:C7:*
>           Bit Rate=65 Mb/s Tx-Power=15 dBm
>           Retry short limit:7 RTS thr:off Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=58/70 Signal level=-52 dBm
>           Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
>           Tx excessive retries:0 Invalid misc:0 Missed beacon:0

You should probably be using the iw command instead of iwconfig. It
produces a lot more data. (Also these two iwconfig outputs look
identical to me, is that your intention?)

> ---
>
> lspci
> ---
> 03:00.0 Network controller: Qualcomm Atheros AR928X Wireless Network Adapter
> (PCI-Express) (rev 01)
>         Subsystem: AzureWave AW-NE771 802.11bgn Wireless Mini PCIe Card
> [AR9281]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 17
>         Region 0: Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
> PME(D0+,D1+,D2-,D3hot+,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000 Data: 0000
>         Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <512ns, L1 <64us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
> TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L1, Exit
> Latency L0s <512ns, L1 <64us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L1 Enabled; RCB 128 bytes Disabled- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [90] MSI-X: Enable- Count=1 Masked-
>                 Vector table: BAR=0 offset=00000000
>                 PBA: BAR=0 offset=00000000
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                 UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                 CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                 CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                 AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+
> ChkEn-
>         Capabilities: [140 v1] Virtual Channel
>                 Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb: Fixed- WRR32- WRR64- WRR128-
>                 Ctrl: ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                         Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                         Status: NegoPending- InProgress-
>         Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
>         Kernel driver in use: ath9k
> ---
>
> patch

Your email client has thoroughly mangled the patch. There's
documentation on how to set it up at Documentation/email-clients.txt
however you should really be sending patches with git-send-email.

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
