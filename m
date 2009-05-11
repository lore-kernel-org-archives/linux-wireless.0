Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:3153 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbZEKWXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 18:23:00 -0400
Received: by wf-out-1314.google.com with SMTP id 26so2606164wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 15:23:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242079585.3845.6.camel@mj>
References: <20090203173228.GB9713@tesla> <20090216205115.21860@gmx.net>
	<43e72e890902161342j23b68a4eoabddb047fb9d9084@mail.gmail.com>
	<20090508211237.316290@gmx.net> <1241818845.6240.4.camel@mj>
	<43e72e890905081453h2d660e6dl38b714467c8f24cb@mail.gmail.com>
	<43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	<20090511001749.efx510zpk404owww-cebfxv@webmail.spamcop.net>
	<43e72e890905110040o6a87d963mf0d5a5a08b22fbfd@mail.gmail.com>
	<1242079585.3845.6.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 May 2009 15:22:41 -0700
Message-ID: <43e72e890905111522v27aa5ef6h4f047dbfae40a626@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath comes
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 3:06 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2009-05-11 at 00:40 -0700, Luis R. Rodriguez wrote:
>> On Sun, May 10, 2009 at 9:17 PM, Pavel Roskin <proski@gnu.org> wrote=
:
>> > Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>> >
>> >> I can reproduce, and I tried without the idle patches but I still=
 see
>> >> the issue. I see this issue only after suspend. Did you suspend a=
nd
>> >> get this as well? I see this using AR5416. If you are seeing this=
 on
>> >> suspend can you try with the patch I posted to linux-wireless to =
see
>> >> if it helps a little?
>> >
>> > I saw this on AR9280 without any suspends. =C2=A0The card doesn't =
support the
>> > 802.11a range, so it's not a direct equivalent of the problem I bi=
sected
>> > with ath5k (invalid rates when scanning and transmitting).
>>
>> Thanks for the heads up Pavel. So can you guys test with this option
>> set as follows:
>>
>> CONFIG_MAC80211_DEFAULT_PS_VALUE=3D0
>>
>> If using compat-wireless just stuff it into config.mk.
>>
>> This fixes my issues and points towards PS code. This could be how w=
e
>> handle PS in ath9k (more likely) or mac80211. For now please disable
>> this if using ath9k until we figure out what causes this.
>
> It looks like there are two issues, and I confused them. =C2=A0One is
> characterized by the kernel messages about the channel, the one
> originally reported in this thread. =C2=A0I have seen it, but I don't
> remember the exact circumstances.
>
> Another issue is connection loss to a WPA enabled AP after several
> minutes. =C2=A0That's what I have seen with AR9280. =C2=A0iwconfig st=
ill shows an
> association, but no traffic can flow.
>
> I just want to tell that it's two different issues. =C2=A0The later i=
s much
> more critical for me, but it would take about 15 minutes to verify ev=
ery
> step if bisecting. =C2=A0Unfortunately, I don't have time to bisect i=
t now,
> but maybe I'll do it later during this week.

Thanks for the heads up, lets address this in another thread then.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
