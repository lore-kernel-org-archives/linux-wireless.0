Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:61909 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZHRBEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 21:04:21 -0400
Received: by an-out-0708.google.com with SMTP id d40so3143614and.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 18:04:22 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 17 Aug 2009 18:04:02 -0700
Message-ID: <43e72e890908171804t2279c750j7baeaf37ad4ff205@mail.gmail.com>
Subject: Few warnings from master-2009-08-17
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This happens with ar9170 and ath9k:

First the driver/firmware/connect info:

Aug 17 17:45:06 tux kernel: [  380.596120] usb 1-3: firmware:
requesting ar9170.fw
Aug 17 17:45:06 tux kernel: [  381.024647] cfg80211: Calling CRDA for
country: US
Aug 17 17:45:06 tux kernel: [  381.026543] Registered led device:
ar9170-phy0::tx
Aug 17 17:45:06 tux kernel: [  381.027168] Registered led device:
ar9170-phy0::assoc
Aug 17 17:45:06 tux kernel: [  381.027177] usb 1-3: Atheros AR9170 is
registered as 'phy0'
Aug 17 17:45:06 tux kernel: [  381.027531] usbcore: registered new
interface driver ar9170usb
Aug 17 17:45:06 tux kernel: [  381.034544] cfg80211: Regulatory domain
changed to country: US
Aug 17 17:45:06 tux kernel: [  381.034550]      (start_freq - end_freq
@ bandwidth), (max_antenna_gain, max_eirp)
Aug 17 17:45:06 tux kernel: [  381.034554]      (2402000 KHz - 2472000
KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Aug 17 17:45:06 tux kernel: [  381.034557]      (5170000 KHz - 5250000
KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Aug 17 17:45:06 tux kernel: [  381.034561]      (5250000 KHz - 5330000
KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 17:45:06 tux kernel: [  381.034564]      (5490000 KHz - 5710000
KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 17:45:06 tux kernel: [  381.034568]      (5735000 KHz - 5835000
KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Aug 17 17:45:13 tux kernel: [  381.165048] udev: renamed network
interface wlan0 to wlan4
Aug 17 17:45:13 tux kernel: [  386.880442] ADDRCONF(NETDEV_UP): wlan4:
link is not ready
Aug 17 17:45:46 tux kernel: [  420.943787] ADDRCONF(NETDEV_CHANGE):
wlan4: link becomes ready
Aug 17 17:45:46 tux kernel: [  420.944740] cfg80211: Calling CRDA for
country: US
Aug 17 17:45:46 tux kernel: [  420.955876] cfg80211: Regulatory domain: US
Aug 17 17:45:46 tux kernel: [  420.955881]      (start_freq - end_freq
@ bandwidth), (max_antenna_gain, max_eirp)
Aug 17 17:45:46 tux kernel: [  420.955889]      (2402000 KHz - 2477000
KHz @ 40000 KHz), (10000 mBi, 10000 mBm)
Aug 17 17:45:46 tux kernel: [  420.955901] cfg80211: Regulatory domain: US
Aug 17 17:45:46 tux kernel: [  420.955905]      (start_freq - end_freq
@ bandwidth), (max_antenna_gain, max_eirp)
Aug 17 17:45:46 tux kernel: [  420.955913]      (2402000 KHz - 2472000
KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Aug 17 17:45:46 tux kernel: [  420.955921]      (5170000 KHz - 5250000
KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Aug 17 17:45:46 tux kernel: [  420.955928]      (5250000 KHz - 5330000
KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 17:45:46 tux kernel: [  420.955936]      (5490000 KHz - 5710000
KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 17:45:46 tux kernel: [  420.955943]      (5735000 KHz - 5835000
KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Aug 17 17:45:46 tux kernel: [  420.955954] cfg80211: Regulatory domain: 98
Aug 17 17:45:46 tux kernel: [  420.955959]      (start_freq - end_freq
@ bandwidth), (max_antenna_gain, max_eirp)
Aug 17 17:45:46 tux kernel: [  420.955966]      (2402000 KHz - 2472000
KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Aug 17 17:45:46 tux kernel: [  420.956346] cfg80211: Current
regulatory domain updated by AP to: US
Aug 17 17:45:46 tux kernel: [  420.956351]      (start_freq - end_freq
@ bandwidth), (max_antenna_gain, max_eirp)
Aug 17 17:45:50 tux kernel: [  420.956359]      (2402000 KHz - 2472000
KHz @ 40000 KHz), (300 mBi, 2700 mBm)


First warning:

Aug 17 17:45:50 tux kernel: [  424.812910] ------------[ cut here ]------------
Aug 17 17:45:50 tux kernel: [  424.812928] WARNING: at
net/wireless/sme.c:610 __cfg80211_disconnected+0x1fb/0x260
[cfg80211]()
Aug 17 17:45:50 tux kernel: [  424.812931] Hardware name: 7660A14
Aug 17 17:45:50 tux kernel: [  424.812933] deauth failed: -67
Aug 17 17:45:50 tux kernel: [  424.812935] Modules linked in:
ar9170usb mac80211 ath cfg80211 <bleh> [last unloaded: cfg80211]
Aug 17 17:45:50 tux kernel: [  424.813002] Pid: 5018, comm: phy0 Not
tainted 2.6.31-rc6-wl #139
Aug 17 17:45:50 tux kernel: [  424.813005] Call Trace:
Aug 17 17:45:50 tux kernel: [  424.813016]  [<ffffffff810585a8>]
warn_slowpath_common+0x78/0xb0
Aug 17 17:45:50 tux kernel: [  424.813020]  [<ffffffff8105863c>]
warn_slowpath_fmt+0x3c/0x40
Aug 17 17:45:50 tux kernel: [  424.813032]  [<ffffffffa00c782b>]
__cfg80211_disconnected+0x1fb/0x260 [cfg80211]
Aug 17 17:45:50 tux kernel: [  424.813043]  [<ffffffffa00c59f2>] ?
cfg80211_send_deauth+0x62/0x80 [cfg80211]
Aug 17 17:45:50 tux kernel: [  424.813054]  [<ffffffffa00c5918>]
__cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
Aug 17 17:45:50 tux kernel: [  424.813064]  [<ffffffffa00c5a01>]
cfg80211_send_deauth+0x71/0x80 [cfg80211]
Aug 17 17:45:50 tux kernel: [  424.813084]  [<ffffffffa021cbc0>]
ieee80211_sta_work+0x380/0x1100 [mac80211]
Aug 17 17:45:50 tux kernel: [  424.813098]  [<ffffffffa021c840>] ?
ieee80211_sta_work+0x0/0x1100 [mac80211]
Aug 17 17:45:50 tux kernel: [  424.813103]  [<ffffffff8106de80>]
worker_thread+0x1d0/0x380
Aug 17 17:45:50 tux kernel: [  424.813107]  [<ffffffff8106de2e>] ?
worker_thread+0x17e/0x380
Aug 17 17:45:50 tux kernel: [  424.813113]  [<ffffffff81073630>] ?
autoremove_wake_function+0x0/0x40
Aug 17 17:45:50 tux kernel: [  424.813117]  [<ffffffff8106dcb0>] ?
worker_thread+0x0/0x380
Aug 17 17:45:50 tux kernel: [  424.813121]  [<ffffffff81073266>]
kthread+0xa6/0xb0
Aug 17 17:45:50 tux kernel: [  424.813126]  [<ffffffff810130ca>]
child_rip+0xa/0x20
Aug 17 17:45:50 tux kernel: [  424.813132]  [<ffffffff81012a50>] ?
restore_args+0x0/0x30
Aug 17 17:45:50 tux kernel: [  424.813136]  [<ffffffff810731c0>] ?
kthread+0x0/0xb0
Aug 17 17:45:50 tux kernel: [  424.813140]  [<ffffffff810130c0>] ?
child_rip+0x0/0x20
Aug 17 17:45:54 tux kernel: [  424.813143] ---[ end trace 7ef91a8a6ee731a1 ]---
Aug 17 17:45:57 tux kernel: [  432.637525] ------------[ cut here ]------------

And it seems right after:

Aug 17 17:45:57 tux kernel: [  432.637557] WARNING: at
net/wireless/sme.c:610 __cfg80211_disconnected+0x1fb/0x260
[cfg80211]()
Aug 17 17:45:57 tux kernel: [  432.637564] Hardware name: 7660A14
Aug 17 17:45:57 tux kernel: [  432.637569] deauth failed: -67
Aug 17 17:45:57 tux kernel: [  432.637573] Modules linked in:
ar9170usb mac80211 ath cfg80211 <bleh> [last unloaded: cfg80211]
Aug 17 17:45:57 tux kernel: [  432.637726] Pid: 5018, comm: phy0
Tainted: G        W  2.6.31-rc6-wl #139
Aug 17 17:45:57 tux kernel: [  432.637732] Call Trace:
Aug 17 17:45:57 tux kernel: [  432.637749]  [<ffffffff810585a8>]
warn_slowpath_common+0x78/0xb0
Aug 17 17:45:57 tux kernel: [  432.637759]  [<ffffffff8105863c>]
warn_slowpath_fmt+0x3c/0x40
Aug 17 17:45:57 tux kernel: [  432.637784]  [<ffffffffa00c782b>]
__cfg80211_disconnected+0x1fb/0x260 [cfg80211]
Aug 17 17:45:57 tux kernel: [  432.637809]  [<ffffffffa00c59f2>] ?
cfg80211_send_deauth+0x62/0x80 [cfg80211]
Aug 17 17:45:57 tux kernel: [  432.637832]  [<ffffffffa00c5918>]
__cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
Aug 17 17:45:57 tux kernel: [  432.637856]  [<ffffffffa00c5a01>]
cfg80211_send_deauth+0x71/0x80 [cfg80211]
Aug 17 17:45:57 tux kernel: [  432.637892]  [<ffffffffa021cbc0>]
ieee80211_sta_work+0x380/0x1100 [mac80211]
Aug 17 17:45:57 tux kernel: [  432.637923]  [<ffffffffa021c840>] ?
ieee80211_sta_work+0x0/0x1100 [mac80211]
Aug 17 17:45:57 tux kernel: [  432.637934]  [<ffffffff8106de80>]
worker_thread+0x1d0/0x380
Aug 17 17:45:57 tux kernel: [  432.637943]  [<ffffffff8106de2e>] ?
worker_thread+0x17e/0x380
Aug 17 17:45:57 tux kernel: [  432.637954]  [<ffffffff81073630>] ?
autoremove_wake_function+0x0/0x40
Aug 17 17:45:57 tux kernel: [  432.637964]  [<ffffffff8106dcb0>] ?
worker_thread+0x0/0x380
Aug 17 17:45:57 tux kernel: [  432.637973]  [<ffffffff81073266>]
kthread+0xa6/0xb0
Aug 17 17:45:57 tux kernel: [  432.637983]  [<ffffffff810130ca>]
child_rip+0xa/0x20
Aug 17 17:45:57 tux kernel: [  432.637995]  [<ffffffff81012a50>] ?
restore_args+0x0/0x30
Aug 17 17:46:06 tux kernel: [  432.638004]  [<ffffffff810731c0>] ?
kthread+0x0/0xb0
Aug 17 17:46:06 tux kernel: [  432.638013]  [<ffffffff810130c0>] ?
child_rip+0x0/0x20
Aug 17 17:46:06 tux kernel: [  432.638019] ---[ end trace 7ef91a8a6ee731a2 ]---


It seems I can get the second warning triggered when I disconnect due
to no probe response from AP:


[ 1060.261105] No probe response from AP <AP-MAC-ADDRESS>after 500ms,
disconnecting.
[ 1060.264257] phy1: device now idle
[ 1060.268293] phy1: Removed STA <AP-MAC-ADDRESS>
[ 1060.290788] phy1: Destroyed STA <AP-MAC-ADDRESS>
[ 1060.290961] wlan6: deauthenticating by local choice (reason=3)
[ 1060.291025] ------------[ cut here ]------------
[ 1060.291057] WARNING: at net/wireless/sme.c:610
__cfg80211_disconnected+0x1fb/0x260 [cfg80211]()
[ 1060.291064] Hardware name: 7660A14
[ 1060.291069] deauth failed: -67
[ 1060.291073] Modules linked in: ar9170usb mac80211 ath cfg80211
<bleh> [last unloaded: ar9170usb]
[ 1060.291230] Pid: 5525, comm: phy1 Tainted: G        W  2.6.31-rc6-wl #139
[ 1060.291237] Call Trace:
[ 1060.291252]  [<ffffffff810585a8>] warn_slowpath_common+0x78/0xb0
[ 1060.291262]  [<ffffffff8105863c>] warn_slowpath_fmt+0x3c/0x40
[ 1060.291287]  [<ffffffffa018682b>]
__cfg80211_disconnected+0x1fb/0x260 [cfg80211]
[ 1060.291312]  [<ffffffffa01849f2>] ? cfg80211_send_deauth+0x62/0x80 [cfg80211]
[ 1060.291336]  [<ffffffffa0184918>]
__cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
[ 1060.291359]  [<ffffffffa0184a01>] cfg80211_send_deauth+0x71/0x80 [cfg80211]
[ 1060.291394]  [<ffffffffa03d9c1f>]
ieee80211_send_deauth_disassoc+0x14f/0x170 [mac80211]
[ 1060.291425]  [<ffffffffa03dd52b>] ieee80211_sta_work+0xceb/0x1100 [mac80211]
[ 1060.291456]  [<ffffffffa03dc840>] ? ieee80211_sta_work+0x0/0x1100 [mac80211]
[ 1060.291466]  [<ffffffff8106de80>] worker_thread+0x1d0/0x380
[ 1060.291475]  [<ffffffff8106de2e>] ? worker_thread+0x17e/0x380
[ 1060.291487]  [<ffffffff8152977b>] ? _spin_unlock_irqrestore+0x3b/0x70
[ 1060.291499]  [<ffffffff81073630>] ? autoremove_wake_function+0x0/0x40
[ 1060.291509]  [<ffffffff8106dcb0>] ? worker_thread+0x0/0x380
[ 1060.291518]  [<ffffffff81073266>] kthread+0xa6/0xb0
[ 1060.291529]  [<ffffffff810130ca>] child_rip+0xa/0x20
[ 1060.291540]  [<ffffffff81012a50>] ? restore_args+0x0/0x30
[ 1060.291549]  [<ffffffff810731c0>] ? kthread+0x0/0xb0
[ 1060.291557]  [<ffffffff810130c0>] ? child_rip+0x0/0
[ 1060.291564] ---[ end trace 7ef91a8a6ee731a3 ]---
[ 1060.428931] phy1: device no longer idle - scanning
[ 1068.424002] phy1: device now idle
[ 1073.259516] phy1: device no longer idle - scanning
[ 1081.234199] phy1: device now idle
[ 1086.357427] phy1: device no longer idle - scanning
[ 1094.366167] phy1: device now idle
[ 1099.247884] phy1: device no longer idle - scanning

Then I got this one with ath9k:

[ 1354.441346] wlan3: deauthenticating by local choice (reason=3)
[ 1354.442954] phy0: Removed STA <AP-MAC-ADDRESS>
[ 1354.454405] phy0: Destroyed STA <AP-MAC-ADDRESS>
[ 1354.489555] phy0: device now idle
[ 1354.569311] ------------[ cut here ]------------
[ 1354.569323] WARNING: at kernel/mutex.c:207 __mutex_lock_common+0x39b/0x3d0()
[ 1354.569326] Hardware name: 7660A14
[ 1354.569329] Modules linked in: ath9k(-) mac80211 ath cfg80211
<bleh>  [last unloaded: cfg80211]
[ 1354.569402] Pid: 10, comm: events/1 Tainted: G        W  2.6.31-rc6-wl #139
[ 1354.569406] Call Trace:
[ 1354.569412]  [<ffffffff810585a8>] warn_slowpath_common+0x78/0xb0
[ 1354.569416]  [<ffffffff810585ef>] warn_slowpath_null+0xf/0x20
[ 1354.569421]  [<ffffffff81527f7b>] __mutex_lock_common+0x39b/0x3d0
[ 1354.569435]  [<ffffffffa00c752a>] ?
cfg80211_sme_scan_done+0x4a/0x150 [cfg80211]
[ 1354.569445]  [<ffffffffa00c752a>] ?
cfg80211_sme_scan_done+0x4a/0x150 [cfg80211]
[ 1354.569450]  [<ffffffff81528091>] mutex_lock_nested+0x41/0x50
[ 1354.569459]  [<ffffffffa00c752a>] cfg80211_sme_scan_done+0x4a/0x150
[cfg80211]
[ 1354.569469]  [<ffffffffa00b9b9a>] ___cfg80211_scan_done+0x3a/0xd0 [cfg80211]
[ 1354.569479]  [<ffffffffa00b9c30>] ? __cfg80211_scan_done+0x0/0x50 [cfg80211]
[ 1354.569488]  [<ffffffffa00b9c30>] ? __cfg80211_scan_done+0x0/0x50 [cfg80211]
[ 1354.569497]  [<ffffffffa00b9c54>] __cfg80211_scan_done+0x24/0x50 [cfg80211]
[ 1354.569502]  [<ffffffff8106de80>] worker_thread+0x1d0/0x380
[ 1354.569506]  [<ffffffff8106de2e>] ? worker_thread+0x17e/0x380
[ 1354.569510]  [<ffffffff81073630>] ? autoremove_wake_function+0x0/0x40
[ 1354.569514]  [<ffffffff8106dcb0>] ? worker_thread+0x0/0x380
[ 1354.569518]  [<ffffffff81073266>] kthread+0xa6/0xb0
[ 1354.569523]  [<ffffffff810130ca>] child_rip+0xa/0x20
[ 1354.569528]  [<ffffffff81012a50>] ? restore_args+0x0/0x30
[ 1354.569532]  [<ffffffff810731c0>] ? kthread+0x0/0xb0
[ 1354.569535]  [<ffffffff810130c0>] ? child_rip+0x0/0x20
[ 1354.569538] ---[ end trace 7ef91a8a6ee731a4 ]---
[ 1354.816457] ath9k 0000:16:00.0: PCI INT A disabled
[ 1354.816833] ath9k: Driver unloaded

  Luis
