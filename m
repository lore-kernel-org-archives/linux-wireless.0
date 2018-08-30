Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbeH3JHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 05:07:01 -0400
Date: Thu, 30 Aug 2018 13:06:33 +0800
From: Dave Young <dyoung@redhat.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwifi@intel.com
Subject: Re: Intel Wireless 8265/8275 (rev 78) issue
Message-ID: <20180830050632.GB2307@dhcp-128-65.nay.redhat.com> (sfid-20180830_070650_261777_E499CB13)
References: <20180829065442.GA3488@dhcp-128-65.nay.redhat.com>
 <6bb91f750e8d37d45da3c2cf1e7e5fc5d453ee8c.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6bb91f750e8d37d45da3c2cf1e7e5fc5d453ee8c.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/18 at 07:15am, Luca Coelho wrote:
> On Wed, 2018-08-29 at 14:54 +0800, Dave Young wrote:
> > Hi,
> 
> Hi Dave,
> 
> 
> > Not sure if this is a known issue, I'm seeing this with latest mainline
> > kernel on Fedora rawhide.
> > 
> > The wireless networking is not stable, I can not access network any more after
> > downloading some big files or just browsing some web pages about some
> > time.  I do not see this when I work in office.  So this maybe relate to
> > wireless router.
> > 
> > "Can not access network" means ping timeout, can not open web pages etc.
> > But the wireless connection looks normal at least from the
> > NetworkManager icon it is still connected.
> > 
> > The router I used at home is an old ASUS WL520gc.  I can confirm I can
> > reproduce this with another ASUA router WL-500gP v2 
> > 
> > My laptop model is Thinkpad T480s.  It is painful I can only use
> > wireless,  any hints how to make it work will be appreciated!
> > 
> > lspci:
> > 3d:00.0 Network controller: Intel Corporation Wireless 8265 / 8275 (rev 78)
> >         Subsystem: Intel Corporation Dual Band Wireless-AC 8265
> >         Flags: bus master, fast devsel, latency 0, IRQ 136
> >         Memory at dc100000 (64-bit, non-prefetchable) [size=8K]
> >         Capabilities: [c8] Power Management version 3
> >         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> >         Capabilities: [40] Express Endpoint, MSI 00
> >         Capabilities: [100] Advanced Error Reporting
> >         Capabilities: [140] Device Serial Number b4-6b-fc-ff-ff-a3-80-d6
> >         Capabilities: [14c] Latency Tolerance Reporting
> >         Capabilities: [154] L1 PM Substates
> >         Kernel driver in use: iwlwifi
> >         Kernel modules: iwlwifi
> > 
> > Part of dmesg:
> > 
> > [    7.892039] Intel(R) Wireless WiFi driver for Linux
> > [    7.892041] Copyright(c) 2003- 2015 Intel Corporation
> > [    7.892168] iwlwifi 0000:3d:00.0: enabling device (0000 -> 0002)
> > [    7.898375] uvcvideo 1-8:1.0: Entity type for entity Extension 4 was not initialized!
> > [    7.899760] uvcvideo 1-8:1.0: Entity type for entity Extension 3 was not initialized!
> > [    7.901297] uvcvideo 1-8:1.0: Entity type for entity Processing 2 was not initialized!
> > [    7.902594] uvcvideo 1-8:1.0: Entity type for entity Camera 1 was not initialized!
> > [    7.904136] input: Integrated Camera: Integrated C as /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/input/input11
> > [    7.906563] usbcore: registered new interface driver uvcvideo
> > [    7.906565] USB Video Class driver (1.1.1)
> > [    7.914162] iwlwifi 0000:3d:00.0: loaded firmware version 36.e91976c0.0 op_mode iwlmvm
> > [    8.080368] iwlwifi 0000:3d:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
> > [    8.149556] iwlwifi 0000:3d:00.0: base HW address: b4:6b:fc:a3:80:d6
> > [    8.151643] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
> > [    8.151646] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
> > [    8.151648] RAPL PMU: hw unit of domain package 2^-14 Joules
> > [    8.151650] RAPL PMU: hw unit of domain dram 2^-14 Joules
> > [    8.151651] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
> > [    8.151653] RAPL PMU: hw unit of domain psys 2^-14 Joules
> > [    8.242895] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> > [    8.244972] thermal thermal_zone5: failed to read out thermal zone (-61)
> > [    8.266903] iwlwifi 0000:3d:00.0 wlp61s0: renamed from wlan0
> > [    8.376663] psmouse serio1: elantech: assuming hardware version 4 (with firmware version 0x7f3001)
> > [    8.388476] psmouse serio1: elantech: Synaptics capabilities query result 0x90, 0x18, 0x0f.
> > [    8.404955] psmouse serio1: elantech: Elan sample query result 00, 20, c9
> > [    8.405711] intel_rapl: Found RAPL domain package
> > [    8.405729] intel_rapl: Found RAPL domain core
> > [    8.405732] intel_rapl: Found RAPL domain uncore
> > [    8.405734] intel_rapl: Found RAPL domain dram
> > [    8.417931] psmouse serio1: elantech: Trying to set up SMBus access
> > [    8.427666] elan_i2c 6-0015: 6-0015 supply vcc not found, using dummy regulator
> > [    8.428913] elan_i2c 6-0015: Linked as a consumer to regulator.0
> > [    8.442870] elan_i2c 6-0015: Elan Touchpad: Module ID: 0x0020, Firmware: 0x0001, Sample: 0x0000, IAP: 0x0000
> > [    8.443236] input: Elan Touchpad as /devices/pci0000:00/0000:00:1f.4/i2c-6/6-0015/input/input19
> > [    8.443961] input: Elan TrackPoint as /devices/pci0000:00/0000:00:1f.4/i2c-6/6-0015/input/input20
> > [    8.483396] systemd-udevd (584) used greatest stack depth: 11320 bytes left
> > [    8.534134] EXT4-fs (nvme0n1p4): mounted filesystem with ordered data mode. Opts: (null)
> > [    8.540006] EXT4-fs (nvme0n1p11): mounted filesystem with ordered data mode. Opts: (null)
> > [    8.544692] EXT4-fs (nvme0n1p3): mounted filesystem with ordered data mode. Opts: (null)
> > [    8.556466] EXT4-fs (nvme0n1p5): mounted filesystem with ordered data mode. Opts: (null)
> > [    8.565545] EXT4-fs (nvme0n1p8): mounted filesystem with ordered data mode. Opts: (null)
> > [    8.598930] EXT4-fs (nvme0n1p7): mounted filesystem with ordered data mode. Opts: (null)
> > [    8.620810] usb 1-7: USB disconnect, device number 2
> > [    8.643967] systemd-journald[522]: Received request to flush runtime journal from PID 1
> > [    8.786474] RPC: Registered named UNIX socket transport module.
> > [    8.786481] RPC: Registered udp transport module.
> > [    8.786482] RPC: Registered tcp transport module.
> > [    8.786483] RPC: Registered tcp NFSv4.1 backchannel transport module.
> > [    9.033765] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> > [    9.033767] Bluetooth: BNEP filters: protocol multicast
> > [    9.033774] Bluetooth: BNEP socket layer initialized
> > [    9.295788] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
> > [    9.532690] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
> > [    9.540906] IPv6: ADDRCONF(NETDEV_UP): wlp61s0: link is not ready
> > [    9.760641] IPv6: ADDRCONF(NETDEV_UP): wlp61s0: link is not ready
> > [   10.006921] IPv6: ADDRCONF(NETDEV_UP): wlp61s0: link is not ready
> > [   10.036910] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
> > [   10.131377] IPv6: ADDRCONF(NETDEV_UP): wlp61s0: link is not ready
> > [   10.670126] Bluetooth: hci0: command 0xfc09 tx timeout
> > [   18.796221] Bluetooth: hci0: Failed to send firmware data (-110)
> > [   71.273464] fuse init (API version 7.27)
> > [   73.269439] IPv6: ADDRCONF(NETDEV_UP): wlp61s0: link is not ready
> > [   74.123114] wlp61s0: authenticate with 00:1f:c6:82:0a:57
> > [   74.126099] wlp61s0: send auth to 00:1f:c6:82:0a:57 (try 1/3)
> > [   74.139740] wlp61s0: authenticated
> > [   74.140142] iwlwifi 0000:3d:00.0 wlp61s0: disabling HE/HT/VHT due to WEP/TKIP use
> > [   74.140146] iwlwifi 0000:3d:00.0 wlp61s0: disabling HT as WMM/QoS is not supported by the AP
> > [   74.140149] iwlwifi 0000:3d:00.0 wlp61s0: disabling VHT as WMM/QoS is not supported by the AP
> 
> Your AP seems to be configured to use WEP or TKIP, which is not allowed
> by IEEE802.11n, so we disable all the higher rates, as you can see
> here.  It should still work, but you will only get very basic rates
> (i.e. slow).

