Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33030 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753212AbeGFHWV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 03:22:21 -0400
Received: by mail-it0-f67.google.com with SMTP id y124-v6so4476697itc.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2018 00:22:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180706054435.3732-1-pkshih@realtek.com>
References: <20180706054435.3732-1-pkshih@realtek.com>
From: Jian-Hong Pan <jian-hong@endlessm.com>
Date: Fri, 6 Jul 2018 15:22:19 +0800
Message-ID: <CAPpJ_eeYkzn=d93QwGfxW2difnXrhW4VOUBgGdsRzW1LNE--RA@mail.gmail.com> (sfid-20180706_092238_022802_2135F687)
Subject: Re: [PATCH] staging: r8822be: Fix RTL8822be can't find any wireless AP
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-07-06 13:44 GMT+08:00  <pkshih@realtek.com>:
> From: Ping-Ke Shih <pkshih@realtek.com>
>
> RTL8822be can't bring up properly on ASUS X530UN, and dmesg says:
> [ 8.591333] r8822be: module is from the staging directory, the quality
> is unknown, you have been warned.
> [ 8.593122] r8822be 0000:02:00.0: enabling device (0000 -> 0003)
> [ 8.669163] r8822be: Using firmware rtlwifi/rtl8822befw.bin
> [ 9.289939] r8822be: rtlwifi: wireless switch is on
> [ 10.056426] r8822be 0000:02:00.0 wlp2s0: renamed from wlan0
> ...
> [ 11.952534] r8822be: halmac_init_hal failed
> [ 11.955933] r8822be: halmac_init_hal failed
> [ 11.956227] r8822be: halmac_init_hal failed
> [ 22.007942] r8822be: halmac_init_hal failed
>
> Jian-Hong reported it works if turn off ASPM with module parameter aspm=0.
> In order to fix this problem kindly, this commit don't turn off aspm but
> enlarge ASPM L1 latency to 7.

I also test this patch on another laptop ASUS X570ZD (AMD Ryzen 7
2700U with Radeon Vega Mobile Gfx) equipped with Realtek rtl8822be
wireless.

dev@endless:~$ sudo lspci -nnvvvs 02:00.0
02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
Device [10ec:b822]
Subsystem: AzureWave Device [1a3b:2950]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 57
Region 0: I/O ports at e000 [size=256]
Region 2: Memory at f7800000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 0000
Capabilities: [70] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0.000W
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <2us, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, OBFF
Via message/WAKE#
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR+, OBFF Disabled
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [148 v1] Device Serial Number 00-e0-4c-ff-fe-b8-22-01
Capabilities: [158 v1] Latency Tolerance Reporting
Max snoop latency: 1048576ns
Max no snoop latency: 1048576ns
Capabilities: [160 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
  PortCommonModeRestoreTime=30us PortTPowerOnTime=60us
L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
   T_CommonMode=0us LTR1.2_Threshold=0ns
L1SubCtl2: T_PwrOn=10us
Kernel driver in use: r8822be
Kernel modules: r8822be

ASUS X570ZD's WiFi adapter already works correctly without this patch
originally.

With this patch, it also works correctly again:
dev@endless:~$ dmesg | grep r8822be
[   19.662441] r8822be: module is from the staging directory, the
quality is unknown, you have been warned.
[   19.664332] r8822be 0000:02:00.0: enabling device (0000 -> 0003)
[   19.681015] r8822be: Using firmware rtlwifi/rtl8822befw.bin
[   19.778437] r8822be: rtlwifi: wireless switch is on
[   19.779919] r8822be 0000:02:00.0 wlp2s0: renamed from wlan0

Here is the full dmesg
https://gist.github.com/starnight/920950ca596916e393ce0534added83e

> Reported-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Tested-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  drivers/staging/rtlwifi/rtl8822be/hw.c | 2 +-
>  drivers/staging/rtlwifi/wifi.h         | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtlwifi/rtl8822be/hw.c b/drivers/staging/rtlwifi/rtl8822be/hw.c
> index 7947edb239a1..88ba5b2fea6a 100644
> --- a/drivers/staging/rtlwifi/rtl8822be/hw.c
> +++ b/drivers/staging/rtlwifi/rtl8822be/hw.c
> @@ -803,7 +803,7 @@ static void _rtl8822be_enable_aspm_back_door(struct ieee80211_hw *hw)
>                 return;
>
>         pci_read_config_byte(rtlpci->pdev, 0x70f, &tmp);
> -       pci_write_config_byte(rtlpci->pdev, 0x70f, tmp | BIT(7));
> +       pci_write_config_byte(rtlpci->pdev, 0x70f, tmp | ASPM_L1_LATENCY << 3);
>
>         pci_read_config_byte(rtlpci->pdev, 0x719, &tmp);
>         pci_write_config_byte(rtlpci->pdev, 0x719, tmp | BIT(3) | BIT(4));
> diff --git a/drivers/staging/rtlwifi/wifi.h b/drivers/staging/rtlwifi/wifi.h
> index 012fb618840b..a45f0eb69d3f 100644
> --- a/drivers/staging/rtlwifi/wifi.h
> +++ b/drivers/staging/rtlwifi/wifi.h
> @@ -88,6 +88,7 @@
>  #define RTL_USB_MAX_RX_COUNT                   100
>  #define QBSS_LOAD_SIZE                         5
>  #define MAX_WMMELE_LENGTH                      64
> +#define ASPM_L1_LATENCY                                7
>
>  #define TOTAL_CAM_ENTRY                                32
>
> --
> 2.15.1
>
