Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36687 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbeA3Tt3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 14:49:29 -0500
Received: by mail-wr0-f175.google.com with SMTP id y3so2659518wrh.3
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jan 2018 11:49:29 -0800 (PST)
Date: Tue, 30 Jan 2018 20:49:26 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Centrino Advanced-N 6235 - Microcode SW error detected
Message-ID: <20180130194926.lg3grfffcsruiz4j@pali> (sfid-20180130_204935_225321_F0672012)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x3fuml353z3fsgjk"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--x3fuml353z3fsgjk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

for almost 3 years I have a problem with Intel wifi card Centrino
Advanced-N 6235. Its firmware periodically crash and in dmesg I'm seeing
a message "Microcode SW error detected".

Problem happens independently of kernel versions (I tried 3.8, 3.13,
3.18, 4.0, 4.9). Currently I'm using Debian Stretch and its 4.9 version.

This wifi card is identified as:

$ lspci -s 03:00.0 -vv
03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235 (rev=
 24)
        Subsystem: Intel Corporation Centrino Advanced-N 6235 AGN
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 32
        Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=3D8K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [d0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee003b8  Data: 0000
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512=
ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ Slo=
tPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLRese=
t-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ Tr=
ansPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit=
 Latency L0s <4us, L1 <32us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- Ch=
kEn-
        Capabilities: [140 v1] Device Serial Number c4-d9-87-ff-ff-6c-38-01
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi

And here is example of dmesg error flood:

[26624.998823] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarti=
ng 0x2000000.
[26624.998826] iwlwifi 0000:03:00.0: CSR values:
[26624.998827] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR=
_INT_PERIODIC_REG)
[26624.998831] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00484b00
[26624.998834] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X0000ff40
[26624.998837] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[26624.998841] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[26624.998844] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[26624.998848] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000038
[26624.998851] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[26624.998854] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[26624.998858] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X000000b0
[26624.998861] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xae3c0ffd
[26624.998864] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000801
[26624.998868] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
[26624.998871] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080044
[26624.998875] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00001416
[26624.998878] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[26624.998881] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[26624.998885] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[26624.998888] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000040
[26624.998892] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88222bc1
[26624.998895] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[26624.998898] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[26624.998902] iwlwifi 0000:03:00.0:      CSR_MONITOR_STATUS_REG: 0X6bf7ffd7
[26624.998905] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[26624.998909] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[26624.998910] iwlwifi 0000:03:00.0: FH register values:
[26624.998921] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: =
0X220b5d00
[26624.998932] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: =
0X0220b040
[26624.998944] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: =
0X000000d8
[26624.998955] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: =
0X80801114
[26624.998967] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: =
0X000000fc
[26624.998978] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: =
0X07030000
[26624.998989] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: =
0X00000000
[26624.999000] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: =
0X07ff0001
[26624.999012] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: =
0X00000000
[26624.999013] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
[26624.999117] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[26624.999118] iwlwifi 0000:03:00.0: Status: 0x000002CC, count: 6
[26624.999120] iwlwifi 0000:03:00.0: 0x000028AA | ADVANCED_SYSASSERT       =
  =20
[26624.999120] iwlwifi 0000:03:00.0: 0x00015984 | uPc
[26624.999121] iwlwifi 0000:03:00.0: 0x00015974 | branchlink1
[26624.999122] iwlwifi 0000:03:00.0: 0x00015974 | branchlink2
[26624.999123] iwlwifi 0000:03:00.0: 0x0000DBEA | interruptlink1
[26624.999124] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[26624.999125] iwlwifi 0000:03:00.0: 0x0000093A | data1
[26624.999126] iwlwifi 0000:03:00.0: 0x00000012 | data2
[26624.999126] iwlwifi 0000:03:00.0: 0x000001F3 | line
[26624.999127] iwlwifi 0000:03:00.0: 0xC1006DA0 | beacon time
[26624.999128] iwlwifi 0000:03:00.0: 0x79AA1260 | tsf low
[26624.999129] iwlwifi 0000:03:00.0: 0x00000006 | tsf hi
[26624.999130] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[26624.999131] iwlwifi 0000:03:00.0: 0xE9B0D44A | time gp2
[26624.999131] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[26624.999132] iwlwifi 0000:03:00.0: 0x754312A8 | uCode version
[26624.999133] iwlwifi 0000:03:00.0: 0x000000B0 | hw version
[26624.999134] iwlwifi 0000:03:00.0: 0x00484B00 | board version
[26624.999135] iwlwifi 0000:03:00.0: 0x0000001C | hcmd
[26624.999136] iwlwifi 0000:03:00.0: 0xAFA63040 | isr0
[26624.999137] iwlwifi 0000:03:00.0: 0x1189F800 | isr1
[26624.999137] iwlwifi 0000:03:00.0: 0x00000E1A | isr2
[26624.999138] iwlwifi 0000:03:00.0: 0x0143FCC3 | isr3
[26624.999139] iwlwifi 0000:03:00.0: 0x00000000 | isr4
[26624.999140] iwlwifi 0000:03:00.0: 0x10000112 | isr_pref
[26624.999141] iwlwifi 0000:03:00.0: 0x000260A4 | wait_event
[26624.999141] iwlwifi 0000:03:00.0: 0x00000080 | l2p_control
[26624.999142] iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
[26624.999143] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
[26624.999144] iwlwifi 0000:03:00.0: 0x00200200 | l2p_addr_match
[26624.999145] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
[26624.999146] iwlwifi 0000:03:00.0: 0x13011136 | timestamp
[26624.999147] iwlwifi 0000:03:00.0: 0x0000D8E8 | flow_handler
[26624.999196] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing in l=
og
[26625.004313] ieee80211 phy0: Hardware restart was requested
[26625.005920] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[26625.012617] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[26625.012699] iwlwifi 0000:03:00.0: Radio type=3D0x2-0x1-0x0
[26625.293980] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[26625.300680] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[26625.300760] iwlwifi 0000:03:00.0: Radio type=3D0x2-0x1-0x0
[27464.823586] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarti=
ng 0x2000000.
[27464.823589] iwlwifi 0000:03:00.0: CSR values:
[27464.823590] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR=
_INT_PERIODIC_REG)
[27464.823594] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00484b00
[27464.823598] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X0000ff40
[27464.823601] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[27464.823604] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[27464.823608] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[27464.823611] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000038
[27464.823615] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[27464.823618] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[27464.823621] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X000000b0
[27464.823625] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xae3c0ffd
[27464.823628] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000801
[27464.823631] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
[27464.823635] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080044
[27464.823638] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X0000991a
[27464.823642] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[27464.823645] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[27464.823649] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[27464.823652] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
[27464.823656] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88222bc1
[27464.823660] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[27464.823663] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[27464.823667] iwlwifi 0000:03:00.0:      CSR_MONITOR_STATUS_REG: 0X6bf7f757
[27464.823670] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[27464.823674] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[27464.823675] iwlwifi 0000:03:00.0: FH register values:
[27464.823686] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: =
0X220b5d00
[27464.823698] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: =
0X0220b040
[27464.823709] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: =
0X00000068
[27464.823720] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: =
0X80801114
[27464.823732] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: =
0X000000fc
[27464.823743] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: =
0X07030000
[27464.823754] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: =
0X00000000
[27464.823766] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: =
0X07ff0001
[27464.823777] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: =
0X00000000
[27464.823779] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
[27464.823903] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[27464.823904] iwlwifi 0000:03:00.0: Status: 0x000002CC, count: 6
[27464.823906] iwlwifi 0000:03:00.0: 0x000028AA | ADVANCED_SYSASSERT       =
  =20
