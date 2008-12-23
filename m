Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:6578 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYLWMtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 07:49:40 -0500
Received: by an-out-0708.google.com with SMTP id d40so821375and.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 04:49:38 -0800 (PST)
Message-ID: <2d0a357f0812230449ua1daea6h81fd53a6393498af@mail.gmail.com> (sfid-20081223_134945_555399_E0373925)
Date: Tue, 23 Dec 2008 13:49:37 +0100
From: "Sedat Dilek" <sedat.dilek@googlemail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 10/10] iwl3945: use rx queue management infrastructure from iwlcore
Cc: "Kalle Valo" <kalle.valo@iki.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1230001118.2570.35.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-9-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-10-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-11-git-send-email-yi.zhu@intel.com>
	 <87r640s3ph.fsf@litku.valot.fi>
	 <1230001118.2570.35.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same error-message and as described before no DNS is resolved with
latest iwlwifi-2.6.git, also.
I added info about wpa_supplicant version I am using, maybe this is important.

-SD

----- Investigations -----

[...]
/var/log/syslog:Dec 23 10:05:35 seduxbox kernel: mac80211-phy0: failed
to set key (1, ff:ff:ff:ff:ff:ff) to hardware (-22)
[...]

# env COLUMNS=180 dpkg -l | grep linux-image | grep 2.6.28-rc9
ii  linux-image-2.6.28-rc9-git3-wl-gcc44
2.6.28~rc9+git3+wl~git20081219.30b5741+ Linux kernel binary image for
version 2.6.28-rc9-git3-wl-gcc44
ii  linux-image-2.6.28-rc9-iwlwifi26-gcc44
2.6.28~rc9+iwlwifi26~git20081223.f4f5c9 Linux kernel binary image for
version 2.6.28-rc9-iwlwifi26-gcc44

# env COLUMNS=120 dpkg -l | grep wpa
ii  wpagui                   0.6.6-1+c0.sidux.1       graphical user
interface for wpa_supplicant
ii  wpasupplicant            0.6.6-1+c0.sidux.1       client support
for WPA and WPA2 (IEEE 802.11i)

root@seduxbox:~# modprobe -r -v iwl3945
rmmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/drivers/net/wireless/iwlwifi/iwl3945.ko
rmmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
rmmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/net/mac80211/mac80211.ko
rmmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/net/rfkill/rfkill.ko
rmmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/drivers/leds/led-class.ko
rmmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/net/wireless/cfg80211.ko
root@seduxbox:~# modprobe -v iwl3945 debug=0x43fff
insmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/net/wireless/cfg80211.ko
insmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/drivers/leds/led-class.ko
insmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/net/rfkill/rfkill.ko
insmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/net/mac80211/mac80211.ko
insmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
insmod /lib/modules/2.6.28-rc9-iwlwifi26-gcc44/kernel/drivers/net/wireless/iwlwifi/iwl3945.ko
debug=0x43fff

root@seduxbox:~# ping www.heise.de
ping: unknown host www.heise.de

root@seduxbox:~# cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet static
	address 192.168.2.103
	broadcast 192.168.2.255
	dns-nameservers 192.168.2.1 217.237.151.142 217.237.150.188
	gateway 192.168.2.1
	netmask 255.255.255.0
	network 192.168.2.0
	wpa-psk <mySecretPassword>
	wpa-ssid WLAN-001C4A41622E

root@seduxbox:~# lsmod | grep iwl
iwl3945                82308  0
iwlcore                85248  1 iwl3945
mac80211              139048  2 iwl3945,iwlcore
rfkill                 14004  3 iwl3945,iwlcore
led_class               7812  2 iwl3945,iwlcore
cfg80211               36888  3 iwl3945,iwlcore,mac80211

