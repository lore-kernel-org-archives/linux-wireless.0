Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:34481 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1COPYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 11:24:14 -0400
Date: Tue, 15 Mar 2011 15:24:22 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Could ath9k and rt2800pci bugs be related?
Message-ID: <20110315152422.610b8434@toddler>
In-Reply-To: <AANLkTi=Gub1JAO21qtRjxVWrtc6Masp1siF3NHntgcvp@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<20110314164812.4c0cfc29@toddler>
	<AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
	<20110315131907.6f06a221@toddler>
	<AANLkTi=Gub1JAO21qtRjxVWrtc6Masp1siF3NHntgcvp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 Mar 2011 19:05:27 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> No its nothing to do with kernel hacking, its just a wireless package.
> instead of compiling the whole kernel or wireless testing, we can
> install a wireless package within our linux distribution in few
> minutes. This package is called compat-wireless which includes latest
> fixes in wireless testing.
> more information in:
> http://wireless.kernel.org/en/users/Download

I tried that and I can confirm that it still crashes. I used the
compat-wireless-2011-03-14 snapshot with a Debian stock 2.6.37-2 kernel.

BTW one of the files had an error with TASK_INTERRUPTIBLE undefined. I
can't remember which file because I forgot to make a note of it before
make wlunload caused the expected crash. The apparent cause was that
/usr/include/linux/sched.h contains far less than sched.h in the kernel
source. I worked around it by defining the macro as 1 at the top of the
affected file.

