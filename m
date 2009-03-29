Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57796 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZC2EuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 00:50:16 -0400
Received: by fxm2 with SMTP id 2so1519944fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 21:50:13 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: p54spi - mesh mode summary
Date: Sun, 29 Mar 2009 07:41:59 +0300
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903280621.02362.jcmvbkbc@gmail.com> <200903282251.42585.chunkeey@web.de>
In-Reply-To: <200903282251.42585.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903290841.59902.jcmvbkbc@gmail.com> (sfid-20090329_065040_052446_7FECBBC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> your last patches had some offset, do you have more code fixes or
> does everything work (properly)?
The offset is caused by the fact that I haven't merged in changes that has been done since 2009.01.09.
Now I've cherry-picked all recent patches related to p54, and IBSS and mesh are working good.

There are 3 issues that I'm focused on now:

- 'cx3110x spi2.0: WR_READY timeout' which sometimes occurs on ifdown-ifup cycle. Communication
  with firmware breaks and sometimes the box hangs altogether. It looks like some locking-concurrency
  issue, but I still haven't found it for sure;

- this, which happens every time when IBSS or mesh starts:
<7>[  211.754448] wlan0: Creating new IBSS network, BSSID 56:75:0c:c5:65:0d
<7>[  213.681352] phy0: Adding new IBSS station 00:1d:6e:9b:ee:6d (dev=wlan0)
<7>[  213.681443] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<4>[  213.684251] ------------[ cut here ]------------
<4>[  213.691850] WARNING: at kernel/softirq.c:138 local_bh_enable+0x54/0xbc()
<4>[  213.699571] Modules linked in: p54spi
<4>[  213.707231] [<c0034ff8>] (dump_stack+0x0/0x14) from [<c005b1f0>] (warn_on_slowpath+0x4c/0x68)
<4>[  213.715623] [<c005b1a4>] (warn_on_slowpath+0x0/0x68) from [<c006051c>] (local_bh_enable+0x54/0xbc)
<4>[  213.732041]  r6:c7cc4e00 r5:c7840380 r4:c04594a0
<4>[  213.740464] [<c00604c8>] (local_bh_enable+0x0/0xbc) from [<bf000038>] (p54spi_op_tx+0x38/0x4c [p54spi])
<4>[  213.757829]  r4:c7cc4e00
<4>[  213.766221] [<bf000000>] (p54spi_op_tx+0x0/0x4c [p54spi]) from [<c01a4d98>] (p54_sta_unlock+0x64/0x78)
<4>[  213.784135]  r5:c7cc41a0 r4:c7840380
<4>[  213.793016] [<c01a4d34>] (p54_sta_unlock+0x0/0x78) from [<c01a4dd4>] (p54_sta_notify+0x28/0x2c)
<4>[  213.802507]  r7:c7971380 r6:c7cc41a0 r5:60000013 r4:c79cd400
<4>[  213.812120] [<c01a4dac>] (p54_sta_notify+0x0/0x2c) from [<c02e0a60>] (sta_info_insert+0x128/0x19c)
<4>[  213.831681] [<c02e0938>] (sta_info_insert+0x0/0x19c) from [<c02e7b90>] (ieee80211_ibss_add_sta+0x150/0x170)
<4>[  213.852830]  r8:00000000 r7:c79cd400 r6:c7971380 r5:00000000 r4:c0416500
<4>[  213.863786] [<c02e7a40>] (ieee80211_ibss_add_sta+0x0/0x170) from [<c02e7e3c>] (ieee80211_rx_bss_info+0x188/0x48c)
<4>[  213.886033]  r8:c701ee24 r7:00000000 r6:00000fff r5:c701ee24 r4:c701ee2e
<4>[  213.897386] [<c02e7cb4>] (ieee80211_rx_bss_info+0x0/0x48c) from [<c02e8fac>] (ieee80211_sta_work+0x388/0xfe8)
<4>[  213.919816] [<c02e8c24>] (ieee80211_sta_work+0x0/0xfe8) from [<c006b2bc>] (run_workqueue+0xa8/0x124)
<4>[  213.942948] [<c006b214>] (run_workqueue+0x0/0x124) from [<c006be20>] (worker_thread+0xec/0x100)
<4>[  213.955003]  r6:c79764e0 r5:c79dc000 r4:c79764e8
<4>[  213.966783] [<c006bd34>] (worker_thread+0x0/0x100) from [<c006ee28>] (kthread+0x5c/0x94)
<4>[  213.978746]  r6:c006bd34 r5:c79764e0 r4:c79dc000
<4>[  213.990586] [<c006edcc>] (kthread+0x0/0x94) from [<c005dd48>] (do_exit+0x0/0x6cc)
<4>[  214.002580]  r6:00000000 r5:00000000 r4:00000000
<4>[  214.014238] ---[ end trace 3652d538aa1ad903 ]---

- infinite beacon resubmission loop in IBSS which causes severe performance degradation, not to mention radio noise.

Before TSF sync loss:
(none):~# ping -s 50000 192.168.4.14
PING 192.168.4.14 (192.168.4.14): 50000 data bytes
50008 bytes from 192.168.4.14: seq=0 ttl=64 time=130.4 ms
50008 bytes from 192.168.4.14: seq=1 ttl=64 time=129.9 ms
50008 bytes from 192.168.4.14: seq=2 ttl=64 time=130.4 ms
50008 bytes from 192.168.4.14: seq=3 ttl=64 time=132.9 ms
50008 bytes from 192.168.4.14: seq=4 ttl=64 time=133.6 ms

After:
(none):~# ifconfig wlan0 down
(none):~# ifconfig wlan0 up
(none):~# ping -s 50000 192.168.4.14
PING 192.168.4.14 (192.168.4.14): 50000 data bytes
50008 bytes from 192.168.4.14: seq=1 ttl=64 time=629.1 ms
50008 bytes from 192.168.4.14: seq=2 ttl=64 time=825.8 ms
50008 bytes from 192.168.4.14: seq=3 ttl=64 time=421.2 ms
50008 bytes from 192.168.4.14: seq=4 ttl=64 time=745.5 ms
50008 bytes from 192.168.4.14: seq=5 ttl=64 time=548.0 ms
50008 bytes from 192.168.4.14: seq=6 ttl=64 time=296.1 ms
50008 bytes from 192.168.4.14: seq=7 ttl=64 time=501.2 ms

Hope that I make patches for at least first two issues during the next few days.

-- 
Thanks a lot (:
-- Max
