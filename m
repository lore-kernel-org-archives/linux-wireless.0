Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:51706 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdJKRA4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 13:00:56 -0400
Received: by mail-io0-f181.google.com with SMTP id b186so2504661iof.8
        for <linux-wireless@vger.kernel.org>; Wed, 11 Oct 2017 10:00:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011093248.Horde.Jwmh0VKhmCeOxBgQzLLpYeZ@gator4166.hostgator.com>
References: <20171010193027.GA23108@embeddedor.com> <5f5f0f54-d901-90be-9025-0a1c4b909368@gmail.com>
 <87o9peqdo2.fsf@kamboji.qca.qualcomm.com> <eb89f2ad-f2d5-b97f-c224-daf3953d912c@gmail.com>
 <20171011093248.Horde.Jwmh0VKhmCeOxBgQzLLpYeZ@gator4166.hostgator.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 11 Oct 2017 10:00:54 -0700
Message-ID: <CAGXu5jKH72JG92CRJ8_89o74Edr6Ym_XTZGzjutGLUbvCbd9JQ@mail.gmail.com> (sfid-20171011_190235_161547_02D5A684)
Subject: Re: [PATCH] rtl8xxxu: mark expected switch fall-throughs
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 11, 2017 at 7:32 AM, Gustavo A. R. Silva
<garsilva@embeddedor.com> wrote:
> Quoting Jes Sorensen <jes.sorensen@gmail.com>:
>> On 10/11/2017 04:41 AM, Kalle Valo wrote:
>>> Jes Sorensen <jes.sorensen@gmail.com> writes:
>>>> On 10/10/2017 03:30 PM, Gustavo A. R. Silva wrote:
>>>>>
>>>>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>>>>> where we are expecting to fall through.
>>>>
>>>> While this isn't harmful, to me this looks like pointless patch churn
>>>> for zero gain and it's just ugly.
>>>
>>> In general I find it useful to mark fall through cases. And it's just a
>>> comment with two words, so they cannot hurt your eyes that much.
>>
>> I don't see them being harmful in the code, but I don't see them of much
>> use either. If it happened as part of natural code development, fine. My
>> objection is to people running around doing this systematically causing
>> patch churn for little to zero gain.
>
> I understand that you think this is of zero gain for you, but as Florian
> Fainelli pointed out:
>
> "That is the canonical way to tell static analyzers and compilers that
> fall throughs are wanted and not accidental mistakes in the code. For
> people that deal with these kinds of errors, it's quite helpful, unless
> you suggest disabling that particular GCC warning specific for that
> file/directory?"
>
> this is very helpful for people working on fixing issues reported by static
> analyzers. It saves a huge amount of time when dealing with False Positives.
> Also, there are cases when an apparently intentional fall-through turns out
> to be an actual missing break or continue.
>
> So there is an ongoing effort to detect such cases and avoid them to show up
> in the future by at least warning people about a potential issue in their
> code. And this is helpful for everybody.

This is an unfortunate omission in the C language, and thankfully both
gcc and clang have stepped up to solve this the same way static
analyzers have solved it. It's not exactly pretty, but it does both
document the intention for humans and provide a way for analyzers to
report issues. Having the compiler help us not make mistakes is quite
handy, and with Gustavo grinding through all the Coverity warnings,
he's found actual bugs with missing "break"s, so I think this has a
demonstrable benefit to the code-base as a whole. It makes things
unambiguous to someone else reviewing the code.

-Kees

-- 
Kees Cook
Pixel Security
