Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:24538 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZEMWbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:31:15 -0400
Received: by wf-out-1314.google.com with SMTP id 26so598412wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 15:31:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242253362.10076.7.camel@johannes.local>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	<1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
	<1242208515.29288.0.camel@johannes.local> <20090513181458.GB19693@tesla>
	<1242253362.10076.7.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 15:30:56 -0700
Message-ID: <43e72e890905131530m1822394wc136c2d5f7fe80dc@mail.gmail.com>
Subject: Re: [RFC v2 3/5] cfg80211: add WoW support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 3:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 11:14 -0700, Luis R. Rodriguez wrote:
>
>> > > +enum nl80211_wow_triggers {
>> > > + NL80211_WOW_TRIGGER_MAGIC_PACKET =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 1 << 0,
>> > > + NL80211_WOW_TRIGGER_BMISS =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =3D 1 << 1,
>> > > + NL80211_WOW_TRIGGER_LINK_CHANGE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 1 << 2,
>> > > + NL80211_WOW_TRIGGER_PATTERN =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =3D 1 << 3,
>> > > +};
>> >
>> > Seems like you need to have a way to set the pattern and magic pac=
ket?
>>
>> Yeah TDB -- the code for that is a bit complex and I don't understan=
d how
>> things are being broken down yet. We could just not have the cababil=
ity
>> present until that's properly figured out.
>
> Yeah I think that would be preferable, maybe even not define the bits
> until we figure out what else we need. It might not actually make sen=
se
> to use bits here, for example if you need a magic packet to wake up i=
t
> might make sense to have just a magic packet netlink attribute that, =
if
> userspace passes it, defines that magic packet with that packet shoul=
d
> be used, instead of requiring that the user sets both the bit and giv=
es
> the packet. etc.

True -- the bit is useful for capability though, not for setting.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
