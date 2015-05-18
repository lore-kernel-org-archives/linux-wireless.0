Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35878 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbbERADh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 20:03:37 -0400
Received: by wizk4 with SMTP id k4so58503793wiz.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 17:03:36 -0700 (PDT)
Message-ID: <55592C54.6010204@gmail.com> (sfid-20150518_020342_184098_2FD44609)
Date: Mon, 18 May 2015 02:03:32 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrdWIgS2ljacWEc2tp?= <moorray3@wp.pl>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org>	<20141027152026.GB19976@tuxdriver.com>	<544E8CB4.3000607@rempel-privat.de>	<20141028134608.GA26283@tuxdriver.com>	<544FA303.5060303@broadcom.com>	<544FA627.3000004@rempel-privat.de>	<5450BEB2.60208@openwrt.org>	<5461F937.9060004@rempel-privat.de>	<5463CB6C.3030204@openwrt.org>	<5463D28F.9080106@lwfinger.net>	<20150206182915.7467bac7@north>	<54EF261E.4040109@gmail.com> <20150226154028.380b96f2@north>
In-Reply-To: <20150226154028.380b96f2@north>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Preliminary test results

- lsusb -d 148f:7601:
Bus 001 Device 007: ID 148f:7601 Ralink Technology, Corp. MT7601U Wireless Adapter


- https://github.com/kuba-moo/mt7601u
- git log -1:
commit ad5474ecd9fd6efd4a7f03f4a8c71ea4bb57ca73
Author: Jakub Kicinski <kubakici@wp.pl>
Date:   Wed May 6 20:44:18 2015 +0200

    make sure .disconnect() doesn't cleanup the device if .resume() failed
    
    Signed-off-by: Jakub Kicinski <kubakici@wp.pl>


- modinfo mt7601u:
filename:       /lib/modules/4.0.3-202.fc21.x86_64/updates/mt7601u.ko
license:        GPL
firmware:       mt7601u.bin
alias:          usb:v7392p7710d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2A5Fp1000d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2955p1001d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2955p0001d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2717p4106d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2001p3D04d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v148Fp760Dd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v148Fp760Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v148Fp760Bd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v148Fp760Ad*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v148Fp7601d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v13D3p3434d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v13D3p3431d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0E8Dp760Bd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0E8Dp760Ad*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0B05p17D3d*dc*dsc*dp*ic*isc*ip*in*
depends:        cfg80211,mac80211
vermagic:       4.0.3-202.fc21.x86_64 SMP mod_unload 
signer:         Fedora kernel signing key
sig_key:        95:7D:C8:E5:9F:5D:E6:03:71:49:1A:D0:9A:C6:8F:85:16:6C:B3:94
sig_hashalgo:   sha256


- md5sum /lib/firmware/mt7601u.bin:
696cedb8e76ecc0cda9f9b0d3972c64d  /lib/firmware/mt7601u.bin


- NetworkManager --version:
1.0.2-2.fc21


plug in device:
- dmesg:
usb 1-4: new high-speed USB device number 6 using ehci-pci
usb 1-4: New USB device found, idVendor=148f, idProduct=7601
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: 802.11 n WLAN
usb 1-4: Manufacturer: MediaTek
usb 1-4: SerialNumber: 1.0
cfg80211: ...
...
usb 1-4: reset high-speed USB device number 6 using ehci-pci
mt7601u 1-4:1.0: ASIC revision: 76010001 MAC revision: 76010500
mt7601u 1-4:1.0: Firmware Version: 0.1.00 Build: 7640 Build time: 201302052146____
mt7601u 1-4:1.0: Warning: unsupported EEPROM version 0d
mt7601u 1-4:1.0: EEPROM ver:0d fae:00
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
usbcore: registered new interface driver mt7601u
mt7601u 1-4:1.0 wlp0s2f1u4: renamed from wlan0
...
cfg80211: ...
...
wlp0s2f1u4: authenticate with <BSSID>
wlp0s2f1u4: send auth to <BSSID> (try 1/3)
wlp0s2f1u4: authenticated
wlp0s2f1u4: associate with <BSSID> (try 1/3)
wlp0s2f1u4: RX AssocResp from <BSSID> (capab=0x411 status=0 aid=1)
wlp0s2f1u4: associated


