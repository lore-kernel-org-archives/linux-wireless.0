Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:32889 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbcB1BGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2016 20:06:36 -0500
Received: by mail-yw0-f179.google.com with SMTP id u200so96692156ywf.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2016 17:06:35 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 28 Feb 2016 03:06:35 +0200
Message-ID: <CAG4k0fCqB1KNLyHV5--pi1nSoDPnV3qM-yTB0T2jmgbnjmqvww@mail.gmail.com> (sfid-20160228_020648_603350_302A7DBC)
Subject: carl1970: stops working at random periods on Ubuntu 15.05
From: alexander nekrasov <i.sinister@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using TP-LINK TL-WN821N and encountering very annoying behaviour -
adapter 'hangs' at random period of time - sometimes it is 1 hour,
sometimes 2. After it hangs Network manager does not see any wireless
networks and the only way to make it work is to reboot system (also
tried unplugging/plugging adapter and removing/adding module but it
did not work)

Heres lsusb -v:
Bus 004 Device 004: ID 0cf3:1002 Atheros Communications, Inc. TP-Link
TL-WN821N v2 / TL-WN822N v1 802.11n [Atheros AR9170]

And here what i have in syslog right before the hang:
Feb 28 01:23:45 evren kernel: [ 3590.458890] ------------[ cut here
]------------
Feb 28 01:23:45 evren kernel: [ 3590.458919] WARNING: CPU: 0 PID: 3749
at /build/linux-PoTihC/linux-4.2.0/drivers/net/wireless/ath/carl9170/main.c:1012
carl9170_op_configure_filter+0x191/0x1a0 [carl9170]()
Feb 28 01:23:45 evren kernel: [ 3590.458925] Modules linked in: drbg
ansi_cprng ctr ccm binfmt_misc fglrx(POE) arc4 snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_codec_hdmi carl9170 snd_hda_intel
snd_hda_codec snd_hda_core ath mac80211 snd_hwdep snd_pcm snd_seq_midi
snd_seq_midi_event cfg80211 kvm_amd kvm snd_rawmidi snd_seq input_leds
joydev snd_seq_device snd_timer edac_core serio_raw edac_mce_amd snd
soundcore k10temp asus_atk0110 amd_iommu_v2 8250_fintek i2c_piix4
shpchp mac_hid cuse parport_pc ppdev lp parport autofs4 pata_acpi
hid_generic usbhid hid r8169 psmouse pata_jmicron firewire_ohci mii
firewire_core pata_atiixp crc_itu_t ahci libahci wmi
Feb 28 01:23:45 evren kernel: [ 3590.459018] CPU: 0 PID: 3749 Comm:
kworker/u16:0 Tainted: P        W  OE   4.2.0-30-generic #36-Ubuntu
Feb 28 01:23:45 evren kernel: [ 3590.459024] Hardware name: System
manufacturer System Product Name/M4A89GTD-PRO/USB3, BIOS 3029
07/05/2012
Feb 28 01:23:45 evren kernel: [ 3590.459063] Workqueue: phy1
ieee80211_reconfig_filter [mac80211]
Feb 28 01:23:45 evren kernel: [ 3590.459068]  0000000000000000
00000000d9cf9215 ffff8800b240fce8 ffffffff817ebf13
Feb 28 01:23:45 evren kernel: [ 3590.459075]  0000000000000000
0000000000000000 ffff8800b240fd28 ffffffff8107b9d6
Feb 28 01:23:45 evren kernel: [ 3590.459082]  8000000000000001
ffff8800c88b5440 ffff8800b240fdac 8000000000000001
Feb 28 01:23:45 evren kernel: [ 3590.459089] Call Trace:
Feb 28 01:23:45 evren kernel: [ 3590.459102]  [<ffffffff817ebf13>]
dump_stack+0x45/0x57
Feb 28 01:23:45 evren kernel: [ 3590.459112]  [<ffffffff8107b9d6>]
warn_slowpath_common+0x86/0xc0
Feb 28 01:23:45 evren kernel: [ 3590.459120]  [<ffffffff8107bb0a>]
warn_slowpath_null+0x1a/0x20
Feb 28 01:23:45 evren kernel: [ 3590.459130]  [<ffffffffc0426c71>]
carl9170_op_configure_filter+0x191/0x1a0 [carl9170]
Feb 28 01:23:45 evren kernel: [ 3590.459163]  [<ffffffffc0373939>]
ieee80211_configure_filter+0x149/0x2a0 [mac80211]
Feb 28 01:23:45 evren kernel: [ 3590.459196]  [<ffffffffc0373aa5>]
ieee80211_reconfig_filter+0x15/0x20 [mac80211]
Feb 28 01:23:45 evren kernel: [ 3590.459205]  [<ffffffff810947aa>]
process_one_work+0x1aa/0x440
Feb 28 01:23:45 evren kernel: [ 3590.459213]  [<ffffffff81094a8b>]
worker_thread+0x4b/0x4c0
Feb 28 01:23:45 evren kernel: [ 3590.459221]  [<ffffffff81094a40>] ?
process_one_work+0x440/0x440
Feb 28 01:23:45 evren kernel: [ 3590.459228]  [<ffffffff8109ae28>]
kthread+0xd8/0xf0
Feb 28 01:23:45 evren kernel: [ 3590.459236]  [<ffffffff8109ad50>] ?
kthread_create_on_node+0x1f0/0x1f0
Feb 28 01:23:45 evren kernel: [ 3590.459243]  [<ffffffff817f319f>]
ret_from_fork+0x3f/0x70
Feb 28 01:23:45 evren kernel: [ 3590.459249]  [<ffffffff8109ad50>] ?
kthread_create_on_node+0x1f0/0x1f0
Feb 28 01:23:45 evren kernel: [ 3590.459255] ---[ end trace
fe0c60ee5cb8db9a ]---
Feb 28 01:23:46 evren kernel: [ 3591.459129] ------------[ cut here
]------------

