Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:58862 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab0JGPSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 11:18:47 -0400
Received: from p5099b351.dip0.t-ipconnect.de ([80.153.179.81] helo=zzz.local)
	by bar.sig21.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.63)
	(envelope-from <js@sig21.net>)
	id 1P3sF3-0002sp-6K
	for linux-wireless@vger.kernel.org; Thu, 07 Oct 2010 17:18:46 +0200
Received: from js by zzz.local with local (Exim 4.72)
	(envelope-from <js@sig21.net>)
	id 1P3sF2-0000px-MV
	for linux-wireless@vger.kernel.org; Thu, 07 Oct 2010 17:18:44 +0200
Date: Thu, 7 Oct 2010 17:18:44 +0200
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org
Subject: 2.6.36-rc7 warning in __cfg80211_auth_remove
Message-ID: <20101007151844.GB3183@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

just got the following while testing with rt73usb on
kernel 2.6.36-rc7 with wpa_supplicant v0.6.10:

wlan0: authentication with 00:22:b0:xx:xx:xx timed out
------------[ cut here ]------------
WARNING: at net/wireless/mlme.c:284 __cfg80211_auth_remove+0xc3/0xd0 [cfg80211]()
Hardware name: GA-MA78GM-S2H
Modules linked in: rt73usb rt2x00usb rt2x00lib mac80211 cfg80211 ppdev kvm_amd kvm ohci_hcd firewire_ohci firewire_core 
Pid: 1167, comm: kworker/u:3 Not tainted 2.6.36-rc7 #1
Call Trace:
 [<ffffffff81040979>] warn_slowpath_common+0x85/0x9d
 [<ffffffff810409ab>] warn_slowpath_null+0x1a/0x1c
 [<ffffffffa002d980>] __cfg80211_auth_remove+0xc3/0xd0 [cfg80211]
 [<ffffffffa002e27c>] cfg80211_send_auth_timeout+0x93/0xaa [cfg80211]
 [<ffffffffa00b12a7>] ? rt2x00mac_config+0x5e/0x68 [rt2x00lib]
 [<ffffffffa004c3eb>] ieee80211_probe_auth_done+0x2a/0x97 [mac80211]
 [<ffffffffa004e551>] ieee80211_work_work+0xecd/0xf3e [mac80211]
 [<ffffffffa004d684>] ? ieee80211_work_work+0x0/0xf3e [mac80211]
 [<ffffffff810595df>] process_one_work+0x29e/0x449
 [<ffffffff81059b42>] worker_thread+0x1db/0x34d
 [<ffffffff81059967>] ? worker_thread+0x0/0x34d
 [<ffffffff8105cdbe>] kthread+0x82/0x8a
 [<ffffffff810030a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81044976>] ? do_exit+0x6c2/0x6d1
 [<ffffffff814e5343>] ? _raw_spin_unlock_irq+0x21/0x3c
 [<ffffffff814e5d41>] ? restore_args+0x0/0x30
 [<ffffffff8105cd3c>] ? kthread+0x0/0x8a
 [<ffffffff810030a0>] ? kernel_thread_helper+0x0/0x10
---[ end trace 1603934106686627 ]---


AP is also rt73usb in other machine, using WPA and hostapd 0.7.3.


Johannes
