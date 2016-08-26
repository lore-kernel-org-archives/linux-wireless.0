Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59609 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753127AbcHZQIL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 12:08:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 26 Aug 2016 21:37:32 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Dave Taht <dave.taht@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: implement NAPI support
In-Reply-To: <CAA93jw5mEMbUVs-i-Bpjkv6tX-umsO=9ZKPEnFcEj=22yjWX1g@mail.gmail.com>
References: <20160826102250.24174-1-rmanohar@qti.qualcomm.com>
 <CAA93jw7vHWROH9Ymq1UoOKA5kw+fDbCM=vJehs8J=QP2PVs_RA@mail.gmail.com>
 <1472209920.390.34.camel@sipsolutions.net>
 <CAA93jw5mEMbUVs-i-Bpjkv6tX-umsO=9ZKPEnFcEj=22yjWX1g@mail.gmail.com>
Message-ID: <ca7f8cbdeeb259f5550e17a8f2a22e4f@codeaurora.org> (sfid-20160826_180816_060078_A4D15139)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-08-26 17:19, Dave Taht wrote:
> On Fri, Aug 26, 2016 at 4:12 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Fri, 2016-08-26 at 03:48 -0700, Dave Taht wrote:
>>> I'm always rather big on people testing latency under load, and napi
>>> tends to add some.
>> 
>> That's a completely useless comment.
>> 
>> Obviously, everybody uses NAPI; it's necessary for system load and 
>> thus
>> performance, and lets drivers take advantage of TCP merging to reduce
>> ACKs, which is tremendously helpful (over wifi in particular.)
>> 
>> Please stop making such drive-by comments that focus only on the 
>> single
>> thing you find important above all; not all people can care only about
>> that single thing, and unconstructively reiterating it over and over
>> doesn't help.
> 
> Well, I apologize for being testy. It is  I spent a lot of time
> testing michal's patchset for the ath10k back in may, and I *will* go
> and retest ath10k, when these patches land. My principal concern with
> using napi is at lower rates than the maxes typically reported in a
> patchset.
> 

You are always welcome to validate this change and share your feedback.

>  But it would be nice if people always did test for latency under load
> when making improvements, before getting to me, and despite having
> helped make a very comprehensive test suite available (flent) that
> tests all sorts of things for wifi, getting people to actually use it
> to see real problems, (in addition to latency under load!) while their
> fingers are still hot in the codebase, and track/plot their results,
> remains an ongoing issue across the entire industry.
> 
> http://blog.cerowrt.org/post/fq_codel_on_ath10k/
> 
As you know, NAPI is designed to improve performance of high speed n/w 
devices. From LWN: "NAPI is a proven 
(www.cyberus.ca/~hadi/usenix-paper.tgz) technique to improve network 
performance on Linux." Even most of Gig-speed network drivers were 
already migrated to NAPI. Tasklets are heavy CPU consumers and it will 
impact performance of other low priority tasks. The article[1] explains 
the problems of tasklet.

 From my observations, average CPU usage got reduced by 10% under heavy 
data traffic against same peak throughput. I validated this change on 
both IPQ4019 platform (Quad-Core ARM Cortex A7 processor) and AP135 
platform (uni-core MIPS 720 MHz processor). I did not observe any 
regression.

> There are many other problems in wifi, of course, that could use
> engineering mental internalization, like airtime fairness, and the
> mis-behavior of the hardware queues,
> 
> http://blog.cerowrt.org/post/cs5_lockout/
> 
> wifi channel scans
> 
> http://blog.cerowrt.org/post/disabling_channel_scans/
> 
> and so on.
> 
> I have a ton more datasets and blog entries left to write up from the
> ath9k work thus far which point to some other issues (minstrel,
> aggregation, retries)
> 
your data are really impressive. Once again, feel free to validate this 
change and share your inputs.

[1] http://lwn.net/Articles/239633/

-Rajkumar
