Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:57007 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYC2XpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 19:45:22 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jfkja-0005WR-HC
	for linux-wireless@vger.kernel.org; Sat, 29 Mar 2008 23:45:14 +0000
Received: from userch028.dsl.pipex.com ([62.190.239.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 23:45:14 +0000
Received: from linux by userch028.dsl.pipex.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 23:45:14 +0000
To: linux-wireless@vger.kernel.org
From: Adam Baker <linux@baker-net.org.uk>
Subject: Re: rt2500pci, infinite calls to =?utf-8?b?cnQyeDAwbWNfY29uZmlndXJlX2ZpbHRlcg==?=
Date: Sat, 29 Mar 2008 23:45:04 +0000 (UTC)
Message-ID: <loom.20080329T232927-720@post.gmane.org> (sfid-20080329_234528_024540_0594AD59)
References: <1206801246.24689.19.camel@Bas> <200803291553.03955.IvDoorn@gmail.com> <1206808941.22448.22.camel@Bas> <200803291801.17068.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn <ivdoorn@...> writes:


> Could you enable debugfs and use the tools here:
> http://www-user.rhrk.uni-kl.de/~nissler/rt2x00/index.html
> 
> To create a dump of the frames as they are actually send out from the driver
> to the hardware including the status report. This will tell if rt2x00 is
> actually bringing the frame to the hardware correctly.
> 

I think you've got that back to front - If I'm reading the
thread correctly the suspicion is the data is being transmitted
correctly by the remote end and is being lost somehere between
the rt2500pci antenna and user space.

The tools would still be helpful to see if a packet is being
received by the hardware and lost in the stack (maybe it doesn't
like something about the received packet) or if it is not even
getting as far as the rt2x00 driver.

> > this is the flag status when running hostapd; as printed with
> > printk(KERN_INFO "rt2500pci filter_flags: %d\n",
> > rt2x00dev->packet_filter);
> > 
> > rt2500pci filter_flags: 2
> > rt2500pci MAC changed: 00:0c:f6:14:05:19
> 
> Packet filter flags of 2 sounds a bit restrictive.
> 
> Johannes, for Master mode shouldn't the following flags be set as well:
> FIF_PROMISC_IN_BSS
> FIF_CONTROL
> 

Ivo,
Don't forget that there was no response to the request for someone to test
if broadcast packets were received in monitor mode on the older hardware
so if the filter flags don't select multicast traffic we could be losing
broadcast traffic too. I'm not sure if the stack will be reporting any
active multicast groups in AP mode. (For the benefit of others the only
reason normal broadcast traffic was working was because there was always a
multicast group present, Ivo's request is linked below.)

http://sourceforge.net/mailarchive/forum.php?thread_name=200803031921.41634.IvDoorn%40gmail.com&forum_name=rt2400-devel