[27464.823906] iwlwifi 0000:03:00.0: 0x00015984 | uPc
[27464.823907] iwlwifi 0000:03:00.0: 0x00015974 | branchlink1
[27464.823908] iwlwifi 0000:03:00.0: 0x00015974 | branchlink2
[27464.823909] iwlwifi 0000:03:00.0: 0x0000DBEA | interruptlink1
[27464.823910] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[27464.823910] iwlwifi 0000:03:00.0: 0x000001DE | data1
[27464.823911] iwlwifi 0000:03:00.0: 0x00000012 | data2
[27464.823912] iwlwifi 0000:03:00.0: 0x000001F3 | line
[27464.823913] iwlwifi 0000:03:00.0: 0x01807986 | beacon time
[27464.823914] iwlwifi 0000:03:00.0: 0xABB9A67A | tsf low
[27464.823915] iwlwifi 0000:03:00.0: 0x00000006 | tsf hi
[27464.823915] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[27464.823916] iwlwifi 0000:03:00.0: 0x320A83FE | time gp2
[27464.823917] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[27464.823918] iwlwifi 0000:03:00.0: 0x754312A8 | uCode version
[27464.823918] iwlwifi 0000:03:00.0: 0x000000B0 | hw version
[27464.823919] iwlwifi 0000:03:00.0: 0x00484B00 | board version
[27464.823920] iwlwifi 0000:03:00.0: 0x0000001C | hcmd
[27464.823921] iwlwifi 0000:03:00.0: 0xAFB63000 | isr0
[27464.823922] iwlwifi 0000:03:00.0: 0x1189F800 | isr1
[27464.823922] iwlwifi 0000:03:00.0: 0x00000E1A | isr2
[27464.823923] iwlwifi 0000:03:00.0: 0x0547FCC2 | isr3
[27464.823924] iwlwifi 0000:03:00.0: 0x00000000 | isr4
[27464.823925] iwlwifi 0000:03:00.0: 0x10800112 | isr_pref
[27464.823926] iwlwifi 0000:03:00.0: 0x000260A4 | wait_event
[27464.823926] iwlwifi 0000:03:00.0: 0x00000050 | l2p_control
[27464.823927] iwlwifi 0000:03:00.0: 0x00000130 | l2p_duration
[27464.823928] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
[27464.823929] iwlwifi 0000:03:00.0: 0x00101042 | l2p_addr_match
[27464.823930] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
[27464.823930] iwlwifi 0000:03:00.0: 0x13011136 | timestamp
[27464.823931] iwlwifi 0000:03:00.0: 0x00006878 | flow_handler
[27464.823979] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing in l=
og
[27464.828011] ieee80211 phy0: Hardware restart was requested
[27464.830081] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[27464.836785] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[27464.836866] iwlwifi 0000:03:00.0: Radio type=3D0x2-0x1-0x0
[27465.117920] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[27465.124628] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
[27465.124710] iwlwifi 0000:03:00.0: Radio type=3D0x2-0x1-0x0

This really looks like firmware problem. What can I do with these
microcode errors? Can you help me?

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--x3fuml353z3fsgjk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCWnDMJQAKCRCL8Mk9A+RD
Uo4EAJ9LRWoNUOo6YKuORssEKd2f+zyK1wCghaTjvz/r6qugJu8VmBhnj1zMU7I=
=3yXu
-----END PGP SIGNATURE-----

--x3fuml353z3fsgjk--
