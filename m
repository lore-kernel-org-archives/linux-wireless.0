Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:28194 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYJWVRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 17:17:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so521855wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 14:17:02 -0700 (PDT)
Message-ID: <1ba2fa240810231417s55f6754cl54a38d9b79526cd8@mail.gmail.com> (sfid-20081023_231710_321485_CDB22615)
Date: Thu, 23 Oct 2008 23:17:02 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <43e72e890810231318t2ef200e4wed96b48efefa62bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
	 <18688.17545.136327.991699@gargle.gargle.HOWL>
	 <1224773124.6002.32.camel@johannes.berg>
	 <43e72e890810231023q5650184r8ce50cb51b63e706@mail.gmail.com>
	 <1ba2fa240810231131l9c9597au2acf166a13a8c03b@mail.gmail.com>
	 <43e72e890810231318t2ef200e4wed96b48efefa62bb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 10:18 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Oct 23, 2008 at 11:31 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Thu, Oct 23, 2008 at 7:23 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>
>>> I checked internally to verify where you would decide when to AMPDU
>>> and to try to get different reviews and opinions, and it seems that
>>> the path we take right now is correct as there is not much overhead so
>>> we always use AMPDU with whoever supports it with data frames. If
>>> you're a STA you do it all the time with the AP for data frames.
>>>
>>> I noticed iwlagn had some more logic within the RC but I gave up
>>> trying to follow the logic. I suspect they do the same though, Tomas?
>
> Thanks for the feedback!
>
>> I got different output from our system engineering. APMDU has overhead
>
> Is that because of the interactions required in firmware for scheduling BTW?
>
No HW support make aggregation faster, the overhead is in the air. BA
is bigger then ACK so if you don't have burst than you need to send BA
for single frame it's slower then sending ACK.

>> and if there is not requirement
>> for high throughput we don't initiate one.
>
> This makes sense to me regardless.
>
>> What is for sure we shounld
>> not have aggregation enabled for VO AC.
>
> Any particular reason? I'll review this too, but my guess would be the
> buffering required before TXing. I'll see how we perform with aggr on

No the problem is on the receiver side you don't release packets to
network stuck out of order so there is inherit delay in aggregation.
Voice is sensitive to delay and jitter.

>> I've payed attention that there are different APs do that differently
>> some opens BA session on BE AC immediately upon association some do it
>> on high throughput I haven't seen in the second case it will be opened
>> on simple ping.
>> Anyhow if we would implement the triggering on throughput  simply
>> setting starting and stopping thresholds to small values will have
>> same effect as your solution and setting it to 0 and maximum will
>> respectively will have effect on  opening BA session upon association.
>
> Seems reasonable. If this is set then as a hw configurable option in
> mac80211 then we can even allow RC control this, should this ever be
> needed (we don't).
>
>  Luis
>
