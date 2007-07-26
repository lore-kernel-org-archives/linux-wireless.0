Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:38370 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756054AbXGZKmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 06:42:54 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id EF5558CAD8
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 12:42:49 +0200 (CEST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 6C51510442
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 10:44:35 +0000 (UTC)
Message-ID: <46A87AAB.6010900@warmcat.com>
Date: Thu, 26 Jul 2007 11:42:51 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwl3945: adding virtual interface interrupts association
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

Current wireless-dev, iwl3945 associated on WPA network okay

# echo -n "mon0" > /sys/class/ieee80211/phy0/add_iface

interrupts the association to the AP:

wlan0: associated
wlan0: switched to short barker preamble (BSSID=00:11:50:ad:ce:38)

(stable like this until mon0 created...)

PM: Adding info for No Bus:mon0
BUG: sleeping function called from invalid context at mm/slab.c:3024
in_atomic():1, irqs_disabled():0
2 locks held by wpa_supplicant/30143:
 #0:  (rtnl_mutex){--..}, at: [<c0621387>] mutex_lock+0x21/0x24
 #1:  (&local->sta_bss_lock){-+..}, at: [<f8a36362>]
ieee80211_sta_scan_results+0x43/0x6b8 [mac80211]
 [<c0405f35>] show_trace_log_lvl+0x1a/0x2f
 [<c0406927>] show_trace+0x12/0x14
 [<c040693f>] dump_stack+0x16/0x18
 [<c0423fb4>] __might_sleep+0xce/0xd5
 [<c047c9d9>] kmem_cache_alloc+0x3b/0xee
 [<f8a367ca>] ieee80211_sta_scan_results+0x4ab/0x6b8 [mac80211]
 [<f8a2d2c9>] ieee80211_ioctl_giwscan+0x3d/0x53 [mac80211]
 [<c061c918>] ioctl_standard_call+0x1f9/0x2c5
 [<c061ca90>] wext_handle_ioctl+0xac/0x375
 [<c05bf83f>] dev_ioctl+0x3e5/0x404
 [<c05b3e41>] sock_ioctl+0x1be/0x1c9
 [<c048ae72>] do_ioctl+0x22/0x67
 [<c048b100>] vfs_ioctl+0x249/0x25c
 [<c048b15c>] sys_ioctl+0x49/0x61
 [<c0404ed2>] sysenter_past_esp+0x5f/0x99
 =======================
BUG: scheduling while atomic: wpa_supplicant/0x10000100/30143
2 locks held by wpa_supplicant/30143:
 #0:  (rtnl_mutex){--..}, at: [<c0621387>] mutex_lock+0x21/0x24
 #1:  (&local->sta_bss_lock){-+..}, at: [<f8a36362>]
ieee80211_sta_scan_results+0x43/0x6b8 [mac80211]
 [<c0405f35>] show_trace_log_lvl+0x1a/0x2f
 [<c0406927>] show_trace+0x12/0x14
 [<c040693f>] dump_stack+0x16/0x18
 [<c0426959>] __schedule_bug+0x51/0x57
 [<c061fcc8>] __sched_text_start+0x78/0x764
 [<c0426984>] __cond_resched+0x25/0x3c
 [<c062041a>] cond_resched+0x26/0x31
 [<c047c9de>] kmem_cache_alloc+0x40/0xee
 [<f8a367ca>] ieee80211_sta_scan_results+0x4ab/0x6b8 [mac80211]
 [<f8a2d2c9>] ieee80211_ioctl_giwscan+0x3d/0x53 [mac80211]
 [<c061c918>] ioctl_standard_call+0x1f9/0x2c5
 [<c061ca90>] wext_handle_ioctl+0xac/0x375
 [<c05bf83f>] dev_ioctl+0x3e5/0x404
 [<c05b3e41>] sock_ioctl+0x1be/0x1c9
 [<c048ae72>] do_ioctl+0x22/0x67
 [<c048b100>] vfs_ioctl+0x249/0x25c
 [<c048b15c>] sys_ioctl+0x49/0x61
 [<c0404ed2>] sysenter_past_esp+0x5f/0x99
 =======================
wlan0: RX WEP frame with unknown keyidx 1 (A1=ff:ff:ff:ff:ff:ff
A2=00:11:50:ad:ce:38 A3=00:13:77:04:c6:ba)
wlan0: RX WEP frame with unknown keyidx 1 (A1=ff:ff:ff:ff:ff:ff
A2=00:11:50:ad:ce:38 A3=00:13:77:04:c6:ba)
... (more of these "unknown keyidx")

association is re-established after some time by wpa_supplicant, but the
break in association seems to be specifically caused by adding the
virtual interface.

-Andy
