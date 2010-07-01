Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63648 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0GAXak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 19:30:40 -0400
Received: by vws5 with SMTP id 5so2984512vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jul 2010 16:30:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Jul 2010 16:30:38 -0700
Message-ID: <AANLkTim6y6TkwpmIe4tsyymy5_jIzbw2ri6z1jIRMuz1@mail.gmail.com>
Subject: Bringing up a virtual wiphy on AR9160 brings down the node
From: Javier Cardona <javier@cozybit.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

We are trying to bring up two virtual wiphys on an AR9160 with not luck.
Creation succeeds, but bringin up an interface on either wihpy locks up the
target in what appears to be an infinite loop of warnings.  More details follow:

- Hardware

phy0: Atheros AR9160 MAC/BB Rev:0 AR5133 RF Rev:b0 mem=0xc8d20000, irq=5

- Wiphy creation

# echo add >> /sys/kernel/debug/ath9k/phy0/wiphy
# cat /sys/kernel/debug/ath9k/phy0/wiphy

primary: phy0 (INACTIVE chan=0 ht=0)
secondary: phy1 (INACTIVE chan=0 ht=0)
addr: 00:00:00:00:00:00
addrmask: ff:ff:ff:ff:ff:ff

- Bring up interface

iwconfig wlan0 essid cozyssid1
ifconfig wlan0 up

Device locks up.  Logs at the bottom of this e-mail.

- Versions tested

version d41229637fb42737ff792271b8f0ac9752de9cb8 (wireless-testing
HEAD as of jun 30 2010)
version 062bee448bd539580ef9f64efe50fdfe04eeb103 (wireless-2.6 HEAD as
of jun 30 2010)
version e40152ee1e1c7a63f4777791863215e3faa37a86 (linux-2.6  v2.6.34 )

We have a dedicated target for this, so we can quickly test patches or
diffent kernel versions.
Does anyone know if virtual wiphys should work on the AR9160 ?

Thanks!

Javier

== Log for wireless-testing kernel d41229637fb42737ff792271b8f0ac9752de9cb8 ==

