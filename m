Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:33731 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYC3NT3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 09:19:29 -0400
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
From: Bas Hulsken <bhulsken@hotmail.com>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <loom.20080329T232927-720@post.gmane.org>
References: <1206801246.24689.19.camel@Bas>
	 <200803291553.03955.IvDoorn@gmail.com> <1206808941.22448.22.camel@Bas>
	 <200803291801.17068.IvDoorn@gmail.com>
	 <loom.20080329T232927-720@post.gmane.org>
Content-Type: text/plain
Date: Sun, 30 Mar 2008 15:15:45 +0200
Message-Id: <1206882945.4973.5.camel@Bas> (sfid-20080330_141934_157106_0A0F3E10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adam, Ivo,

On Sat, 2008-03-29 at 23:45 +0000, Adam Baker wrote:
> Ivo van Doorn <ivdoorn@...> writes:
> 
> 
> > Could you enable debugfs and use the tools here:
> > http://www-user.rhrk.uni-kl.de/~nissler/rt2x00/index.html
> > 
> > To create a dump of the frames as they are actually send out from the driver
> > to the hardware including the status report. This will tell if rt2x00 is
> > actually bringing the frame to the hardware correctly.
> > 
> 
> I think you've got that back to front - If I'm reading the
> thread correctly the suspicion is the data is being transmitted
> correctly by the remote end and is being lost somehere between
> the rt2500pci antenna and user space.
> 
> The tools would still be helpful to see if a packet is being
> received by the hardware and lost in the stack (maybe it doesn't
> like something about the received packet) or if it is not even
> getting as far as the rt2x00 driver.
> 
you're right Adam, it's the receiving part where it goes wrong, anyway,
I've managed to enable debugfs, and the above mentioned tools, so I'll
do some captures today for both normal and promiscuous mode, to see if,
and why/how/where packets get lost.

> Ivo,
> Don't forget that there was no response to the request for someone to test
> if broadcast packets were received in monitor mode on the older hardware
> so if the filter flags don't select multicast traffic we could be losing
> broadcast traffic too. I'm not sure if the stack will be reporting any
> active multicast groups in AP mode. (For the benefit of others the only
> reason normal broadcast traffic was working was because there was always a
> multicast group present, Ivo's request is linked below.)
> 
> http://sourceforge.net/mailarchive/forum.php?thread_name=200803031921.41634.IvDoorn%40gmail.com&forum_name=rt2400-devel
> 
I would like to test for this, but I'm not quite sure how, I've read
Ivo's original message, but I can't find the monitoring bug discussion
Ivo is referring to. Would the frame captures on debugfs, again with the
above mentioned tools test for this bug as well? Or is there something
else I have to do?

thanks,
Bas Hulsken

