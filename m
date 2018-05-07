Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeEGTEF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 15:04:05 -0400
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
Date: Mon, 07 May 2018 22:03:58 +0300
In-Reply-To: <20180507204317.52992b6c@wiggum> ("Michael \=\?utf-8\?Q\?B\=C3\=BCs\?\=
 \=\?utf-8\?Q\?ch\=22's\?\= message of
        "Mon, 7 May 2018 20:43:17 +0200")
Message-ID: <874ljj2spt.fsf@kamboji.qca.qualcomm.com> (sfid-20180507_210418_483462_92443E29)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael B=C3=BCsch <m@bues.ch> writes:

> On Mon, 7 May 2018 10:44:34 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> Although commit 882164a4a928 ("ssb: Prevent build of PCI host features i=
n=20
>> module") appeared to be harmless, it leads to complete failure of driver=
s b43.=20
>
>>   config SSB_DRIVER_PCICORE_POSSIBLE
>>          bool
>> -       depends on SSB_PCIHOST && SSB =3D y
>> +       depends on SSB_PCIHOST && (SSB =3D y || !MIPS)
>>          default y
>>=20
>>   config SSB_DRIVER_PCICORE
>
>
> https://patchwork.kernel.org/patch/10161131/
>
> Could we _please_ switch to not applying patches to ssb or b43, if
> nobody acked (or better reviewed) a patch?
>
> We had multiple changes to ssb and b43 in the recent past that did not
> have a review at all and broke something. I don't think such software
> quality is acceptable at all.
> So please revert 882164a4a928.

Yes, someone please send a revert so that this can be fixed quickly for
v4.17.

> I'm sorry that this patch slipped through the cracks of my inbox.
> But the reaction to that shall not be to just apply the patch. It
> shall be to resubmit it for review.

The thing is that in general I do not have time to ping people for every
patch, I get enough of emails as is. If there are no review comments I
have to assume the patch is ok to apply.

But as ssb has had two major regressions recently I'm going to
significantly raise the bar for ssb patches, and will refuse to apply
random patches if they have not been tested with b43/b44.

--=20
Kalle Valo
