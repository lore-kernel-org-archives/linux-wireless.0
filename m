Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-21.dex002.intermedia.net ([64.78.21.92]:25675 "EHLO
	dhost002-21.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbXEKOXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 10:23:41 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Fri, 11 May 2007 07:23:55 -0700
To: Andy Green <andy@warmcat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
Message-ID: <20070511142355.GB16929@devicescape.com>
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz> <46437DC8.2060805@linux.intel.com> <20070510212355.6c13cde8@griffin.suse.cz> <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com> <20070511001212.GB6971@tuxdriver.com> <464424A7.2040301@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464424A7.2040301@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2007 at 09:09:11AM +0100, Andy Green wrote:

> implementation and you will never see the sources.  What I understand is
> being talked about (maybe unlike the scan stuff this actually is in
> hardware, but I doubt it) is ignoring code in the stack and instead
> implementing pretty much the same code privately, to compile to a binary
> blob you can't see source for or even reverse according to its license.
>  That is a lot less romantic than mysterious hardware just waiting to be
> used.

What are you talking about? The question is about being able to select
between rate control algorithms that could be _included in the kernel
tree_.. How did that end up in binary blobs that I would assume you are
using to refer to firmware?

Some hardware designs _do_ have features that allow rate control
algorithm to be improved, i.e., there are differences in hardware
between wlan chipset (what a surprise). This is not something that is
"hidden" in firmware and anyway, it does not really matter whether this
is in hardware or firmware. We are talking about providing additional
values in TX/RX status fields and being able to do some rate adaptation
operations on hardware TX retransmits, etc.

> If we are far from the AP and only say 5.5Mbps rate packets get through,
> then there is presumably adaptation to that in the stack, it is not like
> it will sequence through 54Mbps -> 48Mbps -> ... 5.5Mbps each time,
> instead any effective rate limiting action will react to the situation
> by issuing mainly 5.5Mbps packets that get through first time and
> probing with faster packets occasionally to see if the situation was
> better.  *Therefore any effective rate adaptation acts to limit any
> benefit that can come from tagging packets with rate lists in firmware
> as is proposed*.

I have to admit I have not looked into details of the Intel's rate
control algorithm, but I would assume it would be this rate control
algorithm that is tagging different rate lists for packets, not the
firmware. Interesting optimizations can be used here if the
hardware/firmware is capable of changing the TX rate for the same packet
between retries. This is one example of functionality that not all wlan
hardware designs support.

> Put another way the meaning of rate limiting is to
> attempt to minimize effective airtime including the wasted restransmits
> at rates that never get through.  So if there are excessive retransmits
> going on due to poor selection of tx rate for the circumstances (rather
> than interference) then isn't it better to address that in the stack so
> all devices can benefit from a smarter algorithm? (not least in
> recouping the wasted airtime and power used for TX that did not get through)

What's your definition of "stack"? Aren't we talking about the driver
being able to propose which of the N rate control algorithms _from the
stack_ should be used with it by default?

-- 
Jouni Malinen                                            PGP id EFC895FA
