Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04517C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 20:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B29CB20836
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 20:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3AsA0tM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfCBUZR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 15:25:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54837 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfCBUZR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 15:25:17 -0500
Received: by mail-wm1-f67.google.com with SMTP id a62so1174158wmh.4
        for <linux-wireless@vger.kernel.org>; Sat, 02 Mar 2019 12:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Sd7QWtsXtDpsBnCPQhtKgfGiPiK2iqBSF9qDDg974MI=;
        b=C3AsA0tMXOgTq9maC88vhbUuPO2iTRVrH6cGvl6MH45FXOIzxeZ0Edh5iVmkKKQ4OJ
         sq7eJiu58X/X92Sb5IcDUVqgwahgSQ+YFcjnAt+FjbcXq8PATTI7zYH2KhuzStf1Eb9c
         6sEzurM/6lqYMuqaO2XnDSZJsClRQ+xIVZoWZgu4dcvTcoE+vq/ySvbc1MuKSlgmIlsu
         H0V6pGPAFutnYyPDcgMlvmG6FXE3iAMSgj0IdUsO6e5CzYnj1vYIOt/5zzNJhSqvOwVr
         9uEfKTMkGqLdFbUZJy4PO11kYUFUb29Y9e+Nr+sx4eWfAAYU+KRowncp/kKav+ympcrD
         qnDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Sd7QWtsXtDpsBnCPQhtKgfGiPiK2iqBSF9qDDg974MI=;
        b=OMN3dOBks8qOT2b498/KAmQbOMYrlPpkeozNtG1QvkCFqRlHLnoj8AyxL4N2Ot9/Se
         EK/ZUvQb1XijFScY6To1ac3zGU3pQJwmilsCYa6b++ICekBJVqLDNEwING1ON0nXatbs
         M3pG19fV4ZjfM75WzDDWlnDcJHmsDzvdGJyUvhGbgOubAr/3ooSSGGr+QCDWWllgJhY+
         RlCA+FqyVfFQLodObpDSL7SHzHIgl0v6AXpF4h3qR01pP1REzWz2wRK08W1/ykxXjdJq
         3HTlp4qOvT3ZjLZul7x3IWkv+MdpYvNeH6c1NCjAm8kXYq3MnDjXB8o4mvlXZvRzKyxl
         Igdw==
X-Gm-Message-State: APjAAAWuz8EHs+OFJszUrq4xSVV16k0GZ+YOgHLBMtV8X6G3HHLcPHqG
        rXbE5tLx1dV/PySp6l1xGEoR7fxiHd31bDeqxgEVLMLs
X-Google-Smtp-Source: APXvYqyVK29nYwRhm9VtkwPT2qi6IdlgV29c+Bbedi+e2FPplojm9Uhh2lepLSVPEcsGdgK37boAo2+GujS0LE+puw8=
X-Received: by 2002:a1c:e715:: with SMTP id e21mr6679617wmh.122.1551558312449;
 Sat, 02 Mar 2019 12:25:12 -0800 (PST)
MIME-Version: 1.0
From:   Anees Ahmed <aneesahmedpro@gmail.com>
Date:   Sun, 3 Mar 2019 01:54:59 +0530
Message-ID: <CA+7P=FJ-KfJDRiQqfjFHzs7-8htp3GbCQ1TM_xOq8Eny8mUG7w@mail.gmail.com>
Subject: QCA6164 Driver Problem (firmware crashes)
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I have a laptop (Lenovo G50-45 80E3) which came with a wifi card
(Qualcomm Atheros QCA6164).

In Windows 10, as far as I have observed, it works perfectly.

In Linux distros, it works fine most of the times except in the
following scenarios:
1. Everytime the system boots, it emits some firmware related error
messages in the log.
2. Sometimes it just stops doing the data transfer with the router,
without any apparent issues in connection. Disconnecting and
reconnecting with the router fixes it.
3. When attempting to suspend, almost everytime, the firmware crashes.
It then stops responding. Only rebooting fixes the issue.
4. When attempting to hibernate, almost everytime, the firmware
crashes. It then stops responding. Only rebooting fixes the issue.
5. My current workaround is to put the laptop in airplane mode before
suspend/hibernate and then turning wifi back on after resume/thaw. It
works fine when using this scheme. But sometimes, firmware crashes
even while putting the laptop in airplane mode. It then stops
responding. Only rebooting fixes the issue.

