Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:48398 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755252AbdKJA3F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 19:29:05 -0500
Received: by mail-qk0-f196.google.com with SMTP id a142so10032388qkb.5
        for <linux-wireless@vger.kernel.org>; Thu, 09 Nov 2017 16:29:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87k1yzq9i8.fsf@toke.dk>
References: <20171109071945.11033-1-toke@toke.dk> <6112ae948ba2409da27709d01da567eb@NALASEXR01H.na.qualcomm.com>
 <87k1yzq9i8.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Thu, 9 Nov 2017 16:29:03 -0800
Message-ID: <CAA93jw6yw5=ALMdRaRrGU9uySmov9HwM-mr2npRbzsSxHgSAGw@mail.gmail.com> (sfid-20171110_012908_657592_A496A2B2)
Subject: Re: [Make-wifi-fast] [PATCH] ath10k: Re-enable TXQs for all devices
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        "make-wifi-fast@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 9, 2017 at 4:10 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>
>>> Commit 4ca1807815aa6801aaced7fdefa9edacc2521767 disables the use of the
>>> mac80211 TXQs for some devices because of a theoretical throughput
>>> regression. We have not seen this regression for a while now, so it sho=
uld be
>>> safe to re-enable TXQs.
>>>
>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>> ---
>>> This has been in LEDE trunk for a couple of months now with good result=
s.
>>>
>> Toke,
>>
>> Good to know that the performance drop is not seen with the chips that d=
oes not
>> have push-pull support. The issue was originally reported with ap152 + q=
ca988x
>> by community [1]. Hope this combination is also considered in LEDE.
>
> Ah, was that the original bug report? Thank you, I have not been able to
> find that anywhere!
>
> The issue that seems to point to has been fixed a while ago; I'll send
> and updated patch with a better commit message (also forgot to cc the
> ath10k list, I see).
>
> -Toke

Hmm. I remember that thread. I thought we'd basically resolved that
issue (45% of the time spent in fq_codel_drop under udp flood),
back then, with eric adding the batch drop fix to fq_codel itself:

See commit: https://osdn.net/projects/android-x86/scm/git/kernel/commits/9d=
18562a227874289fda8ca5d117d8f503f1dcca

which fixed up the problem beautifully:

https://lists.bufferbloat.net/pipermail/make-wifi-fast/2016-May/000590.html

So if we've been carrying this darn patch for the ath10k vs something
that we'd actually fixed elsewhere in the stack, for over a year,
sigh.

--=20

Dave T=C3=A4ht
CEO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-669-226-2619
