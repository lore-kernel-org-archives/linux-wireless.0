Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38137 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZLIGDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 01:03:39 -0500
Received: by pwj9 with SMTP id 9so2136698pwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 22:03:45 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Dec 2009 22:03:45 -0800
Message-ID: <fd145f7d0912082203l1d7ebc50j291cc36dd65a4408@mail.gmail.com>
Subject: WARNING at mac80211_ieee80211_rx
From: Jeffrey Baker <jwbaker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My access point with an AR9220 stopped passing traffic, and these were
seen in dmesg.  I am using compat-wireless 2009-11-06.

also at pastebin: http://pastebin.com/m527862e9

[505869.263259] ------------[ cut here ]-----------		-
[505869.269520] WARNING: at
/root/compat-wireless-2009-11-06/net/mac80211/rx.c:2486
mac80211_ieee80211_rx+0xc9/0x51a [mac80211]()
[505869.273388] Modules linked in: bridge stp loop arc4 ath9k evdev
ath9k_hw snd_pcsp ohci_hcd mac80211 ath snd_pcm ehci_hcd snd_timer ecb
aes_i586 snd soundcore aes_generic cfg80211 snd_page_alloc usbcore
geode_aes rfkill_backport via_rhine geode_rng cs5535_gpio rng_core mii
led_class ext2 mbcache ide_gd_mod thermal_sys ide_pci_generic
ata_generic libata scsi_mod amd74xx cs5536 ide_core
[505869.372485] Pid: 0, comm: swapper Tainted: G        W  2.6.30-2-486 #1
[505869.376345] Call Trace:
[505869.380338]  [<d0bcf12f>] ? mac80211_ieee80211_rx+0xc9/0x51a [mac80211]
[505869.384236]  [<d0bcf12f>] ? mac80211_ieee80211_rx+0xc9/0x51a [mac80211]
[505869.388353]  [<c011e7dc>] ? warn_slowpath_common+0x5e/0x8a
[505869.393089]  [<c011e812>] ? warn_slowpath_null+0xa/0xc
[505869.397070]  [<d0bcf12f>] ? mac80211_ieee80211_rx+0xc9/0x51a [mac80211]
[505869.401013]  [<d0caf4b4>] ? ath_rx_tasklet+0x739/0x780 [ath9k]
[505869.404946]  [<c012f4c6>] ? ktime_get+0xf/0x2b
[505869.408423]  [<c0130b80>] ? commit_creds+0x57/0xec
[505869.412401]  [<c0130804>] ? sched_clock_tick+0x63/0x137
[505869.415073]  [<d0cad928>] ? ath9k_tasklet+0x3f/0xa1 [ath9k]
[505869.420072]  [<c0121e01>] ? tasklet_action+0x49/0x79
[505869.424054]  [<c0122163>] ? __do_softirq+0x82/0x125
[505869.427238]  [<c0122233>] ? do_softirq+0x2d/0x37
[505869.432319]  [<c01222f6>] ? irq_exit+0x25/0x4e
[505869.436302]  [<c0104614>] ? do_IRQ+0x53/0x63
[505869.439044]  [<c0103609>] ? common_interrupt+0x29/0x30
[505869.443025]  [<c01135fc>] ? native_safe_halt+0x2/0x3
[505869.446729]  [<c0107ce7>] ? default_idle+0x3c/0x65
[505869.452591]  [<c0102336>] ? cpu_idle+0x28/0x42
[505869.456573]  [<c0402925>] ? start_kernel+0x291/0x294
[505869.461386] ---[ end trace 65ec8d5e106d761d ]---
