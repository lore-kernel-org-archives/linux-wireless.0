Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:38122 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYITAB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 20:01:58 -0400
Received: by ey-out-2122.google.com with SMTP id 6so220250eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 17:01:56 -0700 (PDT)
Message-ID: <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com> (sfid-20080920_020202_716359_D230B170)
Date: Fri, 19 Sep 2008 17:01:56 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080919235305.GD11665@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com>
	 <20080919030125.GG7408@tesla>
	 <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com>
	 <20080919142801.GA5816@senthil-lnx.users.atheros.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 4:53 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Sep 19, 2008 at 04:31:20PM -0700, Steven Noonan wrote:
>>
>> I'm seeing the same latency issue I reported originally with the latest
>> -tip kernel and WITHOUT irqpoll.
>
> Damn it.
>
>> Apparently there's something else to this...
>
> Steven,
>
> Can you reproduce this? If so can you tell us how? If you can reproduce
> can you try to test this with wireless-testing as well? That is still
> based on 2.6.26-rc6 but its just has all the new wireless development
> stuff queued up for 2.6.28 so far. Everything else is the same.

It's a weird problem, because I'm able to reproduce it by running a
kernel with ath9k loaded for a few hours. In this particular case, I
only ran this kernel for about 3.5 hours , but the delay when VT
switching was getting noticeable. Unload/reload of ath9k and the
latency disappeared again. It's definitely ath9k's doing, but I don't
know how. I'm finding the delay is most noticeable after 7 hours
uptime with ath9k loaded.

I'll pull wireless-testing and run that kernel for another 8 hours.
What's the URL for the repo? Surely you don't mean the
wireless-testing on git.kernel.org that hasn't been touched for almost
a week?

I kind of wish there was a better debugging facility in ath9k. With
ATH_DBG_INTERRUPTS, I see several hundred messages per second, which
fills log files up like crazy (I switched to ftrace_printk as Ingo
suggested, which has alleviated this somewhat). Is there a way to make
it less verbose (perhaps so that it prints data at a rate of no more
than 2 or 3 messages per second)? Or maybe the rate at which it prints
this stuff is indicative something's wrong?

- Steven
