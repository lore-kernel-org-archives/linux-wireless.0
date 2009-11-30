Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48769 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZLALlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 06:41:39 -0500
Received: by fxm5 with SMTP id 5so4762604fxm.28
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 03:41:44 -0800 (PST)
Subject: BUG
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Plamen Vasilev <plamen.vasilev.vasilev@gmail.com>
Date: Mon, 30 Nov 2009 22:39:59 +0200
Message-Id: <A6493376-092E-4B87-93FE-61628CA62B59@gmail.com>
To: hostap@lists.shmoo.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I have D-LINK DWA-547 PCI card on my Gentoo based PC.
I'm using kernel 2.31.r8 with the latest drivers from the linux wireless site.

I have the following error from the kernel :

Nov 30 22:27:04 plamenvasilev kernel: [  493.171844] ------------[ cut here ]------------
Nov 30 22:27:04 plamenvasilev kernel: [  493.171952] WARNING: at /root/compat-wireless-2.6.31-rc7/net/mac80211/tx.c:1251 ieee80211_tx+0x5b/0x1ae [mac80211]()
Nov 30 22:27:04 plamenvasilev kernel: [  493.171960] Hardware name: Deskpro
Nov 30 22:27:04 plamenvasilev kernel: [  493.171965] Modules linked in: xt_state xt_TCPMSS xt_comment iptable_raw pppoe pppox ath9k mac80211 ath cfg80211
Nov 30 22:27:04 plamenvasilev kernel: [  493.171991] Pid: 0, comm: swapper Not tainted 2.6.31-gentoo-r6 #11
Nov 30 22:27:04 plamenvasilev kernel: [  493.171997] Call Trace:
Nov 30 22:27:04 plamenvasilev kernel: [  493.172026]  [<c102f339>] warn_slowpath_common+0x60/0x90
Nov 30 22:27:04 plamenvasilev kernel: [  493.172036]  [<c102f376>] warn_slowpath_null+0xd/0x10
Nov 30 22:27:04 plamenvasilev kernel: [  493.172069]  [<e0840765>] ieee80211_tx+0x5b/0x1ae [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172089]  [<c13c815b>] ? skb_release_data+0x8e/0x92
Nov 30 22:27:04 plamenvasilev kernel: [  493.172122]  [<e0840c3c>] ? ieee80211_skb_resize+0x72/0xa6 [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172155]  [<e08416a6>] ieee80211_master_start_xmit+0x334/0x362 [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172172]  [<c13cf0c2>] dev_hard_start_xmit+0x20e/0x2a1
Nov 30 22:27:04 plamenvasilev kernel: [  493.172196]  [<c13de226>] __qdisc_run+0xbf/0x19d
Nov 30 22:27:04 plamenvasilev kernel: [  493.172205]  [<c13cf496>] dev_queue_xmit+0x25b/0x350
Nov 30 22:27:04 plamenvasilev kernel: [  493.172237]  [<e0841359>] ieee80211_subif_start_xmit+0x6e9/0x702 [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172270]  [<e083f402>] ? __ieee80211_tx_prepare+0x2d4/0x311 [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172292]  [<c13c0000>] ? pci_fixup_nforce2+0x14/0x6f
Nov 30 22:27:04 plamenvasilev kernel: [  493.172313]  [<c1466dac>] ? packet_rcv_spkt+0xb9/0xc1
Nov 30 22:27:04 plamenvasilev kernel: [  493.172322]  [<c13cf0c2>] dev_hard_start_xmit+0x20e/0x2a1
Nov 30 22:27:04 plamenvasilev kernel: [  493.172331]  [<c13c71be>] ? skb_copy_bits+0x4b/0x18b
Nov 30 22:27:04 plamenvasilev kernel: [  493.172341]  [<c13de226>] __qdisc_run+0xbf/0x19d
Nov 30 22:27:04 plamenvasilev kernel: [  493.172350]  [<c13cf496>] dev_queue_xmit+0x25b/0x350
Nov 30 22:27:04 plamenvasilev kernel: [  493.172382]  [<e083c849>] ieee80211_deliver_skb+0xf9/0x101 [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172414]  [<e083dcac>] ieee80211_invoke_rx_handlers+0x145b/0x1b9e [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172425]  [<c13de24a>] ? __qdisc_run+0xe3/0x19d
Nov 30 22:27:04 plamenvasilev kernel: [  493.172457]  [<e0841359>] ? ieee80211_subif_start_xmit+0x6e9/0x702 [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172492]  [<e083e83c>] __ieee80211_rx_handle_packet+0x44d/0x45f [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172526]  [<e083ef83>] __ieee80211_rx+0x4b9/0x50a [mac80211]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172544]  [<c149fdc3>] ? _spin_unlock_bh+0xd/0xf
Nov 30 22:27:04 plamenvasilev kernel: [  493.172613]  [<e08a0b05>] ath_rx_send_to_mac80211+0x6b/0x72 [ath9k]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172640]  [<e08a11b6>] ath_rx_tasklet+0x628/0x670 [ath9k]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172656]  [<c104a6c0>] ? clockevents_program_event+0xd4/0xe3
Nov 30 22:27:04 plamenvasilev kernel: [  493.172668]  [<c104b52e>] ? tick_dev_program_event+0x28/0x95
Nov 30 22:27:04 plamenvasilev kernel: [  493.172677]  [<c1049040>] ? clocksource_get_next+0x3c/0x43
Nov 30 22:27:04 plamenvasilev kernel: [  493.172703]  [<e089f9b8>] ath9k_tasklet+0x44/0x91 [ath9k]
Nov 30 22:27:04 plamenvasilev kernel: [  493.172713]  [<c10331b9>] tasklet_action+0x62/0x9f
Nov 30 22:27:04 plamenvasilev kernel: [  493.172725]  [<c1033f0e>] __do_softirq+0xa7/0x144
Nov 30 22:27:04 plamenvasilev kernel: [  493.172734]  [<c1033fd1>] do_softirq+0x26/0x2b
Nov 30 22:27:04 plamenvasilev kernel: [  493.172742]  [<c10340b6>] irq_exit+0x29/0x5c
Nov 30 22:27:04 plamenvasilev kernel: [  493.172756]  [<c1003f6f>] do_IRQ+0x80/0x96
Nov 30 22:27:04 plamenvasilev kernel: [  493.172766]  [<c10030a9>] common_interrupt+0x29/0x30
Nov 30 22:27:04 plamenvasilev kernel: [  493.172766]  [<c1008065>] ? default_idle+0x42/0x5f
Nov 30 22:27:04 plamenvasilev kernel: [  493.172766]  [<c1001d4c>] cpu_idle+0x44/0x60
Nov 30 22:27:04 plamenvasilev kernel: [  493.172766]  [<c1483f97>] rest_init+0x53/0x55
Nov 30 22:27:04 plamenvasilev kernel: [  493.172766]  [<c17407d7>] start_kernel+0x2b1/0x2b6
Nov 30 22:27:04 plamenvasilev kernel: [  493.172766]  [<c174006a>] i386_start_kernel+0x6a/0x6f
Nov 30 22:27:04 plamenvasilev kernel: [  493.172766] ---[ end trace a8b664535fdf6c28 ]--- 

