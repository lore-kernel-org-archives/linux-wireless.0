Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:45590 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbeHIS2A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 14:28:00 -0400
Received: by mail-wr1-f43.google.com with SMTP id f12-v6so5568859wrv.12
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2018 09:02:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lg9f1rw8.fsf@kamboji.qca.qualcomm.com>
References: <20180731211404.2eac1bb0@wiggum> <87lg9f1rw8.fsf@kamboji.qca.qualcomm.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 9 Aug 2018 18:02:06 +0200
Message-ID: <CAOiHx=nfndmCd-Vara_6764-muWGA0z-RrYXQGmPGHZ0UuzkSQ@mail.gmail.com> (sfid-20180809_180233_300508_6ADDDD39)
Subject: Re: b43/leds: Ensure NUL-termination of LED name string
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 August 2018 at 17:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michael B=C3=BCsch <m@bues.ch> writes:
>
>> strncpy might not NUL-terminate the string, if the name equals the buffe=
r size.
>> Use strlcpy instead.
>>
>> Signed-off-by: Michael Buesch <m@bues.ch>
>> Cc: stable@vger.kernel.org
>
> This is weird, with all the patches you submitted last week I get this
> if I download the patch from patchwork:
>
> $ git am -s 1.mbox
> Patch is empty. Was it split wrong?
>
> But if I download the patch directly from my IMAP folder I have no
> problems:
>
> $ git am -s 1.mbox
> Applying: b43/leds: Ensure NUL-termination of LED name string
>
> This happens even without my custom patchwork script so this has
> something to do with the patchwork server, but it's not obvious to me
> what triggers it. IIRC I have not seen anything like this before. It
> seems that you didn't use git-send-email, I strongly suggest to use that
> just to avoid problems like this.

Looks like patchwork mishandles the pgp signature, the patchwork mbox has

> Content-Type: multipart/signed; micalg=3Dpgp-sha512;
>  boundary=3D"Sig_/EN90ciRq4eWXDUcnZABQ0Ak"; protocol=3D"application/pgp-s=
ignature"

as the only content-type (and the boundary is nowhere to be found),
while the one in my inbox has

> Content-Type: multipart/signed; micalg=3Dpgp-sha512; boundary=3D"Sig_/EN9=
0ciRq4eWXDUcnZABQ0Ak"; protocol=3D"application/pgp-signature"
>
> --Sig_/EN90ciRq4eWXDUcnZABQ0Ak
> Content-Type: text/plain; charset=3DUS-ASCII
> Content-Transfer-Encoding: quoted-printable

When I remove the Content-Type: line(s) from the mbox from patchwork,
git recognises it again as a patch. I guess git am ignores everything
until the boundary, which got dropped by patchwork, so it never finds
the actual patch.


Regards
Jonas