Currently, my primary OS is Ubuntu. But I have a third OS also which I
keep changing (hopping), currently it is AntergOS. All distros face
identical issues with regards to the wifi driver, just the error
messages have minor differences.


FOLLOWING ARE THE INFO AND LOGS FROM MY PRIMARY OS.


$ uname -a
Linux anees-lap-u18 4.15.0-45-generic #48-Ubuntu SMP Tue Jan 29
16:28:13 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux


$ sudo lspci -vvnn
02:00.0 Network controller [0280]: Qualcomm Atheros QCA6164 802.11ac
Wireless Network Adapter [168c:0041] (rev 20)
    Subsystem: Lenovo QCA6164 802.11ac Wireless Network Adapter [17aa:3545]
    Physical Slot: 0-1
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 48
    Region 0: Memory at f0800000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit-
        Address: fee08004  Data: 4026
        Masking: 000000fe  Pending: 00000000
    Capabilities: [70] Express (v2) Endpoint, MSI 00
        DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
unlimited, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
SlotPowerLimit 0.000W
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <4us, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+,
OBFF Via message
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v2] Advanced Error Reporting
        UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [148 v1] Virtual Channel
        Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:   ArbSelect=Fixed
        Status: InProgress-
        VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status: NegoPending- InProgress-
    Capabilities: [168 v1] Device Serial Number 00-00-00-00-00-00-00-00
    Capabilities: [178 v1] Latency Tolerance Reporting
        Max snoop latency: 0ns
        Max no snoop latency: 0ns
    Capabilities: [180 v1] L1 PM Substates
        L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
L1_PM_Substates+
              PortCommonModeRestoreTime=50us PortTPowerOnTime=10us
        L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
               T_CommonMode=0us LTR1.2_Threshold=0ns
        L1SubCtl2: T_PwrOn=10us
    Kernel driver in use: ath10k_pci
    Kernel modules: ath10k_pci


# This is the system log every time the system boots:
$ sudo dmesg
[   24.212523] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[   24.506056] ath10k_pci 0000:02:00.0: Direct firmware load for
ath10k/pre-cal-pci-0000:02:00.0.bin failed with error -2
[   24.506088] ath10k_pci 0000:02:00.0: Direct firmware load for
ath10k/cal-pci-0000:02:00.0.bin failed with error -2
[   24.532778] ath10k_pci 0000:02:00.0: Direct firmware load for
ath10k/QCA6174/hw2.1/firmware-6.bin failed with error -2
[   24.544064] ath10k_pci 0000:02:00.0: qca6164 hw2.1 target
0x05010000 chip_id 0x003405ff sub 17aa:3545
[   24.544069] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1
tracing 1 dfs 0 testmode 0
[   24.544509] ath10k_pci 0000:02:00.0: firmware ver
SW_RM.1.1.1-00157-QCARMSWPZ-1 api 5 features ignore-otp,no-4addr-pad
crc32 10bf8e08
[   24.706369] ath10k_pci 0000:02:00.0: board_file api 2 bmi_id N/A
crc32 ae2e275a
[   25.874889] ath10k_pci 0000:02:00.0: htt-ver 3.1 wmi-op 4 htt-op 3
cal otp max-sta 32 raw 0 hwcrypto 1
[   25.971375] ath: EEPROM regdomain: 0x6c
[   25.971378] ath: EEPROM indicates we should expect a direct regpair map
[   25.971380] ath: Country alpha2 being used: 00
[   25.971381] ath: Regpair used: 0x6c
[   25.980634] ath10k_pci 0000:02:00.0 wlp2s0: renamed from wlan0


