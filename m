Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42031 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2AOGFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jan 2012 01:05:06 -0500
Received: by eekd4 with SMTP id d4so1524713eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jan 2012 22:05:04 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Jan 2012 00:05:03 -0600
Message-ID: <CAGb7EHeHGWQBeT=XRtNQRX_96ZLz-4eMgM9mzt85g5UtOiEQ_A@mail.gmail.com> (sfid-20120115_070540_308946_2F523A5C)
Subject: brcmsmac on Broadcom 4313[14e4:4727] in HP dm1-4010us - connection
 timeouts, dropped connection, poor signal strenght
From: vincent mortellaro <vinhsynd@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Machine:
HP dm1-4010us
Broadcom 4313 [14e4:4727] with integrated Broadcom 20702 Bluetooth

Software:
Default installation of Fedora 16
"$uname -r": 3.1.7-1.fc16.x86_64


Summary of symptoms:
After initial installation of Fedora 16 with updates to kernel 3.1.7,
network manager shows a functional brcm4313
with wireless networks within range. However, all networks have 1 - 2
bars of signal, and connection to networks
may take up to 30+seconds when standing within 3 ft of the router or
not at all over 10ft distant without an obstruction.
Connections that are established have frequent time-outs when browsing
the internet, disconnections from the router
with inability to re-establish a connection. This behaviour occurs in
both WPA encrypted and unencrypted networks.

What I've tried:

I started with the FAQ check list on linuxwireless.org, below is
output I encountered from each of the steps:

First, this is the output from $dmesg with the Fedora 16 x86_64 kernel
3.1.7-1 version of
ieee80211, brcmsmac, cfg80211, wlan0 outputs (This one is not from
immediately after login):

$dmesg
[ 5546.472374] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: false (implement)
[ 5546.472399] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed:
disassociated
[ 5546.472413] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled false, count 1 (implement)
[ 5546.472428] wlan0: deauthenticating from 26:4e:7f:40:9b:76 by local
choice (reason=3)
[ 5546.478142] cfg80211: Calling CRDA to update world regulatory domain
[ 5546.509539] cfg80211: World regulatory domain updated:
[ 5546.509547] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 5546.509553] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5546.509557] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[ 5546.509561] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[ 5546.509565] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5546.509569] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5546.509592] cfg80211: Calling CRDA for country: US
[ 5546.520696] cfg80211: Regulatory domain changed to country: US
[ 5546.520703] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 5546.520708] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2700 mBm)
[ 5546.520713] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 1700 mBm)
[ 5546.520717] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5546.520721] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5546.520725] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5546.520729] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 3000 mBm)
[ 5567.191248] ieee80211 phy0: brcms_ops_config: change monitor mode:
false (implement)
[ 5567.191260] ieee80211 phy0: brcms_ops_config: change power-save
mode: false (implement)
[ 5567.192256] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: false (implement)
[ 5567.193273] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 5616.345041] wlan0: authenticate with 20:4e:7f:40:9b:76 (try 1)
[ 5616.346922] wlan0: authenticated
[ 5616.347976] wlan0: associate with 20:4e:7f:40:9b:76 (try 1)
[ 5616.356245] wlan0: RX AssocResp from 20:4e:7f:40:9b:76 (capab=0x431
status=0 aid=3)
[ 5616.356255] wlan0: associated
[ 5616.356812] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: true (implement)
[ 5616.356826] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 5616.356833] ieee80211 phy0: changing basic rates failed: -22
[ 5616.356839] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 0 (implement)
[ 5616.357800] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 5616.392720] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[ 5627.010110] wlan0: no IPv6 routers present
[ 5637.003395] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 1 (implement)


I have tried googling for "wlan0: deauthenticating from
26:4e:7f:40:9b:76 by local choice (reason=3)"
 and "ieee80211 phy0: changing basic rates failed: -22" but I was not
able to find
information I could understand how to use.

Additionally, this is the output from "$ rfkill list" with the default
modules included with
Fedora 16 x86_64 kernel 3.1.7-1:

0: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
1: hp-wifi: Wireless LAN
	Soft blocked: no
	Hard blocked: no
2: hp-bluetooth: Bluetooth
	Soft blocked: no
	Hard blocked: no
3: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no



I then installed the stable compat-wireless drivers from linuxwireless.org.
I used "$ ./scripts/driver-select brcm80211" to pick the drivers to compile.
There were 4 warnings from $make:

/home/vincent/Downloads/compat-wireless-3.2-1-s/net/wireless/core.c:7:0:
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the
previous definition
/home/vincent/Downloads/compat-wireless-3.2-1-s/net/wireless/reg.c:36:0:
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the
previous definition
/home/vincent/Downloads/compat-wireless-3.2-1-s/net/wireless/lib80211.c:16:0:
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the
previous definition
/home/vincent/Downloads/compat-wireless-3.2-1-s/net/wireless/lib80211_crypt_tkip.c:13:0:
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the
previous definition

There were issues with "$make install".
I confirmed the output from "$sudo make install" to be sure that
updated modules
were used after installation as instructed by the FAQ:

updates/net/mac80211/mac80211.ko
updates/net/wireless/cfg80211.ko
updates/net/wireless/lib80211.ko
updates/net/wireless/lib80211_crypt_ccmp.ko
updates/net/wireless/lib80211_crypt_tkip.ko
updates/net/wireless/lib80211_crypt_wep.ko

