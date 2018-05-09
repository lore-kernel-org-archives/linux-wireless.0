Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60344 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755939AbeEIKDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 06:03:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression caused by commit 882164a4a928
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
        <20180507204317.52992b6c@wiggum>
        <874ljj2spt.fsf@kamboji.qca.qualcomm.com>
        <20180507213043.727cee15@wiggum>
Date: Wed, 09 May 2018 13:03:30 +0300
In-Reply-To: <20180507213043.727cee15@wiggum> ("Michael \=\?utf-8\?Q\?B\=C3\=BCs\?\=
 \=\?utf-8\?Q\?ch\=22's\?\= message of
        "Mon, 7 May 2018 21:30:43 +0200")
Message-ID: <87lgctw3gt.fsf@kamboji.qca.qualcomm.com> (sfid-20180509_120404_114155_F632873A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael B=C3=BCsch <m@bues.ch> writes:

> On Mon, 07 May 2018 22:03:58 +0300
> Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Michael B=C3=BCsch <m@bues.ch> writes:
>>=20
>> > On Mon, 7 May 2018 10:44:34 -0500
>> > Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> >=20=20
>> >> Although commit 882164a4a928 ("ssb: Prevent build of PCI host feature=
s in=20
>> >> module") appeared to be harmless, it leads to complete failure of dri=
vers b43.=20=20=20
>> >=20=20
>> >>   config SSB_DRIVER_PCICORE_POSSIBLE
>> >>          bool
>> >> -       depends on SSB_PCIHOST && SSB =3D y
>> >> +       depends on SSB_PCIHOST && (SSB =3D y || !MIPS)
>> >>          default y
>> >>=20
>> >>   config SSB_DRIVER_PCICORE=20=20
>> >
>> >
>> > https://patchwork.kernel.org/patch/10161131/
>> >
>> > Could we _please_ switch to not applying patches to ssb or b43, if
>> > nobody acked (or better reviewed) a patch?
>> >
>> > We had multiple changes to ssb and b43 in the recent past that did not
>> > have a review at all and broke something. I don't think such software
>> > quality is acceptable at all.
>> > So please revert 882164a4a928.=20=20
>>=20
>> Yes, someone please send a revert so that this can be fixed quickly for
>> v4.17.
>
> Uhm, can you just type git revert 882164a4a928? :)

But it needs a proper commit log explaining why it's reverted (links to
bugzilla report etc). And I prefer also reverts to be reviewed on the
list.

> Or do I have to send you a pull request?

A revert is a regular commit, so you can submit it using git
format-patch and git send-email.

>> > I'm sorry that this patch slipped through the cracks of my inbox.
>> > But the reaction to that shall not be to just apply the patch. It
>> > shall be to resubmit it for review.=20=20
>>=20
>> The thing is that in general I do not have time to ping people for every
>> patch, I get enough of emails as is. If there are no review comments I
>> have to assume the patch is ok to apply.
>
> Yes, I understand that pinging people can be annoying and time
> consuming. But we have tools like patchwork. Why isn't pinging
> (semi)automated? Patchwork should really track the review status of a
> patch.

That would be awesome but patchwork is nowhere near that kind of
sophistication. I like it but to be honest it's really simple at the
moment. My custom client script has a simple way to ping about patches
but even that is too much work on the long run. Some people do send Acks
to the driver they maintain but not always, I guess because too busy
with real life or something which is totally understandable. But it
would not scale at all if I would start pinging for the 25% of patches
that they have not acked.

> I think the concept of no-comments =3D everything-ok is
> fundamentally broken. But it has always been that way for wireless and
> lots of other subsystems.

It's a balance between bureaucracy and getting things done. From my POV
the only viable solution is that maintainers actively follow the patches
on the mailing list.

--=20
Kalle Valo
