Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:9647 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYJaB0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 21:26:53 -0400
Received: by yx-out-2324.google.com with SMTP id 8so419573yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 18:26:51 -0700 (PDT)
Message-ID: <43e72e890810301826x72ca0c75xd986a30227429d08@mail.gmail.com> (sfid-20081031_022657_949500_832E6C79)
Date: Thu, 30 Oct 2008 18:26:51 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <1ba2fa240810231417s55f6754cl54a38d9b79526cd8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
	 <18688.17545.136327.991699@gargle.gargle.HOWL>
	 <1224773124.6002.32.camel@johannes.berg>
	 <43e72e890810231023q5650184r8ce50cb51b63e706@mail.gmail.com>
	 <1ba2fa240810231131l9c9597au2acf166a13a8c03b@mail.gmail.com>
	 <43e72e890810231318t2ef200e4wed96b48efefa62bb@mail.gmail.com>
	 <1ba2fa240810231417s55f6754cl54a38d9b79526cd8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 2:17 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Thu, Oct 23, 2008 at 10:18 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Oct 23, 2008 at 11:31 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>>> On Thu, Oct 23, 2008 at 7:23 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>
>>>> I checked internally to verify where you would decide when to AMPDU
>>>> and to try to get different reviews and opinions, and it seems that
>>>> the path we take right now is correct as there is not much overhead so
>>>> we always use AMPDU with whoever supports it with data frames. If
>>>> you're a STA you do it all the time with the AP for data frames.
>>>>
>>>> I noticed iwlagn had some more logic within the RC but I gave up
>>>> trying to follow the logic. I suspect they do the same though, Tomas?
>>
>> Thanks for the feedback!
>>
>>> I got different output from our system engineering. APMDU has overhead
>>
>> Is that because of the interactions required in firmware for scheduling BTW?
>>
> No HW support make aggregation faster, the overhead is in the air. BA
> is bigger then ACK so if you don't have burst than you need to send BA
> for single frame it's slower then sending ACK.
>
>>> and if there is not requirement
>>> for high throughput we don't initiate one.
>>
>> This makes sense to me regardless.
>>
>>> What is for sure we shounld
>>> not have aggregation enabled for VO AC.
>>
>> Any particular reason? I'll review this too, but my guess would be the
>> buffering required before TXing. I'll see how we perform with aggr on
>
> No the problem is on the receiver side you don't release packets to
> network stuck out of order so there is inherit delay in aggregation.
> Voice is sensitive to delay and jitter.

I got some more review on this and it seems you can potentially have
optimizations not only for VO (besides just disabling it) but also for
each AC on aggregation (well BE and BK can use the same). Question is
how do we want to deal with this for now in mac80211, leave it up to
each driver to handle this or do we move this centrally to mac80211?
I'd rather we try to come to some agreement on some decent decision
for each AC and move this decision to mac80211. Thoughts?

  Luis
