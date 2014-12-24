Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50966 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaLXDKI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 22:10:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Y3cKr-0005IG-7i
	for linux-wireless@vger.kernel.org; Wed, 24 Dec 2014 04:10:05 +0100
Received: from 106.216.241.166 ([106.216.241.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2014 04:10:05 +0100
Received: from tg.kiran by 106.216.241.166 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2014 04:10:05 +0100
To: linux-wireless@vger.kernel.org
From: TGK <tg.kiran@igate.com>
Subject: MAC80211 dynamic powersave freeze
Date: Wed, 24 Dec 2014 02:57:56 +0000 (UTC)
Message-ID: <loom.20141224T035621-218@post.gmane.org> (sfid-20141224_041013_450915_AAC8463D)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are facing  a lot of wireless related problems for  one  of products 
deployed at customer place . The customer is reporting frequent freeze/crash 
of the system. 
We have never been able to reproduce this problem in our lab, but in a 
wireless environment with many Access points, the crash does occur quite 
frequently when the system moves from one AP to another

Our product’s Linux kernel is based on 2.6.2 and we are using compat-3.3.n 
drivers for PCI based ath9k card

Having investigated the logs, we have observed that the crash is mainly 
occurring due to mac80211 dynamic power save module.  Following information 
is recorded in log every time prior to crash/system freeze.

 ---------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----
un  1 17:18:46 test kernel: [10176.378049] wlan0: moving STA 
00:22:55:f2:ff:09 to state 1
Jun  1 17:18:46 test kernel: [10176.378052] wlan0: moving STA 
00:22:55:f2:ff:09 to state 0
Jun  1 17:18:46 test kernel: [10176.388077] wlan0: associate with 
00:22:55:f3:34:69 (try 1)
Jun  1 17:18:46 test kernel: [10176.392344] wlan0: RX ReassocResp from 
00:22:55:f3:34:69 (capab=0x431 status=0 aid=129)
Jun  1 17:18:46 test kernel: [10176.392348] wlan0: associated
Jun  1 17:18:46 test kernel: [10176.392352] wlan0: moving STA 
00:22:55:f3:34:69 to state 1
Jun  1 17:18:46 test kernel: [10176.392354] wlan0: moving STA 
00:22:55:f3:34:69 to state 2
Jun  1 17:18:46 test kernel: [10176.410656] wlan0: moving STA 
00:22:55:f3:34:69 to state 3
Jun  1 17:19:48 test kernel: [10238.735122] wlan0: authenticate with 
00:22:55:44:62:76 (try 1)
Jun  1 17:19:48 test kernel: [10238.834021] ------------[ cut here ]--------
----
Jun  1 17:19:48 test kernel: [10238.834060] WARNING: at 
/usr/local/src/compat-wireless-3.3-2-n/net/mac80211/tx.c:767 
invoke_tx_handlers+0xb20/0x13c0 [mac80211]()
Jun  1 17:19:48 test kernel: [10238.834064] Hardware name: OEM-A1901-00
Jun  1 17:19:48 test kernel: [10238.834145] Call Trace:
Jun  1 17:19:48 test kernel: [10238.834160]  [<ffffffff81005ca9>] 
dump_trace+0x79/0x340
Jun  1 17:19:48 test kernel: [10238.834168]  [<ffffffff814a0bb4>] 
dump_stack+0x69/0x6f
Jun  1 17:19:48 test kernel: [10238.834176]  [<ffffffff81051993>] 
warn_slowpath_common+0x73/0xb0
Jun  1 17:19:48 test kernel: [10238.834196]  [<ffffffffa0412640>] 
invoke_tx_handlers+0xb20/0x13c0 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834248]  [<ffffffffa04130b7>] 
ieee80211_tx+0x87/0x130 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834302]  [<ffffffffa041320c>] 
ieee80211_xmit+0xac/0x150 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834347]  [<ffffffffa0414477>] 
ieee80211_tx_skb_tid+0x57/0x70 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834395]  [<ffffffffa03fea90>] 
ieee80211_dynamic_ps_enable_work+0x2b0/0x4c0 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834416]  [<ffffffff8106e010>] 
run_workqueue+0xb0/0x1d0
Jun  1 17:19:48 test kernel: [10238.834422]  [<ffffffff8106e1cb>] 
worker_thread+0x9b/0x100
Jun  1 17:19:48 test kernel: [10238.834429]  [<ffffffff8107167e>] 
kthread+0x8e/0xa0
Jun  1 17:19:48 test kernel: [10238.834435]  [<ffffffff81003df4>] 
kernel_thread_helper+0x4/0x10
Jun  1 17:19:48 test kernel: [10238.834440] ---[ end trace 5490dac9b02f8a16 
]---
Jun  1 17:19:48 test kernel: [10238.834444] ------------[ cut here ]--------
----
Jun  1 17:19:48 test kernel: [10238.834462] WARNING: at 
/usr/local/src/compat-wireless-3.3-2-n/net/mac80211/tx.c:55 
invoke_tx_handlers+0x1325/0x13c0 [mac80211]()
Jun  1 17:19:48 test kernel: [10238.834572] Call Trace:
Jun  1 17:19:48 test kernel: [10238.834579]  [<ffffffff81005ca9>] 
dump_trace+0x79/0x340
Jun  1 17:19:48 test kernel: [10238.834585]  [<ffffffff814a0bb4>] 
dump_stack+0x69/0x6f
Jun  1 17:19:48 test kernel: [10238.834591]  [<ffffffff81051993>] 
warn_slowpath_common+0x73/0xb0
Jun  1 17:19:48 test kernel: [10238.834611]  [<ffffffffa0412e45>] 
invoke_tx_handlers+0x1325/0x13c0 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834657]  [<ffffffffa04130b7>] 
ieee80211_tx+0x87/0x130 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834701]  [<ffffffffa041320c>] 
ieee80211_xmit+0xac/0x150 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834746]  [<ffffffffa0414477>] 
ieee80211_tx_skb_tid+0x57/0x70 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834790]  [<ffffffffa03fea90>] 
ieee80211_dynamic_ps_enable_work+0x2b0/0x4c0 [mac80211]
Jun  1 17:19:48 test kernel: [10238.834809]  [<ffffffff8106e010>] 
run_workqueue+0xb0/0x1d0
Jun  1 17:19:48 test kernel: [10238.834814]  [<ffffffff8106e1cb>] 
worker_thread+0x9b/0x100
Jun  1 17:19:48 test kernel: [10238.834820]  [<ffffffff8107167e>] 
kthread+0x8e/0xa0
Jun  1 17:19:48 test kernel: [10238.834825]  [<ffffffff81003df4>] 
kernel_thread_helper+0x4/0x10
Jun  1 17:19:48 test kernel: [10238.834829] ---[ end trace 5490dac9b02f8a17 
]---
Jun  1 17:19:49 test kernel: [10239.431272] wlan0: authenticate with 
00:22:55:44:62:76 (try 2)
Jun  1 17:19:49 test kernel: [10239.631216] wlan0: authenticate with 
00:22:55:44:62:76 (try 3)
Jun  1 17:19:49 test kernel: [10239.831018] wlan0: authentication with 
00:22:55:44:62:76 timed out
Jun  1 17:19:49 test kernel: [10239.841324] ath: Failed to stop TX DMA, 
queues=0x001!
Jun  1 17:19:49 test kernel: [10239.848357] ------------[ cut here ]--------
----
Jun  1 17:19:49 test kernel: [10239.848375] WARNING: at 
/usr/local/src/compat-wireless-3.3-2-
n/drivers/net/wireless/ath/ath9k/rc.c:794 ath_rc_get_highest_rix+0x1f6/0x210 
[ath9k]()
Jun  1 17:19:49 test kernel: [10239.848459] Call Trace:
Jun  1 17:19:49 test kernel: [10239.848474]  [<ffffffff81005ca9>] 
dump_trace+0x79/0x340
Jun  1 17:19:49 test kernel: [10239.848482]  [<ffffffff814a0bb4>] 
dump_stack+0x69/0x6f
Jun  1 17:19:49 test kernel: [10239.848490]  [<ffffffff81051993>] 
warn_slowpath_common+0x73/0xb0
Jun  1 17:19:49 test kernel: [10239.848498]  [<ffffffffa04e4fc6>] 
ath_rc_get_highest_rix+0x1f6/0x210 [ath9k]
Jun  1 17:19:49 test kernel: [10239.848524]  [<ffffffffa04e5068>] 
ath_get_rate+0x88/0x470 [ath9k]
Jun  1 17:19:49 test kernel: [10239.848561]  [<ffffffffa040646e>] 
rate_control_get_rate+0x8e/0x150 [mac80211]
Jun  1 17:19:49 test kernel: [10239.848599]  [<ffffffffa0412508>] 
invoke_tx_handlers+0x9e8/0x13c0 [mac80211]
Jun  1 17:19:49 test kernel: [10239.848645]  [<ffffffffa04130b7>] 
ieee80211_tx+0x87/0x130 [mac80211]
Jun  1 17:19:49 test kernel: [10239.848689]  [<ffffffffa041320c>] 
ieee80211_xmit+0xac/0x150 [mac80211]
Jun  1 17:19:49 test kernel: [10239.848733]  [<ffffffffa0414477>] 
ieee80211_tx_skb_tid+0x57/0x70 [mac80211]
Jun  1 17:19:49 test kernel: [10239.848775]  [<ffffffffa03f6e67>] 
ieee80211_offchannel_return+0x187/0x1f0 [mac80211]
Jun  1 17:19:49 test kernel: [10239.848802]  [<ffffffffa0401b81>] 
ieee80211_work_work+0x5e1/0x18c0 [mac80211]
Jun  1 17:19:49 test kernel: [10239.848824]  [<ffffffff8106e010>] 
run_workqueue+0xb0/0x1d0
Jun  1 17:19:49 test kernel: [10239.848830]  [<ffffffff8106e1cb>] 
worker_thread+0x9b/0x100
Jun  1 17:19:49 test kernel: [10239.848836]  [<ffffffff8107167e>] 
kthread+0x8e/0xa0
Jun  1 17:19:49 test kernel: [10239.848841]  [<ffffffff81003df4>] 
kernel_thread_helper+0x4/0x10
Jun  1 17:19:49 test kernel: [10239.848854] ---[ end trace 5490dac9b02f8a18 
]---
Jun  1 17:19:50 test kernel: [10240.854337] ath: Failed to stop TX DMA, 
queues=0x001!

----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
 

 Beyond this point, the system is rendered useless and only option left is 
to reboot the system

Would highly appreciate, if the following queries are clarified

1.       Is this a known issue? Is there anyway to reproduce it in a lab 
environment

2.       Is there a fix available  in latest/recent version of compat or 
backports. In which version of compat is thee fix available?

3.       If I disable dynamic power save in mac80211, would it solve my 
problem?


regards
TGK

