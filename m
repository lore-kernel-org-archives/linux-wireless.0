Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:43451 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3JSXyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Oct 2013 19:54:10 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Yannik =?utf-8?q?V=C3=B6lker?= <yannikv@yahoo.de>
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
Date: Sat, 19 Oct 2013 23:53:53 +0000
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52616CD0.2000203@rempel-privat.de> <5262789D.8030704@yahoo.de>
In-Reply-To: <5262789D.8030704@yahoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201310192354.04352.s.L-H@gmx.de> (sfid-20131020_015425_314660_2C931A26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Saturday 19 October 2013, Yannik Völker wrote:
[…]
> [  708.193488] cfg80211: Calling CRDA to update world regulatory domain 
> [  708.492120] usbcore: registered new interface driver ar5523
> [  708.509819] cfg80211: World regulatory domain updated:
> [  708.509822] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  708.509823] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  708.509824] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  708.509825] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  708.509826] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  708.509827] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  720.232697] usb 3-14: USB disconnect, device number 8
> [  721.721980] usb 3-14: new high-speed USB device number 9 using xhci_hcd
> [  721.739153] usb 3-14: New USB device found, idVendor=129b, idProduct=160c
> [  721.739163] usb 3-14: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  721.739168] usb 3-14: Product: AR5523
> [  721.739174] usb 3-14: Manufacturer: Atheros Communications Inc
> [  721.739178] usb 3-14: SerialNumber: 1.0
> mtp-probe: checking bus 3, device 9:
> "/sys/devices/pci0000:00/0000:00:14.0/usb3/3-14"
> mtp-probe: bus: 3, device: 9 was not an MTP device

Like Oleksij Rempel mentioned, working with arbitrarily cut kernel 
messages is pretty futile, but I would first recommend to confirm that
your firmware is really correct:

	$ md5sum -b /lib/firmware/ar5523.bin
	78fe4478dca9134c028e7507421b3f6a */lib/firmware/ar5523.bin

ar5523 behaves in a slightly uncommon way, when you first connect your 
USB wlan card, it flags 0x129b, 0x160c (let's at least use this 
example) as its USB IDs. ar5523.ko binds to this USB and starts the 
firmware upload, once the firmware is uploaded to the device, a USB bus
reset is triggered and the firmware makes the device now flag a 
different USB, decremented by 1 - so ending up with 0x129b, 0x160b this
time, only now after this modeswitch the module can actually load. 

In the past - before ar5523 was ever merged into linux, there was (at 
least) one faulty firmware version which incremented the USB ID, rather
than decrementing it, which would be one explanation for your problem.

