Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935918Ab1ETVL6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 17:11:58 -0400
Subject: Re: iwlagn log spam
From: wwguy <wey-yi.w.guy@intel.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DD6D573.2060800@erley.org>
References: <4DD6D573.2060800@erley.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 14:08:39 -0700
Message-ID: <1305925719.1444.11.camel@wwguy-ubuntu> (sfid-20110520_231204_863792_E69A9CFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pat,


On Fri, 2011-05-20 at 13:56 -0700, pat-lkml wrote:
> Resend(oops, never setup plain text vs html on this machine)
> 
> I've been getting spammed with: 
> 
> iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 00:0c:42:64:bb:1d
> tid = 0
> 
> Every 35s for the 16 hours my machine has been up:
> 
> anvil $ uname -a
> Linux anvil 2.6.39-gentoo #1 SMP PREEMPT Fri May 20 01:53:54 EDT
> 2011 x86_64 Intel(R) Core(TM) i7 CPU Q 820 @ 1.73GHz GenuineIntel
> GNU/Linux
> 
> anvil $ dmesg | grep iwlagn_tx_agg_start | wc -l
> 1621
> 
> anvil $ uptime
>  16:44:40 up 14:49,  3 users,  load average: 1.11, 0.82, 0.48
> 
> Is there a good reason to print this message?  Is it indicative of a
> problem?  Everything works fine.
> 
> Here's a little dmesg info from my system:
> 
> anvil $ dmesg | grep iwlagn | grep -v iwlagn_tx_agg_start
> [    3.675798] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
> Linux, in-tree:
> [    3.675802] iwlagn: Copyright(c) 2003-2010 Intel Corporation
> [    3.675877] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low)
> -> IRQ 17
> [    3.675893] iwlagn 0000:03:00.0: setting latency timer to 64
> [    3.675983] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R)
> Advanced-N + WiMAX 6250 AGN, REV=0x84
> [    3.688288] iwlagn 0000:03:00.0: device EEPROM VER=0x540, CALIB=0x6
> [    3.688290] iwlagn 0000:03:00.0: Device SKU: 0Xb
> [    3.688306] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg,
> 24 802.11a channels
> [    3.688373] iwlagn 0000:03:00.0: irq 57 for MSI/MSI-X
> [    3.697702] iwlagn 0000:03:00.0: loaded firmware version
> 41.28.5.1 build 33926
> [    3.760104] iwlagn 0000:03:00.0: wlan0: Features changed:
> 0x00004800 -> 0x00004000
> [   32.590823] iwlagn 0000:03:00.0: Aggregation not enabled for tid
> 0 because load = 2
> [  330.931071] iwlagn 0000:03:00.0: Aggregation not enabled for tid
> 0 because load = 9
> 
Just want to be clear, which message flooding your system?
is 
iwlagn 0000:03:00.0: Aggregation not enabled for tid
> 0 because load = 9
or
iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 00:0c:42:64:bb:1d
> tid = 0
> 
the second message should only show once when the aggregation being establish. if you are seeing it every 35 seconds, that is bad. 
but the first message is checking the traffic load is high enough to establish the aggregation queue, which is ok.
and we should not log this type of message as "ERROR", I will submit a patch to change that.

Wey
> 


