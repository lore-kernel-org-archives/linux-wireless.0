Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64236 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2AUTLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 14:11:17 -0500
Received: by qcsf13 with SMTP id f13so894102qcs.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jan 2012 11:11:16 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 21 Jan 2012 20:11:16 +0100
Message-ID: <CA+XEK3kzPiHeqccfcR=ZF_5fKERoeC26uuMoPKXKoM=f2dZX3A@mail.gmail.com> (sfid-20120121_201122_113082_9EFC0190)
Subject: WEB problem with compat-wireless-2012-01-20
From: Thibaud Ecarot <thibaud.ecarot@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have a problem with compat-wireless-2012-01-20.tar.bz2. Since
yesterday, I can not connect to a wireless network WEP.

With compat-wireless-2012-01-18.tar.bz2 => WEP No problem
With compat-wireless-2012-01-20.tar.bz2 =>  WEP Problem and WPA2 NO PROBLEM

I am french. I hope you can help me.

Thanks ;)


[code]akrogames@akropc:~$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=11.04
DISTRIB_CODENAME=natty
DISTRIB_DESCRIPTION="Ubuntu 11.04"
[/code]

[code]akrogames@akropc:~$ lsusb
Bus 002 Device 004: ID 04f2:b1d8 Chicony Electronics Co., Ltd
Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
[/code]

[code]akrogames@akropc:~$ lspci
00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 18)
00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16
Root Port (rev 18)
00:16.0 Communication controller: Intel Corporation 5 Series/3400
Series Chipset HECI Controller (rev 06)
00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 05)
00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
High Definition Audio (rev 05)
00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 1 (rev 05)
00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 2 (rev 05)
00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 05)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
Interface Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series
Chipset 4 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus
Controller (rev 05)
00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400
Series Chipset Thermal Subsystem (rev 05)
02:00.0 VGA compatible controller: ATI Technologies Inc Redwood
[Radeon HD 5600 Series]
02:00.1 Audio device: ATI Technologies Inc Redwood HDMI Audio [Radeon
HD 5600 Series]
03:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57780
Gigabit Ethernet PCIe (rev 01)
05:00.0 Network controller: Atheros Communications Inc. AR9287
Wireless Network Adapter (PCI-Express) (rev 01)
ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath
Architecture Generic Non-core Registers (rev 05)
ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath
Architecture System Address Decoder (rev 05)
ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 05)
ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
[/code]

[code]akrogames@akropc:~$ lspci -nn |grep -i net
03:00.0 Ethernet controller [0200]: Broadcom Corporation NetLink
BCM57780 Gigabit Ethernet PCIe [14e4:1692] (rev 01)
05:00.0 Network controller [0280]: Atheros Communications Inc. AR9287
Wireless Network Adapter (PCI-Express) [168c:002e] (rev 01)
[/code]

[code]akrogames@akropc:~$ sudo lshw -C network
[sudo] password for akrogames:
  *-network
       description: Ethernet interface
       product: NetLink BCM57780 Gigabit Ethernet PCIe
       vendor: Broadcom Corporation
       physical id: 0
       bus info: pci@0000:03:00.0
       logical name: eth0
       version: 01
       serial: 20:6a:8a:17:7e:af
       size: 10Mbit/s
       capacity: 1Gbit/s
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress bus_master cap_list ethernet
physical tp mii 10bt 10bt-fd 100bt 100bt-fd 1000bt 1000bt-fd
autonegotiation
       configuration: autonegotiation=on broadcast=yes driver=tg3
driverversion=3.116 duplex=half firmware=sb latency=0 link=no
multicast=yes port=MII speed=10Mbit/s
       resources: irq:44 memory:f0200000-f020ffff
  *-network
       description: Wireless interface
       product: AR9287 Wireless Network Adapter (PCI-Express)
       vendor: Atheros Communications Inc.
       physical id: 0
       bus info: pci@0000:05:00.0
       logical name: wlan0
       version: 01
       serial: 20:7c:8f:47:11:8c
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress bus_master cap_list ethernet
physical wireless
       configuration: broadcast=yes driver=ath9k
driverversion=2.6.38-13-generic firmware=N/A latency=0 link=no
multicast=yes wireless=IEEE 802.11bgn
       resources: irq:17 memory:f0300000-f030ffff
[/code]

