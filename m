Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46846 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753899AbdGUP3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 11:29:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
References: <20170716112129.10206-1-ian@mnementh.co.uk>
        <CACna6rxQNqdpuiq2mF3EJQ694AHa74tVex06vp53kqjrwoNkog@mail.gmail.com>
Date: Fri, 21 Jul 2017 18:29:42 +0300
In-Reply-To: <CACna6rxQNqdpuiq2mF3EJQ694AHa74tVex06vp53kqjrwoNkog@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Mon, 17 Jul 2017
 06:53:53 +0200")
Message-ID: <87k23124gp.fsf@purkki.adurom.net> (sfid-20170721_173209_013109_1A238BA0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 16 July 2017 at 13:21, Ian Molton <ian@mnementh.co.uk> wrote:
>> I've been doing some cleanups in the broadcome brcmfmac driver, trying to
>> understand how it works.
>>
>> I think this makes the driver a *lot* more readable.
>>
>> Of note:
>>
>> * Gets rid of the arbitrary and completely 1:1 mapping of
>>  struct brcmf_{core,chip}_priv/struct brcmf_{core,chip} structures
>>  which add unreadability whilst offering no real seperation.
>>
>> * The patch titled HACK - stabilise the value of ->sbwad in use
>>  highlights an issue that is either bizarre undocumented behaviour or a
>>  genuine bug - without datasheets, I dont know. Essentially the value of=
 sbwad
>>  is taken as the base address in several functions, even though it is su=
bject
>>  to change should other IO occur that moves the window offset
>>
>> Obviously this is a first cut at this and needs substantial cleanup itse=
lf,
>> however I wanted to get some idea of wether I should continue working on=
 this.
>
> I looked at 4 random patches and none got any description. Not to
> mention their chaotic subjects. In this state I can't even review it.
> If you want to have some change accepted, you've to convince us it's
> needed. Work on cleaning your patches and resend them. You also need
> to signed off your changes.

And try to stick with max 10-12 patches per patchset rule. More than
that and it gets difficult for everyone (submitter, reviewers and
maintainers). And if you are a new with the subsystem, like you are
here, start with baby steps: send one patch, wait for it to get applied,
send two, wait, send four, wait etc. This way you learn how things work
without putting too much burden on the maintainers and things go forward
smoothly.

--=20
Kalle Valo
