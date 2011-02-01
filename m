Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:52336 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab1BALsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 06:48:11 -0500
Date: Tue, 1 Feb 2011 12:47:57 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Eric Fernandez <zeb@zebulon.org.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
Message-ID: <20110201114757.GA11930@sig21.net>
References: <AANLkTik=oRjh9UHAsOOTpuOJR7OBw2HCsXd8vhHN_YJY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTik=oRjh9UHAsOOTpuOJR7OBw2HCsXd8vhHN_YJY@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Feb 01, 2011 at 09:26:25AM +0000, Eric Fernandez wrote:
> I reported this issue for two Linux distribution (Arch and Mandriva)
> after upgrading to kernel 2.6.37 and is rather critical for users of
> RT2573 Ralink USB Wireless adapters. This leads to complete system
> crash, which is solved either by using a wired ethernet connection, or
> by downgrading the kernel to 2.6.36 version. This happens in
> particular when watching a streaming video (e.g. Youtube). I do not
> see any entry in the log files. The sound goes to a loop, system is
> completely blocked and only a hard reset will allow rebooting.
> 
> I feel this issue has been reported for other distributions too:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/673682
> and this may be related:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/002935.html
> 
> I tried to use the compat-wireless drivers (2011-01-30), which were
> compiled correctly, but rt2x00 module loading segfaults when inserting
> the USB adapter.
> 
> What can I do to help squashing this issue?

I have no immediate idea about the cause of the crash, but
did you make sure you unloaded _all_ wireless modules
before plugging in the USB adapter after installing
compat-wireless?  "make unload" or a reboot should do the trick.

If it still crashes, can you check dmesg for the crash messages?


Thanks,
Johannes
