Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ext.lri.fr ([129.175.15.4]:39498 "EHLO ext.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab0I0Nkt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 09:40:49 -0400
Date: Mon, 27 Sep 2010 15:29:57 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: A few questions about modifications in carl9170
Message-ID: <20100927132957.GA2977@qubit.lri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

It's been now some time since I started hacking on drivers for the AR9170
chipset based cards.  I initially wanted to enable wireless link capacity
estimation (in terms of attainable throughput), based on the measurement of
data frame service time.  In other words, I wanted to measure the time it
takes the card to fully process each frame it receives from upper layers, from
the instant it first considers the frame for transmission until the instant
when the frame is considered processed (reception of ACK for unicast or end of
transmission for multicast).

What I ended up doing was to modify the carl9170 firmware to enable the card
itself to do the measurement and report that value back along the TX status.

The most important question is about struct carl9170_tx_status.  Is it safe to
simply add a u32 duration field and update the CARL9170_TX_STATUS_SIZE to 6?

After quite some testing, it appears that as soon as I change the size of that
struct, I start getting things like this (on any recent kernel with recent
driver+firmware):

usb 1-1: no command feedback received (-110).
carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00 .....6...$..
usb 1-1: restart device (6)
ieee80211 phy0: writing reg 0x1c36f0 (val 0x2400) failed (-110)
usb 1-1: device restarted successfully.
------------[ cut here ]------------
WARNING: at /build/buildd/linux-2.6.35/kernel/workqueue.c:495 flush_cpu_workqueue+0x7a/0x80()
...
Modules linked in: carl9170 mac80211 led_class ath cfg80211 compat ...
Call Trace:
[<c014a812>] warn_slowpath_common+0x72/0xa0
[<c016199a>] ? flush_cpu_workqueue+0x7a/0x80
[<c016199a>] ? flush_cpu_workqueue+0x7a/0x80
[<c014a862>] warn_slowpath_null+0x22/0x30
[<c016199a>] flush_cpu_workqueue+0x7a/0x80
[<c01620ee>] flush_workqueue+0x3e/0x60
[<db90f699>] ieee80211_restart_hw+0x19/0x80 [mac80211]
[<db872d92>] carl9170_restart_work+0xc2/0x150 [carl9170]
[<c016155e>] run_workqueue+0x8e/0x150
[<db872cd0>] ? carl9170_restart_work+0x0/0x150 [carl9170]
[<c01616a4>] worker_thread+0x84/0xe0
[<c0165920>] ? autoremove_wake_function+0x0/0x50
[<c0161620>] ? worker_thread+0x0/0xe0
[<c01654f4>] kthread+0x74/0x80
[<c0165480>] ? kthread+0x0/0x80
[<c010363e>] kernel_thread_helper+0x6/0x10
--[ end trace 163c2ca4bc44c139 ]---

At first glance, it seems to be the result of a reentrant call of
flush_workqueue.

If the size of struct tx_status has to remain 2, is there any easy and safe
way to push that duration calculation back towards the driver without
sacrifying the actual information that is useful for the ratecontrol
algorithm?

Thanks you.

Ignacy

-- 
If you're not living on the edge, you're taking up too much space.