[code]akrogames@akropc:~$ lsmod
Module                  Size  Used by
binfmt_misc            17565  1
parport_pc             36959  0
ppdev                  17113  0
vesafb                 13761  1
snd_hda_codec_hdmi     28167  1
joydev                 17606  0
snd_hda_codec_realtek   336771  1
arc4                   12529  2
snd_hda_intel          33176  2
ath9k                 129702  0
snd_hda_codec         103804  3
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep              13604  1 snd_hda_codec
snd_pcm                96391  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
mac80211              506394  1 ath9k
snd_seq_midi           13324  0
snd_rawmidi            30486  1 snd_seq_midi
compat                 16032  1 mac80211
snd_seq_midi_event     14899  1 snd_seq_midi
ath9k_common           14052  1 ath9k
snd_seq                61621  2 snd_seq_midi,snd_seq_midi_event
ath9k_hw              408513  2 ath9k,ath9k_common
uvcvideo               72195  0
ath                    23822  3 ath9k,ath9k_common,ath9k_hw
videodev               82052  1 uvcvideo
sparse_keymap          13898  0
snd_timer              29602  2 snd_pcm,snd_seq
snd_seq_device         14462  3 snd_seq_midi,snd_rawmidi,snd_seq
fglrx                2739144  66
v4l2_compat_ioctl32    17078  1 videodev
snd                    67382  14
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
psmouse                73535  0
serio_raw              13166  0
intel_ips              18097  0
cfg80211              203992  3 ath9k,mac80211,ath
soundcore              12680  1 snd
snd_page_alloc         18529  2 snd_hda_intel,snd_pcm
video                  19438  0
lp                     17825  0
parport                46458  3 parport_pc,ppdev,lp
usbhid                 46956  0
hid                    91020  1 usbhid
tg3                   141750  0
ahci                   25951  3
libahci                26642  1 ahci
[/code]

[code]akrogames@akropc:~$ iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     IEEE 802.11bgn  ESSID:off/any
          Mode:Managed  Frequency:2.422 GHz  Access Point: Not-Associated
          Tx-Power=13 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on

[/code]

[code]akrogames@akropc:~$ ifconfig
eth0      Link encap:Ethernet  HWaddr 20:6a:8a:17:7e:af
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          Packets reçus:0 erreurs:0 :0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:1000
          Octets reçus:0 (0.0 B) Octets transmis:0 (0.0 B)
          Interruption:16

lo        Link encap:Boucle locale
          inet adr:127.0.0.1  Masque:255.0.0.0
          adr inet6: ::1/128 Scope:Hôte
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          Packets reçus:642 erreurs:0 :0 overruns:0 frame:0
          TX packets:642 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:0
          Octets reçus:72393 (72.3 KB) Octets transmis:72393 (72.3 KB)

wlan0     Link encap:Ethernet  HWaddr 20:7c:8f:47:11:8c
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          Packets reçus:659 erreurs:0 :24 overruns:0 frame:0
          TX packets:51 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:1000
          Octets reçus:188946 (188.9 KB) Octets transmis:16537 (16.5 KB)
[/code]

[code]akrogames@akropc:~$ sudo iwlist scan
lo        Interface doesn't support scanning.

eth0      Interface doesn't support scanning.

wlan0     Scan completed :
          Cell 01 - Address: AA:23:61:45:4B:2C
                    Channel:3
                    Frequency:2.422 GHz (Channel 3)
                    Quality=70/70  Signal level=-31 dBm
                    Encryption key:on
                    ESSID:"freebox_GWGSBM"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
                              18 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=00000000a7f99139
                    Extra: Last beacon: 770ms ago
                    IE: Unknown: 000E66726565626F785F47574753424D
                    IE: Unknown: 010882848B961224486C
                    IE: Unknown: 030103
                    IE: Unknown: 2A0104
                    IE: Unknown: 32040C183060
                    IE: Unknown:
2D1A6E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
3D1603050700000000000000000000000000000000000000
                    IE: Unknown: 3E0100
                    IE: Unknown:
DD180050F2020101000003A4000027A4000042435E0062322F00
                    IE: Unknown: 7F0101
                    IE: Unknown: DD07000C4300000000
                    IE: Unknown:
