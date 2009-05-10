Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:30137 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZEJSlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 14:41:53 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1887856rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2009 11:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905081453h2d660e6dl38b714467c8f24cb@mail.gmail.com>
References: <20090203173228.GB9713@tesla> <20090206202205.218710@gmx.net>
	<20090206211804.GG5031@tesla> <20090214230618.203560@gmx.net>
	<43e72e890902141718v544f5caejb71f53bdadbf8a8f@mail.gmail.com>
	<20090216205115.21860@gmx.net> <43e72e890902161342j23b68a4eoabddb047fb9d9084@mail.gmail.com>
	<20090508211237.316290@gmx.net> <1241818845.6240.4.camel@mj>
	<43e72e890905081453h2d660e6dl38b714467c8f24cb@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 10 May 2009 11:41:33 -0700
Message-ID: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath comes
To: Pavel Roskin <proski@gnu.org>
Cc: Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 8, 2009 at 2:53 PM, Luis R. Rodriguez <mcgrof@gmail.com> wr=
ote:
> On Fri, May 8, 2009 at 2:40 PM, Pavel Roskin <proski@gnu.org> wrote:
>> On Fri, 2009-05-08 at 23:12 +0200, Alexander Bartha wrote:
>>> Hello to everybody at linuxwireless
>>>
>>> Since the "Submodule" ath comes aht9k says in messages:
>>>
>>> May =C2=A07 22:11:34 ws1 [ 4442.304763] ath9k: Unable to set channe=
l
>>> May =C2=A07 22:11:34 ws1 [ 4442.425550] ath9k: timeout (100000 us) =
on reg 0x9860: 0x0
>>> 0049d19 & 0x00000001 !=3D 0x00000000
>>> May =C2=A07 22:11:34 ws1 [ 4442.425555] ath9k: Unable to reset chan=
nel (2422 Mhz) res
>>> et status 4294967291
>>> May =C2=A07 22:11:34 ws1 [ 4442.425560] ath9k: Unable to set channe=
l
>>> May =C2=A07 22:11:34 ws1 [ 4442.546365] ath9k: timeout (100000 us) =
on reg 0x9860: 0x0
>>> 0049d19 & 0x00000001 !=3D 0x00000000

I can reproduce, and I tried without the idle patches but I still see
the issue. I see this issue only after suspend. Did you suspend and
get this as well? I see this using AR5416. If you are seeing this on
suspend can you try with the patch I posted to linux-wireless to see
if it helps a little?

  Luis

>>> i have tried different versions of the modules but since compat-wir=
eless-2009-04-16 i get this errors.
>>>
>>> till that all works fine sometime the driver have little problems a=
fter not using the network. thanks for the drivers
>>
>> I track wireless-testing.git and I saw it in the last weeks. =C2=A0I=
 think it
>> happens after about 260 pings at the normal speed (i.e. not with flo=
od
>> ping). =C2=A0I was thinking about bisecting the problem, but I don't=
 have
>> much time right now.
>>
>> Last time I saw it was on Monday. =C2=A0There were some changes to a=
th9k
>> since then, so maybe it's fixed.
>
> This may have been caused by the idle patches for which Johannes has
> posted a fix. This should get merged soon so give it a few more days
> and try again.
>
> If you want something a little more stable you can go with the stable
> compat-wireless releases:
>
> http://wireless.kernel.org/en/users/Download/stable
>
> =C2=A0Luis
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