root@seduxbox:~# tail -f /var/log/messages
Dec 23 13:31:06 seduxbox kernel: reserve_memtype failed
0xd8000000-0xdc000000, track write-combining, req write-combining
Dec 23 13:31:06 seduxbox kernel: Xorg:5236 conflicting memory types
d8000000-dc000000 write-combining<->uncached-minus
Dec 23 13:31:06 seduxbox kernel: reserve_memtype failed
0xd8000000-0xdc000000, track write-combining, req write-combining
Dec 23 13:31:06 seduxbox kernel: Xorg:5254 freeing invalid memtype
d8000000-dc000000
Dec 23 13:31:07 seduxbox kernel: Xorg:5236 conflicting memory types
d8000000-dc000000 write-combining<->uncached-minus
Dec 23 13:31:07 seduxbox kernel: reserve_memtype failed
0xd8000000-0xdc000000, track write-combining, req write-combining
Dec 23 13:31:07 seduxbox kernel: Xorg:5258 freeing invalid memtype
d8000000-dc000000
Dec 23 13:31:19 seduxbox kernel: ADDRCONF(NETDEV_CHANGE): wlan0: link
becomes ready
Dec 23 13:31:20 seduxbox kernel: padlock: VIA PadLock not detected.
Dec 23 13:32:22 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A disabled
Dec 23 13:32:49 seduxbox kernel: cfg80211: Using static regulatory domain info
Dec 23 13:32:49 seduxbox kernel: cfg80211: Regulatory domain: US
Dec 23 13:32:49 seduxbox kernel: 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
Dec 23 13:32:49 seduxbox kernel: 	(2402000 KHz - 2472000 KHz @ 40000
KHz), (600 mBi, 2700 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5170000 KHz - 5190000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5190000 KHz - 5210000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5210000 KHz - 5230000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5230000 KHz - 5330000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5735000 KHz - 5835000 KHz @ 40000
KHz), (600 mBi, 3000 mBm)
Dec 23 13:32:49 seduxbox kernel: cfg80211: Calling CRDA for country: US
Dec 23 13:32:50 seduxbox kernel: iwl3945: Intel(R) PRO/Wireless
3945ABG/BG Network Connection driver for Linux, 1.2.26ks
Dec 23 13:32:50 seduxbox kernel: iwl3945: Copyright(c) 2003-2008 Intel
Corporation
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A ->
GSI 17 (level, low) -> IRQ 17
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: Tunable
channels: 13 802.11bg, 23 802.11a channels
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: Detected Intel
Wireless WiFi Link 3945ABG
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A ->
GSI 17 (level, low) -> IRQ 17
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: firmware:
requesting iwlwifi-3945-2.ucode
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: loaded firmware
version 15.28.2.8
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:radio
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:assoc
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:RX
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:TX
Dec 23 13:32:50 seduxbox kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Dec 23 13:32:53 seduxbox kernel: ADDRCONF(NETDEV_CHANGE): wlan0: link
becomes ready