Another quite likely problem would be a side effect of your previous
ndiswrapper installation, which -in order to function- takes over the
USB IDs for itself, so also make sure to get rid of all traces of it,
in particular its overrides in /etc/modprobe.d/*.conf.

But in order to do anything, we really need full logs - at least from 
the moment on you plug in your USB card. What your log should look like
is something like this:

[ 4826.812663] usb 3-1.6: new high-speed USB device number 6 using ehci-pci
[ 4826.899085] usb 3-1.6: New USB device found, idVendor=1385, idProduct=4251
[ 4826.899090] usb 3-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 4826.899092] usb 3-1.6: Product: WG111T
[ 4826.899103] usb 3-1.6: Manufacturer: Atheros Communications Inc
[ 4826.899105] usb 3-1.6: SerialNumber: 1.0
[ 4827.004173] usbcore: registered new interface driver ar5523
[ 4827.325368] usb 3-1.6: USB disconnect, device number 6
[ 4827.502257] usb 3-1.6: new high-speed USB device number 7 using ehci-pci
[ 4827.588323] usb 3-1.6: New USB device found, idVendor=1385, idProduct=4250
[ 4827.588328] usb 3-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 4827.588331] usb 3-1.6: Product: WG111T
[ 4827.588333] usb 3-1.6: Manufacturer: Atheros Communications Inc
[ 4827.588335] usb 3-1.6: SerialNumber: 1.0
[ 4827.637048] usb 3-1.6: Cap: CAP_TARGET_VERSION=0x00000006
[ 4827.637432] usb 3-1.6: Cap: CAP_TARGET_REVISION=0x00000001
[ 4827.637800] usb 3-1.6: Cap: CAP_MAC_VERSION=0x00000008
[ 4827.638176] usb 3-1.6: Cap: CAP_MAC_REVISION=0x00000001
[ 4827.638520] usb 3-1.6: Cap: CAP_PHY_REVISION=0x00000046
[ 4827.638889] usb 3-1.6: Cap: CAP_ANALOG_5GHz_REVISION=0x00000046
[ 4827.639138] usb 3-1.6: Cap: CAP_ANALOG_2GHz_REVISION=0x00000000
[ 4827.639525] usb 3-1.6: Cap: CAP_REG_DOMAIN=0x00000000
[ 4827.639885] usb 3-1.6: Cap: CAP_REG_CAP_BITS=0x00000000
[ 4827.640147] usb 3-1.6: Cap: CAP_WIRELESS_MODES=0x00000000
[ 4827.640534] usb 3-1.6: Cap: CAP_CHAN_SPREAD_SUPPORT=0x0000001c
[ 4827.640885] usb 3-1.6: Cap: CAP_COMPRESS_SUPPORT=0x00000001
[ 4827.641151] usb 3-1.6: Cap: CAP_BURST_SUPPORT=0x00000001
[ 4827.641527] usb 3-1.6: Cap: CAP_FAST_FRAMES_SUPPORT=0x00000001
[ 4827.641884] usb 3-1.6: Cap: CAP_CHAP_TUNING_SUPPORT=0x00000001
[ 4827.642133] usb 3-1.6: Cap: CAP_TURBOG_SUPPORT=0x00000001
[ 4827.642508] usb 3-1.6: Cap: CAP_TURBO_PRIME_SUPPORT=0x00000001
[ 4827.642761] usb 3-1.6: Cap: CAP_DEVICE_TYPE=0x00000001
[ 4827.643132] usb 3-1.6: Cap: CAP_WME_SUPPORT=0x00000001
[ 4827.643383] usb 3-1.6: Cap: CAP_TOTAL_QUEUES=0x00000001
[ 4827.643757] usb 3-1.6: Cap: CAP_CONNECTION_ID_MAX=0x0000000a
[ 4827.644013] usb 3-1.6: Cap: CAP_LOW_5GHZ_CHAN=0x00000004
[ 4827.644382] usb 3-1.6: Cap: CAP_HIGH_5GHZ_CHAN=0x00001338
[ 4827.644756] usb 3-1.6: Cap: CAP_LOW_2GHZ_CHAN=0x000017d4
[ 4827.645008] usb 3-1.6: Cap: CAP_HIGH_2GHZ_CHAN=0x00000908
[ 4827.645390] usb 3-1.6: Cap: CAP_TWICE_ANTENNAGAIN_5G=0x00000001
[ 4827.645659] usb 3-1.6: Cap: CAP_TWICE_ANTENNAGAIN_2G=0x00000004
[ 4827.646014] usb 3-1.6: Cap: CAP_CIPHER_AES_CCM=0x00000001
[ 4827.646276] usb 3-1.6: Cap: CAP_CIPHER_TKIP=0x00000000
[ 4827.646649] usb 3-1.6: Cap: CAP_MIC_TKIP=0x00000000
[ 4827.647409] usb 3-1.6: MAC/BBP AR5523, RF AR2112
[ 4827.647676] usb 3-1.6: Found and initialized AR5523 device

only then, afterwards when you actually up your interface, the calls to
wpa_supplicant and crda will happen, like:

[29068.766731] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[29092.453104] NET: Registered protocol family 17
[29093.421812] wlan1: authenticate with 01:23:45:67:89:ab
[29093.431498] wlan1: send auth to 01:23:45:67:89:ab (try 1/3)
[29093.434232] wlan1: authenticated
[29093.435348] wlan1: associate with 01:23:45:67:89:ab (try 1/3)
[29093.438360] wlan1: RX AssocResp from 01:23:45:67:89:ab (capab=0x431 status=0 aid=1)
[29093.439215] wlan1: associated
[29093.439243] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[29093.439332] cfg80211: Calling CRDA for country: DE
[29093.443332] cfg80211: Regulatory domain changed to country: DE
[29093.443335] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[29093.443337] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[29093.443339] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[29093.443341] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[29093.443342] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[29093.443344] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)

We'd need the debugging information for all of these messages, 
especially the early ones about the mode switch.

Personally I'm rather confident that the existing USB IDs are correct,
namely 0x129b, 0x160c without firmware loaded and 0x129b, 0x160b after
the firmware upload has executed its modeswitch, which would be 
reminiscence of your earlier games with ndiswrapper (which -surprise-
also uploads a(n eventually broken, see above) firmware). In order to
make sure to remove different firmwares from your device's RAM, you 
need to physically disconnect your USB device for a moment (or power
down your whole system), unloading ndiswrapper and loading ar5523.ko
or just warmrebooting is not enough (as this won't make the device
forget its firmware).

Regards
	Stefan Lippers-Hollmann