- iwconfig wlp0s2f1u4:
wlp0s2f1u4  IEEE 802.11bgn  ESSID:"AP"  
          Mode:Managed  Frequency:2.422 GHz  Access Point: <BSSID>   
          Bit Rate=135 Mb/s   Tx-Power=20 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=67/70  Signal level=-43 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:873   Missed beacon:0


 == suspend to ram test ==

while connected:
- systemctl suspend
- dmesg:
wlp0s2f1u4: deauthenticating from <BSSID> by local choice (Reason: 3=DEAUTH_LEAVING)
cfg80211: ...
...
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.001 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
PM: Entering mem sleep
PM: suspend of devices complete after 2579.708 msecs
PM: late suspend of devices complete after 0.653 msecs
PM: noirq suspend of devices complete after 11.487 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
...
 ..
  .   
   RESUME
  .
 ..
...
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
ACPI: Waking up from system sleep state S3
PM: noirq resume of devices complete after 84.948 msecs
PM: early resume of devices complete after 0.520 msecs
...
mt7601u 1-4:1.0: Error: MCU response pre-completed!
mt7601u 1-4:1.0: Warning: unsupported EEPROM version 0d
mt7601u 1-4:1.0: EEPROM ver:0d fae:00
...
PM: resume of devices complete after 313.068 msecs
PM: Finishing wakeup.
Restarting tasks ... 
...
wlp0s2f1u4: authenticate with <BSSID>
wlp0s2f1u4: send auth to <BSSID> (try 1/3)
wlp0s2f1u4: authenticated
wlp0s2f1u4: associate with <BSSID> (try 1/3)
wlp0s2f1u4: RX AssocResp from <BSSID> (capab=0x411 status=0 aid=1)
wlp0s2f1u4: associated
...
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/softirq.c:150 __local_bh_enable_ip+0x72/0xa0()
Modules linked in: ...mt7601u(O) mac80211 cfg80211 ...
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G         C O    4.0.3-202.fc21.x86_64 #1
...
Call Trace:
 <IRQ>  [<ffffffff8177cc28>] dump_stack+0x45/0x57
 [<ffffffff8109d5ea>] warn_slowpath_common+0x8a/0xc0
 [<ffffffff8109d71a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810a14f2>] __local_bh_enable_ip+0x72/0xa0
 [<ffffffffa064868b>] destroy_conntrack+0x7b/0x100 [nf_conntrack]
 [<ffffffff8169d0e7>] nf_conntrack_destroy+0x17/0x30
 [<ffffffff81652165>] skb_release_head_state+0x95/0xe0
 [<ffffffff816521c6>] skb_release_all+0x16/0x30
 [<ffffffff8165240c>] consume_skb+0x2c/0x80
 [<ffffffffa08913d6>] ieee80211_tx_status+0xb66/0xe60 [mac80211]
 [<ffffffff8157ba88>] ? ehci_work.part.62+0x9a8/0xa50
 [<ffffffffa07dedb4>] ? ieee80211_get_hdrlen_from_skb+0x24/0x40 [cfg80211]
 [<ffffffffa07c4997>] mt7601u_tx_status+0x87/0xa0 [mt7601u]
 [<ffffffffa07bf00e>] mt7601u_complete_tx+0x8e/0x1c0 [mt7601u]
 [<ffffffff8155a065>] __usb_hcd_giveback_urb+0x85/0x140
 [<ffffffff8155ad0b>] usb_giveback_urb_bh+0xab/0x100
 [<ffffffff810a1786>] tasklet_action+0xe6/0xf0
 [<ffffffff810a1bab>] __do_softirq+0x10b/0x2b0
 [<ffffffff810a1f75>] irq_exit+0x125/0x130
 [<ffffffff817860e8>] do_IRQ+0x58/0xf0
 [<ffffffff81783e2d>] common_interrupt+0x6d/0x6d
 <EOI>  [<ffffffff8104d369>] ? lapic_timer_setup+0x19/0x20
 [<ffffffff8105fb86>] ? native_safe_halt+0x6/0x10
 [<ffffffff8101fade>] default_idle+0x1e/0xc0
 [<ffffffff8101fbff>] amd_e400_idle+0x7f/0x120
 [<ffffffff810205af>] arch_cpu_idle+0xf/0x20
 [<ffffffff810e02aa>] cpu_startup_entry+0x30a/0x420
 [<ffffffff81773137>] rest_init+0x77/0x80
 [<ffffffff81d4b03a>] start_kernel+0x4a3/0x4c4
 [<ffffffff81d4a120>] ? early_idt_handlers+0x120/0x120
 [<ffffffff81d4a4d7>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81d4a63a>] x86_64_start_kernel+0x161/0x184