root@seduxbox:~# tail -50 /var/log/kern.log
Dec 23 13:31:07 seduxbox kernel: reserve_memtype failed
0xd8000000-0xdc000000, track write-combining, req write-combining
Dec 23 13:31:07 seduxbox kernel: Xorg:5258 freeing invalid memtype
d8000000-dc000000
Dec 23 13:31:19 seduxbox kernel: wlan0: authenticate with AP 00:1c:4a:41:62:2e
Dec 23 13:31:19 seduxbox kernel: wlan0: authenticated
Dec 23 13:31:19 seduxbox kernel: wlan0: associate with AP 00:1c:4a:41:62:2e
Dec 23 13:31:19 seduxbox kernel: wlan0: RX AssocResp from
00:1c:4a:41:62:2e (capab=0x411 status=0 aid=1)
Dec 23 13:31:19 seduxbox kernel: wlan0: associated
Dec 23 13:31:19 seduxbox kernel: ADDRCONF(NETDEV_CHANGE): wlan0: link
becomes ready
Dec 23 13:31:20 seduxbox kernel: padlock: VIA PadLock not detected.
Dec 23 13:31:20 seduxbox kernel: mac80211-phy0: failed to set key (2,
ff:ff:ff:ff:ff:ff) to hardware (-22)
Dec 23 13:31:29 seduxbox kernel: wlan0: no IPv6 routers present
Dec 23 13:32:22 seduxbox kernel: wlan0: deauthenticating by local
choice (reason=3)
Dec 23 13:32:22 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
Dec 23 13:32:22 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
Dec 23 13:32:22 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
Dec 23 13:32:22 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A disabled
Dec 23 13:32:49 seduxbox kernel: cfg80211: Using static regulatory domain info
Dec 23 13:32:49 seduxbox kernel: cfg80211: Regulatory domain: US
Dec 23 13:32:49 seduxbox kernel: 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
Dec 23 13:32:49 seduxbox kernel: 	(2402000 KHz - 2472000 KHz @ 40000
KHz), (600 mBi, 2700 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5170000 KHz - 5190000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5190000 KHz - 5210000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5210000 KHz - 5230000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5230000 KHz - 5330000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Dec 23 13:32:49 seduxbox kernel: 	(5735000 KHz - 5835000 KHz @ 40000
KHz), (600 mBi, 3000 mBm)
Dec 23 13:32:49 seduxbox kernel: cfg80211: Calling CRDA for country: US
Dec 23 13:32:50 seduxbox kernel: iwl3945: Intel(R) PRO/Wireless
3945ABG/BG Network Connection driver for Linux, 1.2.26ks
Dec 23 13:32:50 seduxbox kernel: iwl3945: Copyright(c) 2003-2008 Intel
Corporation
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A ->
GSI 17 (level, low) -> IRQ 17
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: setting latency
timer to 64
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: Tunable
channels: 13 802.11bg, 23 802.11a channels
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: Detected Intel
Wireless WiFi Link 3945ABG
Dec 23 13:32:50 seduxbox kernel: phy0: Selected rate control algorithm
'iwl-3945-rs'
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A ->
GSI 17 (level, low) -> IRQ 17
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: irq 1274 for MSI/MSI-X
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: firmware:
requesting iwlwifi-3945-2.ucode
Dec 23 13:32:50 seduxbox kernel: iwl3945 0000:10:00.0: loaded firmware
version 15.28.2.8
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:radio
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:assoc
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:RX
Dec 23 13:32:50 seduxbox kernel: Registered led device: iwl-phy0:TX
Dec 23 13:32:50 seduxbox kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Dec 23 13:32:53 seduxbox kernel: wlan0: authenticate with AP 00:1c:4a:41:62:2e
Dec 23 13:32:53 seduxbox kernel: wlan0: authenticated
Dec 23 13:32:53 seduxbox kernel: wlan0: associate with AP 00:1c:4a:41:62:2e
Dec 23 13:32:53 seduxbox kernel: wlan0: RX AssocResp from
00:1c:4a:41:62:2e (capab=0x411 status=0 aid=1)
Dec 23 13:32:53 seduxbox kernel: wlan0: associated
Dec 23 13:32:53 seduxbox kernel: ADDRCONF(NETDEV_CHANGE): wlan0: link
becomes ready
Dec 23 13:32:54 seduxbox kernel: mac80211-phy0: failed to set key (1,
ff:ff:ff:ff:ff:ff) to hardware (-22)
Dec 23 13:33:03 seduxbox kernel: wlan0: no IPv6 routers present

[EOI] - End Of Investigations

On Tue, Dec 23, 2008 at 3:58 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Mon, 2008-12-22 at 22:07 +0800, Kalle Valo wrote:
>> Yes, ifconfig up works but now iwlist wlan0 scan crashes. I just
>> tested this once due to lack of time.
>>
>> I hope I get my wifi working before Christmas ;)
>
> http://marc.info/?l=linux-wireless&m=123000088608330&w=2 should fix the
> problem. Thanks a lot for your testing.
>
> Thanks,
> -yi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
