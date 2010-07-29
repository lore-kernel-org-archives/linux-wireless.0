Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43661 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab0G2LWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 07:22:08 -0400
Received: from sits by silver.sucs.swan.ac.uk with local (Exim 4.69)
	(envelope-from <sits@sucs.org>)
	id 1OeQhb-0006FT-QM
	for linux-wireless@vger.kernel.org; Thu, 29 Jul 2010 11:51:03 +0100
Date: Thu, 29 Jul 2010 11:51:03 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: linux-wireless@vger.kernel.org
Subject: WARNING: at net/wireless/mlme.c:47 cfg80211_send_rx_auth+0x8a/0x130
Message-ID: <20100729105103.GA20903@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Over the past 6 months or so I sometimes see warn on slowpath in dmesg
if I turn on my EeePC 900 (which uses ath5k) and it immediately connects
to AP. Here's an example of the warning from a recent kernel:

[   13.010403] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=3)
[   13.016644] wlan0: authenticate with xx:xx:xx:xx:xx:xx (try 1)
[   13.025436] wlan0: authenticated
[   13.025445] ------------[ cut here ]------------
[   13.025458] WARNING: at net/wireless/mlme.c:47 cfg80211_send_rx_auth+0x8a/0x130()
[   13.025463] Hardware name: 900
[   13.025469] Pid: 490, comm: phy0 Not tainted 2.6.35-rc6-00150-gd15aa2c #1
[   13.025474] Call Trace:
[   13.025485]  [<b01247f3>] ? warn_slowpath_common+0x73/0xb0
[   13.025492]  [<b04a2f8a>] ? cfg80211_send_rx_auth+0x8a/0x130
[   13.025499]  [<b04a2f8a>] ? cfg80211_send_rx_auth+0x8a/0x130
[   13.025506]  [<b0124849>] ? warn_slowpath_null+0x19/0x20
[   13.025512]  [<b04a2f8a>] ? cfg80211_send_rx_auth+0x8a/0x130
[   13.025519]  [<b04b65c7>] ? ieee80211_probe_auth_done+0x67/0x90
[   13.025526]  [<b04b7a63>] ? ieee80211_work_work+0x253/0x14e0
[   13.025534]  [<b0120790>] ? dequeue_task_fair+0x20/0x1d0
[   13.025540]  [<b012052a>] ? T.1071+0x2a/0x80
[   13.025547]  [<b04d51e0>] ? schedule+0x130/0x2d0
[   13.025553]  [<b04b7810>] ? ieee80211_work_work+0x0/0x14e0
[   13.025562]  [<b0137f1f>] ? worker_thread+0x10f/0x210
[   13.025569]  [<b013b2d0>] ? autoremove_wake_function+0x0/0x40
[   13.025576]  [<b0137e10>] ? worker_thread+0x0/0x210
[   13.025582]  [<b013af04>] ? kthread+0x74/0x80
[   13.025587]  [<b013ae90>] ? kthread+0x0/0x80
[   13.025594]  [<b01030b6>] ? kernel_thread_helper+0x6/0x10
[   13.025599] ---[ end trace 84910d510f8a9a59 ]---

After a delay the machine goes on to the connect to the AP anyway so it
seems fairly harmless. Any ideas?

-- 
Sitsofe | http://sucs.org/~sits/