Jul  1 15:56:52 192.168.1.89 [  625.948014] Pid: 657, comm: udevd
Tainted: G        W   2.6.35-rc3-wl+ #36
Jul  1 15:56:52 192.168.1.89 [  625.948523] Call Trace:
Jul  1 15:56:52 192.168.1.89 [  625.949019]  [<c022159d>]
warn_slowpath_common+0x65/0x7a
Jul  1 15:56:52 192.168.1.89 [  625.949779]  [<c8d4db4f>] ?
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:52 192.168.1.89 [  625.950459]  [<c02215c1>]
warn_slowpath_null+0xf/0x13
Jul  1 15:56:53 192.168.1.89 [  625.951321]  [<c8d4db4f>]
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:53 192.168.1.89 [  625.952010]  [<c0503ec5>] ? skb_copy+0x2e/0x83
Jul  1 15:56:53 192.168.1.89 [  625.952506]  [<c050195a>] ?
copy_skb_header+0x1b/0x7a
Jul  1 15:56:53 192.168.1.89 [  625.953135]  [<c0503f10>] ? skb_copy+0x79/0x83
Jul  1 15:56:53 192.168.1.89 [  625.953697]  [<c8f43545>]
ath_rx_send_to_mac80211+0x47/0x60 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  625.954440]  [<c8f445f9>]
ath_rx_tasklet+0xb1a/0xbc7 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  625.955110]  [<c0296115>] ?
do_sync_write+0x89/0xc4
Jul  1 15:56:53 192.168.1.89 [  625.987465]  [<c050195a>] ?
copy_skb_header+0x1b/0x7a
Jul  1 15:56:53 192.168.1.89 [  626.037154]  [<c0503ec5>] ? skb_copy+0x2e/0x83
Jul  1 15:56:53 192.168.1.89  cfg80211
Jul  1 15:56:53 192.168.1.89 [  626.129764]  [<c0202c69>]
common_interrupt+0x29/0x30
Jul  1 15:56:53 192.168.1.89 [  626.173011]  [<c050195a>] ?
copy_skb_header+0x1b/0x7a
Jul  1 15:56:53 192.168.1.89 [  626.214305]  [<c02034b7>] do_IRQ+0x61/0x74
Jul  1 15:56:53 192.168.1.89 [  626.259421]  [<c8f43545>]
ath_rx_send_to_mac80211+0x47/0x60 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  626.307313]  [<c8d4db4f>]
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:53 192.168.1.89  ath9k_common
Jul  1 15:56:53 192.168.1.89 [  626.426786]  [<c02259fa>] do_softirq+0x25/0x2a
Jul  1 15:56:53 192.168.1.89 [  626.482399]  [<c02034b7>] do_IRQ+0x61/0x74
Jul  1 15:56:53 192.168.1.89 [  626.542467]  [<c0503ec5>] ? skb_copy+0x2e/0x83
Jul  1 15:56:53 192.168.1.89 [  626.599719]  [<c02259fa>] do_softirq+0x25/0x2a
Jul  1 15:56:53 192.168.1.89 [  626.658443]  [<c8d4db4f>] ?
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:53 192.168.1.89 [  626.713817]  [<c0503f10>] ? skb_copy+0x79/0x83
Jul  1 15:56:53 192.168.1.89 [  626.763933]  [<c050195a>] ?
copy_skb_header+0x1b/0x7a
Jul  1 15:56:53 192.168.1.89  ath
Jul  1 15:56:53 192.168.1.89 [  626.863347]  [<c8d4db4f>] ?
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:53 192.168.1.89 [  626.916466]  [<c0503ec5>] ? skb_copy+0x2e/0x83
Jul  1 15:56:53 192.168.1.89 [  626.966157]  [<c8d4db4f>]
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:53 192.168.1.89 [  627.021193]  [<c8f4072f>] ?
ath9k_iowrite32+0x36/0x3a [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.073978]  [<c02259fa>] do_softirq+0x25/0x2a
Jul  1 15:56:53 192.168.1.89 [  627.129802] WARNING: at
net/mac80211/rx.c:2615 ieee80211_rx+0x64/0x72d [mac80211]()
Jul  1 15:56:53 192.168.1.89 [  627.186867]  [<c8d4db4f>]
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:53 192.168.1.89 [  627.242171]  [<c8f445f9>]
ath_rx_tasklet+0xb1a/0xbc7 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.293765]  [<c8f4072f>] ?
ath9k_iowrite32+0x36/0x3a [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.341849]  [<c0503f10>] ? skb_copy+0x79/0x83
Jul  1 15:56:53 192.168.1.89 [  627.386080] Hardware name: Uknown
Jul  1 15:56:53 192.168.1.89 [  627.430741]  [<c02250e8>]
tasklet_action+0x40/0x67
Jul  1 15:56:53 192.168.1.89 [  627.477316]  [<c0503ec5>] ? skb_copy+0x2e/0x83
Jul  1 15:56:53 192.168.1.89 [  627.517866]  [<c02259fa>] do_softirq+0x25/0x2a
Jul  1 15:56:53 192.168.1.89 [  627.554554] ------------[ cut here
]------------
Jul  1 15:56:53 192.168.1.89 [  627.585662]  [<c0225933>]
__do_softirq+0x91/0x133
Jul  1 15:56:53 192.168.1.89 [  627.616025]  [<c8f445f9>]
ath_rx_tasklet+0xb1a/0xbc7 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.648940]  [<c8f43545>]
ath_rx_send_to_mac80211+0x47/0x60 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.683115]  [<c8f445f9>]
ath_rx_tasklet+0xb1a/0xbc7 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.715819]  [<c050195a>] ?
copy_skb_header+0x1b/0x7a
Jul  1 15:56:53 192.168.1.89 [  627.749672]  [<c050195a>] ?
copy_skb_header+0x1b/0x7a
Jul  1 15:56:53 192.168.1.89 [  627.782008]  [<c8d4db4f>]
ieee80211_rx+0x64/0x72d [mac80211]
Jul  1 15:56:53 192.168.1.89 [  627.811240] Hardware name: Uknown
Jul  1 15:56:53 192.168.1.89 [  627.837036]  [<c8f445f9>]
ath_rx_tasklet+0xb1a/0xbc7 [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.865451]  [<c022159d>]
warn_slowpath_common+0x65/0x7a
Jul  1 15:56:53 192.168.1.89 [  627.894958] WARNING: at
net/mac80211/rx.c:2615 ieee80211_rx+0x64/0x72d [mac80211]()
Jul  1 15:56:53 192.168.1.89 [  627.923736]  [<c8f4278f>]
ath9k_tasklet+0x8f/0x11f [ath9k]
Jul  1 15:56:53 192.168.1.89 [  627.953563]  [<c050195a>] ?
copy_skb_header+0x1b/0x7a
Jul  1 15:56:53 192.168.1.89 [  627.985001]  [<c02215c1>]
warn_slowpath_null+0xf/0x13
Jul  1 15:56:53 192.168.1.89 [  628.019969]  [<c0503ec5>] ? skb_copy+0x2e/0x83
Jul  1 15:56:53 192.168.1.89 [  628.055442]  [<c0503f10>] ? skb_copy+0x79/0x83
Jul  1 15:56:53 192.168.1.89 [  628.093201]  [<c0225933>]
__do_softirq+0x91/0x133
Jul  1 15:56:53 192.168.1.89  ath9k_common


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