# This is the system log after a successful suspend (and the subsequent resume):
$ sudo dmesg
[ 1088.087662] wlp2s0: deauthenticating from 88:b1:e1:a7:c8:40 by
local choice (Reason: 3=DEAUTH_LEAVING)
[ 1091.293187] ath10k_pci 0000:02:00.0: failed to update channel list: -11
[ 1094.365118] ath10k_pci 0000:02:00.0: failed to set pdev regdomain: -11
[ 1094.610358] PM: suspend entry (deep)
[ 1094.610363] PM: Syncing filesystems ... done.
[ 1096.304067] Freezing user space processes ...
[ 1097.437176] ath10k_pci 0000:02:00.0: failed to delete WMI vdev 1: -11
[ 1097.449275] ath10k_pci 0000:02:00.0: failed to read hi_board_data
address: -16
[ 1103.581096] ath10k_pci 0000:02:00.0: could not suspend target (-11)
[ 1106.628111] ath10k_pci 0000:02:00.0: failed to receive initialized
event from target: 00000000
[ 1109.652185] ath10k_pci 0000:02:00.0: failed to receive initialized
event from target: 00000000
[ 1109.652342] ath10k_pci 0000:02:00.0: failed to wait for target init: -110
[ 1109.657506] (elapsed 13.353 seconds) done.
[ 1109.657519] OOM killer disabled.
[ 1109.657520] Freezing remaining freezable tasks ... (elapsed 0.262
seconds) done.
[ 1112.814879] PM: Saving platform NVS memory
[ 1112.884421] PM: Restoring platform NVS memory
[ 1116.539542] OOM killer enabled.
[ 1116.539543] Restarting tasks ... done.
[ 1116.564335] rfkill: input handler enabled
[ 1116.614505] PM: suspend exit
[ 1116.798484] rfkill: input handler disabled
[ 1117.506319] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[ 1118.926213] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[ 1119.004471] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[ 1123.890778] wlp2s0: authenticate with 88:b1:e1:a7:c8:40
[ 1123.921847] wlp2s0: send auth to 88:b1:e1:a7:c8:40 (try 1/3)
[ 1123.931521] wlp2s0: authenticated
[ 1123.934156] wlp2s0: associate with 88:b1:e1:a7:c8:40 (try 1/3)
[ 1123.937070] wlp2s0: RX AssocResp from 88:b1:e1:a7:c8:40
(capab=0x501 status=0 aid=1)
[ 1123.939673] wlp2s0: associated
[ 1123.939848] ath: EEPROM regdomain: 0x8348
[ 1123.939849] ath: EEPROM indicates we should expect a country code
[ 1123.939851] ath: doing EEPROM country->regdmn map search
[ 1123.939852] ath: country maps to regdmn code: 0x3a
[ 1123.939854] ath: Country alpha2 being used: US
[ 1123.939854] ath: Regpair used: 0x3a
[ 1123.939856] ath: regdomain 0x8348 dynamically updated by country IE
[ 1123.940769] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[ 1124.033939] wlp2s0: Limiting TX power to 24 (24 - 0) dBm as
advertised by 88:b1:e1:a7:c8:40


