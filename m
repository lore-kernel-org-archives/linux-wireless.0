Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:50996 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752465AbeB1PFA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 10:05:00 -0500
Received: by mail-it0-f66.google.com with SMTP id d13so1213931itf.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 07:04:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87tvu1dv5f.fsf@purkki.adurom.net>
References: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
 <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com>
 <20180215151445.52e08b03@cakuba.netronome.com> <CAJ0CqmVG4rNO=MSxaNF6s9vS3QueBVv0aFddETPaMpPQsYJh4Q@mail.gmail.com>
 <87tvu1dv5f.fsf@purkki.adurom.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Wed, 28 Feb 2018 16:04:58 +0100
Message-ID: <CAJ0CqmU6w9k_3ZZwHiB5eLZ_4H_8OqS-P58Uwbioa4qe4xhM2A@mail.gmail.com> (sfid-20180228_160503_802647_CD5C1382)
Subject: Re: [PATCH] mt7601u: make write with mask access atomic
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
>>> On Thu, 15 Feb 2018 23:59:24 +0100, Lorenzo Bianconi wrote:
>>>> Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
>>>> to make mt7601u_rmw and mt7601u_rmc atomic since it is possible that
>>>> read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved
>>>> with a different write operation on the same register.
>>>> Moreover move write trace point in __mt7601u_vendor_single_wr
>>>>
>>>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>>>
>>> Could you provide an example of which accesses make it problematic?
>>> Is this fixing an actual bug?
>>
>> it is not an issue I had experimented, I noticed a theoretical race
>> reviewing the code.
>
> The commit log should always answer the question "Why?". If you find a
> theoretical issue in the code document that clearly in the commit log.
> That helps to choose correct tree and sending to stable releases etc.
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why
>
> --
> Kalle Valo

Hi Kalle,

I have already sent a v2: https://patchwork.kernel.org/patch/10225849/
Is the commit message ok?

Regards,
Lorenzo
