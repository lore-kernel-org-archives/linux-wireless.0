Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56866 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032604Ab2I1U1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:46 -0400
Received: by ieak13 with SMTP id k13so8323150iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2012 13:27:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348829840.13298.17.camel@jlt4.sipsolutions.net>
References: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com>
	<1348737219.10353.6.camel@jlt4.sipsolutions.net>
	<CA+yqC4bo9Xcy9HMeJYAFHqEYBCUErF+Y4ivfe9s+xQ+endCU-Q@mail.gmail.com>
	<1348829840.13298.17.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Sep 2012 13:27:45 -0700
Message-ID: <CA+yqC4ZMZ+2jDoNW3dyetJB40gdAVUm7sAGQb5e-FyhNV9VHnA@mail.gmail.com> (sfid-20120928_233319_728275_94A374B9)
Subject: Re: [PATCH 0/3] add scan flags support
From: Sam Leffler <sleffler@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, eliad <eliad@wizery.com>,
	coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 28, 2012 at 3:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-09-27 at 09:39 -0700, Sam Leffler wrote:
>
>> > Maybe it'd be worthwhile to go for a more generic approach, marking
>> > scans as "low priority" or "high priority" or similar, and then
>> > implementing such behaviour based on such settings? Our device for
>> > example has a notion of "background scan" vs. "forced scan", which
>> > behave differently in the firmware, and it would be useful to be able to
>> > use these different behaviours. However, I can't say that "TX abort"
>> > would be a guaranteed scan behaviour for a "background scan".
>>
>> Having a priority mechanism or similar would be fine. I usually
>> hesitate doing the generic thing because the actual semantics can very
>> so significantly from driver to driver that applications may end up
>> having to build in knowledge of which driver is being used to get what
>> they way want. But in fact what you suggest is how txabort is used--we
>> mark wpa_supplicant bgscan's w/ txabort while fgscan's are not marked
>> in this way.
>
> Yes, I agree it's a slippery slope, however with all the different
> mechanisms that can be built in drivers/firmware/... I'm not really sure
> how else to treat them?
>
> In theory we could say that we have
>  * TX abort
>  * Intel BG scan (otherwise opaque, in firmware)
>  * TI BG scan (otherwise opaque, in firmware)
>  * ...
>
> as separate flags/settings/..., but ultimately it seems that all that
> would happen is that everybody would patch the supplicant to use their
> mechanism for background scanning if available. Then, in theory, the
> supplicant would know which one it's using, but since it doesn't really
> know the semantics it doesn't really make a difference?
>
> Maybe we should agree on a few basic rules for the "generic" BG scan,
> but I'm not sure what sensible rules would be. They can't be rules on
> reliability, as then "tx-abort" wouldn't be a valid implementation
> (unless you retried, but that could literally run forever), and I'm not
> sure what other kind of rule would make sense. Either way, the
> supplicant is going to have to assume that a finished "BG scan" has a
> smaller result set than a "regular" scan ...
>
> There might be value in having more information about the actual "abort
> due to TX" (whether it happened or not), but again that would be tied to
> the specific implementation, and I'm not sure how to formulate any such
> thing more generically. Right now, I don't even know how our or TI's
> implementation behaves differently for the different types of scan.

In my experience the reason why a bgscan was aborted is not important;
you just want to know true/false so you know if you have a "complete
picture" of the environment to make decisions. I also find the abort
model much preferable to extending the scan work because unless
results are sent back immediately you can easily end up sending back
stale results.

-Sam
