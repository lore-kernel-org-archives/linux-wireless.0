Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:63410 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZCaISu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:18:50 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2902726rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 01:18:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238487365.5970.78.camel@johannes.local>
References: <1238471826-3980-1-git-send-email-lrodriguez@atheros.com>
	<1238485738.5970.64.camel@johannes.local> <43e72e890903310110l49b8a6b8hfe42202d5da0304@mail.gmail.com>
	<1238487365.5970.78.camel@johannes.local>
Date: Tue, 31 Mar 2009 01:18:32 -0700
Message-ID: <43e72e890903310118k6131fb90gd334fad47cb297ec@mail.gmail.com> (sfid-20090331_101854_011454_B1697754)
Subject: Re: [PATCH] cfg80211: send regulatory beacon hint events to userspace
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 1:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-03-31 at 01:10 -0700, Luis R. Rodriguez wrote:
>
>> >> + =C2=A0 =C2=A0 /* Unforunately this is needed */
>> >> + =C2=A0 =C2=A0 nl_bands =3D nla_nest_start(msg, NL80211_ATTR_WIP=
HY_BANDS);
>> >> + =C2=A0 =C2=A0 if (!nl_bands)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> >> + =C2=A0 =C2=A0 nl_band =3D nla_nest_start(msg, band);
>> >> + =C2=A0 =C2=A0 if (!nl_band)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> >> +
>> >> + =C2=A0 =C2=A0 /*
>> >> + =C2=A0 =C2=A0 =C2=A0* Our hack is to piggy back the channel pri=
or to beacon hint
>> >> + =C2=A0 =C2=A0 =C2=A0* and after the beacon hint so userspace ca=
n analyze the
>> >> + =C2=A0 =C2=A0 =C2=A0* differences. Right now only no-ibss and p=
assive-scan flags
>> >> + =C2=A0 =C2=A0 =C2=A0* can change as that's the only thing we ex=
pect to learn out
>> >> + =C2=A0 =C2=A0 =C2=A0* of a beacon for now. By re-using these at=
tributes we can
>> >> + =C2=A0 =C2=A0 =C2=A0* avoid introducing new structs.
>> >> + =C2=A0 =C2=A0 =C2=A0*/
>> >> + =C2=A0 =C2=A0 nl_freqs =3D nla_nest_start(msg, NL80211_BAND_ATT=
R_FREQS);
>> >> + =C2=A0 =C2=A0 if (!nl_freqs)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> >> +
>> >> + =C2=A0 =C2=A0 for (i =3D 0; i <=3D 1; i++) {
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nl_freq =3D nla_nest_=
start(msg, i);
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!nl_freq)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 goto nla_put_failure;
>> >> +
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chan =3D (i =3D=3D 0)=
 ? channel_before : channel_after;
>> >> +
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NLA_PUT_U32(mNo, that=
's not exclusive...sg, NL80211_FREQUENCY_ATTR_FREQ,
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 chan->center_freq);
>> >> +
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (chan->flags & IEE=
E80211_CHAN_PASSIVE_SCAN)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (chan->flags & IEE=
E80211_CHAN_NO_IBSS)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
>> >> +
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nla_nest_end(msg, nl_=
freq);
>> >> + =C2=A0 =C2=A0 }
>> >
>> > I don't think I like this -- it's confusing to userspace code that=
 wants
>> > to use a unified message parser.
>>
>> I know the feeling, more on this below.
>>
>> > Do we really need that before/after thing anyway? I think if we re=
ally
>> > need this then we should add new attributes.
>>
>> Well we can definitely add new attributes, but remember we still hav=
e
>> to pass the center of freq. The cleanest solution is to define an
>> attribute with a center-freq, if-passive-lifted, if-beaconing-enable=
d
>> flags. But that ends up adding all that for something we already hav=
e
>> attributes for. I chose to use what we have.
>
> No, we don't have to do that. All we'd need to do is add a new attrib=
ute
> NL80211_ATTR_FREQ_CHANGE, which we document to
> =C2=A01) contain an array
> =C2=A02) in that array, contain nesting
> =C2=A03) in that nesting contain NL80211_FREQUENCY_ATTR
>
> That means you'd only need to remove the bands nesting and replace th=
e
> BAND_ATTR_FREQS nesting by ATTR_FREQ_CHANGE nesting. Only one new
> attribute needed in total, and you can keep almost all the code too. =
The
> array nesting is a little ugly, but that's not a big concern.

Sounds good, thanks.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
