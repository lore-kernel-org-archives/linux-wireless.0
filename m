Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1CIKIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 05:08:15 -0500
Date: Wed, 9 Mar 2011 11:06:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ivdoorn@gmail.com, Johannes Stezenbach <js@sig21.net>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Unplugging usb wlan (rt73usb) hangs the system
Message-ID: <20110309100651.GA23594@redhat.com>
References: <4D6E7B55.6010905@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4D6E7B55.6010905@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 02, 2011 at 07:16:05PM +0200, Ozan Çağlayan wrote:
> I have a bunch of different Edimax and Asus WLAN sticks that are working
> very well in Linux 2.6.37.2 with the rt73usb driver. But there's a
> really annoying problem which causes the system to hang upon unplugging
> those sticks.
> 
> First X server goes. Then you can SSH into the machine for a while, and
> then I/O operations will start to fail. Magic SysRQ can be used to
> safely sync/unmount/reboot the system.
> 
> It's happening very frequently but there are times that nothing bad happens.
> 
> As far as I can tell, it happens much more frequently if you were
> associated to an AP when you unplugged the stick but let me clear this
> after testing plug/unplug without associating at all.
> 
> One thing that is quite sure is that after unplugging the stick, if you
> do nothing with your keyboard, the problem seems not to appear, e.g. I'm
> moving the mouse cursor for a while, no problem at all but once I hit
> pageup/pagedown to browse on the current konsole screenbuffer, it hangs!
> So the problem seems to be triggered after keyboard interrupts.
> 
> I've set up a netconsole connection and got the dmesg for a while.
> There's no oops/warning/error but every 2 minutes another tasks
> generates a stacktrace because of 120 seconds timeout. I'm attaching the
> log.

I can confirm problem exist in 2.6.37. I can not reproduce it in
current wireless-testing. I did not investigate further, I guess
issue is fixed by:

commit d7bb5f845f437662296adbfeaab8fbfce1c32289
Author: Johannes Stezenbach <js@sig21.net>
Date:   Mon Dec 13 12:32:49 2010 +0100

    rt2x00: fix hang when unplugging USB device in us

Stanislaw
