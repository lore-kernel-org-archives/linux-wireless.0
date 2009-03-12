Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:33385 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZCLB31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 21:29:27 -0400
Received: by fxm24 with SMTP id 24so216665fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 18:29:25 -0700 (PDT)
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 03:29:20 +0200
Message-Id: <1236821360.9581.78.camel@maxim-laptop> (sfid-20090312_022933_702835_D6F436E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-11 at 11:17 -0700, Reinette Chatre wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> 
> Patch fixes the bug 1900 at
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1900
> 
> Issues:
> Throughput and success ratio calculations were not done properly.
> Number of retries were exceeding 16.

At last... 

Here goes last annoying bug, inside my 
"Intel Corporation PRO/Wireless 3945ABG"

>From now on my wifi is perfect!


Well, that is what I thought, but although this patch helps a lot,
still some issues remain:


When I use disable_hw_scan=1, rate control issues still pop up.

This what happens to upload speed (tested using netcat, sending
a /dev/zero contents around:

For a while, it's solid at 3.0 Mbytes/s, a speed I would expect, but
then after a few minutes have passed, it drops down to about 2.8
Mbytes/s. Then again after few minutes it drops to 2.6 Mbytes/s, and
this pattern repeats. I waited till it hit 2.2 Mbytes/s.

Running iwconfig, reveals that this wifi card did run in 24Mbits/s mode
at that time! And trying force it to run in 54M/s mode didn't help
ether.

On the other omitting  the 'disable_hw_scan=1' option (which appears to
work once again, since  few days ago it broke s2disk with hung scan) -
rate didn't drop - it seemed to be always 
3.0/3.1(!) Mbytes/s, but after several minutes it did drop to
2.4Mbytes/s, and iwconfig showed the 36 Mbytes/s.
I set rate manually to 54Mbytes/s, and 3.0/3.1 rate returned.

So this helps, but something is still broken in rate control.



Downloads speeds, which I didn't test with hardware scanning disabled,
are, and I think always were at 2.4/2.5 Mbytes/s - and no more speed
drops ether it seems. Do you have a clue, why they are lower?
Also I noticed that for few seconds (about 15) download rate went as
high as 2.7 Mbytes/s.


In  addition to that, I glad to see , finally that functions were
merged, since they really need some love. For example, led appear to
blink at same rate regardless of transmit rate, be it a ssh session or a
torture speed test like I explained above. It seems that for few seconds
led blinks faster, but then reverts back to standard (minimal?) rate of
blinking.

Now at least it is worth to fix all that (when I have free time I do so,
that is if there will be need to do so....)


Best regards and thanks,
	Maxim Levitsky

