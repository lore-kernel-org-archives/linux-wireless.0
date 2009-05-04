Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:12890 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZEDTX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 15:23:29 -0400
Received: by wf-out-1314.google.com with SMTP id 26so3335038wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 12:23:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905042053.19091.rossi.f@inwind.it>
References: <1241452330.8683.49.camel@johannes.local> <49FF2FE8.8010004@gmail.com>
	<20090504181357.GA19022@tuxdriver.com> <200905042053.19091.rossi.f@inwind.it>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 May 2009 12:23:15 -0700
Message-ID: <43e72e890905041223n76ee71d8ie4322adc10917bb6@mail.gmail.com>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
To: Fabio Rossi <rossi.f@inwind.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Richard Farina <sidhayn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 4, 2009 at 11:53 AM, Fabio Rossi <rossi.f@inwind.it> wrote:
> On Monday 04 May 2009, John W. Linville wrote:
>
>> On Mon, May 04, 2009 at 02:11:52PM -0400, Richard Farina wrote:
>> > Johannes Berg wrote:
>> >> Umm, if _you_ set channel 11 then you _will_ see channel 11. It's=
 just
>> >> that when it's scanning and happens to be on channel 132 instead =
of 11,
>> >> while you previously set 11, you will _after_ this patch see 11, =
not
>> >> 132.
>> >
>> > Yes, and at what point does it seem like a good idea to hide the c=
hannel
>> > the wifi card is on? =C2=A0If I set channel 11 and it is scanning =
instead of
>> > locked on channel 11 then I should see the current channel the har=
dware
>> > is on. =C2=A0This seems like an aweful idea to me, granted, it may=
 help a few
>> > people that don't understand how scanning works, but hiding the tr=
uth is
>> > never a good idea. NACK.
>>
>> I can see what you mean, but I think showing seemingly random
>> fluctuations in channel assignments is at best distracting. =C2=A0Do=
n't you
>> agree that most people are more interested in seeing the configurati=
on
>> state than the transient state of the hardware?
>
> I want to report my experience. There was a bug in the ath5k driver w=
ith a
> hanging result during scanning mode. I was able to discover the probl=
em
> thanks to the iwconfig output.
>
> In alternative, is it possible to add a status flag so that iwconfig =
from user
> space can report scanning mode is operative?

iw event

Or the old way : iwevent

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
