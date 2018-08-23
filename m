Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45174 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbeHWKV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 06:21:28 -0400
Subject: Re: FTM/measurement APIs
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1534766611.6287.20.camel@sipsolutions.net>
From: Lior David <liord@codeaurora.org>
Message-ID: <eea4129b-b994-ff31-2397-a1630b8a8e9a@codeaurora.org> (sfid-20180823_085336_048126_0609232A)
Date: Thu, 23 Aug 2018 09:53:13 +0300
MIME-Version: 1.0
In-Reply-To: <1534766611.6287.20.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 8/20/2018 3:03 PM, Johannes Berg wrote:
> Hi all,
> 
> After much delay on our side (don't ask), I'm contemplating upstream
> APIs for FTM again.
> 
I appreciate the effort. I had a discussion with Luca on the previous API a long
time ago and gave some comments, mainly to ensure it fits 11ad use cases, but
sadly I also moved to other tasks...

> Luca tells me that there are also other things to take into
> consideration, notably angle of arrival. Or CIR/CFR but I have no idea
> what those are, unless they're "Channel Impulse/Frequency Response" and
> then perhaps that's what's used for angle measurement?
> 
Yes AOA (angle of arrival) is based on CIR(channel impulse response) or CFR
(channel frequency response). Our 11ad chip can do CIR but most other chips do
CFR (I think). AOA finds azimuth and elevation from CIR by running some
algorithm in user space and using a database. Not sure how easy it is to offload
to FW. Anyhow I suggest calling the measurement CIR or CFR and not mentioning
AOA, since the CIR/CFR can be useful for other stuff.

> Anyway, I'll use the angle measurement as an example here.
> 
> In building the APIs for this, I'm wondering how much "generics" make
> sense. We could build an API that's structured like this:
> 
> Measure(
>  - [timeout]
>  - [MAC randomization]
>  - FTM
>    - <FTM settings like TSF request?>
>    - targets
>      0: - MAC address
>         - channel
>         - ...
>      1: - MAC address
>         - channel
>         - ...
>  - Angle
>    - <common settings>
>    - targets
>      0: - MAC address
>         - channel
>         - ...
> )
> 
> This is very generic, so you could add something like
> 
>   - my_other_measurement
>     - param1
>     - param2
> 
> that's in no way connected to the target list.
> 
> However, note the duplication of MAC/channel.
> 
> You could also have only partially overlapping (or entirely disjoint)
> target lists, in which case the concurrency no longer makes much sense.
> The driver would have to build a combined target list, and then execute
> the measurements. This implies more logic is needed.
> 
> 
> The other option is to restrict this new API to doing "peer-related"
> measurements, and build the list like this:
> 
> Peer-Measurement(
>   - [timeout]
>   - [MAC randomization]
>   - global FTM options
>     - ...
>   - global angle options
>     - ...
>   - peers
>     0: - MAC address
>        - channel
>        - FTM
>          - ... [FTM settings]
>        - Angle
>          - ... [Angle settings]
>     1: - MAC address
>        - channel
>        - ...
> )
> 
> This is less generic, since it's restricted to a list of MAC/channel
> pairs as the list of targets, and you can't add any other non-target
> measurements to do simultaneously, at least not directly in this
> structure. We could possibly still add it, but it would be more complex.
> 
> (And maybe the global options aren't really needed, for FTM the only one
> I can think of is "request associated AP TSF" but that could be a per-
> peer setting too.)
> 
> 
> In a way, I prefer the second option. It's far simpler to start out
> with, technically could be extended to non-peer measurements (though not
> as cleanly perhaps), and matches the various location use cases far
> better.
> 
I also prefer the second option. It is both simpler and allows the driver to
better organize the measurements (for example, in our implementation we always
do CIR at the beginning or end of FTM burst).

> 
> Any thoughts? Is anyone aware of any other measurements that are coming
> up to be used in products that we'd want to cover here?
> 
We had some "exotic" measurements that we wanted to support but none are
critical as far as I remember...
I can provide more detailed comments when you send actual nl80211 API (I think I
gave most comments to Luca but can find them again).

Thanks,
Lior
