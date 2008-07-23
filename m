Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:54392 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbYGWPWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 11:22:08 -0400
Message-ID: <48874C9D.2050900@lwfinger.net> (sfid-20080723_172211_495519_93F088E7)
Date: Wed, 23 Jul 2008 10:22:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gautam Iyer <gi1242+vger@stanford.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: 2.6.26 b43 speed issue (redux) and new firmware drivers
References: <20080722193637.GC19885@stanford.edu>
In-Reply-To: <20080722193637.GC19885@stanford.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gautam Iyer wrote:
> Hi All,
> 
> I'm writing to inquire about a "new" firmware drivers for Broadcom 43xx:
> On April 6, 2008 it looks like broadcom-wl-4.150.10.5.2.tar.bz2 appeared
> on http://mirror2.openwrt.org/sources/. The install guide for b43
> recommends you use b43-fwcutter-011 and broadcom-wl-4.150.10.5.tar.bz2
> 
> I tried to use broadcom-wl-4.150.10.5.2.tar.bz2 with b43-fwcutter-011,
> but it complained that the md5 sum was not recognized :). Just wondering
> if there is any way to use this new firmware?
> 
> Thanks in advance,
> 
> GI
> 
> PS: The main reason I ask is for "performance": A while ago I reported
>     that my Broadcom 4312 gave 2/3 the speed under b43 (2.6.25), when
>     compared to ndiswrapper. (I tested by running ttcp, and measuring
>     the throughput. I got roughly 3MB/s with ndiswrapper, and
>     2 MB/s with b43).
> 
>     I just upgraded to 2.6.26, and found that my b43 speed *increased*
>     to 2.4MB/s :). So thanks to whomever is responsible! I was also
>     hoping that if I upgrade even the firmware I would be able to
>     "toast" ndiswrapper. (I transfer large files on my home network
>     often, which is why I care about the speed so much.)

I do not know what changed between 4.150.10.5 and 4.150.10.2, but I doubt that 
the firmware in the new driver will make any appreciable difference in the 
performance of the BCM4312. My guess is that they found some errors in the 
handling of the N PHY or the LP PHY, which are the two newest devices, and fixed 
them. Of course, we do need to update fwcutter to test my hypothesis. As a 
reverse engineer, I also need to see what changed. What version is the Windows 
driver that you use?

It is a fact of life that this kind of reverse engineering rarely will perform 
better than the original driver. After all, if we make an exact copy, then we 
repeat their mistakes. Any mistakes of ours have a small chance of improving 
performance. Where we do improve on the original is in the error handling.

I get the same performance with my BCM4312 as you do.

Larry
