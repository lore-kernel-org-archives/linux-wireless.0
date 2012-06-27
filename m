Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33279 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab2F0VD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 17:03:59 -0400
Received: by yenl2 with SMTP id l2so1317603yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 14:03:58 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 23:03:58 +0200
Message-ID: <CAGh0HCBU-Udztv-CTTGGRfFHTJNSpAwmzbTJXsr5=pRQ0=c8fw@mail.gmail.com> (sfid-20120627_230403_720465_7167B567)
Subject: Poor signal strength on BCM4313
From: Guillaume Bouchard <guillaume.bouchard@liris.cnrs.fr>
To: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

I have a laptop (hp dm1 4131 ef) which is using a broadcom BCM4313
chip on archlinux with a kernel 3.4.4. (detailed system information at
the end of the mail)

I'm able to connect to wifi network with this card, but only within a
really limited range (ie, acces point should be at no more than 3
meters from the laptop, else signal strength is quickly falling to 0).

I found one or two references to the same problem on forums, but
usually people have the same laptop too, so I'm wondering if it can
come from the hardware.

So what is the status of this chip? Is this issue known ? Is there a solution ?

Thank you for your time and please ask if you need more information
about my configuration or some test done.

Configuration details:

$ lspci -vvv

03:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n
Wireless LAN Controller (rev 01)
        Subsystem: Hewlett-Packard Company Device 1795
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at 90200000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [d0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L1,
Latency L0 <4us, L1 <64us
                        ClockPM+ Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [13c v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-3d-ff-ff-68-e4-d5
        Capabilities: [16c v1] Power Budgeting <?>
        Kernel driver in use: bcma-pci-bridge




$ uname -a

Linux hpdm1 3.4.4-2-ARCH #1 SMP PREEMPT Sun Jun 24 18:59:47 CEST 2012
x86_64 GNU/Linux


$ lsmod

Module                  Size  Used by
aes_x86_64              7508  1
cryptd                  8741  0
aes_generic            26138  1 aes_x86_64
arc4                    1410  2
brcmsmac              528035  0
cordic                  1105  1 brcmsmac
crc8                    1186  1 brcmsmac
brcmutil                3152  1 brcmsmac
bcma                   22757  1 brcmsmac
mac80211              395680  1 brcmsmac
cfg80211              170074  2 brcmsmac,mac80211
rfkill                 15604  2 cfg80211
snd_hda_codec_idt      55508  1
snd_hda_codec_hdmi     23672  1
snd_hda_intel          24053  7
snd_hda_codec          94273  3
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel
uvcvideo               69437  0
videobuf2_vmalloc       2468  1 uvcvideo
videobuf2_memops        2246  1 videobuf2_vmalloc
videobuf2_core         20415  1 uvcvideo
fglrx                2619025  102
videodev               93086  1 uvcvideo
snd_hwdep               6300  1 snd_hda_codec
snd_pcm                74958  3 snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel
snd_page_alloc          7217  2 snd_pcm,snd_hda_intel
snd_timer              18966  1 snd_pcm
snd                    58997  21
snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_hda_codec_idt,snd_pcm,snd_hda_codec,snd_hda_intel
soundcore               5410  1 snd
r8169                  49354  0
evdev                   9754  7
serio_raw               4653  0
uas                     9285  0
i2c_piix4               8224  0
ums_realtek             7391  0
i2c_core               20369  2 i2c_piix4,videodev
k10temp                 2915  0
amd_iommu_v2            7359  1 fglrx
mii                     4123  1 r8169
usb_storage            44792  1 ums_realtek
psmouse                70792  0
media                  10213  2 uvcvideo,videodev
wmi                     8475  0
processor              26567  2
microcode              12185  0
button                  4502  1 fglrx
thermal                 7959  0
battery                 6517  0
video                  11307  0
ac                      2376  0
ext4                  424175  3
crc16                   1359  1 ext4
jbd2                   73919  1 ext4
mbcache                 5977  1 ext4
sd_mod                 29239  5
ohci_hcd               21720  0
ahci                   20549  4
libahci                20023  1 ahci
libata                167611  2 ahci,libahci
ehci_hcd               41026  0
scsi_mod              132942  4 uas,usb_storage,libata,sd_mod
usbcore               147565  7
uas,uvcvideo,ums_realtek,usb_storage,ohci_hcd,ehci_hcd
usb_common               954  1 usbcore

-- 
Guillaume
