Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:34326 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751178AbdGQJN0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 05:13:26 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6H9DFnm031811
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 10:13:25 +0100
Received: from mail-wr0-f200.google.com (mail-wr0-f200.google.com [209.85.128.200])
        by mx08-00252a01.pphosted.com with ESMTP id 2bq7heh1uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 10:13:25 +0100
Received: by mail-wr0-f200.google.com with SMTP id u89so5809597wrc.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 02:13:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rxQNqdpuiq2mF3EJQ694AHa74tVex06vp53kqjrwoNkog@mail.gmail.com>
References: <20170716112129.10206-1-ian@mnementh.co.uk> <CACna6rxQNqdpuiq2mF3EJQ694AHa74tVex06vp53kqjrwoNkog@mail.gmail.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Mon, 17 Jul 2017 10:13:23 +0100
Message-ID: <CAE_XsMLVjT1kGmQBciADQwHKS+AgytzxePyQrYnGQQqanFj9jw@mail.gmail.com> (sfid-20170717_111331_648953_EF724764)
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 July 2017 at 05:53, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> On 16 July 2017 at 13:21, Ian Molton <ian@mnementh.co.uk> wrote:
>> I've been doing some cleanups in the broadcome brcmfmac driver, trying t=
o
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
>
> --
> Rafa=C5=82

As someone who is interested in any bug fixes to this driver (Device
is used on Raspberry Pi3/0W and we have a number of issues reported
which we are actively investigating), it would be very useful to more
clearly split out any actual fixes vs simply tidying up (Yes, I agree
the driver is mostly incomprehensible). Perhaps asking the
list/maintainers for comments on any located issues/bugs fixes would
be a useful starting point, along with ensuring the description gives
a good explanation of what the suspect issue is.

James