Luka, thanks for the suggestion,  moved AP to use WPA2-personal + AES.
seems I got only two features disabled this time:
[   20.949347] iwlwifi 0000:3d:00.0 wlp61s0: disabling HT as WMM/QoS is not supported by the AP
[   20.949351] iwlwifi 0000:3d:00.0 wlp61s0: disabling VHT as WMM/QoS is not supported by the AP
[   20.949622] wlp61s0: associate with 00:1f:c6:82:0a:57 (try 1/3)

> 
> 
> > [   74.141838] wlp61s0: associate with 00:1f:c6:82:0a:57 (try 1/3)
> > [   74.149298] wlp61s0: RX AssocResp from 00:1f:c6:82:0a:57 (capab=0x411 status=0 aid=3)
> > [   74.160220] wlp61s0: associated
> > [   74.201707] IPv6: ADDRCONF(NETDEV_CHANGE): wlp61s0: link becomes ready
> > [   79.350950] usb 1-2: new low-speed USB device number 4 using xhci_hcd
> > [   79.482476] usb 1-2: New USB device found, idVendor=17ef, idProduct=6016, bcdDevice= 0.00
> > [   79.482485] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > [   79.482491] usb 1-2: Product: ThinkPad USB Laser Mouse
> > [   79.482496] usb 1-2: Manufacturer: Lenovo
> > [   79.488601] input: Lenovo ThinkPad USB Laser Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:17EF:6016.0001/input/input21
> > [   79.490030] hid-generic 0003:17EF:6016.0001: input,hidraw0: USB HID v1.11 Mouse [Lenovo ThinkPad USB Laser Mouse] on usb-0000:00:14.0-2/input0
> > [   87.228112] tun: Universal TUN/TAP device driver, 1.6
> > [ 1870.764779] e1000e: enp0s31f6 NIC Link is Up 10 Mbps Full Duplex, Flow Control: Rx/Tx
> > [ 1870.764903] e1000e 0000:00:1f.6 enp0s31f6: 10/100 speed: disabling TSO
> > [ 1870.765098] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s31f6: link becomes ready
> > [ 2521.068469] wlp61s0: deauthenticating from 00:1f:c6:82:0a:57 by local choice (Reason: 3=DEAUTH_LEAVING)
> 
> Other than that I can't really see what is going on, except that
> something is deciding to disconnect here...
> 
> So, first thing I'd suggest would be to try to reconfigure your AP to
> use something else than WEP or TKIP, just to see if it improves in any
> way.

Will observe if it works or not. BTW, my old laptop Thinkpad T440s works
well with the same AP.

> 
> And BTW, is this a regression in recent kernels or has this always
> happened to you with this laptop/AP combination?

>From my observation it just always happen, but hmm not 100% sure..

> 
> --
> Cheers,
> Luca.
> 

Thanks
Dave