I then performed a "$sudo reboot" since "$ sudo make wlunload"
reported fatal errors that
mac80211 and cfg80211 were still in use.

Below is the output from dmesg and rfkill with the
compat-wireless-3.2-1-s version
of the brcm80211 drivers immediately after log:

$dmesg
[   20.826225] cfg80211: Calling CRDA to update world regulatory domain
[   21.281904] cfg80211: World regulatory domain updated:
[   21.281910] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   21.281915] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   21.281920] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   21.281924] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   21.281928] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   21.281932] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   21.606925] brcmsmac 0000:03:00.0: bus 3 slot 0 func 0 irq 3
[   21.606970] brcmsmac 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   21.606981] brcmsmac 0000:03:00.0: setting latency timer to 64
[   24.448777] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   24.451976] cfg80211: Calling CRDA for country: XV
[   26.725646] ieee80211 phy0: brcms_ops_config: change monitor mode:
false (implement)
[   26.725657] ieee80211 phy0: brcms_ops_config: change power-save
mode: false (implement)
[   26.726655] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: false (implement)
[   26.727567] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  126.945272] wlan0: authenticate with 26:4e:7f:40:9b:76 (try 1)
[  126.947070] wlan0: authenticated
[  126.947706] wlan0: associate with 26:4e:7f:40:9b:76 (try 1)
[  126.953931] wlan0: RX AssocResp from 26:4e:7f:40:9b:76 (capab=0x421
status=0 aid=1)
[  126.953945] wlan0: associated
[  126.954502] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: true (implement)
[  126.954526] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[  126.954539] ieee80211 phy0: changing basic rates failed: -22
[  126.954550] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 0 (implement)
[  126.956332] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  126.958902] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[  127.017967] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[  127.026809] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: true (implement)
[  135.021482] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 1 (implement)
[  135.023558] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[  137.928875] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[  137.929656] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[  137.930167] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[  208.892247] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU

$rfkill list
0: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
1: hp-wifi: Wireless LAN
	Soft blocked: no
	Hard blocked: no
2: hp-bluetooth: Bluetooth
	Soft blocked: no
	Hard blocked: no
3: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no

The symptoms at this point are the exact same as in summary on a
default installation of Fedora 16.

I then tried to use iw to connect to an unencrypted wireless network
in order to bypass Network Manager.
I did this by first turning off wireless networking in the nm-applet
and then turning it back on
without having it join a network. I found when i felt wireless "off"
in the nm-applet it gave a soft block in rfkill.

I used "$ sudo iw wlan0 connect $SSID" which reported "wlan0 (phy #0):
connected to $BSSID".
However, when I followed with "$ sudo iw wlan0 link" it reported "Not
Connected".

dmesg after this transaction shows:
[  817.823171] ieee80211 phy0: brcms_ops_config: change monitor mode:
false (implement)
[  817.823182] ieee80211 phy0: brcms_ops_config: change power-save
mode: false (implement)
[  817.824322] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: false (implement)
[  817.825483] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  839.430644] wlan0: authenticate with 26:4e:7f:40:9b:76 (try 1)
[  839.432229] wlan0: authenticated
[  839.432365] wlan0: associate with 26:4e:7f:40:9b:76 (try 1)
[  839.438215] wlan0: RX AssocResp from 26:4e:7f:40:9b:76 (capab=0x421
status=0 aid=1)
[  839.438230] wlan0: associated
[  839.438757] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: true (implement)
[  839.438781] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[  839.438795] ieee80211 phy0: changing basic rates failed: -22
[  839.438806] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 0 (implement)
[  839.440633] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  839.440828] wlan0: disassociating from 26:4e:7f:40:9b:76 by local
choice (reason=3)
[  839.441666] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: false (implement)
[  839.441687] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed:
disassociated
[  839.441700] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled false, count 0 (implement)
[  839.441739] wlan0: deauthenticating from 26:4e:7f:40:9b:76 by local
choice (reason=3)
[  839.448270] cfg80211: Calling CRDA to update world regulatory domain
[  839.460877] cfg80211: World regulatory domain updated:
[  839.460885] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  839.460890] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  839.460895] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  839.460899] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  839.460903] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  839.460907] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  839.460940] cfg80211: Calling CRDA for country: US
[  839.468440] cfg80211: Regulatory domain changed to country: US
[  839.468446] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  839.468451] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2700 mBm)
[  839.468455] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 1700 mBm)
[  839.468459] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  839.468463] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  839.468467] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  839.468471] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 3000 mBm)
[  850.002117] wlan0: no IPv6 routers present

I never was able to get "$ sudo iw wlan0 link" to show I had a connection.

I then proceeded to try the "bleeding-edge" compat-wireless driver
from today's build.
However, after the same steps as with stable compat-wireless,
rebooting the newest build left me
with non recognized wireless card. So I've reverted back to the stable
compat-wireless version,
that still has the symptoms summarized above.

At this point I'm unsure where I may have went wrong or how to further proceed.
But I am very willing to run any further tests needed to clarify the
issue I'm having.

Thank you for taking to time to read this.
-Vince

PS: I will be at work and away from the affected machine from Sunday
6am US Central Time until Monday 10am
US Central Time. I realize this is a pretty fast moving mailing list
and will try to answer any questions tomorrow
in a timely fashion, but won't be able to do any tests until Monday morning.