After some time of using the wireless i get the following :

Nov 30 22:33:47 plamenvasilev hostapd: wlan0: STA 00:1f:df:0e:dd:eb MLME: MLME-AUTHENTICATE.indication(00:1f:df:0e:dd:eb, OPEN_SYSTEM)
Nov 30 22:33:47 plamenvasilev hostapd: wlan0: STA 00:1f:df:0e:dd:eb MLME: MLME-DELETEKEYS.request(00:1f:df:0e:dd:eb)
Nov 30 22:33:47 plamenvasilev hostapd: wlan0: STA 00:1f:df:0e:dd:eb IEEE 802.11: authentication OK (open system)
Nov 30 22:33:47 plamenvasilev hostapd: wlan0: STA 00:1f:df:0e:dd:eb MLME: MLME-AUTHENTICATE.indication(00:1f:df:0e:dd:eb, OPEN_SYSTEM)
Nov 30 22:33:47 plamenvasilev hostapd: wlan0: STA 00:1f:df:0e:dd:eb MLME: MLME-DELETEKEYS.request(00:1f:df:0e:dd:eb)
Nov 30 22:33:47 plamenvasilev hostapd: wlan0: STA 00:1f:df:0e:dd:eb IEEE 802.11: authenticated
Nov 30 22:33:47 plamenvasilev hostapd: wlan0: STA 00:1f:df:0e:dd:eb IEEE 802.11: authenticated
Nov 30 22:36:14 plamenvasilev hostapd: wlan0: WPA rekeying GTK
Nov 30 22:36:14 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 WPA: sending 1/2 msg of Group Key Handshake
Nov 30 22:36:14 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 WPA: received EAPOL-Key frame (2/2 Group)
Nov 30 22:36:14 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 WPA: group key handshake completed (RSN)
Nov 30 22:36:48 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 WPA: event 2 notification
Nov 30 22:36:48 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 IEEE 802.1X: unauthorizing port
Nov 30 22:36:48 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 IEEE 802.11: disassociated
Nov 30 22:36:48 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 MLME: MLME-DISASSOCIATE.indication(00:1e:52:83:3f:f2, 8)
Nov 30 22:36:48 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 MLME: MLME-DELETEKEYS.request(00:1e:52:83:3f:f2)
Nov 30 22:36:49 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 IEEE 802.11: deauthenticated due to inactivity
Nov 30 22:36:49 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 MLME: MLME-DEAUTHENTICATE.indication(00:1e:52:83:3f:f2, 2)
Nov 30 22:36:49 plamenvasilev hostapd: wlan0: STA 00:1e:52:83:3f:f2 MLME: MLME-DELETEKEYS.request(00:1e:52:83:3f:f2)

After that i have to restart hostapd service because i cannot connect any more.
Any ideas ?