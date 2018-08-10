Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbeHJRAu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 13:00:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43/leds: Ensure NUL-termination of LED name string
References: <20180731211404.2eac1bb0@wiggum>
        <87lg9f1rw8.fsf@kamboji.qca.qualcomm.com>
        <CAOiHx=nfndmCd-Vara_6764-muWGA0z-RrYXQGmPGHZ0UuzkSQ@mail.gmail.com>
        <87mutvzfc5.fsf@kamboji.qca.qualcomm.com>
        <CAOiHx==2xBajOL1wQmC=9mv-DnCw4PrmumSMEOqoDC69OkAWNQ@mail.gmail.com>
        <87in4jzd6g.fsf@kamboji.qca.qualcomm.com>
        <CAOiHx=mWcN1=7ejJiZ+0T6FPDgU_GQdHyzJeBfa6Baq_9v0mWg@mail.gmail.com>
Date: Fri, 10 Aug 2018 17:30:35 +0300
In-Reply-To: <CAOiHx=mWcN1=7ejJiZ+0T6FPDgU_GQdHyzJeBfa6Baq_9v0mWg@mail.gmail.com>
        (Jonas Gorski's message of "Fri, 10 Aug 2018 10:31:40 +0200")
Message-ID: <87a7puz438.fsf@kamboji.qca.qualcomm.com> (sfid-20180810_163132_663556_D06A1849)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonas Gorski <jonas.gorski@gmail.com> writes:

> On 9 August 2018 at 19:01, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Jonas Gorski <jonas.gorski@gmail.com> writes:
>>
>>> On 9 August 2018 at 18:15, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>> Jonas Gorski <jonas.gorski@gmail.com> writes:
>>>>
>>>>> On 9 August 2018 at 17:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>>>>> Michael B=C3=BCsch <m@bues.ch> writes:
>>>>>>
>>>>>>> strncpy might not NUL-terminate the string, if the name equals the =
buffer size.
>>>>>>> Use strlcpy instead.
>>>>>>>
>>>>>>> Signed-off-by: Michael Buesch <m@bues.ch>
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>
>>>>>> This is weird, with all the patches you submitted last week I get th=
is
>>>>>> if I download the patch from patchwork:
>>>>>>
>>>>>> $ git am -s 1.mbox
>>>>>> Patch is empty. Was it split wrong?
>>>>>>
>>>>>> But if I download the patch directly from my IMAP folder I have no
>>>>>> problems:
>>>>>>
>>>>>> $ git am -s 1.mbox
>>>>>> Applying: b43/leds: Ensure NUL-termination of LED name string
>>>>>>
>>>>>> This happens even without my custom patchwork script so this has
>>>>>> something to do with the patchwork server, but it's not obvious to me
>>>>>> what triggers it. IIRC I have not seen anything like this before. It
>>>>>> seems that you didn't use git-send-email, I strongly suggest to use =
that
>>>>>> just to avoid problems like this.
>>>>>
>>>>> Looks like patchwork mishandles the pgp signature, the patchwork mbox=
 has
>>>>>
>>>>>> Content-Type: multipart/signed; micalg=3Dpgp-sha512;
>>>>>>  boundary=3D"Sig_/EN90ciRq4eWXDUcnZABQ0Ak"; protocol=3D"application/=
pgp-signature"
>>>>>
>>>>> as the only content-type (and the boundary is nowhere to be found),
>>>>> while the one in my inbox has
>>>>>
>>>>>> Content-Type: multipart/signed; micalg=3Dpgp-sha512;
>>>>>> boundary=3D"Sig_/EN90ciRq4eWXDUcnZABQ0Ak";
>>>>>> protocol=3D"application/pgp-signature"
>>>>>>
>>>>>> --Sig_/EN90ciRq4eWXDUcnZABQ0Ak
>>>>>> Content-Type: text/plain; charset=3DUS-ASCII
>>>>>> Content-Transfer-Encoding: quoted-printable
>>>>>
>>>>> When I remove the Content-Type: line(s) from the mbox from patchwork,
>>>>> git recognises it again as a patch. I guess git am ignores everything
>>>>> until the boundary, which got dropped by patchwork, so it never finds
>>>>> the actual patch.
>>>>
>>>> Awesome, thanks for debugging this! It would be great if someone could
>>>> report this to the patchwork maintainers, I don't have the time right
>>>> now.
>>>
>>> Silly question, but who *are* the maintainers? I just spend several
>>> minutes on https://patchwork.kernel.org/ and google, and failed to
>>> find any contact information.
>>
>> Not a silly question at all. I'm not sure what's the preferred way to
>> report bugs but at least I found this:
>>
>> http://jk.ozlabs.org/projects/patchwork/
>>
>> I guess they use the github tracker:
>>
>> https://github.com/getpatchwork/patchwork/issues/
>
> Going through the issues, I guess this is already fixed in master with
>
> https://github.com/getpatchwork/patchwork/commit/e27ff061dc01e51967a97888=
4a5c59152863ab9c
>
> and queued for the next 2.1 release (or not? the stable/2.1 branch
> also contains a version bump to 2.2 ... )

Very nice, thanks so much for investigating this!

> I have still no idea who runs the patchwork instance at
> patchwork.kernel.org though.

The admins are Linux Foundation's IT group and one can file a ticket via
helpdesk@kernel.org But IMHO there's no need to do that, this is the
first time I'm seeing the bug and it can easily wait until
patchwork.kernel.org is updated anyway. As long as the issue is fixed
upstream.

--=20
Kalle Valo
