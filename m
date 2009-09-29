Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60403 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbZI2Tha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 15:37:30 -0400
Received: by iwn8 with SMTP id 8so3284896iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 12:37:33 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 29 Sep 2009 12:37:12 -0700
Message-ID: <43e72e890909291237q23c40b91xc45245d44a4c10d6@mail.gmail.com>
Subject: New cfg80211 warning on 2.6.32-rc<bleh>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got this while running my tests by booting with mem=300M and CPU downscaled.

  Luis

[ 2032.396393] phy4: Removed STA <ap-BSSID>
[ 2032.408522] phy4: Destroyed STA <ap-BSSID>
[ 2032.408542] wlan0: deauthenticating from <ap-BSSID> by local choice
(reason=3)
[ 2032.442906] phy4: device now idle
[ 2032.451837] ------------[ cut here ]------------
[ 2032.451876] WARNING: at net/wireless/core.c:613
wdev_cleanup_work+0xe9/0x110 [cfg80211]()
[ 2032.451883] Hardware name: 7660A14
[ 2032.451888] Modules linked in: ath5k(-) <bleh>
[ 2032.452072] Pid: 10, comm: events/1 Tainted: G        W  2.6.32-rc2-wl #45
[ 2032.452080] Call Trace:
[ 2032.452098]  [<ffffffff8105be78>] warn_slowpath_common+0x78/0xb0
[ 2032.452109]  [<ffffffff8105bebf>] warn_slowpath_null+0xf/0x20
[ 2032.452127]  [<ffffffffa00c25b9>] wdev_cleanup_work+0xe9/0x110 [cfg80211]
[ 2032.452144]  [<ffffffffa00c24d0>] ? wdev_cleanup_work+0x0/0x110 [cfg80211]
[ 2032.452156]  [<ffffffff81075c3e>] worker_thread+0x1fe/0x3b0
[ 2032.452165]  [<ffffffff81075bed>] ? worker_thread+0x1ad/0x3b0
[ 2032.452176]  [<ffffffff8107abf0>] ? autoremove_wake_function+0x0/0x40
[ 2032.452188]  [<ffffffff81075a40>] ? worker_thread+0x0/0x3b0
[ 2032.452198]  [<ffffffff8107a82e>] kthread+0x8e/0xa0
[ 2032.452209]  [<ffffffff8101300a>] child_rip+0xa/0x20
[ 2032.452221]  [<ffffffff81012990>] ? restore_args+0x0/0x30
[ 2032.452230]  [<ffffffff8107a7a0>] ? kthread+0x0/0xa0
[ 2032.452239]  [<ffffffff81013000>] ? child_rip+0x0/0x20
[ 2032.452245] ---[ end trace 7d678c5342bdcaab ]---
[ 2033.767265] ath5k 0000:03:00.0: PCI INT A disabled
