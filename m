Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:44368 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758334AbXEKPEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 11:04:33 -0400
Message-ID: <464485FE.1020603@warmcat.com>
Date: Fri, 11 May 2007 16:04:30 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jouni Malinen <jkm@devicescape.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz> <46437DC8.2060805@linux.intel.com> <20070510212355.6c13cde8@griffin.suse.cz> <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com> <20070511001212.GB6971@tuxdriver.com> <464424A7.2040301@warmcat.com> <20070511142355.GB16929@devicescape.com>
In-Reply-To: <20070511142355.GB16929@devicescape.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Fri, May 11, 2007 at 09:09:11AM +0100, Andy Green wrote:
> 
>> implementation and you will never see the sources.  What I understand is
>> being talked about (maybe unlike the scan stuff this actually is in
>> hardware, but I doubt it) is ignoring code in the stack and instead
>> implementing pretty much the same code privately, to compile to a binary
>> blob you can't see source for or even reverse according to its license.
>>  That is a lot less romantic than mysterious hardware just waiting to be
>> used.
> 
> What are you talking about? The question is about being able to select
> between rate control algorithms that could be _included in the kernel
> tree_.. How did that end up in binary blobs that I would assume you are
> using to refer to firmware?

Could I possibly be talking about this?

''The 3945, as an example, let's you configure the hardware with a set
of rates, retries per rate, and a fallback order.  You submit one Tx
request to the hardware and it then performs all the retries, fallbacks,
etc without host interaction over overhead.  The rate control algorithm
needs to be aware of the attempts made by the hardware.  The specific
mechanism by which the 3945 sets up those rates is device specific.  The
mechanism by which the results are reported back are device specific.
The functions related to selecting the Tx rate are called twice for
*EVERY PACKET*.  Anything you can do to make that code-path faster and
leaner for the specific device it is using is a win.  Hardware specific
beats generic.''

http://marc.info/?l=linux-wireless&m=117882282325836&w=2

You understand re-reading this that when he talks about "You submit one
Tx request to the [']hardware['] and it then performs all the retries,
fallbacks, etc without host interaction over overhead." this is stuff in
the closed-source firmware?  Aka "binary blob" with restrictive license?

> Some hardware designs _do_ have features that allow rate control
> algorithm to be improved, i.e., there are differences in hardware
> between wlan chipset (what a surprise). This is not something that is
> "hidden" in firmware and anyway, it does not really matter whether this
> is in hardware or firmware. We are talking about providing additional
> values in TX/RX status fields and being able to do some rate adaptation
> operations on hardware TX retransmits, etc.

Is it really true this is a feature of hardware and not closed-source
firmware?  Because if I was designing such a thing - and I have designed
similarly complex silicon - damnned if I would allocate pure hardware to
it.  Since the device already has a concept of firmware, as we can all
see, I would instead implement these multistage actions with the
firmware.  Which happens to be closed source by Intel's choice.

>> If we are far from the AP and only say 5.5Mbps rate packets get through,
>> then there is presumably adaptation to that in the stack, it is not like
>> it will sequence through 54Mbps -> 48Mbps -> ... 5.5Mbps each time,
>> instead any effective rate limiting action will react to the situation
>> by issuing mainly 5.5Mbps packets that get through first time and
>> probing with faster packets occasionally to see if the situation was
>> better.  *Therefore any effective rate adaptation acts to limit any
>> benefit that can come from tagging packets with rate lists in firmware
>> as is proposed*.
> 
> I have to admit I have not looked into details of the Intel's rate
> control algorithm, but I would assume it would be this rate control
> algorithm that is tagging different rate lists for packets, not the
> firmware. Interesting optimizations can be used here if the
> hardware/firmware is capable of changing the TX rate for the same packet
> between retries. This is one example of functionality that not all wlan
> hardware designs support.

AIUI the proposal is to tag packets with lists of rates to retry at.
But if the aimed-for and typical case is that you get through on the
first try, how interesting is it really to migrate the retry action to a
closed-source and per-vendor (or per-device) implementation instead of
coming through the rate selection action in the stack.

>> Put another way the meaning of rate limiting is to
>> attempt to minimize effective airtime including the wasted restransmits
>> at rates that never get through.  So if there are excessive retransmits
>> going on due to poor selection of tx rate for the circumstances (rather
>> than interference) then isn't it better to address that in the stack so
>> all devices can benefit from a smarter algorithm? (not least in
>> recouping the wasted airtime and power used for TX that did not get through)
> 
> What's your definition of "stack"? Aren't we talking about the driver
> being able to propose which of the N rate control algorithms _from the
> stack_ should be used with it by default?

Stack == mac80211.  No: what James is talking about, as I quoted above,
is a firmware implementation of "per-packet rate-list automatic retry"
that requires special support in mac80211.

Let me ask: is it really so impossible to create a generic "nearly
optimal" algorithm for rate selection in the stack that you have to
offload the task to $DRIVER?  What is it about the awesome software
running in $DRIVER or $DEVICE that can do a better job than mac80211
ever can?

-Andy
