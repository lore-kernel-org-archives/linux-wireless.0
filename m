Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:51512 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZCYDqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 23:46:11 -0400
Received: by an-out-0708.google.com with SMTP id d14so2208264and.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 20:46:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903242015l449f0835v5602694c735f9b96@mail.gmail.com>
References: <200903241938.47155.chunkeey@web.de> <200903242324.33485.chunkeey@web.de>
	<20090324223022.M51759@bobcopeland.com> <43e72e890903241613x6e6de1ecp909ee6f4156ba709@mail.gmail.com>
	<43e72e890903241617i629a4c75of573bb7f77572ade@mail.gmail.com>
	<43e72e890903241652o70aa8e2bjd40a5ae9a4ebc91a@mail.gmail.com>
	<20090325010626.GA8528@hash.localnet> <43e72e890903241930g7985f7c7i858a0e94fb8db667@mail.gmail.com>
	<43e72e890903241959x51dc9278oc424bfa85cff9e0f@mail.gmail.com>
	<43e72e890903242015l449f0835v5602694c735f9b96@mail.gmail.com>
Date: Tue, 24 Mar 2009 20:45:53 -0700
Message-ID: <43e72e890903242045n520842c3q9392f75651a6b905@mail.gmail.com> (sfid-20090325_044613_187380_AA4D5466)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 8:15 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Mar 24, 2009 at 7:59 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Tue, Mar 24, 2009 at 7:30 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> On Tue, Mar 24, 2009 at 6:06 PM, Bob Copeland <me@bobcopeland.com> =
wrote:
>>>> On Tue, Mar 24, 2009 at 04:52:09PM -0700, Luis R. Rodriguez wrote:
>>>>> Alright here's a quick concat of all these patches (also one smal=
l
>>>>> sparse fix on Christian's last patch). It also now throws ath5k, =
ath9k
>>>>> and ar9170 into ath/. We can rename the drivers after, was lazy t=
o do
>>>>> that. Think its easier for review to separate that too.
>>>>>
>>>>> http://bombadil.infradead.org/~mcgrof/patches/ath/ath-common-v3.p=
atch.txt
>>>>>
>>>>> Bob, where was that switch break error?
>>>>
>>>> 1st patch:
>>>>
>>>>> + =C2=A0 =C2=A0 switch (band) {
>>>>> + =C2=A0 =C2=A0 case IEEE80211_BAND_2GHZ:
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl =3D ah->regulator=
y.regpair->reg_2ghz_ctl;
>>>>> + =C2=A0 =C2=A0 case IEEE80211_BAND_5GHZ:
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl =3D ah->regulator=
y.regpair->reg_5ghz_ctl;
>>>>> + =C2=A0 =C2=A0 default:
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl =3D NO_CTL;
>>>>> + =C2=A0 =C2=A0 }
>>>>> + =C2=A0 =C2=A0 return ctl;
>>>>> +}
>>>>
>>>> I think I had it like the following and changed it -- actually wit=
h
>>>> the returns it's probably better...
>>>>
>>>> switch (band) {
>>>> case XXX:
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ah->...;
>>>> case YYY:
>>>> ...
>>>> }
>>>
>>> Alright thanks, I've fixed that here, it also now does not introduc=
e
>>> any new checkpatch or sparse complaints.
>>>
>>> http://bombadil.infradead.org/~mcgrof/patches/ath/ath-common-v4.pat=
ch.txt
>>>
>>> My shiny new wl rebased on 29 kernel is compiling, will let you kno=
w
>>> in the morning how it goes.
>>
>> Ah poo, ath5k_reg_notifier() got lost.
>
> Fixed..
>
> http://bombadil.infradead.org/~mcgrof/patches/ath/ath-common-v5.patch=
=2Etxt

Nope.. no luck, something got messed up along the way... needs a closer=
 look.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