DD1E00904C336E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
DD1A00904C3403050700000000000000000000000000000000000000
          Cell 02 - Address: AA:23:61:45:4B:2D
                    Channel:3
                    Frequency:2.422 GHz (Channel 3)
                    Quality=70/70  Signal level=-40 dBm
                    Encryption key:on
                    ESSID:""
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
                              18 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=00000000a7fb2a35
                    Extra: Last beacon: 660ms ago
                    IE: Unknown: 0000
                    IE: Unknown: 010882848B961224486C
                    IE: Unknown: 030103
                    IE: Unknown: 32040C183060
                    IE: Unknown: 33082001020304050607
                    IE: Unknown: 33082105060708090A0B
                    IE: Unknown: 050400010000
                    IE: Unknown: 2A0104
                    IE: Unknown:
2D1A6E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
3D1603050700000000000000000000000000000000000000
                    IE: Unknown: 7F0101
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown:
DD180050F2020101000003A4000027A4000042435E0062322F00
                    IE: Unknown: 0B0501004A127A
                    IE: Unknown:
DD1E00904C336E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
DD1A00904C3403050700000000000000000000000000000000000000
                    IE: Unknown: DD07000C4300000000
          Cell 03 - Address: AA:23:61:45:4B:2E
                    Channel:3
                    Frequency:2.422 GHz (Channel 3)
                    Quality=44/70  Signal level=-66 dBm
                    Encryption key:on
                    ESSID:""
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
                              18 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=00000000a7fcc36e
                    Extra: Last beacon: 560ms ago
                    IE: Unknown: 0000
                    IE: Unknown: 010882848B961224486C
                    IE: Unknown: 030103
                    IE: Unknown: 32040C183060
                    IE: Unknown: 33082001020304050607
                    IE: Unknown: 33082105060708090A0B
                    IE: Unknown: 050400010000
                    IE: Unknown: 2A0104
                    IE: Unknown:
2D1A6E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
3D1603050700000000000000000000000000000000000000
                    IE: Unknown: 7F0101
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown:
DD180050F2020101000003A4000027A4000042435E0062322F00
                    IE: Unknown: 0B0501004A127A
                    IE: Unknown:
DD1E00904C336E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
DD1A00904C3403050700000000000000000000000000000000000000
                    IE: Unknown: DD07000C4300000000
          Cell 04 - Address: AA:23:61:45:4B:2F
                    Channel:3
                    Frequency:2.422 GHz (Channel 3)
                    Quality=70/70  Signal level=-40 dBm
                    Encryption key:on
                    ESSID:""
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
                              18 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=00000000a7fb3ca8
                    Extra: Last beacon: 660ms ago
                    IE: Unknown: 0000
                    IE: Unknown: 010882848B961224486C
                    IE: Unknown: 030103
                    IE: Unknown: 32040C183060
                    IE: Unknown: 33082001020304050607
                    IE: Unknown: 33082105060708090A0B
                    IE: Unknown: 050400010000
                    IE: Unknown: 2A0104
                    IE: Unknown:
2D1A6E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
3D1603050700000000000000000000000000000000000000
                    IE: Unknown: 7F0101
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown:
DD180050F2020101000003A4000027A4000042435E0062322F00
                    IE: Unknown: 0B0501004A127A
                    IE: Unknown:
DD1E00904C336E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown:
DD1A00904C3403050700000000000000000000000000000000000000
                    IE: Unknown: DD07000C4300000000
          Cell 05 - Address: 00:1D:6A:69:E5:FF
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=37/70  Signal level=-73 dBm
                    Encryption key:on
                    ESSID:"Livebox-4636"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=00000220f2257180
                    Extra: Last beacon: 640ms ago
                    IE: Unknown: 000C4C697665626F782D34363336
                    IE: Unknown: 010882848B960C121824
                    IE: Unknown: 030106
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 2A0100
                    IE: Unknown: 32043048606C
                    IE: Unknown:
DD180050F2020101820003A4000027A4000042435E0062322F00
                    IE: Unknown:
2D1A4C101BFFFF000000000000000000000000000000000000000000
                    IE: Unknown:
3D1606080800000000000000000000000000000000000000
                    IE: Unknown: DD0900037F01010000FF7F
                    IE: Unknown: DD0A00037F04010001000000
                    IE: Unknown: 0706465220010D14
                    IE: Unknown:
