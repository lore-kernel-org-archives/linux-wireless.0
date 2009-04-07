Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:60182 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZDGTUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:20:42 -0400
Message-ID: <49DBA77F.2090104@lwfinger.net> (sfid-20090407_212046_965312_6DD9832C)
Date: Tue, 07 Apr 2009 14:20:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: 2.6.29 linus tree: iwlagn  Failed to register hw (error -2) on
 first try. Success on unload and retry
References: <200904072248.56413.a.miskiewicz@gmail.com>
In-Reply-To: <200904072248.56413.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arkadiusz Miskiewicz wrote:
> Hi,
> 
> Some recent commits (in last 2 days I guess) broke iwlagn driver.
> Using Linus tree as of aeeae86859f4319de0a4946b44771d9926eeed54
> 
> [    5.431753] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> [    5.431755] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> [    5.431836] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    5.431863] iwlagn 0000:03:00.0: setting latency timer to 64
> [    5.431965] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5350AGN REV=0x24
> [    5.451117] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [    5.451202] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
> [    5.451591] phy0: Selected rate control algorithm 'iwl-agn-rs'
> [    5.458313] phy0: Failed to initialize wep: -2
> [    5.489134] iwlagn 0000:03:00.0: Failed to register hw (error -2)
> [    5.489214] iwlagn 0000:03:00.0: PCI INT A disabled
> [    5.489221] iwlagn: probe of 0000:03:00.0 failed with error -2

The problem is not with iwlagn as I see the same problem with b43.

There are at least 3 regressions in the latest version of Linus's tree. The
first is bad commit 9cb610d - it inhibits loading of modules from initrd and the
system will not boot. I'm bisecting the second - a NULL pointer BUG. Once that
one is located, I'll scope out the one you found. I know that commit 45e36c1 is
after the problem.

Larry