---[ end trace dfa8ecf6346f14b1 ]---


 == mini stress test ==

1. unplug device while connected:
- dmesg:
...
usb 1-4: USB disconnect, device number 4
wlp0s2f1u4: deauthenticating from <BSSID> by local choice (Reason: 3=DEAUTH_LEAVING)
mt7601u 1-4:1.0: mt7601u_rxdc_cal timed out
...

2. plug in device a few seconds after:
- dmesg:
...
usb 1-4: new high-speed USB device number 7 using ehci-pci
usb 1-4: New USB device found, idVendor=148f, idProduct=7601
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: 802.11 n WLAN
usb 1-4: Manufacturer: MediaTek
usb 1-4: SerialNumber: 1.0
usb 1-4: reset high-speed USB device number 7 using ehci-pci
mt7601u 1-4:1.0: ASIC revision: 76010001 MAC revision: 76010500
mt7601u 1-4:1.0: Firmware Version: 0.1.00 Build: 7640 Build time: 201302052146____
mt7601u 1-4:1.0: Warning: unsupported EEPROM version 0d
mt7601u 1-4:1.0: EEPROM ver:0d fae:00
mt7601u 1-4:1.0: Error: RX urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp evt:0 seq:5-4!
mt7601u 1-4:1.0: Error: RX urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp evt:0 seq:5-4!
mt7601u 1-4:1.0: Error: RX urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp evt:0 seq:5-4!
mt7601u 1-4:1.0: Error: RX urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp evt:0 seq:5-4!
mt7601u 1-4:1.0: Error: RX urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp urb failed:-71
mt7601u 1-4:1.0: Error: MCU resp evt:0 seq:5-4!
mt7601u 1-4:1.0: Error: mt7601u_mcu_wait_resp timed out
mt7601u 1-4:1.0: Vendor request req:07 off:0080 failed:-71
mt7601u 1-4:1.0: Vendor request req:02 off:0080 failed:-71
mt7601u 1-4:1.0: Vendor request req:02 off:0080 failed:-71
mt7601u: probe of 1-4:1.0 failed with error -110
usb 1-4: USB disconnect, device number 7
usb 1-4: new high-speed USB device number 8 using ehci-pci
usb 1-4: New USB device found, idVendor=148f, idProduct=7601
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: 802.11 n WLAN
usb 1-4: Manufacturer: MediaTek
usb 1-4: SerialNumber: 1.0
usb 1-4: reset high-speed USB device number 8 using ehci-pci
mt7601u 1-4:1.0: ASIC revision: 76010001 MAC revision: 76010500
mt7601u 1-4:1.0: Warning: unsupported EEPROM version 0d
mt7601u 1-4:1.0: EEPROM ver:0d fae:00
ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
mt7601u 1-4:1.0 wlp0s2f1u4: renamed from wlan0
...
wlp0s2f1u4: authenticate with <BSSID>
wlp0s2f1u4: send auth to <BSSID> (try 1/3)
wlp0s2f1u4: authenticated
wlp0s2f1u4: associate with <BSSID> (try 1/3)
wlp0s2f1u4: RX AssocResp from <BSSID> (capab=0x411 status=0 aid=1)
wlp0s2f1u4: associated
...
------------[ cut here ]------------
WARNING: CPU: 3 PID: 0 at kernel/softirq.c:150 __local_bh_enable_ip+0x72/0xa0()
Modules linked in: ... mt7601u(O) mac80211 cfg80211 ...
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G           O    4.0.3-202.fc21.x86_64 #1
...
Call Trace:
 <IRQ>  [<ffffffff8177cc28>] dump_stack+0x45/0x57
 [<ffffffff8109d5ea>] warn_slowpath_common+0x8a/0xc0
 [<ffffffff8109d71a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810a14f2>] __local_bh_enable_ip+0x72/0xa0
 [<ffffffffa06c268b>] destroy_conntrack+0x7b/0x100 [nf_conntrack]
 [<ffffffff8169d0e7>] nf_conntrack_destroy+0x17/0x30
 [<ffffffff81652165>] skb_release_head_state+0x95/0xe0
 [<ffffffff816521c6>] skb_release_all+0x16/0x30
 [<ffffffff8165240c>] consume_skb+0x2c/0x80
 [<ffffffffa07703d6>] ieee80211_tx_status+0xb66/0xe60 [mac80211]
 [<ffffffff8157ba88>] ? ehci_work.part.62+0x9a8/0xa50
 [<ffffffffa0620db4>] ? ieee80211_get_hdrlen_from_skb+0x24/0x40 [cfg80211]
 [<ffffffffa043c997>] mt7601u_tx_status+0x87/0xa0 [mt7601u]
 [<ffffffffa043700e>] mt7601u_complete_tx+0x8e/0x1c0 [mt7601u]
 [<ffffffff8155a065>] __usb_hcd_giveback_urb+0x85/0x140
 [<ffffffff8155ad0b>] usb_giveback_urb_bh+0xab/0x100
 [<ffffffff810a1786>] tasklet_action+0xe6/0xf0
 [<ffffffff810a1bab>] __do_softirq+0x10b/0x2b0
 [<ffffffff810a1f75>] irq_exit+0x125/0x130
 [<ffffffff817860e8>] do_IRQ+0x58/0xf0
 [<ffffffff81783e2d>] common_interrupt+0x6d/0x6d
 <EOI>  [<ffffffff8104d369>] ? lapic_timer_setup+0x19/0x20
 [<ffffffff8105fb86>] ? native_safe_halt+0x6/0x10
 [<ffffffff8101fade>] default_idle+0x1e/0xc0
 [<ffffffff8101fbff>] amd_e400_idle+0x7f/0x120
 [<ffffffff810205af>] arch_cpu_idle+0xf/0x20
 [<ffffffff810e02aa>] cpu_startup_entry+0x30a/0x420
 [<ffffffff8104b5c5>] start_secondary+0x1a5/0x1f0
---[ end trace 453a9db773f4554b ]---


 == throughput test == 

MT7601U Wi-Fi <~1m LOS~> AP(Wi-Fi <-bridge-> 100Mbit switch) <-> SERVER

- iperf -c <SERVER> -i 1:
------------------------------------------------------------
Client connecting to <SERVER>, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local <CLIENT IP> port 45680 connected with <SERVER IP> port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  1.0- 2.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  2.0- 3.0 sec  11.0 MBytes  92.3 Mbits/sec
[  3]  3.0- 4.0 sec  11.1 MBytes  93.3 Mbits/sec
[  3]  4.0- 5.0 sec  10.8 MBytes  90.2 Mbits/sec
[  3]  5.0- 6.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  6.0- 7.0 sec  10.5 MBytes  88.1 Mbits/sec
[  3]  7.0- 8.0 sec  10.4 MBytes  87.0 Mbits/sec
[  3]  8.0- 9.0 sec  11.0 MBytes  92.3 Mbits/sec
[  3]  9.0-10.0 sec  11.4 MBytes  95.4 Mbits/sec
[  3]  0.0-10.0 sec   110 MBytes  92.1 Mbits/sec


