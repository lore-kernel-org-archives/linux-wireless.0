Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58374 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3AYSg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 13:36:59 -0500
Message-ID: <5102D0C7.50907@candelatech.com> (sfid-20130125_193703_779760_52DD97B3)
Date: Fri, 25 Jan 2013 10:36:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sam Leffler <sleffler@google.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Increasing throughput on 3-radio system?
References: <5102CADE.2010900@candelatech.com> <CA+yqC4b2_q5Nn2t7C-5JdAfxR-QA8KtBgqE_sw91ZfNwt-k+LQ@mail.gmail.com>
In-Reply-To: <CA+yqC4b2_q5Nn2t7C-5JdAfxR-QA8KtBgqE_sw91ZfNwt-k+LQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2013 10:23 AM, Sam Leffler wrote:
> On Fri, Jan 25, 2013 at 10:11 AM, Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>> wrote:
>
>     I've put 3 ath9k AR9380 NICs into a single system (core-i7).  Each is
>     configured for an AP on a separate 5Ghz channel (40Mhz wide).
>
>     Individually, I can get about 300Mbps transmit towards the AP on any
>     particular radio, but when running all together, total throughput is
>     only about 475Mbps.
>
>     I assume there is some cross-channel bleeding or similar.
>
>
> Yes.
>
>
>     The APs are close by, so I was wondering if perhaps there was a way
>     to configure the radios to be less sensitive and thus pay less
>     attention to channel cross-talk?
>
>     Any suggestions for things to try are appreciated!
>
>
> If you cannot fully isolate the antenna the usual approach is to schedule radio usage so tx/rx is done on all radios at the same time. Ubiquity and Mikrotik do
> this and there have been many research papers that discuss this.

It seems basically impossible to fully isolate the NICs in a normal
system.  The u.fl/IPEX pigtails bleed for sure.  The NICs probably bleed
just as bad or worse, and I can't think of a good way to increase isolation
without somehow encasing each NIC in a small RF-proof box (and somehow keeping the
RF from running down the pci-e ribon cables, etc).

Playing tricks with scheduling seems pretty nifty, but probably not realistic
for my particular use case (emulating lots and lots of stations that should run
against whatever AP(s) the customers may be using).

If there were a way to decrease rx-sensitivity, wouldn't that be pretty
similar to having all NICs transmit at once (in other words, the NICs
could better ignore the fainter cross-talk signals and focus on the
high-powered signals on their particular channel)?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

