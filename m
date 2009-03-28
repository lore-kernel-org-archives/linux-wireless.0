Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:12521 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZC1U0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 16:26:34 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1923909wff.4
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 13:26:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238269957.4217.24.camel@johannes.local>
References: <20090323162834.154525349@sipsolutions.net> <20090323163053.344441542@sipsolutions.net>
	<20090328045529.GF5543@bombadil.infradead.org> <1238262118.4217.13.camel@johannes.local>
	<43e72e890903281218s6b4eeb9eu4a97aa3e87c5a3a6@mail.gmail.com>
	<1238269957.4217.24.camel@johannes.local>
Date: Sat, 28 Mar 2009 13:26:17 -0700
Message-ID: <43e72e890903281326j1bba2456j3b82bf3831b614f6@mail.gmail.com> (sfid-20090328_212644_055373_652CD3D1)
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 12:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-03-28 at 12:18 -0700, Luis R. Rodriguez wrote:
>
>> >> That's fine from a logical point of view as compromise here as ou=
r
>> >> ampdu start should be relatively quick. Now while I can say this
>> >> from a logical point of view this patch obviously needed more
>> >> testing but lets see how it holds up and I'm glad you're the one
>> >> who wrote it. I'm confident there won't be any issues but that
>> >> is something I cannot gaurantee just based on the review. We now
>> >> need to go out and tests this. All other patches previous to this
>> >> make 100% perfect sense.
>> >
>> > :)
>> > I think it also makes more _sense_ to not ask the driver to handle=
 these
>> > frames, because we won't set the AMPDU flag correctly if the sessi=
on
>> > start is declined.
>>
>> Hm, wouldn't we send them as normal frames if its declined here even=
tually?
>
> Yes, we take them off the sta->pending, put them through TX processin=
g
> and send them as normal frames.

OK so you're not suggesting we change this more, just stating that
this makes sense.

>> >> This piece:
>> >>
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (*state !=3D HT_=
AGG_STATE_IDLE) {
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 /* in progress */
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 queued =3D true;
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 info->flags |=3D IEEE80211_TX_INTFL_NEED_TXPROCESSING;
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 __skb_queue_tail(&tid_tx->pending, skb);
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> >>
>> >> Can probably be ported to stable too, to just TX_DROP.
>> >
>> > No, why? We're handing the frames to the driver. It wants to handl=
e
>> > those frames before agg session is started correctly. That's what =
I was
>> > referring to before with this making more sense now.
>>
>> OK I see that but I am not sure of what's done to the skb in the old
>> case if the session is note complete yet, nor now if the session get=
s
>> declined. I can check later, right now I'm feeling lazy.
>
> Before my patch the skb is still passed to the driver, which would ne=
ed
> to be able to handle it (it =3D=3D session being stopped). I'm not en=
tirely
> sure ath9k handles it properly but I suspect it does.

Not sure, this begs the question when you were seeing the received
addba response come up first. SInce both iwlagn and ath9k use the irq
safe aggregation cb I was suspecting this would happen in general on
UP boxen and probably even less likely to happen on ath9k as we don't
have to talk to the firmware during the ampdu start action.

>> > Ok that might make some sense, though as a parameter you can easil=
y see
>> > where it's coming from, I think :) I agree that the entire code is=
 a
>> > little brain twister...
>>
>> Yeah.. I had to re-read aggregation code again to get the hang of it=
=2E
>> Anything we can do to make
>> it easier for people to pick would be nice. I think I'll go patch up
>> the aggr-tx kdoc too now, unless we
>> plan on nuking some stuff soon again. I suspect the next big change
>> will be to move software based
>> aggregation queue handling and mapping to ACs within mac80211 for th=
at
>> type of hardware which
>> we'll need for ar9170, ralink stuff, broadcom (if that ever happens)
>> and our next generation 11n USB
>> driver.
>
> Right -- but I don't expect to be working on it any time soon myself.

I didn't expect you to. We may have the need first unless chr gets to
ar9170 stuff first.

   Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
