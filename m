Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:61233 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYEJOjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 10:39:44 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K0N007GNQ1TJ6I0@mta5.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sat, 10 May 2008 10:39:30 -0400 (EDT)
Date: Sat, 10 May 2008 10:39:27 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -	2.6.26-rc1
 kernel
In-reply-to: <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <1210430367.3778.9.camel@X61.NetworkingUnlimited.com> (sfid-20080510_163948_876272_CF18D468)
MIME-version: 1.0
Content-type: text/plain
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2008-05-10 at 03:12 +0300, Tomas Winkler wrote:
> On Sat, May 10, 2008 at 2:41 AM, Vincent C Jones
> <v.jones@networkingunlimited.com> wrote:
> >
> > On Sat, 2008-05-10 at 00:23 +0300, Tomas Winkler wrote:
> >> On Fri, May 9, 2008 at 7:57 PM, Vincent C Jones
> >> <v.jones@networkingunlimited.com> wrote:
> >> > The channel/frequency reporting by iwlwifi is incompatible with
> >> >  wpa_supplicant for 5GHz (802.11A) channels. Version numbers and iwlist
> >> >  versus wpa_supplicant scan results are below. Association still works if
> >> >  the correct channel is specified using iwconfig, but that is
> >> >  incompatible with roaming.
> >>
> >> Fixed by the patch ' iwlwifi: Fix frequency in rx_status fill'
> >>
> >> Thanks
> >> Tomas
> >
> > This patch did not apply cleanly to plain 2.6.26-rc1: off by -4 lines in
> > iwl-3945.c and by 1078 lines in iwl-4965.c. More important, it did not
> > fix the problem of wpa_supplicant thinking the 802.11A access points are
> > on channel 0. Same results with 2.6.26-rc1-git7, with & without patch.
> > Any idea when this patch (and the patches it appears to depend on) will
> > make it into the 2.6.26 release?
> >
> 
> This patch is against wireless-testing.git, it's just too lines and
> doesn't really have logical dependencies on other patches so I didn't
> create a separate patch for 2.6.26...It looks maybe I should.
> Can you  try to eproduce your problem on wireless-testing kernel with
> this patch?
> Also some logs will be useful
> 
> Thanks
> Tomas

Tomas,

No joy. Did I git the wrong tree?

(git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git)

Still had to apply your patch (offset 223 lines this time). Also applied
the media/built-in.o patch so my config would compile. Wpa_supplicant
(v0.6.3) still reports 0 for the channel of 11A stations:

> scan_res
bssid / frequency / signal level / flags / ssid
00:1a:c1:8a:23:40       0       208     [WPA-PSK-TKIP
+CCMP][WPA2-PSK-TKIP+CCMP-preauth] NetworkingUnlimited
00:1e:2a:6c:93:d9       2462    169     [WPA-PSK-TKIP
+CCMP][WPA2-PSK-TKIP+CCMP]NetworkingUnlimited-G
> 

I've appended output of iwlist scan and dmesg. Any other logs of
interest?


          Cell 05 - Address: 00:1A:C1:8A:23:40
                    ESSID:"NetworkingUnlimited"
                    Mode:Master
                    Frequency:5.24 GHz (Channel 48)
                    Channel:48
                    Quality=95/100  Signal level=-56 dBm  Noise
level=-94 dBm
                    Encryption key:on
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : TKIP CCMP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : TKIP CCMP
                        Authentication Suites (1) : PSK
                       Preauthentication Supported
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Extra:tsf=000000eefc735037



Abridged dmesg:
Linux version 2.6.26-rc1-wl-test (vcjones@X61) (gcc version 4.2.1 (SUSE
Linux)) #2 SMP Sat May 10 10:12:36 EDT 2008
Command line: root=/dev/disk/by-id/scsi-SATA_ST9160824AS_5MA6SYPF-part6
vga=0x317 resume=/dev/sda7 splash=silent PROFILE=NUI_HQ
 . . .
thinkpad_acpi: ThinkPad ACPI Extras v0.20
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7NETB1WW (2.11 ), EC 7MHT25WW-1.03
thinkpad_acpi: Lenovo ThinkPad X61, model 7675CTO
thinkpad_acpi: radio switch found; radios are enabled
 . . .
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
input: ThinkPad Extra Buttons as /class/input/input5
agpgart: AGP aperture is 256M @ 0xe0000000
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26ks
iwl4965: Copyright(c) 2003-2008 Intel Corporation
eth0: (PCI Express:2.5GB/s:Width x1) 00:16:d3:c4:11:e5
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
ICH8M: not 100% native mode: will probe irqs later
ICH8M: IDE port disabled
    ide0: BM-DMA at 0x18e0-0x18e7
Probing IDE interface ide0...
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0016d3ffffc411e5]
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-4965-rs'
ACPI: PCI interrupt for device 0000:03:00.0 disabled
input: 4965AGN as /class/input/input6
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
thinkpad_ec: thinkpad_ec 0.37 loaded.
tp_smapi 0.37 loading...
tp_smapi successfully loaded (smapi_port=0xb2).
Adding 5246600k swap on /dev/sda7.  Priority:-1 extents:1
across:5246600k
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:
dm-devel@redhat.com
loop: module loaded
fuse init (API version 7.9)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sda8: found reiserfs format "3.6" with standard journal
ReiserFS: sda8: using ordered data mode
ReiserFS: sda8: journal params: device sda8, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda8: checking transaction log (sda8)
ReiserFS: sda8: Using r5 hash to sort names
firmware: requesting intel-ucode/06-0f-0b
firmware: requesting intel-ucode/06-0f-0b
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
40100102, writing 40100106)
firmware: requesting iwlwifi-4965-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
NET: Registered protocol family 17
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
mtrr: type mismatch for e0000000,10000000 old: write-back new:
write-combining
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
input: /usr/sbin/acpi-keys as /class/input/input7
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
<end of dmesg at boot time>

>>>> issue command "iwconfig wlan0 chan 48"

wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:c1:8a:23:40
wlan0: RX authentication from 00:1a:c1:8a:23:40 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:1a:c1:8a:23:40
wlan0: RX AssocResp from 00:1a:c1:8a:23:40 (capab=0x11 status=0 aid=1)
wlan0: associated


 
