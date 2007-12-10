Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36277 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXLJPdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:33:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Date: Mon, 10 Dec 2007 16:30:47 +0100
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
References: <1196189059.6058.95.camel@johannes.berg> <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com> <1197299937.6035.81.camel@johannes.berg>
In-Reply-To: <1197299937.6035.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712101630.48124.mb@bu3sch.de> (sfid-20071210_153308_259876_415C9A2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 December 2007 16:18:57 Johannes Berg wrote:
> 
> > > I never said you should keep native layout structures. I merely said
> > > that it leads to better code if the data is converted to CPU endianness
> > > at the system boundary. While the actual system boundary is obviously
> > > the PCI(-E) bus, the logical system boundary may well be at the point
> > > where you load a certain value from the DMA memory into the CPU to
> > > operate with it (whether it's then pushed back out to memory on the
> > > stack is uninteresting).
> > 
> > I'm not buying this logical boundary definition if you don't do clean
> > cut you still have to be endian aware across the whole code so what's
> > a difference.
> 
> No, you only have to be endian aware when you do a load from a structure
> you *know* was/is DMAed from/to the card. That's a world of a
> difference.

I agree that it's a lot easier to read and maintain, if you convert _all_
your data structures (also single integers) to and from device endianness
at the time when you write/read them to the device. It unifies the
workflow a lot and results in much less swappings.

my_data = read_drom_device()
swap_to_cpu(my_data)
do_whatever(my_data)
store the data somewhere else in the device structs for
later use, maybe.
do_something_else(my_data)

You see that now you have only _one_ place that you have to care about.
And if you have to write your data back at some point, simply do it
just before the write.

And, little endian intel guys, this will simplify your life a lot by
removing lots of cpu_to_xxx stuff _and_ result
in no performance loss, as the swap will be optimized away. :)
That's a deal, eh?
And we big endian people, we don't care about one or two swap instructions.
It won't hurt performance in any way.
(Johannes also showed that in most cases this approach doesn't even
add extra instructions).

-- 
Greetings Michael.
