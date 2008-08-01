Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:62794 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYHAMkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 08:40:05 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1037906rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 05:40:05 -0700 (PDT)
Message-ID: <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com> (sfid-20080801_144008_958774_0CBAFB27)
Date: Fri, 1 Aug 2008 15:40:04 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1217592554.8621.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 1, 2008 at 3:09 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Had to think about this for a bit...
>
>> > Right. Which brings us back to the original point, why does the hw need
>> > to make the scheduling decision between agg and non-agg?
>>
>> There is no scheduling between aag and legacy queue in the sense of
>> qdisc .
>
> Right. So why are you saying we should have a separate qdisc for it?

I need a sw queue for it.

>> The aggregation need to be taken from single stream as
>> explained before,
>
> I think we simply agree on that. Which brings me back to my original
> point: to provide fairness within that stream we shouldn't have separate
> qdiscs for agg/non-agg parts of the stream.

You agree on the fact that it's a seperate stream but you still
doesn't want separate queue for it....

>> Iwlwifi has HW support for it that that's the whole story we just need
>> queueing support from the software buffering stopping and starting
>> queue and last but not least there is a classification just an
>> extension of the regular AC scheduling.  The fairness between legacy
>> and agg queue must be provided by actually 'not scheduling'
>
> I don't understand what you mean by "not scheduling".

Not scheduling mean not string to prioritize streams in SW. I guess it means RR.

 AIUI from the
> specs, there is no scheduling between aggregation/non-aggregation
> queues, or "within an AC" as I would say it.
>
> Therefore, I think we should remove the extra software queues and split
> up the single-AC stream into the different hardware queues in the
> driver, to be reunited in the FIFOs.

Aggregation is a separate stream even on the air it has it's own
rhythm.  For example
from AP perspective you an have 3 streams for the same TID for 3
stations. Each station
has it's own rate of processing aggregation stream.  It may vary on
number of packets and size of the aggregation
this is determine in association time.
So shell I stop the whole AC queue just because on station is slower?
Tomas
