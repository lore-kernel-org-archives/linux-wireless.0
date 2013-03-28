Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49560 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3C1La6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 07:30:58 -0400
Received: by mail-qa0-f46.google.com with SMTP id k4so1457595qaq.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Mar 2013 04:30:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXZpYA8MVRk6++T5ykEEcTKL=gf4CqBMkexEr6N+GAd8A@mail.gmail.com>
References: <1364461894-30555-1-git-send-email-vincent.stehle@laposte.net>
	<1364462493.8312.8.camel@jlt4.sipsolutions.net>
	<CA+icZUXZpYA8MVRk6++T5ykEEcTKL=gf4CqBMkexEr6N+GAd8A@mail.gmail.com>
Date: Thu, 28 Mar 2013 12:30:57 +0100
Message-ID: <CA+icZUUHrtKX_BUYzZQugmwwP9UG3Dyw7S4jwbs5japJS3ZGbw@mail.gmail.com> (sfid-20130328_123101_102213_CB4C64E3)
Subject: Re: [PATCH] mac80211: fix uninitialized variable
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vincent <vincent.stehle@laposte.net>,
	linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 12:28 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Mar 28, 2013 at 10:21 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2013-03-28 at 10:11 +0100, Vincent wrote:
>>> Fix one code path where chanctx_conf is tested as being non-NULL while it may
>>> be uninitialized.
>>
>> No, you're wrong, presumably misled by the compiler.
>>
>
> Hi,
>
> especially, when you use gcc >=4.7.x compiler with "-Os"
> optimize-level you and your binaries/libs get confused.
> Arnd Bergmann sent a patch for these "false-positives" (use
> "-Wmaybe-uninitialized" as a CFLAGS).
> I think this is a good idea.
> If more kernel-developers ACK it, it might get mainline :-)?
> Gogogo johill (but don't runaway) :-)...
>
> For more details see also gcc-docs on how to suppress errors and treat
> them as warnings [1].
>
> Regards,
> - Sedat -
>
> [1] http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#Warning-Options
>

Uuurgh, forgot to add the link for Arnd's patch....

- Sedat -

[2] https://patchwork.kernel.org/patch/2274041/

>> johannes
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
