Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:44742 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbYA2UQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 15:16:01 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Larry Finger'" <larry.finger@lwfinger.net>,
	"'Stefano Brivio'" <stefano.brivio@polimi.it>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: RE: [RFT] [PATCH] rc80211-pid: fix rate adjusting
Date: Tue, 29 Jan 2008 21:15:49 +0100
Message-ID: <00f201c862b3$be1f00b0$0b3ca8c0@gotws1589> (sfid-20080129_201608_252629_E686FFDB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <479E928C.5000709@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My test system is broken. 

I was using a kernel build a couple of days ago while I was doing the
initial test with the new rate control function.

Since I was getting deviant result, I decided to build a fresh kernel 
before I continue my test. I also had added some debugging to see what 
actually happens.

Unfortunately the rt2x00/rt61pci driver is broken in current git. I'm using
http://www.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git, 
and the 'everything' branch. 

I got plenty of :
[ 2119.568376] WARNING: at net/mac80211/rx.c:2022 __ieee80211_rx()
[ 2119.574828] Pid: 0, comm: swapper Not tainted 2.6.24-rc8wireless-lae #8
[ 2119.582022]  [<c01030ea>] show_trace_log_lvl+0x1a/0x30
[ 2119.587708]  [<c0103bc2>] show_trace+0x12/0x20
[ 2119.592574]  [<c010434c>] dump_stack+0x6c/0x80
[ 2119.597484]  [<d0860138>] __ieee80211_rx+0x68/0x610 [mac80211]
[ 2119.604037]  [<d0850a0e>] ieee80211_tasklet_handler+0xae/0xe0 [mac80211]
[ 2119.611484]  [<c011bd33>] tasklet_action+0x33/0x70
[ 2119.616773]  [<c011bc64>] __do_softirq+0x54/0xb0
[ 2119.621938]  [<c011bcf5>] do_softirq+0x35/0x40
[ 2119.626822]  [<c011bf53>] irq_exit+0x43/0x50
[ 2119.631516]  [<c0104671>] do_IRQ+0x51/0xa0
[ 2119.636031]  [<c0102c43>] common_interrupt+0x23/0x28
[ 2119.641506]  [<c0100e48>] cpu_idle+0x28/0x80
[ 2119.646219]  [<c02e095c>] rest_init+0x5c/0x60
[ 2119.651010]  [<c0380b45>] start_kernel+0x205/0x290
[ 2119.656312]  [<00000000>] run_init_process+0x3fefff40/0x20


I think it has something to do with the "cfg80211 API for channels/bitrates,

mac80211 and driver conversion" commit.

I will get back as soon as my test system is up and running again.

Regards
Lars

