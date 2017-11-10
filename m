Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755255AbdKJBGr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 20:06:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Dave Taht <dave.taht@gmail.com>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        "make-wifi-fast\@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [Make-wifi-fast] [PATCH] ath10k: Re-enable TXQs for all devices
References: <20171109071945.11033-1-toke@toke.dk>
        <6112ae948ba2409da27709d01da567eb@NALASEXR01H.na.qualcomm.com>
        <87k1yzq9i8.fsf@toke.dk>
        <CAA93jw6yw5=ALMdRaRrGU9uySmov9HwM-mr2npRbzsSxHgSAGw@mail.gmail.com>
Date: Fri, 10 Nov 2017 03:06:41 +0200
In-Reply-To: <CAA93jw6yw5=ALMdRaRrGU9uySmov9HwM-mr2npRbzsSxHgSAGw@mail.gmail.com>
        (Dave Taht's message of "Thu, 9 Nov 2017 16:29:03 -0800")
Message-ID: <87tvy3lz6m.fsf@purkki.adurom.net> (sfid-20171110_020651_736156_2DE33E98)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding ath10k list to get this discussion to the list archive.

Dave Taht <dave.taht@gmail.com> writes:

> On Thu, Nov 9, 2017 at 4:10 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@to=
ke.dk> wrote:
>> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>>
>>>> Commit 4ca1807815aa6801aaced7fdefa9edacc2521767 disables the use of the
>>>> mac80211 TXQs for some devices because of a theoretical throughput
>>>> regression. We have not seen this regression for a while now, so it sh=
ould be
>>>> safe to re-enable TXQs.
>>>>
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>>> ---
>>>> This has been in LEDE trunk for a couple of months now with good resul=
ts.
>>>>
>>> Toke,
>>>
>>> Good to know that the performance drop is not seen with the chips that =
does not
>>> have push-pull support. The issue was originally reported with ap152 + =
qca988x
>>> by community [1]. Hope this combination is also considered in LEDE.
>>
>> Ah, was that the original bug report? Thank you, I have not been able to
>> find that anywhere!
>>
>> The issue that seems to point to has been fixed a while ago; I'll send
>> and updated patch with a better commit message (also forgot to cc the
>> ath10k list, I see).
>>
>> -Toke
>
> Hmm. I remember that thread. I thought we'd basically resolved that
> issue (45% of the time spent in fq_codel_drop under udp flood),
> back then, with eric adding the batch drop fix to fq_codel itself:
>
> See commit: https://osdn.net/projects/android-x86/scm/git/kernel/commits/=
9d18562a227874289fda8ca5d117d8f503f1dcca
>
> which fixed up the problem beautifully:
>
> https://lists.bufferbloat.net/pipermail/make-wifi-fast/2016-May/000590.ht=
ml
>
> So if we've been carrying this darn patch for the ath10k vs something
> that we'd actually fixed elsewhere in the stack, for over a year,
> sigh.

--=20
Kalle Valo
