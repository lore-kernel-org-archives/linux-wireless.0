Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35295 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbbETRGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 13:06:09 -0400
Received: by wgfl8 with SMTP id l8so59652764wgf.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 10:06:08 -0700 (PDT)
Message-ID: <555CBEFC.50902@gmail.com> (sfid-20150520_190614_651489_F46716B2)
Date: Wed, 20 May 2015 19:06:04 +0200
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
References: <544DB5A8.7090405@openmailbox.org>	<20141027152026.GB19976@tuxdriver.com>	<544E8CB4.3000607@rempel-privat.de>	<20141028134608.GA26283@tuxdriver.com>	<544FA303.5060303@broadcom.com>	<544FA627.3000004@rempel-privat.de>	<5450BEB2.60208@openwrt.org>	<5461F937.9060004@rempel-privat.de>	<5463CB6C.3030204@openwrt.org>	<5463D28F.9080106@lwfinger.net>	<20150206182915.7467bac7@north>	<54EF261E.4040109@gmail.com> <20150226154028.380b96f2@north> <55592C54.6010204@gmail.com>
In-Reply-To: <55592C54.6010204@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18.05.2015 02:03, poma wrote:
> 
> Preliminary test results
> 
> - lsusb -d 148f:7601:
> Bus 001 Device 007: ID 148f:7601 Ralink Technology, Corp. MT7601U Wireless Adapter
> 
> 
> - https://github.com/kuba-moo/mt7601u
> - git log -1:
> commit ad5474ecd9fd6efd4a7f03f4a8c71ea4bb57ca73
> Author: Jakub Kicinski <kubakici@wp.pl>
> Date:   Wed May 6 20:44:18 2015 +0200
> 
>     make sure .disconnect() doesn't cleanup the device if .resume() failed
>     
>     Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> 
> 
> - modinfo mt7601u:
> filename:       /lib/modules/4.0.3-202.fc21.x86_64/updates/mt7601u.ko
> license:        GPL
> firmware:       mt7601u.bin
> alias:          usb:v7392p7710d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v2A5Fp1000d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v2955p1001d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v2955p0001d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v2717p4106d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v2001p3D04d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v148Fp760Dd*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v148Fp760Cd*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v148Fp760Bd*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v148Fp760Ad*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v148Fp7601d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v13D3p3434d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v13D3p3431d*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v0E8Dp760Bd*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v0E8Dp760Ad*dc*dsc*dp*ic*isc*ip*in*
> alias:          usb:v0B05p17D3d*dc*dsc*dp*ic*isc*ip*in*
> depends:        cfg80211,mac80211
> vermagic:       4.0.3-202.fc21.x86_64 SMP mod_unload 
> signer:         Fedora kernel signing key
> sig_key:        95:7D:C8:E5:9F:5D:E6:03:71:49:1A:D0:9A:C6:8F:85:16:6C:B3:94
> sig_hashalgo:   sha256
> 
> 
> - md5sum /lib/firmware/mt7601u.bin:
> 696cedb8e76ecc0cda9f9b0d3972c64d  /lib/firmware/mt7601u.bin
> 
> 
> - NetworkManager --version:
> 1.0.2-2.fc21
> 
> 
> plug in device:
> - dmesg:
> usb 1-4: new high-speed USB device number 6 using ehci-pci
> usb 1-4: New USB device found, idVendor=148f, idProduct=7601
> usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-4: Product: 802.11 n WLAN
> usb 1-4: Manufacturer: MediaTek
> usb 1-4: SerialNumber: 1.0
> cfg80211: ...
> ...
> usb 1-4: reset high-speed USB device number 6 using ehci-pci
> mt7601u 1-4:1.0: ASIC revision: 76010001 MAC revision: 76010500
> mt7601u 1-4:1.0: Firmware Version: 0.1.00 Build: 7640 Build time: 201302052146____
> mt7601u 1-4:1.0: Warning: unsupported EEPROM version 0d
> mt7601u 1-4:1.0: EEPROM ver:0d fae:00
> ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> usbcore: registered new interface driver mt7601u
> mt7601u 1-4:1.0 wlp0s2f1u4: renamed from wlan0
> ...
> cfg80211: ...
> ...
> wlp0s2f1u4: authenticate with <BSSID>
> wlp0s2f1u4: send auth to <BSSID> (try 1/3)
> wlp0s2f1u4: authenticated
> wlp0s2f1u4: associate with <BSSID> (try 1/3)
> wlp0s2f1u4: RX AssocResp from <BSSID> (capab=0x411 status=0 aid=1)
> wlp0s2f1u4: associated
> 
> 
> - iwconfig wlp0s2f1u4:
> wlp0s2f1u4  IEEE 802.11bgn  ESSID:"AP"  
>           Mode:Managed  Frequency:2.422 GHz  Access Point: <BSSID>   
>           Bit Rate=135 Mb/s   Tx-Power=20 dBm   
>           Retry short limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=67/70  Signal level=-43 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:873   Missed beacon:0
> 
> 
...

Can be tested with the test compilation I share with you bona fide:
http://goo.gl/Gm4ffO
ISO/Fedora-Live-Xfce-WiFi.iso

Runs on baremetal & QEMU/KVM/Libvirt/Virtual Machine Manager
http://www.linux-kvm.org/page/USB_Host_Device_Assigned_to_Guest


With the script 'mt7601u-fw-install' can be initiated the download and installation of the required firmware,
though it would be optimal to resolve it in the following manner:

In OpenWrt repo - mt76 - mac80211 driver for MediaTek MT76x2 802.11ac chips
https://github.com/openwrt/mt76

there is a license file together with firmwares:
https://github.com/openwrt/mt76/blob/master/firmware


Whether the same can be done with:
mt7601u -  Linux mac80211-based driver for Mediatek MT7601U USB bgn WiFi dongle
https://github.com/kuba-moo/mt7601u
?


