Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:51253 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbeICPbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 11:31:03 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Grant Grundler <grundler@google.com>, wgong@qti.qualcomm.com
Cc: wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <1535967508.3437.31.camel@sipsolutions.net>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com> <1535967508.3437.31.camel@sipsolutions.net>
Date: Mon, 03 Sep 2018 13:11:21 +0200
Message-ID: <87in3m25uu.fsf@toke.dk> (sfid-20180903_131249_777038_0020D925)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2018-08-30 at 16:32 -0700, Grant Grundler wrote:
>> On Sun, Aug 12, 2018 at 10:37 PM Wen Gong <wgong@qti.qualcomm.com> wrote:
>> ...
>> > I have tested with your method for shift 6/8/10/7 all twice time in open air environment.
>> 
>> I've attached the graphed data which Wen provided me and I made one
>> "cleanup": the median and average "ICMP" are computed only using
>> values where flent has an "antagonist" load running.  The first 28 and
>> last 26 seconds of the test are "idle" - it makes no sense to include
>> the latency of those. This drops about 1/7th of the data points.
>> 
>> My observations:
>> o the delta between average and median is evidence this is not
>> particularly reliable data (but expected result for "open air" wifi
>> testing in a corp environment).
>> o sk_pacing_shift=8 and/or =7 appears to have suffered from
>> significant open air interference - I've attached a graph of the raw
>> data.
>> o I'm comfortable asserting throughput is higher and latency is lower
>> for sk_pacing_shift=6 (vs 7) at the cost of additional CPU
>> utilization.
>> 
>> My questions:
>> 1) Is the current conversation just quibbling about 6 vs 7 for the
>> ath10k default?
>
> 6 vs. 8, I think? But I didn't follow the full discussion.
>
> I also think that we shouldn't necessarily restrict this to "for the
> ath10k". Is there any reason to think that this would be different for
> different chips?

No, I also think it should be possible to select a value that will work
for all drivers. There's a strong diminishing returns effect here after
a certain point, and I believe we should strongly push back against just
adding more buffering to chase (single-flow) throughput numbers; and I'm
not convinced that having different values for different drivers is
worth the complexity.

As far as I'm concerned, just showing an increase in maximum throughput
under ideal conditions (as this initial patch submission did) is not
sufficient argument for adding more buffering. At a minimum, the
evaluation should also include:

- Impact on latency and throughput for competing flows in the same test.
- Impact on latency for the TCP flow itself.
- A full evaluation at low rates and in scenarios with more than one
  client.

As far as the actual value, I *think* it may be that the default shift
should be 7 (8 ms) rather than 8 (4 ms) as it currently is. Going back
and looking at my data from when I submitted the original patch, it
looks like the point of diminishing returns is somewhere between those
two with ath9k (where I did most of my testing), and it seems reasonable
that it could be slightly higher (i.e., more buffering) for ath10k.

-Toke
