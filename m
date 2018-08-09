Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40037 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbeHITHH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 15:07:07 -0400
Received: by mail-wr1-f41.google.com with SMTP id h15-v6so5698763wrs.7
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2018 09:41:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mutvzfc5.fsf@kamboji.qca.qualcomm.com>
References: <20180731211404.2eac1bb0@wiggum> <87lg9f1rw8.fsf@kamboji.qca.qualcomm.com>
 <CAOiHx=nfndmCd-Vara_6764-muWGA0z-RrYXQGmPGHZ0UuzkSQ@mail.gmail.com> <87mutvzfc5.fsf@kamboji.qca.qualcomm.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 9 Aug 2018 18:41:04 +0200
Message-ID: <CAOiHx==2xBajOL1wQmC=9mv-DnCw4PrmumSMEOqoDC69OkAWNQ@mail.gmail.com> (sfid-20180809_184153_120873_55C107D1)
Subject: Re: b43/leds: Ensure NUL-termination of LED name string
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 August 2018 at 18:15, Kalle Valo <kvalo@codeaurora.org> wrote:
> Jonas Gorski <jonas.gorski@gmail.com> writes:
>
>> On 9 August 2018 at 17:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Michael B=C3=BCsch <m@bues.ch> writes:
>>>
>>>> strncpy might not NUL-terminate the string, if the name equals the buf=
fer size.
>>>> Use strlcpy instead.
>>>>
>>>> Signed-off-by: Michael Buesch <m@bues.ch>
>>>> Cc: stable@vger.kernel.org
>>>
>>> This is weird, with all the patches you submitted last week I get this
>>> if I download the patch from patchwork:
>>>
>>> $ git am -s 1.mbox
>>> Patch is empty. Was it split wrong?
>>>
>>> But if I download the patch directly from my IMAP folder I have no
>>> problems:
>>>
>>> $ git am -s 1.mbox
>>> Applying: b43/leds: Ensure NUL-termination of LED name string
>>>
>>> This happens even without my custom patchwork script so this has
>>> something to do with the patchwork server, but it's not obvious to me
>>> what triggers it. IIRC I have not seen anything like this before. It
>>> seems that you didn't use git-send-email, I strongly suggest to use tha=
t
>>> just to avoid problems like this.
>>
>> Looks like patchwork mishandles the pgp signature, the patchwork mbox ha=
s
>>
>>> Content-Type: multipart/signed; micalg=3Dpgp-sha512;
>>>  boundary=3D"Sig_/EN90ciRq4eWXDUcnZABQ0Ak"; protocol=3D"application/pgp=
-signature"
>>
>> as the only content-type (and the boundary is nowhere to be found),
>> while the one in my inbox has
>>
>>> Content-Type: multipart/signed; micalg=3Dpgp-sha512;
>>> boundary=3D"Sig_/EN90ciRq4eWXDUcnZABQ0Ak";
>>> protocol=3D"application/pgp-signature"
>>>
>>> --Sig_/EN90ciRq4eWXDUcnZABQ0Ak
>>> Content-Type: text/plain; charset=3DUS-ASCII
>>> Content-Transfer-Encoding: quoted-printable
>>
>> When I remove the Content-Type: line(s) from the mbox from patchwork,
>> git recognises it again as a patch. I guess git am ignores everything
>> until the boundary, which got dropped by patchwork, so it never finds
>> the actual patch.
>
> Awesome, thanks for debugging this! It would be great if someone could
> report this to the patchwork maintainers, I don't have the time right
> now.

Silly question, but who *are* the maintainers? I just spend several
minutes on https://patchwork.kernel.org/ and google, and failed to
find any contact information.


Regards
Jonas
