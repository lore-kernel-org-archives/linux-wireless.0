Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:44862 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3BKJYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 04:24:04 -0500
Message-ID: <5118B8A6.5000306@gmail.com> (sfid-20130211_102415_726261_CD86AE70)
Date: Mon, 11 Feb 2013 09:23:50 +0000
From: Bob Bowles <bobjohnbowles@gmail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, 1072082@bugs.launchpad.net,
	linux-input@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: 046d:c52b Problems using Logitech Unifying Receiver
References: <51177702.4030506@gmail.com> <CAGRGNgVSMN7JtXSMuKVMcE4qOk9SCaZ5W4xpu5O2i5snchOqYw@mail.gmail.com>
In-Reply-To: <CAGRGNgVSMN7JtXSMuKVMcE4qOk9SCaZ5W4xpu5O2i5snchOqYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian

Thanks for getting back to me.

Following advice received earlier from Christian Lamparter, I have 
already submitted the report to linux-input.

Best Wishes   Bob Bowles

On 11/02/13 01:26, Julian Calaby wrote:

> Hi Bob,
>
> This isn't the correct place to ask about this hardware, this is for
> wireless devices that use WiFi or bluetooth, not wireless keyboard /
> mice solutions. You should ask questions about keyboards and mice on
> the linux-input list. (CC'd)
>
> On Sun, Feb 10, 2013 at 9:31 PM, Bob Bowles <bobjohnbowles@gmail.com> wrote:
>> bob@bobDell:/$ # Launchpad Short Description:
>> 046d:c52b Problems using Logitech Unifying Receiver
> While I'm familiar with the hardware (I have it working flawlessly on
> a couple of my computers) I don't really have any experience debugging
> issues with it.
>
> Hopefully someone on the linux-input list will be able to help you.
>
>> bob@bobDell:/$ # Launchpad Long Description:
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072082
>>
>> Commit that caused the regression 534a7b8e10ec55d9f521e68c20dbb3634c25b98a.
>>
>> I recently purchased a new Logitech K350 keyboard (UK layout) and M505
>> mouse, both of which use the Logitech Unifying Receiver. I 'paired' the
>> keyboard and mouse to the receiver by using the proprietary Logitech
>> 'Setpoint' software on a friend's computer running Windows XP. On their
>> computer, the receiver, keyboard and mouse worked perfectly.
>>
>> I then moved the receiver to my own computer, a new Dell Inspiron 7520 SE
>> running under Ubuntu 12.04.1. I tried with no success to get the keyboard
>> and mouse to work by repeatedly unplugging and re-plugging the receiver, and
>> by re-booting the machine.
>>
>> I experimented with solutions posted on the web, in particular in this
>> thread on Ask Ubuntu
>> (http://askubuntu.com/questions/128345/logitech-m515-does-not-work-after-upgrade-to-12-04/202627#202627).
>> The accepted answer did not solve my problem.
>>
>> WORKAROUND:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072082/+attachment/3415472/+files/mousefix
>> running this workaround script on the command line enabled the receiver. I
>> added the script to crontab as suggested. The script does not cause the
>> receiver to work after a reboot, but I found that a single unplug/replug
>> cycle was now sufficient to restore operation of the keyboard and mouse.
>>
>> Potential duplicate of
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039143 .
>>
>>
>> bob@bobDell:/$ # KEYWORDS:
>> kernel usb3 logitech
>>
>>
>> bob@bobDell:/$
>> bob@bobDell:/$ # Kernel Version:
>> bob@bobDell:/$ cat /proc/version
>> Linux version 3.8.0-030800rc6-generic (root@gomeisa) (gcc version 4.6.3
>> (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201301312135 SMP Fri Feb 1 02:36:25 UTC
>> 2013
>>
>>
>> bob@bobDell:/$
>> bob@bobDell:/$ # Oops... message: N/A
>>
>>
>> bob@bobDell:/$
>> bob@bobDell:/$ # Script to reproduce:
>> bob@bobDell:/$ # No script. These are the steps:
>> bob@bobDell:/$ # 1) Ensure Logitech Unifying Receiver is plugged into a USB3
>> port (on this computer ALL ports are USB3)
>> bob@bobDell:/$ # 2) Boot the computer
>> bob@bobDell:/$ # 3) Attempt to use the Logitech keyboard or mouse at the
>> Ubuntu login screen
>> bob@bobDell:/$ # EXPECTED OUTCOME: the keyboard/mouse should work.
>> bob@bobDell:/$ # OBSERVED OUTCOME: the keyboard/mouse do not work.
>> bob@bobDell:/$ # NB 1: The Logitech Receiver must be pre-configured to be
>> paired with the keyboard/mouse. This can be most easily done on a Windows
>> system. Correct functioning of the receiver/keyboard/mouse can be checked
>> prior to the above test by using on a Windows system, or testing them on
>> another computer with USB2 ports.
>> bob@bobDell:/$ # NB 2: This is an INTERMITTENT failure; frequency of failure
>> is approximately 90% or more of trials.
>>
>>
>> bob@bobDell:/$
>> bob@bobDell:/$ # Environment:
>> bob@bobDell:/$ lsb_release -rd
>> Description:    Ubuntu 12.04.2 LTS
>> Release:    12.04
>>
>>
>> bob@bobDell:/$
>> bob@bobDell:/$ # Software (NB Headers not installed):
>> root@bobDell:/usr/src/linux-headers-3.8.0-030800rc6-generic/scripts# sh
>> ver_linux
>> sh: 0: Can't open ver_linux
>>
>>
>> root@bobDell:/#
>> root@bobDell:/# # Module information:
>> root@bobDell:/# cat /proc/modules
>> hid_logitech_dj 18767 0 - Live 0xffffffffa04b5000
>> bnep 18258 2 - Live 0xffffffffa05bc000
>> parport_pc 32866 0 - Live 0xffffffffa05ac000
>> rfcomm 47864 16 - Live 0xffffffffa018f000
>> ppdev 17113 0 - Live 0xffffffffa0189000
>> binfmt_misc 17540 1 - Live 0xffffffffa01a0000
>> joydev 17613 0 - Live 0xffffffffa03ef000
>> coretemp 13596 0 - Live 0xffffffffa040a000
>> snd_hda_codec_hdmi 37223 1 - Live 0xffffffffa03ff000
>> kvm_intel 137899 0 - Live 0xffffffffa08d8000
>> kvm 451836 1 kvm_intel, Live 0xffffffffa069c000
>> arc4 12573 2 - Live 0xffffffffa040f000
>> snd_hda_codec_conexant 62464 1 - Live 0xffffffffa068b000
>> snd_hda_intel 44339 3 - Live 0xffffffffa04a9000
>> i915 616318 3 - Live 0xffffffffa05d3000
>> radeon 956896 0 - Live 0xffffffffa04c1000
>> snd_hda_codec 141461 3
>> snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live
>> 0xffffffffa0485000
>> ghash_clmulni_intel 13259 0 - Live 0xffffffffa04bc000
>> aesni_intel 55495 0 - Live 0xffffffffa0476000
>> iwldvm 249055 0 - Live 0xffffffffa0438000
>> snd_hwdep 13668 1 snd_hda_codec, Live 0xffffffffa03fa000
>> snd_pcm 102477 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
>> 0xffffffffa041d000
>> ablk_helper 13597 1 aesni_intel, Live 0xffffffffa02d7000
>> cryptd 20501 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
>> 0xffffffffa02cc000
>> snd_seq_midi 13324 0 - Live 0xffffffffa0298000
>> snd_rawmidi 30417 1 snd_seq_midi, Live 0xffffffffa0414000
>> mac80211 613116 1 iwldvm, Live 0xffffffffa0358000
>> lrw 13294 1 aesni_intel, Live 0xffffffffa017b000
>> ttm 84051 1 radeon, Live 0xffffffffa0342000
>> rts5139 351018 0 - Live 0xffffffffa02eb000 (C)
>> snd_seq_midi_event 14899 1 snd_seq_midi, Live 0xffffffffa00c3000
>> snd_seq 61930 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa0271000
>> drm_kms_helper 49597 2 i915,radeon, Live 0xffffffffa02dd000
>> iwlwifi 183399 1 iwldvm, Live 0xffffffffa029e000
>> uvcvideo 82214 0 - Live 0xffffffffa0282000
>> aes_x86_64 17255 1 aesni_intel, Live 0xffffffffa00bd000
>> snd_timer 29989 2 snd_pcm,snd_seq, Live 0xffffffffa0180000
>> xts 12922 1 aesni_intel, Live 0xffffffffa00b8000
>> snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
>> 0xffffffffa0176000
>> gf128mul 14951 2 lrw,xts, Live 0xffffffffa00a6000
>> cfg80211 525244 3 iwldvm,mac80211,iwlwifi, Live 0xffffffffa01ef000
>> snd 69533 16
>> snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
>> Live 0xffffffffa0164000
>> btusb 18291 0 - Live 0xffffffffa00b2000
>> drm 286915 6 i915,radeon,ttm,drm_kms_helper, Live 0xffffffffa01a7000
>> videobuf2_core 40785 1 uvcvideo, Live 0xffffffffa009b000
>> dell_wmi 12681 0 - Live 0xffffffffa015a000
>> dell_laptop 17425 0 - Live 0xffffffffa0154000
>> sparse_keymap 13890 1 dell_wmi, Live 0xffffffffa015f000
>> videodev 130053 2 uvcvideo,videobuf2_core, Live 0xffffffffa0133000
>> bluetooth 246976 24 bnep,rfcomm,btusb, Live 0xffffffffa00f5000
>> dcdbas 14449 1 dell_laptop, Live 0xffffffffa00ec000
>> videobuf2_vmalloc 13056 1 uvcvideo, Live 0xffffffffa00e7000
>> videobuf2_memops 13202 1 videobuf2_vmalloc, Live 0xffffffffa0089000
>> psmouse 92375 0 - Live 0xffffffffa00cf000
>> soundcore 12680 1 snd, Live 0xffffffffa00ca000
>> snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0xffffffffa00ac000
>> microcode 23017 0 - Live 0xffffffffa0094000
>> wmi 19256 1 dell_wmi, Live 0xffffffffa008e000
>> lpc_ich 17144 0 - Live 0xffffffffa0073000
>> serio_raw 13215 0 - Live 0xffffffffa006e000
>> i2c_algo_bit 13564 2 i915,radeon, Live 0xffffffffa005d000
>> mei 41820 0 - Live 0xffffffffa0062000
>> mac_hid 13253 0 - Live 0xffffffffa004e000
>> video 19467 1 i915, Live 0xffffffffa0037000
>> lp 17799 0 - Live 0xffffffffa0012000
>> parport 46562 3 parport_pc,ppdev,lp, Live 0xffffffffa0041000
>> usbhid 47346 1 hid_logitech_dj, Live 0xffffffffa007c000
>> hid 101262 2 hid_logitech_dj,usbhid, Live 0xffffffffa0019000
>> r8169 68785 0 - Live 0xffffffffa0000000
>>
>>
>> root@bobDell:/#
>> root@bobDell:/# # Loaded driver and hardware information:
>> root@bobDell:/# cat /proc/ioports
>> 0000-0cf7 : PCI Bus 0000:00
>>    0000-001f : dma1
>>    0020-0021 : pic1
>>    0040-0043 : timer0
>>    0050-0053 : timer1
>>    0060-0060 : keyboard
>>    0062-0062 : EC data
>>    0064-0064 : keyboard
>>    0066-0066 : EC cmd
>>    0070-0077 : rtc0
>>    0080-008f : dma page reg
>>    00a0-00a1 : pic2
>>    00c0-00df : dma2
>>    00f0-00ff : fpu
>>    0400-0453 : pnp 00:04
>>      0400-0403 : ACPI PM1a_EVT_BLK
>>      0404-0405 : ACPI PM1a_CNT_BLK
>>      0408-040b : ACPI PM_TMR
>>      0410-0415 : ACPI CPU throttle
>>      0420-042f : ACPI GPE0_BLK
>>      0430-0433 : iTCO_wdt
>>      0450-0450 : ACPI PM2_CNT_BLK
>>    0454-0457 : pnp 00:06
>>    0458-047f : pnp 00:04
>>      0460-047f : iTCO_wdt
>>    0500-057f : pnp 00:04
>>    0680-069f : pnp 00:04
>> 0cf8-0cff : PCI conf1
>> 0d00-ffff : PCI Bus 0000:00
>>    1000-100f : pnp 00:04
>>    164e-164f : pnp 00:04
>>    2000-2fff : PCI Bus 0000:07
>>      2000-20ff : 0000:07:00.0
>>        2000-20ff : r8169
>>    3000-3fff : PCI Bus 0000:01
>>      3000-30ff : 0000:01:00.0
>>    4000-403f : 0000:00:02.0
>>    4040-405f : 0000:00:1f.3
>>    4060-407f : 0000:00:1f.2
>>      4060-407f : ahci
>>    4080-4087 : 0000:00:1f.2
>>      4080-4087 : ahci
>>    4088-408f : 0000:00:1f.2
>>      4088-408f : ahci
>>    4090-4093 : 0000:00:1f.2
>>      4090-4093 : ahci
>>    4094-4097 : 0000:00:1f.2
>>      4094-4097 : ahci
>>    fd60-fd63 : pnp 00:04
>>    ffff-ffff : pnp 00:04
>>      ffff-ffff : pnp 00:04
>>
>> root@bobDell:/# cat /proc/iomem
>> 00000000-0000ffff : reserved
>> 00010000-0009d3ff : System RAM
>> 0009d400-0009ffff : reserved
>> 000a0000-000bffff : PCI Bus 0000:00
>> 000c0000-000cedff : Video ROM
>> 000cf000-000cffff : Adapter ROM
>> 000e0000-000fffff : reserved
>>    000f0000-000fffff : System ROM
>> 00100000-1fffffff : System RAM
>>    01000000-016f8e10 : Kernel code
>>    016f8e11-01cee83f : Kernel data
>>    01df3000-01f49fff : Kernel bss
>> 20000000-201fffff : reserved
>>    20000000-201fffff : pnp 00:0a
>> 20200000-40003fff : System RAM
>> 40004000-40004fff : reserved
>>    40004000-40004fff : pnp 00:0a
>> 40005000-8ffaffff : System RAM
>> 8ffb0000-913affff : reserved
>> 913b0000-9a3befff : System RAM
>> 9a3bf000-9aebefff : reserved
>> 9aebf000-9afbefff : ACPI Non-volatile Storage
>> 9afbf000-9affefff : ACPI Tables
>> 9afff000-9affffff : System RAM
>> 9b000000-9f9fffff : reserved
>> 9fa00000-feafffff : PCI Bus 0000:00
>>    9fa00000-9fa00fff : pnp 00:09
>>    a0000000-afffffff : PCI Bus 0000:01
>>      a0000000-afffffff : 0000:01:00.0
>>    b0000000-bfffffff : 0000:00:02.0
>>    c0000000-c0ffffff : PCI Bus 0000:01
>>      c0000000-c003ffff : 0000:01:00.0
>>      c0040000-c005ffff : 0000:01:00.0
>>    c1000000-c13fffff : 0000:00:02.0
>>    c1400000-c14fffff : PCI Bus 0000:07
>>      c1400000-c1403fff : 0000:07:00.0
>>        c1400000-c1403fff : r8169
>>      c1404000-c1404fff : 0000:07:00.0
>>        c1404000-c1404fff : r8169
>>    c1500000-c15fffff : PCI Bus 0000:08
>>      c1500000-c1501fff : 0000:08:00.0
>>        c1500000-c1501fff : iwlwifi
>>    c1600000-c160ffff : 0000:00:14.0
>>      c1600000-c160ffff : xhci_hcd
>>    c1610000-c1613fff : 0000:00:1b.0
>>      c1610000-c1613fff : ICH HD audio
>>    c1614000-c161400f : 0000:00:16.0
>>      c1614000-c161400f : mei
>>    c1615000-c16150ff : 0000:00:1f.3
>>    c1617000-c16177ff : 0000:00:1f.2
>>      c1617000-c16177ff : ahci
>>    c1618000-c16183ff : 0000:00:1d.0
>>      c1618000-c16183ff : ehci_hcd
>>    c1619000-c16193ff : 0000:00:1a.0
>>      c1619000-c16193ff : ehci_hcd
>>    e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>>      e0000000-efffffff : reserved
>>        e0000000-efffffff : pnp 00:09
>> feb00000-feb03fff : reserved
>> fec00000-fec00fff : reserved
>>    fec00000-fec003ff : IOAPIC 0
>> fed00000-fed003ff : HPET 0
>> fed10000-fed19fff : reserved
>>    fed10000-fed17fff : pnp 00:09
>>    fed18000-fed18fff : pnp 00:09
>>    fed19000-fed19fff : pnp 00:09
>> fed1c000-fed1ffff : reserved
>>    fed1c000-fed1ffff : pnp 00:09
>>      fed1f410-fed1f414 : iTCO_wdt
>> fed20000-fed3ffff : pnp 00:09
>> fed90000-fed93fff : pnp 00:09
>> fee00000-fee00fff : Local APIC
>>    fee00000-fee00fff : reserved
>> ff000000-ff000fff : pnp 00:09
>> ffb80000-ffffffff : reserved
>> 100000000-1df5fffff : System RAM
>> 1df600000-1dfffffff : RAM buffer
>>
>>
>> root@bobDell:/#
>> root@bobDell:/# # PCI information:
>> root@bobDell:/# lspci -vvv
>> 00:00.0 Host bridge: Intel Corporation Ivy Bridge DRAM Controller (rev 09)
>>      Subsystem: Dell Device 0572
>>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort+ >SERR- <PERR- INTx-
>>      Latency: 0
>>      Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>>
>> 00:01.0 PCI bridge: Intel Corporation Ivy Bridge PCI Express Root Port (rev
>> 09) (prog-if 00 [Normal decode])
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0, Cache Line Size: 64 bytes
>>      Bus: primary=00, secondary=01, subordinate=06, sec-latency=0
>>      I/O behind bridge: 00003000-00003fff
>>      Memory behind bridge: c0000000-c0ffffff
>>      Prefetchable memory behind bridge: 00000000a0000000-00000000afffffff
>>      Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- <SERR- <PERR-
>>      BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>          PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>      Capabilities: [88] Subsystem: Dell Device 0572
>>      Capabilities: [80] Power Management version 3
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>          Address: fee0f00c  Data: 4181
>>      Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
>>          DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1
>> <1us
>>              ExtTag- RBE+ FLReset-
>>          DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>              RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>              MaxPayload 256 bytes, MaxReadReq 128 bytes
>>          DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>> TransPend-
>>          LnkCap:    Port #2, Speed unknown, Width x8, ASPM L0s L1, Latency L0
>> <256ns, L1 <8us
>>              ClockPM- Surprise- LLActRep- BwNot+
>>          LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>              ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>          LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive-
>> BWMgmt+ ABWMgmt-
>>          SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surprise-
>>              Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
>>          SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>> LinkChg-
>>              Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>          SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
>> Interlock-
>>              Changed: MRL- PresDet+ LinkState-
>>          RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>          RootCap: CRSVisible-
>>          RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>          DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
>>          DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>          LnkCtl2: Target Link Speed: Unknown, EnterCompliance- SpeedDis-,
>> Selectable De-emphasis: -3.5dB
>>               Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>               Compliance De-emphasis: -6dB
>>          LnkSta2: Current De-emphasis Level: -3.5dB
>>      Capabilities: [100 v1] Virtual Channel
>>          Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
>>          Arb:    Fixed- WRR32- WRR64- WRR128-
>>          Ctrl:    ArbSelect=Fixed
>>          Status:    InProgress-
>>          VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>              Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
>>              Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>              Status:    NegoPending- InProgress-
>>      Capabilities: [140 v1] Root Complex Link
>>          Desc:    PortNumber=02 ComponentID=01 EltType=Config
>>          Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB-
>> LinkType=MemMapped LinkValid+
>>              Addr:    00000000fed19000
>>      Capabilities: [d94 v1] #19
>>      Kernel driver in use: pcieport
>>      Kernel modules: shpchp
>>
>> 00:02.0 VGA compatible controller: Intel Corporation Ivy Bridge Graphics
>> Controller (rev 09) (prog-if 00 [VGA controller])
>>      Subsystem: Dell Device 0572
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0
>>      Interrupt: pin A routed to IRQ 47
>>      Region 0: Memory at c1000000 (64-bit, non-prefetchable) [size=4M]
>>      Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
>>      Region 4: I/O ports at 4000 [size=64]
>>      Expansion ROM at <unassigned> [disabled]
>>      Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>          Address: fee0c00c  Data: 4162
>>      Capabilities: [d0] Power Management version 2
>>          Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [a4] PCI Advanced Features
>>          AFCap: TP+ FLR+
>>          AFCtrl: FLR-
>>          AFStatus: TP-
>>      Kernel driver in use: i915
>>      Kernel modules: i915
>>
>> 00:14.0 USB controller: Intel Corporation Panther Point USB xHCI Host
>> Controller (rev 04) (prog-if 30 [XHCI])
>>      Subsystem: Dell Device 0572
>>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0
>>      Interrupt: pin A routed to IRQ 42
>>      Region 0: Memory at c1600000 (64-bit, non-prefetchable) [size=64K]
>>      Capabilities: [70] Power Management version 2
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
>>          Address: 00000000fee0300c  Data: 41b1
>>      Kernel driver in use: xhci_hcd
>>
>> 00:16.0 Communication controller: Intel Corporation Panther Point MEI
>> Controller #1 (rev 04)
>>      Subsystem: Dell Device 0572
>>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0
>>      Interrupt: pin A routed to IRQ 44
>>      Region 0: Memory at c1614000 (64-bit, non-prefetchable) [size=16]
>>      Capabilities: [50] Power Management version 3
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>          Address: 00000000fee0f00c  Data: 41d1
>>      Kernel driver in use: mei
>>      Kernel modules: mei
>>
>> 00:1a.0 USB controller: Intel Corporation Panther Point USB Enhanced Host
>> Controller #2 (rev 04) (prog-if 20 [EHCI])
>>      Subsystem: Dell Device 0572
>>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0
>>      Interrupt: pin A routed to IRQ 16
>>      Region 0: Memory at c1619000 (32-bit, non-prefetchable) [size=1K]
>>      Capabilities: [50] Power Management version 2
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [58] Debug port: BAR=1 offset=00a0
>>      Capabilities: [98] PCI Advanced Features
>>          AFCap: TP+ FLR+
>>          AFCtrl: FLR-
>>          AFStatus: TP-
>>      Kernel driver in use: ehci-pci
>>
>> 00:1b.0 Audio device: Intel Corporation Panther Point High Definition Audio
>> Controller (rev 04)
>>      Subsystem: Dell Device 0572
>>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0, Cache Line Size: 64 bytes
>>      Interrupt: pin A routed to IRQ 46
>>      Region 0: Memory at c1610000 (64-bit, non-prefetchable) [size=16K]
>>      Capabilities: [50] Power Management version 2
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>          Address: 00000000fee0100c  Data: 4142
>>      Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
>>          DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
>> <1us
>>              ExtTag- RBE- FLReset+
>>          DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>              RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>              MaxPayload 128 bytes, MaxReadReq 128 bytes
>>          DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>          LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, Latency
>> L0 <64ns, L1 <1us
>>              ClockPM- Surprise- LLActRep- BwNot-
>>          LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
>>              ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>          LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
>> BWMgmt- ABWMgmt-
>>      Capabilities: [100 v1] Virtual Channel
>>          Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
>>          Arb:    Fixed- WRR32- WRR64- WRR128-
>>          Ctrl:    ArbSelect=Fixed
>>          Status:    InProgress-
>>          VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>              Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>              Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>>              Status:    NegoPending- InProgress-
>>          VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>              Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>              Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=22
>>              Status:    NegoPending- InProgress-
>>      Capabilities: [130 v1] Root Complex Link
>>          Desc:    PortNumber=0f ComponentID=00 EltType=Config
>>          Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB-
>> LinkType=MemMapped LinkValid+
>>              Addr:    00000000fed1c000
>>      Kernel driver in use: snd_hda_intel
>>      Kernel modules: snd-hda-intel
>>
>> 00:1c.0 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 1
>> (rev c4) (prog-if 00 [Normal decode])
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0, Cache Line Size: 64 bytes
>>      Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
>>      I/O behind bridge: 00002000-00002fff
>>      Memory behind bridge: fff00000-000fffff
>>      Prefetchable memory behind bridge: 00000000c1400000-00000000c14fffff
>>      Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- <SERR- <PERR-
>>      BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>          PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>      Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>>          DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
>> <1us
>>              ExtTag- RBE+ FLReset-
>>          DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>              RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>              MaxPayload 128 bytes, MaxReadReq 128 bytes
>>          DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>          LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
>> <512ns, L1 <16us
>>              ClockPM- Surprise- LLActRep+ BwNot-
>>          LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>              ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>          LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
>> BWMgmt+ ABWMgmt-
>>          SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surprise-
>>              Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
>>          SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>> LinkChg-
>>              Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>          SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
>> Interlock-
>>              Changed: MRL- PresDet- LinkState+
>>          RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>          RootCap: CRSVisible-
>>          RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>          DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>>          DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>          LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
>> Selectable De-emphasis: -6dB
>>               Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>               Compliance De-emphasis: -6dB
>>          LnkSta2: Current De-emphasis Level: -3.5dB
>>      Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>>          Address: 00000000  Data: 0000
>>      Capabilities: [90] Subsystem: Dell Device 0572
>>      Capabilities: [a0] Power Management version 2
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Kernel driver in use: pcieport
>>      Kernel modules: shpchp
>>
>> 00:1c.1 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 2
>> (rev c4) (prog-if 00 [Normal decode])
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0, Cache Line Size: 64 bytes
>>      Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
>>      I/O behind bridge: 0000f000-00000fff
>>      Memory behind bridge: c1500000-c15fffff
>>      Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>      Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- <SERR- <PERR-
>>      BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>          PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>      Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>>          DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
>> <1us
>>              ExtTag- RBE+ FLReset-
>>          DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>              RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>              MaxPayload 128 bytes, MaxReadReq 128 bytes
>>          DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>          LnkCap:    Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
>> <512ns, L1 <16us
>>              ClockPM- Surprise- LLActRep+ BwNot-
>>          LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>              ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>          LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
>> BWMgmt+ ABWMgmt-
>>          SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surprise-
>>              Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
>>          SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>> LinkChg-
>>              Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>          SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
>> Interlock-
>>              Changed: MRL- PresDet- LinkState+
>>          RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>          RootCap: CRSVisible-
>>          RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>          DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>>          DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>          LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
>> Selectable De-emphasis: -6dB
>>               Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>               Compliance De-emphasis: -6dB
>>          LnkSta2: Current De-emphasis Level: -3.5dB
>>      Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>>          Address: 00000000  Data: 0000
>>      Capabilities: [90] Subsystem: Dell Device 0572
>>      Capabilities: [a0] Power Management version 2
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Kernel driver in use: pcieport
>>      Kernel modules: shpchp
>>
>> 00:1d.0 USB controller: Intel Corporation Panther Point USB Enhanced Host
>> Controller #1 (rev 04) (prog-if 20 [EHCI])
>>      Subsystem: Dell Device 0572
>>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0
>>      Interrupt: pin A routed to IRQ 23
>>      Region 0: Memory at c1618000 (32-bit, non-prefetchable) [size=1K]
>>      Capabilities: [50] Power Management version 2
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [58] Debug port: BAR=1 offset=00a0
>>      Capabilities: [98] PCI Advanced Features
>>          AFCap: TP+ FLR+
>>          AFCtrl: FLR-
>>          AFStatus: TP-
>>      Kernel driver in use: ehci-pci
>>
>> 00:1f.0 ISA bridge: Intel Corporation Panther Point LPC Controller (rev 04)
>>      Subsystem: Dell Device 0572
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0
>>      Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>>      Kernel driver in use: lpc_ich
>>      Kernel modules: lpc_ich
>>
>> 00:1f.2 SATA controller: Intel Corporation Panther Point 6 port SATA
>> Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
>>      Subsystem: Dell Device 0572
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0
>>      Interrupt: pin B routed to IRQ 41
>>      Region 0: I/O ports at 4088 [size=8]
>>      Region 1: I/O ports at 4094 [size=4]
>>      Region 2: I/O ports at 4080 [size=8]
>>      Region 3: I/O ports at 4090 [size=4]
>>      Region 4: I/O ports at 4060 [size=32]
>>      Region 5: Memory at c1617000 (32-bit, non-prefetchable) [size=2K]
>>      Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>          Address: fee0300c  Data: 41a1
>>      Capabilities: [70] Power Management version 3
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot+,D3cold-)
>>          Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
>>      Capabilities: [b0] PCI Advanced Features
>>          AFCap: TP+ FLR+
>>          AFCtrl: FLR-
>>          AFStatus: TP-
>>      Kernel driver in use: ahci
>>
>> 00:1f.3 SMBus: Intel Corporation Panther Point SMBus Controller (rev 04)
>>      Subsystem: Dell Device 0572
>>      Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>      Interrupt: pin C routed to IRQ 10
>>      Region 0: Memory at c1615000 (64-bit, non-prefetchable) [size=256]
>>      Region 4: I/O ports at 4040 [size=32]
>>      Kernel modules: i2c-i801
>>
>> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI
>> Device 682f (prog-if 00 [VGA controller])
>>      Subsystem: Dell Device 0572
>>      Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Interrupt: pin A routed to IRQ 16
>>      Region 0: Memory at a0000000 (64-bit, prefetchable) [size=256M]
>>      Region 2: Memory at c0000000 (64-bit, non-prefetchable) [size=256K]
>>      Region 4: I/O ports at 3000 [size=256]
>>      Expansion ROM at c0040000 [disabled] [size=128K]
>>      Capabilities: [50] Power Management version 3
>>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0-,D1+,D2+,D3hot+,D3cold-)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
>>          DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1
>> unlimited
>>              ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>          DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>              RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>              MaxPayload 256 bytes, MaxReadReq 512 bytes
>>          DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
>> TransPend-
>>          LnkCap:    Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0
>> <64ns, L1 <1us
>>              ClockPM- Surprise- LLActRep- BwNot-
>>          LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>              ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>          LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive-
>> BWMgmt- ABWMgmt-
>>          DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>>          DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>>          LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
>> Selectable De-emphasis: -6dB
>>               Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>               Compliance De-emphasis: -6dB
>>          LnkSta2: Current De-emphasis Level: -3.5dB
>>      Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>>          Address: 00000000fee0f00c  Data: 4152
>>      Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
>> Len=010 <?>
>>      Capabilities: [150 v1] Advanced Error Reporting
>>          UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>          UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>          UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
>> MalfTLP+ ECRC- UnsupReq- ACSViol-
>>          CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>          CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>          AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>>      Kernel modules: radeon
>>
>> 07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B
>> PCI Express Gigabit Ethernet controller (rev 07)
>>      Subsystem: Dell Device 0572
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0, Cache Line Size: 64 bytes
>>      Interrupt: pin A routed to IRQ 43
>>      Region 0: I/O ports at 2000 [size=256]
>>      Region 2: Memory at c1404000 (64-bit, prefetchable) [size=4K]
>>      Region 4: Memory at c1400000 (64-bit, prefetchable) [size=16K]
>>      Capabilities: [40] Power Management version 3
>>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>          Address: 00000000fee0100c  Data: 41c1
>>      Capabilities: [70] Express (v2) Endpoint, MSI 01
>>          DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1
>> <64us
>>              ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>          DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>              RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>              MaxPayload 128 bytes, MaxReadReq 4096 bytes
>>          DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>          LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
>> unlimited, L1 <64us
>>              ClockPM+ Surprise- LLActRep- BwNot-
>>          LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
>> CommClk+
>>              ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>>          LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
>> BWMgmt- ABWMgmt-
>>          DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>>          DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>>          LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
>> Selectable De-emphasis: -6dB
>>               Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>               Compliance De-emphasis: -6dB
>>          LnkSta2: Current De-emphasis Level: -6dB
>>      Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
>>          Vector table: BAR=4 offset=00000000
>>          PBA: BAR=4 offset=00000800
>>      Capabilities: [d0] Vital Product Data
>>          No end tag found
>>      Capabilities: [100 v1] Advanced Error Reporting
>>          UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>          UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>          UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
>> MalfTLP+ ECRC- UnsupReq- ACSViol-
>>          CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>>          CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>          AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>>      Capabilities: [140 v1] Virtual Channel
>>          Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
>>          Arb:    Fixed- WRR32- WRR64- WRR128-
>>          Ctrl:    ArbSelect=Fixed
>>          Status:    InProgress-
>>          VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>              Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>              Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>              Status:    NegoPending- InProgress-
>>      Capabilities: [160 v1] Device Serial Number d7-05-00-00-68-4c-e0-00
>>      Kernel driver in use: r8169
>>      Kernel modules: r8169
>>
>> 08:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev
>> c4)
>>      Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN
>>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Latency: 0, Cache Line Size: 64 bytes
>>      Interrupt: pin A routed to IRQ 45
>>      Region 0: Memory at c1500000 (64-bit, non-prefetchable) [size=8K]
>>      Capabilities: [c8] Power Management version 3
>>          Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>      Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>          Address: 00000000fee0100c  Data: 41e1
>>      Capabilities: [e0] Express (v1) Endpoint, MSI 00
>>          DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1
>> unlimited
>>              ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>>          DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>              RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>>              MaxPayload 128 bytes, MaxReadReq 128 bytes
>>          DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>          LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
>> <4us, L1 <32us
>>              ClockPM+ Surprise- LLActRep- BwNot-
>>          LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>              ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>>          LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
>> BWMgmt- ABWMgmt-
>>      Capabilities: [100 v1] Advanced Error Reporting
>>          UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>          UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>          UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
>> MalfTLP+ ECRC- UnsupReq- ACSViol-
>>          CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>>          CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>          AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>>      Capabilities: [140 v1] Device Serial Number 68-5d-43-ff-ff-e7-99-5b
>>      Kernel driver in use: iwlwifi
>>      Kernel modules: iwlwifi
>>
>>
>> root@bobDell:/#
>> root@bobDell:/# # SCSI information:
>> root@bobDell:/# cat /proc/scsi/scsi
>> Attached devices:
>> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>>    Vendor: ATA      Model: WDC WD10JPVT-75A Rev: 01.0
>>    Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>>    Vendor: HL-DT-ST Model: DVD+-RW GT60N    Rev: A102
>>    Type:   CD-ROM                           ANSI  SCSI revision: 05
>> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>>    Vendor: Generic- Model: xD/SD/M.S.       Rev: 1.00
>>    Type:   Direct-Access                    ANSI  SCSI revision: 02
>>
>>
>> root@bobDell:/#
>> root@bobDell:/# # Other possibly relevant information:
>> root@bobDell:/# ls /proc
>> 1     1207  1392  2151  2294  2336  2440  2512  2689  30   44   65 754  975
>> diskstats    kmsg           sched_debug    version
>> 10    1210  1394  2154  2297  2340  2445  2518  27    31   45   651 782  986
>> dma          kpagecount     schedstat vmallocinfo
>> 1009  1228  1396  2188  2299  2353  2452  2526  2709  32   46   66 8    987
>> dri          kpageflags     scsi           vmstat
>> 1043  1230  14    2199  23    2354  2453  2529  2743  33   5    67 825  991
>> driver       latency_stats  self           zoneinfo
>> 1049  1234  15    22    2300  2362  2455  2535  2757  34   57   7 831  993
>> execdomains  loadavg        slabinfo
>> 1052  1242  1510  2228  2301  2364  2457  2536  2795  349  575  71 845  acpi
>> fb           locks          softirqs
>> 1056  1249  1568  2248  2302  2372  2465  2597  28    35   576  722 857
>> asound     filesystems  mdstat         stat
>> 1063  1253  16    2251  2303  2374  2473  26    2841  351  58   73 9
>> buddyinfo  fs           meminfo        swaps
>> 1068  1254  1681  2252  2307  2386  2476  2615  2842  36   598  730 905  bus
>> interrupts   misc           sys
>> 1073  1263  17    2257  2309  2388  2482  2617  2850  37   599  731 909
>> cgroups    iomem        modules        sysrq-trigger
>> 11    13    18    2270  2320  2390  2486  2619  2862  38   601  735 910
>> cmdline    ioports      mounts         sysvipc
>> 1190  1329  1831  2272  2322  2397  2493  262   2878  40   61   74 94
>> consoles   irq          mtrr           timer_list
>> 1197  1336  19    2279  2323  24    2498  2621  2883  41   62   745 95
>> cpuinfo    kallsyms     net            timer_stats
>> 12    1388  2     2282  2328  2403  2503  263   29    42   63   752 951
>> crypto     kcore        pagetypeinfo   tty
>> 1206  1390  21    2289  2331  2411  2504  2670  3     43   64   753 973
>> devices    key-users    partitions     uptime
>>
>>
>> root@bobDell:/#
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> (unrelated question: why all the shell prompts?)
>
> Thanks,
>

