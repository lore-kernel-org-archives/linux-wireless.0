Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33505 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbXEKIJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 04:09:15 -0400
Message-ID: <464424A7.2040301@warmcat.com>
Date: Fri, 11 May 2007 09:09:11 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Tomas Winkler <tomasw@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz> <46437DC8.2060805@linux.intel.com> <20070510212355.6c13cde8@griffin.suse.cz> <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com> <20070511001212.GB6971@tuxdriver.com>
In-Reply-To: <20070511001212.GB6971@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, May 11, 2007 at 01:24:58AM +0300, Tomas Winkler wrote:
>> On 5/10/07, Jiri Benc <jbenc@suse.cz> wrote:
>>> On Thu, 10 May 2007 13:17:12 -0700, jketreno wrote:
> 
>>>> Generic algorithms aren't as capable as hardware specific algorithms
>>>> when you factor performance, latency, system utilization, power
>>>> consumption, etc.  Optimal algorithms are written to take advantage of
>>>> the capabilities exposed by the hardware.
>>> You said the same about hardware scanning. Michael showed you that's
>>> not true.
>>>
>> Michael has shortened the dwell time on the channel, while hw scanning
>> has shorten switching time from the channel to channel and no the time
>> you are listening on the channel
>> I wouldn't call it an optimization. Did he measured the power consumption ?
> 
> This was going to be my question, and I think it is a worthy point. :-)

The scan "power savings" in question are so small as to not be
measurable. The stack is only involved at the time it changes the
channel... a few tens of us of CPU time over the multiple seconds of
scan action... and the scan action itself only happens at long intervals.

Is this really about commercial product differentiation? "Our hardware
does faster 'hardware' scan" is good for Intel, even though the truth
would more properly be expressed as "we took scan away from the open
stack and put it in the closed source firmware binary blob where our
implementation is a special modal thing that sooner or later will cause
side effects, and there are space constraints and less of an OS API
structure to lean on and the code is not reviewed". (I assume everyone
who has used ipw3945 and even iwlwifi is familiar with MICROCODE ERROR
and bad things arising from that.)  And in the end as was pointed out
beforehand, the scan implementation in the firmware is not measurably
faster or more saving of power anyway.

(While I was writing this the 3945 on this box lost association, and
when I tried to reinsert the driver modprobe stalled and I see permanent
100% CPU usage on both cores.  That's a genuine low hanging fruit for
"powersaving" on iwl3945/iwlwifi ;-) )

>>> If the slowdown is not big, yes, it is. Unifying things almost always
>>> means you need to accept some trade-offs.
>> Clean API gives you the ability to enjoy from the both worlds. WiFi is
>> about mobility power saving and therefore hw offloading is essential.

Sexy-sounding "hw offloading" is a very different thing to migrating off
open code and putting it in vendor-specific closed source firmware.  The
firmware is just code like any other, for an embedded ARM7 or similar,
except that it is customized for a specific vendor hardware
implementation and you will never see the sources.  What I understand is
being talked about (maybe unlike the scan stuff this actually is in
hardware, but I doubt it) is ignoring code in the stack and instead
implementing pretty much the same code privately, to compile to a binary
blob you can't see source for or even reverse according to its license.
 That is a lot less romantic than mysterious hardware just waiting to be
used.

If we are far from the AP and only say 5.5Mbps rate packets get through,
then there is presumably adaptation to that in the stack, it is not like
it will sequence through 54Mbps -> 48Mbps -> ... 5.5Mbps each time,
instead any effective rate limiting action will react to the situation
by issuing mainly 5.5Mbps packets that get through first time and
probing with faster packets occasionally to see if the situation was
better.  *Therefore any effective rate adaptation acts to limit any
benefit that can come from tagging packets with rate lists in firmware
as is proposed*.  Put another way the meaning of rate limiting is to
attempt to minimize effective airtime including the wasted restransmits
at rates that never get through.  So if there are excessive retransmits
going on due to poor selection of tx rate for the circumstances (rather
than interference) then isn't it better to address that in the stack so
all devices can benefit from a smarter algorithm? (not least in
recouping the wasted airtime and power used for TX that did not get through)

Collecting numbers on the retransmit probability per packet for
different environments would be interesting anyway aside from all this,
allowing objective metrics on rate management performance, but you would
think it would be an important element of making the decision to pursue
doing all the work to tag packets with rate lists in the firmware.

>> What worth the few more lines of the code that gives you this ability
>> this is also a trade-off.
> 
> Agreed.  FWIW, power saving is worthwhile even for fixed stations as well.

Anyone can propose anything and just slip the word patriot- er -
powersaving in a few times.  The true issue here is how much stuff that
can and should be done in the open, shared stack are you willing to see
in a vendor-specific binary blob (with support for the vendor-specific
blobby APIs added to the stack) to get claimed advantages (eg,
powersaving, scan speed) that aren't shown to hold water.  I can imagine
sometimes the benefits can be genuine and strong and you have to work
with it, but the other times...

-Andy