DD880050F204104A000110104400010210570001001041000100103B00010310470010002348BB4636002348BB463648BB463610210005536167656D102300084C697665626F7832102400084C697665626F78321042000A4C4B30393330344450321054000800060050F20400011011000D4C697665626F78322D34363336100800020086103C000101
          Cell 06 - Address: 00:24:D4:99:74:81
                    Channel:12
                    Frequency:2.467 GHz (Channel 12)
                    Quality=40/70  Signal level=-70 dBm
                    Encryption key:off
                    ESSID:"FreeWifi"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=00000000c6a77960
                    Extra: Last beacon: 270ms ago
                    IE: Unknown: 00084672656557696669
                    IE: Unknown: 010882848B960C121824
                    IE: Unknown: 03010C
                    IE: Unknown: 050400020000
                    IE: Unknown: 2A0104
                    IE: Unknown: 32043048606C
                    IE: Unknown:
2D1A6C0003FFFFFF0001000000000000000100000000000000000000
                    IE: Unknown:
3D160C000000000000000000000000000000000000000000
                    IE: Unknown:
DD180050F2020101000003A4000027A4000042435E0062322F00
          Cell 07 - Address: 00:24:D4:99:74:80
                    Channel:12
                    Frequency:2.467 GHz (Channel 12)
                    Quality=31/70  Signal level=-79 dBm
                    Encryption key:on
                    ESSID:"Freebox-A08DC7"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=00000000c6a84160
                    Extra: Last beacon: 220ms ago
                    IE: Unknown: 000E46726565626F782D413038444337
                    IE: Unknown: 010882848B960C121824
                    IE: Unknown: 03010C
                    IE: Unknown: 050401020000
                    IE: Unknown: 2A0104
                    IE: Unknown: 32043048606C
                    IE: WPA Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown:
2D1A6C0003FFFFFF0001000000000000000100000000000000000000
                    IE: Unknown:
3D160C000700000000000000000000000000000000000000
                    IE: Unknown:
DD180050F2020101000003A4000027A4000042435E0062322F00
[/code]

[code]akrogames@akropc:~$ uname -r -m
2.6.38-13-generic x86_64
akrogames@akropc:~$ cat /etc/network/interfaces
auto lo
iface lo inet loopback
[/code]

[code]akrogames@akropc:~$ nm-tool

NetworkManager Tool

State: disconnected

- Device: eth0 -----------------------------------------------------------------
  Type:              Wired
  Driver:            tg3
  State:             unavailable
  Default:           no
  HW Address:        20:6A:8A:17:7E:AF

  Capabilities:
    Carrier Detect:  yes
    Speed:           10 Mb/s

  Wired Properties
    Carrier:         off


- Device: wlan0 ----------------------------------------------------------------
  Type:              802.11 WiFi
  Driver:            ath9k
  State:             disconnected
  Default:           no
  HW Address:        20:7C:8F:47:11:8C

  Capabilities:

  Wireless Properties
    WEP Encryption:  yes
    WPA Encryption:  yes
    WPA2 Encryption: yes

  Wireless Access Points
    FreeWifi:        Infra, 00:24:D4:99:74:81, Freq 2467 MHz, Rate 54
Mb/s, Strength 57
    Livebox-4636:    Infra, 00:1D:6A:69:E5:FF, Freq 2437 MHz, Rate 54
Mb/s, Strength 51 WPA WPA2
    Freebox-A08DC7:  Infra, 00:24:D4:99:74:80, Freq 2467 MHz, Rate 54
Mb/s, Strength 51 WPA
    FreeWifi:        Infra, 46:96:6C:9D:CE:0A, Freq 2412 MHz, Rate 54
Mb/s, Strength 57
    freebox:         Infra, 46:96:6C:9D:CE:08, Freq 2412 MHz, Rate 54
Mb/s, Strength 44 WEP
    freebox_GWGSBM:  Infra, AA:23:61:45:4B:2C, Freq 2422 MHz, Rate 54
Mb/s, Strength 100 WEP
    freephonie:      Infra, 46:96:6C:9D:CE:0B, Freq 2412 MHz, Rate 54
Mb/s, Strength 58 WPA Enterprise
[/code]

[code]akrogames@akropc:~$ sudo rfkill list
0: phy0: Wireless LAN
    Soft blocked: no
    Hard blocked: no
[/code]

-- 
-----------------------------------------------------------
Thibaud ECAROT
Cl� publique

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Public Key Server -- Get ``0x4f7ae89312064d51 ''

http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4F7AE89312064D51

-----END PGP SIGNATURE-----
