Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:3807 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLBU7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:59:48 -0500
Received: from gollum.odi.ch ([77.56.180.60]) by viefep27-int.chello.at
          (InterMail vM.7.09.01.00 201-2219-108-20080618) with ESMTP
          id <20081202205933.CCAH26032.viefep27-int.chello.at@gollum.odi.ch>
          for <linux-wireless@vger.kernel.org>;
          Tue, 2 Dec 2008 21:59:33 +0100
Received: from [192.168.111.10] (mithril [192.168.111.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gollum.odi.ch (Postfix) with ESMTPSA id EEF72100C6
	for <linux-wireless@vger.kernel.org>; Tue,  2 Dec 2008 21:59:31 +0100 (CET)
Message-ID: <4935A1B3.1090906@odi.ch> (sfid-20081202_215953_296698_F030BA08)
Date: Tue, 02 Dec 2008 21:59:31 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WARNING: at net/mac80211/mlme.c:2249
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just played around with 2.6.28-rc7 and this warning showed up right after
connecting to my AP. It's a MacBook Pro with an Atheros AR5008. Hope that means
something to you.

Cheers,

Ortwin

Dec  2 21:49:19 mithril wlan0: direct probe to AP 00:09:5b:69:af:da try 1
Dec  2 21:49:19 mithril wlan0 direct probe responded
Dec  2 21:49:19 mithril wlan0: authenticate with AP 00:09:5b:69:af:da
Dec  2 21:49:19 mithril wlan0: authenticate with AP 00:09:5b:69:af:da
Dec  2 21:49:19 mithril wlan0: authenticated
Dec  2 21:49:19 mithril wlan0: associate with AP 00:09:5b:69:af:da
Dec  2 21:49:19 mithril wlan0: RX AssocResp from 00:09:5b:69:af:da (capab=0x411
status=0 aid=1)
Dec  2 21:49:19 mithril wlan0: associated
Dec  2 21:49:19 mithril ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Dec  2 20:49:20 mithril avahi-daemon[7430]: Registering new address record for
fe80::217:f2ff:feee:59ce on wlan0.*.
Dec  2 21:49:23 mithril ------------[ cut here ]------------
Dec  2 21:49:23 mithril WARNING: at net/mac80211/mlme.c:2249
ieee80211_sta_work+0xee7/0x1000()
Dec  2 21:49:23 mithril Modules linked in: rfcomm ip6t_LOG nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 snd_hda_intel ohci1394 uvcvideo compat_ioctl32
videodev v4l1_compat appletouch
Dec  2 21:49:23 mithril Pid: 954, comm: ath9k Not tainted 2.6.28-rc7 #4
Dec  2 21:49:23 mithril Call Trace:
Dec  2 21:49:23 mithril [<c012d8a4>] warn_on_slowpath+0x54/0x70
Dec  2 21:49:23 mithril [<c038f5b0>] ? dev_queue_xmit+0xc0/0x4f0
Dec  2 21:49:23 mithril [<c0136d95>] ? lock_timer_base+0x25/0x50
Dec  2 21:49:23 mithril [<c0136ee2>] ? __mod_timer+0xa2/0xc0
Dec  2 21:49:23 mithril [<c042eac7>] ? _spin_unlock_bh+0x17/0x20
Dec  2 21:49:23 mithril [<c040a65a>] ? ieee80211_rx_bss_get+0x8a/0xa0
Dec  2 21:49:23 mithril [<c040a708>] ? ieee80211_rx_bss_put+0x98/0xb0
Dec  2 21:49:23 mithril [<c040c1c9>] ? ieee80211_privacy_mismatch+0x89/0xb0
Dec  2 21:49:23 mithril [<c0410127>] ieee80211_sta_work+0xee7/0x1000
Dec  2 21:49:23 mithril [<c0232009>] ? __delay+0x9/0x10
Dec  2 21:49:23 mithril [<c011fbf1>] ? update_curr+0x91/0x110
Dec  2 21:49:23 mithril [<c012105e>] ? hrtick_update+0x2e/0x30
Dec  2 21:49:23 mithril [<c012958c>] ? dequeue_task_fair+0x3c/0x50
Dec  2 21:49:23 mithril [<c011f60c>] ? dequeue_task+0xdc/0x140
Dec  2 21:49:23 mithril [<c0124a5d>] ? finish_task_switch+0x2d/0x90
Dec  2 21:49:23 mithril [<c042cbfb>] ? schedule+0x3fb/0x9a0
Dec  2 21:49:23 mithril [<c013d65e>] run_workqueue+0x7e/0x120
Dec  2 21:49:23 mithril [<c040f240>] ? ieee80211_sta_work+0x0/0x1000
Dec  2 21:49:23 mithril [<c013e079>] worker_thread+0x99/0xf0
Dec  2 21:49:23 mithril [<c0140e30>] ? autoremove_wake_function+0x0/0x50
Dec  2 21:49:23 mithril [<c013dfe0>] ? worker_thread+0x0/0xf0
Dec  2 21:49:23 mithril [<c0140b12>] kthread+0x42/0x70
Dec  2 21:49:23 mithril [<c0140ad0>] ? kthread+0x0/0x70
Dec  2 21:49:23 mithril [<c010401f>] kernel_thread_helper+0x7/0x18
Dec  2 21:49:23 mithril ---[ end trace 815970fc36fc4a24 ]---