Following messages are also relevant to adapter failure but i guess it
will be to long to post it here.

Also after unplugging/pluggin i see following:
Feb 28 01:46:44 evren kernel: [ 4970.256337] usb 4-1.4: USB
disconnect, device number 13
Feb 28 01:46:52 evren kernel: [ 4977.878803] usb 4-1.4: new high-speed
USB device number 14 using ehci-pci
Feb 28 01:46:52 evren kernel: [ 4978.023152] usb 4-1.4: New USB device
found, idVendor=0cf3, idProduct=1002
Feb 28 01:46:52 evren kernel: [ 4978.023166] usb 4-1.4: New USB device
strings: Mfr=16, Product=32, SerialNumber=48
Feb 28 01:46:52 evren kernel: [ 4978.023173] usb 4-1.4: Product: USB2.0 WLAN
Feb 28 01:46:52 evren kernel: [ 4978.023179] usb 4-1.4: Manufacturer: ATHER
Feb 28 01:46:52 evren kernel: [ 4978.023185] usb 4-1.4: SerialNumber: 12345
Feb 28 01:46:52 evren kernel: [ 4978.098854] usb 4-1.4: reset
high-speed USB device number 14 using ehci-pci
Feb 28 01:46:52 evren kernel: [ 4978.232174] usb 4-1.4: driver   API:
1.9.7 2012-12-15 [1-1]
Feb 28 01:46:52 evren kernel: [ 4978.232187] usb 4-1.4: firmware API:
1.9.6 2012-07-07
Feb 28 01:46:52 evren kernel: [ 4978.569953] ath: EEPROM regdomain: 0x809c
Feb 28 01:46:52 evren kernel: [ 4978.569962] ath: EEPROM indicates we
should expect a country code
Feb 28 01:46:52 evren kernel: [ 4978.569967] ath: doing EEPROM
country->regdmn map search
Feb 28 01:46:52 evren kernel: [ 4978.569971] ath: country maps to
regdmn code: 0x52
Feb 28 01:46:52 evren kernel: [ 4978.569975] ath: Country alpha2 being used: CN
Feb 28 01:46:52 evren kernel: [ 4978.569980] ath: Regpair used: 0x52
Feb 28 01:46:52 evren kernel: [ 4978.570407] ieee80211 phy1: Selected
rate control algorithm 'minstrel_ht'
Feb 28 01:46:25 evren wpa_supplicant[835]: message repeated 3 times: [
wlan0: CTRL-EVENT-SCAN-FAILED ret=-19 retry=1]
Feb 28 01:46:52 evren NetworkManager[691]: <info>  (wlan0): using
nl80211 for WiFi device control
Feb 28 01:46:52 evren NetworkManager[691]: <info>  (wlan0): driver
supports Access Point (AP) mode
Feb 28 01:46:52 evren kernel: [ 4978.576459] input: phy1 WPS Button as
/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4/4-1.4:1.0/ieee80211/phy1/input31
Feb 28 01:46:52 evren NetworkManager[691]: <info>  rfkill8: found WiFi
radio killswitch (at
/sys/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4/4-1.4:1.0/ieee80211/phy1/rfkill8)
(driver carl9170)
Feb 28 01:46:52 evren systemd[1]: Starting Load/Save RF Kill Switch
Status of rfkill8...
Feb 28 01:46:52 evren systemd[1]: Started Load/Save RF Kill Switch
Status of rfkill8.
Feb 28 01:46:53 evren kernel: [ 4978.752536] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Feb 28 01:46:53 evren kernel: [ 4978.753087] usb 4-1.4: no command
feedback received (-90).
Feb 28 01:46:53 evren kernel: [ 4978.753098] usb 4-1.4: restart device (6)
Feb 28 01:46:53 evren NetworkManager[691]: <info>  devices added
(path: /sys/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4/4-1.4:1.0/net/wlan0,
iface: wlan0)
Feb 28 01:46:53 evren NetworkManager[691]: <info>  device added (path:
/sys/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4/4-1.4:1.0/net/wlan0,
iface: wlan0): no ifupdown configuration found.
Feb 28 01:46:53 evren wpa_supplicant[835]: wlan0:
CTRL-EVENT-REGDOM-CHANGE init=DRIVER type=COUNTRY alpha2=CN
Feb 28 01:46:53 evren NetworkManager[691]: <info>  (wlan0): supplicant
interface state: disabled -> inactive
Feb 28 01:46:54 evren kernel: [ 4979.891093] usb 4-1.4: device
restarted successfully.
Feb 28 01:46:54 evren kernel: [ 4979.899273] ieee80211 phy1: Hardware
restart was requested
Feb 28 01:46:54 evren avahi-daemon[681]: Withdrawing workstation
service for wlan0.
Feb 28 01:46:54 evren ModemManager[642]: <info>  (net/wlan0): released
by modem /sys/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4
Feb 28 01:46:54 evren NetworkManager[691]: <info>  devices removed
(path: /sys/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4/4-1.4:1.0/net/wlan0,
iface: wlan0)
Feb 28 01:46:54 evren NetworkManager[691]: <info>  radio killswitch
/sys/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4/4-1.4:1.0/ieee80211/phy1/rfkill8
disappeared
Feb 28 01:46:54 evren systemd[1]: Stopping Load/Save RF Kill Switch
Status of rfkill8...
Feb 28 01:46:54 evren NetworkManager[691]: <info>  (wlan0): supplicant
interface state: inactive -> disabled
Feb 28 01:46:54 evren systemd[1]: Stopped Load/Save RF Kill Switch
Status of rfkill8.
Feb 28 01:46:55 evren ModemManager[642]: <info>  Couldn't find support
for device at '/sys/devices/pci0000:00/0000:00:13.2/usb4/4-1/4-1.4':
not supported by any plugin

Cab smb help me to solve this issue?
