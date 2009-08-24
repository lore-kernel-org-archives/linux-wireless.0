Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:35231 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbZHXIJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 04:09:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KOV009Q8G028H40@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 24 Aug 2009 10:09:38 +0200 (CEST)
Received: from [137.226.12.123]
 (informatik-4-137-226-12-123.nn.RWTH-Aachen.DE [137.226.12.123] (may be
 forged))	by relay.rwth-aachen.de (8.13.8+Sun/8.13.8/1)
 with ESMTP id n7O89cBG002151	for <linux-wireless@vger.kernel.org>; Mon,
 24 Aug 2009 10:09:38 +0200 (CEST)
Message-id: <4A924A99.9020203@nets.rwth-aachen.de>
Date: Mon, 24 Aug 2009 10:08:57 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WARNING: at include/net/mac80211.h:2104 minstrel_get_rate
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I managed to trigger the following warning (for the first time)
on 2.6.31-rc6. Never seen this in rc3,4,5 but maybe I was
just lucky this time.

[854748.332641] wlan0: associated
[854756.240475] ------------[ cut here ]------------
[854756.254840] WARNING: at include/net/mac80211.h:2104 minstrel_get_rate+0x78/0x48a [mac80211]()
[854756.280793] Modules linked in: xt_state ipt_MASQUERADE aes_generic ipt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 arc4 ecb ath5k mac80211 ehci_hcd ath ohci_hcd
[854756.331887] Pid: 2554, comm: wpa_supplicant Not tainted 2.6.31-rc6-ah0 #8
[854756.352601] Call Trace:
[854756.360408]  [<d08873e0>] ? minstrel_get_rate+0x78/0x48a [mac80211]
[854756.379597]  [<c1012746>] warn_slowpath_common+0x60/0x77
[854756.395887]  [<c101276a>] warn_slowpath_null+0xd/0x10
[854756.411487]  [<d08873e0>] minstrel_get_rate+0x78/0x48a [mac80211]
[854756.430129]  [<c113b665>] ? vsnprintf+0xceb/0xd62
[854756.444692]  [<d087ba06>] rate_control_get_rate+0x82/0xc9 [mac80211]
[854756.464190]  [<d0880fd3>] invoke_tx_handlers+0x4f9/0xb37 [mac80211]
[854756.483347]  [<c1058d12>] ? pollwake+0x0/0x59
[854756.496872]  [<d0880849>] ? __ieee80211_tx_prepare+0x2a5/0x2fc [mac80211]
[854756.517656]  [<d08819da>] ieee80211_tx+0xa9/0x199 [mac80211]
[854756.535056]  [<d08820b6>] ieee80211_master_start_xmit+0x280/0x290 [mac80211]
[854756.556562]  [<c119f641>] dev_hard_start_xmit+0x1c2/0x24a
[854756.573136]  [<c11acf67>] __qdisc_run+0xb4/0x172
[854756.587352]  [<c11a1c79>] dev_queue_xmit+0x1b9/0x2a8
[854756.602611]  [<c124d7c3>] ? nl80211_send_deauth+0xd/0x11
[854756.618976]  [<d0883582>] ieee80211_tx_skb+0x4e/0x51 [mac80211]
[854756.637185]  [<d0877739>] ieee80211_send_deauth_disassoc+0xfc/0x104 [mac80211]
[854756.659283]  [<d087788a>] ieee80211_set_disassoc+0xf5/0x1f9 [mac80211]
[854756.679303]  [<d087a571>] ieee80211_sta_req_auth+0x5b/0x9a [mac80211]
[854756.699039]  [<d0872a51>] ieee80211_ioctl_siwfreq+0x10b/0x13e [mac80211]
[854756.719498]  [<c1247209>] ioctl_standard_call+0x4b/0x26c
[854756.735791]  [<c1259159>] ? __mutex_lock_slowpath+0x17e/0x186
[854756.753398]  [<c1246f57>] wext_handle_ioctl+0xe2/0x179
[854756.769228]  [<d0872946>] ? ieee80211_ioctl_siwfreq+0x0/0x13e [mac80211]
[854756.789710]  [<c11a0e76>] dev_ioctl+0x554/0x57e
[854756.803693]  [<c11947d2>] ? sys_sendto+0xa1/0xc0
[854756.817911]  [<c1194f45>] ? sys_recvfrom+0x96/0xb7
[854756.832652]  [<c122882a>] ? packet_bind+0x50/0x66
[854756.847117]  [<c11954b8>] ? sock_ioctl+0x0/0x1ee
[854756.861333]  [<c119569a>] sock_ioctl+0x1e2/0x1ee
[854756.875555]  [<c11954b8>] ? sock_ioctl+0x0/0x1ee
[854756.889781]  [<c1056e99>] vfs_ioctl+0x19/0x50
[854756.903235]  [<c10576eb>] do_vfs_ioctl+0x446/0x47a
[854756.917974]  [<c1194809>] ? sys_send+0x18/0x1a
[854756.931677]  [<c1195280>] ? sys_socketcall+0xbb/0x165
[854756.947179]  [<c105774b>] sys_ioctl+0x2c/0x45
[854756.960605]  [<c1002715>] syscall_call+0x7/0xb
[854756.974302] ---[ end trace cd3397cce4cc2497 ]---
[854764.311238] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX


Best regards,
Arnd
