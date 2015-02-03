Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:37753 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbbBCKCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 05:02:42 -0500
Received: by mail-la0-f42.google.com with SMTP id ms9so49847435lab.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 02:02:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPp0ZBZfdmwJNAtR6R1ue0OAj1pYh+L_kxRrixXD=3keLgKZKQ@mail.gmail.com>
References: <CAJ1dT9x+vWm4uZ-r9PZrTmKjEQc260NhOKoRzH=Ab=oWkeZ83w@mail.gmail.com>
	<CAPp0ZBZfdmwJNAtR6R1ue0OAj1pYh+L_kxRrixXD=3keLgKZKQ@mail.gmail.com>
Date: Tue, 3 Feb 2015 11:02:41 +0100
Message-ID: <CAJ1dT9x58-ZGWX7Gku3a8K-GskvaX6=C=Lyo24PE6=cjBfjw2Q@mail.gmail.com> (sfid-20150203_110248_606822_FF219BDB)
Subject: Re: Open Source RRM & Hand-Over Optimization (WAS: Throughput
 regression with `tcp: refine TSO autosizing`)
From: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bs@anyfi.net>
To: Avery Pennarun <apenwarr@google.com>
Cc: David Reed <dpreed@reed.com>,
	dstanley <dstanley@arubanetworks.com>,
	Derrick Pallas <pallas@meraki.com>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2015 at 11:53 PM, Avery Pennarun <apenwarr@google.com> wrote:
> On Mon, Feb 2, 2015 at 11:44 AM, Björn Smedman <bs@anyfi.net> wrote:
>> On Mon, Feb 2, 2015 at 5:21 AM, Avery Pennarun <apenwarr@google.com> wrote:
>>> While there is definitely some work to be done in handoff, it seems
>>> like there are some find implementations of this already in existence.
>>> Several brands of "enterprise access point" setups seem to do well at
>>> this.  It would be nice if they interoperated, I guess.
>>>
>>> The fact that there's no open source version of this kind of handoff
>>> feature bugs me, but we are working on it here and the work is all
>>> planned to be open source, for example: (very early version)
>>> https://gfiber.googlesource.com/vendor/google/platform/+/master/waveguide/
>>
>> We've got an SDN-inspired architecture with 802.11 frame tunneling (a
>> la CAPWAP), airtime fairness, infrastructure initiated hand-over,
>> Opportunistic Key Caching (OKC), IEEE 802.11r Fast BSS Transition and
>> a few more goodies. It's currently free as in beer
>> (http://anyfi.net/software,
>> https://github.com/carrierwrt/carrierwrt/pull/7 and
>> http://www.anyfinetworks.com/download) up to 100 APs, but we're
>> definitely going to open source in one form or another.
>>
>> We've also tried to raise some interest in fixing up CAPWAP
>> (https://www.ietf.org/mail-archive/web/opsawg/current/msg03196.html),
>> which is (unfortunately) the best open standard at the moment.
>> Interest seems marginal though...
>
> This sounds cool.  Is the CAPWAP/encapsulation stuff separable from
> the rest?  At 802.11ac speeds, a super fast WAN link, and a low-cost
> SoC, too many layers can be a killer.

Our current architecture is a bit "fixed function" with tunneling
built in. That's because it's targeted at guest access / homespots
where there's typically a "local MAC" for the home Wi-Fi network
(which we don't touch), and for guests you usually want to tunnel
anyway. Many use L2oGRE to tunnel a "second SSID" in this use-case,
but since the visited AP is a point of attack we think you should
encrypt "through" the AP. You can do that without any extra overhead
since you're just shoveling encrypted 802.11 frames from one interface
to another, but you're right it's a bit slower in practice: in the
extreme case of frame shoveling in user space you're limited to about
40 Mbps (for guests) on a $10 SoC (but home Wi-Fi throughput is not
impacted).

What we're working on now though is an "Open wSwitch" that lets you
pick and choose which frames to tunnel and where, even within one BSS
/ for a single STA. You'll also be able to set the temporal key (TK)
from a central location so that you can do e.g. OKC / 802.11r combined
with local bridging. This should make it possible to do both the
secure guest access and the more enterprisy stuff over the same
control plane protocol. We're also planning to put the 802.11
tunneling in kernel space this time, which should easily get you 100
Mbps of AES-128-CCM through a cheap SoC (and into/out of a cheap
mobile device!).
