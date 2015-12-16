Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36349 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbbLPTAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 14:00:09 -0500
Received: by mail-wm0-f46.google.com with SMTP id p187so14672690wmp.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 11:00:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151215.155856.467616191891653108.davem@davemloft.net>
References: <CACT4Y+ZnZ2EcZwc6T5LZ1YR2zC8+6aFT_JFYb_LeegnB6tmESw@mail.gmail.com>
 <20151215.154851.2132284113916223057.davem@davemloft.net> <CACT4Y+a804iMbkA+kWdYfOPYGQz61ZCRVqKOdDBYtSM=FQ2cYQ@mail.gmail.com>
 <20151215.155856.467616191891653108.davem@davemloft.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 16 Dec 2015 19:59:48 +0100
Message-ID: <CACT4Y+YCkDLemqW_Ci6Hv418qWLP91kZSoXH8dvXYZbZbgSO1A@mail.gmail.com> (sfid-20151216_200017_729181_79778B01)
Subject: Re: Information leak in llcp_sock_bind/llcp_raw_sock_bind
To: syzkaller <syzkaller@googlegroups.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2015 at 9:58 PM, David Miller <davem@davemloft.net> wrote:
> From: Dmitry Vyukov <dvyukov@google.com>
> Date: Tue, 15 Dec 2015 21:55:37 +0100
>
>> I've seen a kernel address at least in pptp_bind,
>
> We're not talking about pptp_bind.
>
> We're talking about llcp_{,raw}_sock_bind().
>
> If your hex dump doesn't show it, don't report anything unless you are
> absolutely sure via code inspection that there could be a leak.  And
> in that case make it perfectly clear exactly how that can happen.
>
> I am generally unimpressed with your reports half of the time,
> and just a small amount of extra effort would extraordinarily
> improve the quality of the things your post.
>
> Thanks.
>
>> So it is almost impossible to prove that a PC cannot be leaked.
>
> You can't show that anything is actually being leaked in this specific
> case, period.


I am a human and sometimes do mistakes.

In this case, I checked that the bind succeeds when I pass
sockaddrlen=0, which is suspicious and matches the behavior of pptp
case (not checking sockaddrlen at all). Then I looked at the code and
misread it, because it uses a different idiom from other cases I saw
(explicitly checking sockaddrlen value). Then I wrote a test program
and observed a varying, garbage-looking values returned from
getsockname. From that I concluded that there is an information leak.
This is wrong.

For the purpose of improvement of my reports, what are the other
reports you are not impressed with and why?

Thank you