# This is the system log after a failed suspend (due to wifi card
firmware crash):
$ sudo dmesg
[ 3890.086991] wlp2s0: deauthenticating from 88:b1:e1:a7:c8:40 by
local choice (Reason: 3=DEAUTH_LEAVING)
[ 3890.112855] ath10k_pci 0000:02:00.0: firmware crashed! (guid
5b2e643e-09fc-4c55-907b-78003f1a8125)
[ 3890.112872] ath10k_pci 0000:02:00.0: qca6164 hw2.1 target
0x05010000 chip_id 0x003405ff sub 17aa:3545
[ 3890.112876] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1
tracing 1 dfs 0 testmode 0
[ 3890.113485] ath10k_pci 0000:02:00.0: firmware ver
SW_RM.1.1.1-00157-QCARMSWPZ-1 api 5 features ignore-otp,no-4addr-pad
crc32 10bf8e08
[ 3890.113808] ath10k_pci 0000:02:00.0: board_file api 2 bmi_id N/A
crc32 ae2e275a
[ 3890.113814] ath10k_pci 0000:02:00.0: htt-ver 3.1 wmi-op 4 htt-op 3
cal otp max-sta 32 raw 0 hwcrypto 1
[ 3890.115837] ath10k_pci 0000:02:00.0: firmware register dump:
[ 3890.115849] ath10k_pci 0000:02:00.0: [00]: 0x05010000 0x00000000
0x0092E500 0x00000000
[ 3890.115855] ath10k_pci 0000:02:00.0: [04]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115859] ath10k_pci 0000:02:00.0: [08]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115864] ath10k_pci 0000:02:00.0: [12]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115868] ath10k_pci 0000:02:00.0: [16]: 0x00000000 0x00000000
0x00000000 0x0092E500
[ 3890.115873] ath10k_pci 0000:02:00.0: [20]: 0x00000000 0x004018F0
0x00000000 0x00000000
[ 3890.115877] ath10k_pci 0000:02:00.0: [24]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115881] ath10k_pci 0000:02:00.0: [28]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115885] ath10k_pci 0000:02:00.0: [32]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115890] ath10k_pci 0000:02:00.0: [36]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115894] ath10k_pci 0000:02:00.0: [40]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115898] ath10k_pci 0000:02:00.0: [44]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115902] ath10k_pci 0000:02:00.0: [48]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115906] ath10k_pci 0000:02:00.0: [52]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115910] ath10k_pci 0000:02:00.0: [56]: 0x00000000 0x00000000
0x00000000 0x00000000
[ 3890.115915] ath10k_pci 0000:02:00.0: Copy Engine register dump:
[ 3890.115926] ath10k_pci 0000:02:00.0: [00]: 0x00034400   1   1   3   3
[ 3890.115936] ath10k_pci 0000:02:00.0: [01]: 0x00034800  23  23 506 507
[ 3890.115946] ath10k_pci 0000:02:00.0: [02]: 0x00034c00   7   7   6   7
[ 3890.115955] ath10k_pci 0000:02:00.0: [03]: 0x00035000  13  13  14  13
[ 3890.115965] ath10k_pci 0000:02:00.0: [04]: 0x00035400 1333 1333 220 156
[ 3890.115975] ath10k_pci 0000:02:00.0: [05]: 0x00035800   0   0   0   0
[ 3890.115985] ath10k_pci 0000:02:00.0: [06]: 0x00035c00   3   3   3   3
[ 3890.115995] ath10k_pci 0000:02:00.0: [07]: 0x00036000   1   1   1   1
[ 3890.200927] ath10k_pci 0000:02:00.0: device has crashed during init
[ 3890.229001] ath10k_pci 0000:02:00.0: device has crashed during init
[ 3890.229006] ath10k_pci 0000:02:00.0: failed to wait for target init: -70
[ 3890.232486] ieee80211 phy0: Hardware restart was requested
[ 3890.232555] ath10k_pci 0000:02:00.0: failed to delete WMI vdev 1: -108
[ 3890.285030] ath10k_pci 0000:02:00.0: device has crashed during init
[ 3890.313053] ath10k_pci 0000:02:00.0: device has crashed during init
[ 3890.313058] ath10k_pci 0000:02:00.0: failed to wait for target init: -70
[ 3891.342643] radeon_dp_aux_transfer_native: 22 callbacks suppressed
[ 3894.096807] ata1: exception Emask 0x40 SAct 0x0 SErr 0xc0800 action 0x7
[ 3894.096820] ata1: SError: { HostInt CommWake 10B8B }
[ 3894.096830] ata1: hard resetting link
[ 3894.631096] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 3894.665627] ata1.00: configured for UDMA/100
[ 3894.665973] ata1: EH complete
[ 4109.279064] INFO: task cups-browsed:1153 blocked for more than 120 seconds.
[ 4109.279078]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.279083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.279089] cups-browsed    D    0  1153      1 0x00000000
[ 4109.279096] Call Trace:
[ 4109.279115]  __schedule+0x291/0x8a0
[ 4109.279122]  schedule+0x2c/0x80
[ 4109.279127]  schedule_preempt_disabled+0xe/0x10
[ 4109.279132]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.279139]  __mutex_lock_slowpath+0x13/0x20
[ 4109.279144]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.279149]  mutex_lock+0x2f/0x40
[ 4109.279155]  __netlink_dump_start+0x51/0x1c0
[ 4109.279160]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.279164]  ? rtnl_getlink+0x280/0x280
[ 4109.279168]  ? rtnl_getlink+0x280/0x280
[ 4109.279172]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.279177]  netlink_rcv_skb+0x54/0x130
[ 4109.279184]  rtnetlink_rcv+0x15/0x20
[ 4109.279188]  netlink_unicast+0x19e/0x240
[ 4109.279193]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.279201]  sock_sendmsg+0x3e/0x50
[ 4109.279206]  SYSC_sendto+0x13f/0x180
[ 4109.279212]  ? SYSC_getsockname+0xb3/0xf0
[ 4109.279217]  ? sock_alloc_file+0xa0/0x150
[ 4109.279224]  ? fd_install+0x25/0x30
[ 4109.279228]  ? sock_map_fd+0x44/0x80
[ 4109.279234]  SyS_sendto+0xe/0x10
[ 4109.279240]  do_syscall_64+0x73/0x130
[ 4109.279247]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.279253] RIP: 0033:0x7f396b20ddfa
[ 4109.279255] RSP: 002b:00007fffd36ff330 EFLAGS: 00000293 ORIG_RAX:
000000000000002c
[ 4109.279261] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f396b20ddfa
[ 4109.279264] RDX: 0000000000000014 RSI: 00007fffd3700410 RDI: 000000000000000b
[ 4109.279266] RBP: 0000000000000000 R08: 00007fffd37003d0 R09: 000000000000000c
[ 4109.279269] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fffd3700410
[ 4109.279271] R13: 0000000000000014 R14: 0000000000000000 R15: 00007fffd37003d0
[ 4109.279281] INFO: task whoopsie:1232 blocked for more than 120 seconds.
[ 4109.279287]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.279292] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.279296] whoopsie        D    0  1232      1 0x00000000
[ 4109.279301] Call Trace:
[ 4109.279307]  __schedule+0x291/0x8a0
[ 4109.279313]  schedule+0x2c/0x80
[ 4109.279318]  schedule_preempt_disabled+0xe/0x10
[ 4109.279322]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.279329]  __mutex_lock_slowpath+0x13/0x20
[ 4109.279334]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.279338]  mutex_lock+0x2f/0x40
[ 4109.279342]  __netlink_dump_start+0x51/0x1c0
[ 4109.279347]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.279353]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.279357]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.279362]  netlink_rcv_skb+0x54/0x130
[ 4109.279368]  rtnetlink_rcv+0x15/0x20
[ 4109.279372]  netlink_unicast+0x19e/0x240
[ 4109.279377]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.279383]  sock_sendmsg+0x3e/0x50
[ 4109.279388]  SYSC_sendto+0x13f/0x180
[ 4109.279397]  ? ktime_get_ts64+0x51/0xf0
[ 4109.279403]  SyS_sendto+0xe/0x10
[ 4109.279408]  do_syscall_64+0x73/0x130
[ 4109.279414]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.279417] RIP: 0033:0x7f948c9e0c96
[ 4109.279420] RSP: 002b:00007fff6cc7d8f0 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.279424] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007f948c9e0c96
[ 4109.279427] RDX: 0000000000000014 RSI: 00007fff6cc7d980 RDI: 0000000000000007
[ 4109.279429] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.279432] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fff6cc7d980
[ 4109.279434] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.279477] INFO: task packagekitd:1638 blocked for more than 120 seconds.
[ 4109.279483]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.279487] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.279491] packagekitd     D    0  1638      1 0x00000000
[ 4109.279496] Call Trace:
[ 4109.279502]  __schedule+0x291/0x8a0
[ 4109.279508]  schedule+0x2c/0x80
[ 4109.279513]  schedule_preempt_disabled+0xe/0x10
[ 4109.279517]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.279524]  __mutex_lock_slowpath+0x13/0x20
[ 4109.279528]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.279533]  mutex_lock+0x2f/0x40
[ 4109.279537]  __netlink_dump_start+0x51/0x1c0
[ 4109.279542]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.279548]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.279552]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.279556]  netlink_rcv_skb+0x54/0x130
[ 4109.279563]  rtnetlink_rcv+0x15/0x20
[ 4109.279567]  netlink_unicast+0x19e/0x240
[ 4109.279572]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.279578]  sock_sendmsg+0x3e/0x50
[ 4109.279583]  SYSC_sendto+0x13f/0x180
[ 4109.279590]  ? ktime_get_ts64+0x51/0xf0
[ 4109.279597]  SyS_sendto+0xe/0x10
[ 4109.279602]  do_syscall_64+0x73/0x130
[ 4109.279607]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.279611] RIP: 0033:0x7effa129a9ae
[ 4109.279613] RSP: 002b:00007ffebeb6a0e0 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.279617] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007effa129a9ae
[ 4109.279620] RDX: 0000000000000014 RSI: 00007ffebeb6a170 RDI: 0000000000000005
[ 4109.279622] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.279625] R10: 0000000000004000 R11: 0000000000000246 R12: 00007ffebeb6a170
[ 4109.279627] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.279703] INFO: task goa-daemon:2071 blocked for more than 120 seconds.
[ 4109.279708]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.279712] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.279716] goa-daemon      D    0  2071   1809 0x00000000
[ 4109.279721] Call Trace:
[ 4109.279728]  __schedule+0x291/0x8a0
[ 4109.279733]  schedule+0x2c/0x80
[ 4109.279738]  schedule_preempt_disabled+0xe/0x10
[ 4109.279742]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.279749]  __mutex_lock_slowpath+0x13/0x20
[ 4109.279754]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.279758]  mutex_lock+0x2f/0x40
[ 4109.279762]  __netlink_dump_start+0x51/0x1c0
[ 4109.279767]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.279773]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.279777]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.279782]  netlink_rcv_skb+0x54/0x130
[ 4109.279788]  rtnetlink_rcv+0x15/0x20
[ 4109.279792]  netlink_unicast+0x19e/0x240
[ 4109.279797]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.279804]  sock_sendmsg+0x3e/0x50
[ 4109.279808]  SYSC_sendto+0x13f/0x180
[ 4109.279815]  ? ktime_get_ts64+0x51/0xf0
[ 4109.279822]  SyS_sendto+0xe/0x10
[ 4109.279827]  do_syscall_64+0x73/0x130
[ 4109.279833]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.279836] RIP: 0033:0x7f10114379ae
[ 4109.279838] RSP: 002b:00007ffff9e6aee0 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.279843] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f10114379ae
[ 4109.279845] RDX: 0000000000000014 RSI: 00007ffff9e6af70 RDI: 000000000000000b
[ 4109.279847] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.279850] R10: 0000000000004000 R11: 0000000000000246 R12: 00007ffff9e6af70
[ 4109.279852] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.279899] INFO: task evolution-calen:2372 blocked for more than
120 seconds.
[ 4109.279904]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.279908] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.279912] evolution-calen D    0  2372   2321 0x00000000
[ 4109.279917] Call Trace:
[ 4109.279923]  __schedule+0x291/0x8a0
[ 4109.279929]  schedule+0x2c/0x80
[ 4109.279934]  schedule_preempt_disabled+0xe/0x10
[ 4109.279938]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.279944]  ? __switch_to_asm+0x34/0x70
[ 4109.279950]  __mutex_lock_slowpath+0x13/0x20
[ 4109.279954]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.279958]  mutex_lock+0x2f/0x40
[ 4109.279963]  __netlink_dump_start+0x51/0x1c0
[ 4109.279967]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.279973]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.279978]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.279982]  netlink_rcv_skb+0x54/0x130
[ 4109.279988]  rtnetlink_rcv+0x15/0x20
[ 4109.279992]  netlink_unicast+0x19e/0x240
[ 4109.279997]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.280004]  sock_sendmsg+0x3e/0x50
[ 4109.280009]  SYSC_sendto+0x13f/0x180
[ 4109.280016]  ? ktime_get_ts64+0x51/0xf0
[ 4109.280022]  SyS_sendto+0xe/0x10
[ 4109.280027]  do_syscall_64+0x73/0x130
[ 4109.280033]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.280036] RIP: 0033:0x7fd447e87c96
[ 4109.280038] RSP: 002b:00007ffc769063c0 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.280043] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007fd447e87c96
[ 4109.280045] RDX: 0000000000000014 RSI: 00007ffc76906450 RDI: 0000000000000009
[ 4109.280047] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.280050] R10: 0000000000004000 R11: 0000000000000246 R12: 00007ffc76906450
[ 4109.280052] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.280063] INFO: task evolution-addre:2396 blocked for more than
120 seconds.
[ 4109.280068]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.280072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.280076] evolution-addre D    0  2396   2385 0x00000000
[ 4109.280080] Call Trace:
[ 4109.280086]  __schedule+0x291/0x8a0
[ 4109.280091]  schedule+0x2c/0x80
[ 4109.280096]  schedule_preempt_disabled+0xe/0x10
[ 4109.280100]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.280106]  ? __switch_to_asm+0x34/0x70
[ 4109.280112]  __mutex_lock_slowpath+0x13/0x20
[ 4109.280116]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.280121]  mutex_lock+0x2f/0x40
[ 4109.280125]  __netlink_dump_start+0x51/0x1c0
[ 4109.280129]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.280135]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.280139]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.280144]  netlink_rcv_skb+0x54/0x130
[ 4109.280150]  rtnetlink_rcv+0x15/0x20
[ 4109.280154]  netlink_unicast+0x19e/0x240
[ 4109.280160]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.280166]  sock_sendmsg+0x3e/0x50
[ 4109.280171]  SYSC_sendto+0x13f/0x180
[ 4109.280178]  ? ktime_get_ts64+0x51/0xf0
[ 4109.280184]  SyS_sendto+0xe/0x10
[ 4109.280189]  do_syscall_64+0x73/0x130
[ 4109.280195]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.280198] RIP: 0033:0x7fafc0ea0c96
[ 4109.280200] RSP: 002b:00007fffe7cb0040 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.280205] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007fafc0ea0c96
[ 4109.280207] RDX: 0000000000000014 RSI: 00007fffe7cb00d0 RDI: 0000000000000007
[ 4109.280209] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.280212] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fffe7cb00d0
[ 4109.280214] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.280224] INFO: task gjs:2441 blocked for more than 120 seconds.
[ 4109.280229]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.280233] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.280237] gjs             D    0  2441   1809 0x00000000
[ 4109.280241] Call Trace:
[ 4109.280247]  __schedule+0x291/0x8a0
[ 4109.280253]  schedule+0x2c/0x80
[ 4109.280257]  schedule_preempt_disabled+0xe/0x10
[ 4109.280262]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.280269]  __mutex_lock_slowpath+0x13/0x20
[ 4109.280273]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.280277]  mutex_lock+0x2f/0x40
[ 4109.280282]  __netlink_dump_start+0x51/0x1c0
[ 4109.280286]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.280292]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.280296]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.280301]  netlink_rcv_skb+0x54/0x130
[ 4109.280307]  rtnetlink_rcv+0x15/0x20
[ 4109.280311]  netlink_unicast+0x19e/0x240
[ 4109.280316]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.280322]  sock_sendmsg+0x3e/0x50
[ 4109.280327]  SYSC_sendto+0x13f/0x180
[ 4109.280337]  ? compat_poll_select_copy_remaining+0x130/0x130
[ 4109.280344]  SyS_sendto+0xe/0x10
[ 4109.280349]  do_syscall_64+0x73/0x130
[ 4109.280355]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.280358] RIP: 0033:0x7fe61c808c96
[ 4109.280360] RSP: 002b:00007ffd83d6ab00 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.280364] RAX: ffffffffffffffda RBX: 0000000000000014 RCX: 00007fe61c808c96
[ 4109.280367] RDX: 0000000000000014 RSI: 00007ffd83d6ab90 RDI: 0000000000000014
[ 4109.280369] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.280372] R10: 0000000000004000 R11: 0000000000000246 R12: 00007ffd83d6ab90
[ 4109.280374] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.280387] INFO: task gnome-software:2605 blocked for more than 120 seconds.
[ 4109.280393]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.280397] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.280401] gnome-software  D    0  2605   1852 0x00000000
[ 4109.280405] Call Trace:
[ 4109.280411]  __schedule+0x291/0x8a0
[ 4109.280417]  schedule+0x2c/0x80
[ 4109.280421]  schedule_preempt_disabled+0xe/0x10
[ 4109.280426]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.280432]  __mutex_lock_slowpath+0x13/0x20
[ 4109.280437]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.280441]  mutex_lock+0x2f/0x40
[ 4109.280446]  __netlink_dump_start+0x51/0x1c0
[ 4109.280450]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.280456]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.280460]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.280465]  netlink_rcv_skb+0x54/0x130
[ 4109.280471]  rtnetlink_rcv+0x15/0x20
[ 4109.280475]  netlink_unicast+0x19e/0x240
[ 4109.280480]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.280487]  sock_sendmsg+0x3e/0x50
[ 4109.280491]  SYSC_sendto+0x13f/0x180
[ 4109.280498]  ? ktime_get_ts64+0x51/0xf0
[ 4109.280505]  SyS_sendto+0xe/0x10
[ 4109.280510]  do_syscall_64+0x73/0x130
[ 4109.280516]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.280519] RIP: 0033:0x7f3ccadca9ae
[ 4109.280521] RSP: 002b:00007ffd3bdd2240 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.280525] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f3ccadca9ae
[ 4109.280528] RDX: 0000000000000014 RSI: 00007ffd3bdd22d0 RDI: 000000000000000c
[ 4109.280530] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.280532] R10: 0000000000004000 R11: 0000000000000246 R12: 00007ffd3bdd22d0
[ 4109.280535] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.280544] INFO: task deja-dup-monito:3278 blocked for more than
120 seconds.
[ 4109.280550]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.280553] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.280557] deja-dup-monito D    0  3278   1852 0x00000000
[ 4109.280562] Call Trace:
[ 4109.280568]  __schedule+0x291/0x8a0
[ 4109.280573]  schedule+0x2c/0x80
[ 4109.280578]  schedule_preempt_disabled+0xe/0x10
[ 4109.280582]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.280589]  __mutex_lock_slowpath+0x13/0x20
[ 4109.280593]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.280598]  mutex_lock+0x2f/0x40
[ 4109.280602]  __netlink_dump_start+0x51/0x1c0
[ 4109.280606]  rtnetlink_rcv_msg+0x1c2/0x2b0
[ 4109.280612]  ? rtnl_bridge_notify+0xf0/0xf0
[ 4109.280616]  ? rtnl_calcit.isra.28+0x110/0x110
[ 4109.280621]  netlink_rcv_skb+0x54/0x130
[ 4109.280627]  rtnetlink_rcv+0x15/0x20
[ 4109.280631]  netlink_unicast+0x19e/0x240
[ 4109.280636]  netlink_sendmsg+0x2d1/0x3d0
[ 4109.280643]  sock_sendmsg+0x3e/0x50
[ 4109.280648]  SYSC_sendto+0x13f/0x180
[ 4109.280655]  ? ktime_get_ts64+0x51/0xf0
[ 4109.280661]  SyS_sendto+0xe/0x10
[ 4109.280666]  do_syscall_64+0x73/0x130
[ 4109.280672]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 4109.280675] RIP: 0033:0x7f08442e5c96
[ 4109.280677] RSP: 002b:00007ffe39ab3c10 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[ 4109.280682] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007f08442e5c96
[ 4109.280684] RDX: 0000000000000014 RSI: 00007ffe39ab3ca0 RDI: 0000000000000009
[ 4109.280687] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 4109.280689] R10: 0000000000004000 R11: 0000000000000246 R12: 00007ffe39ab3ca0
[ 4109.280691] R13: 0000000000000014 R14: 0000000000004000 R15: 0000000000000000
[ 4109.280704] INFO: task kworker/2:4:5337 blocked for more than 120 seconds.
[ 4109.280710]       Tainted: G           OE    4.15.0-45-generic #48-Ubuntu
[ 4109.280714] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4109.280718] kworker/2:4     D    0  5337      2 0x80000000
[ 4109.280773] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[ 4109.280776] Call Trace:
[ 4109.280783]  __schedule+0x291/0x8a0
[ 4109.280789]  schedule+0x2c/0x80
[ 4109.280793]  schedule_preempt_disabled+0xe/0x10
[ 4109.280798]  __mutex_lock.isra.2+0x18c/0x4d0
[ 4109.280803]  ? _cond_resched+0x19/0x40
[ 4109.280808]  __mutex_lock_slowpath+0x13/0x20
[ 4109.280813]  ? __mutex_lock_slowpath+0x13/0x20
[ 4109.280817]  mutex_lock+0x2f/0x40
[ 4109.280823]  rtnl_lock+0x15/0x20
[ 4109.280861]  ieee80211_restart_work+0x56/0xd0 [mac80211]
[ 4109.280868]  process_one_work+0x1de/0x410
[ 4109.280873]  worker_thread+0x32/0x410
[ 4109.280879]  kthread+0x121/0x140
[ 4109.280883]  ? process_one_work+0x410/0x410
[ 4109.280888]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 4109.280893]  ? do_syscall_64+0x73/0x130
[ 4109.280898]  ? SyS_exit_group+0x14/0x20
[ 4109.280903]  ret_from_fork+0x22/0x40
