Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:52023 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYITBNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 21:13:34 -0400
Received: by gxk9 with SMTP id 9so1399065gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 18:13:32 -0700 (PDT)
Message-ID: <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com> (sfid-20080920_031345_448782_9B2E062B)
Date: Fri, 19 Sep 2008 18:13:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <20080919030125.GG7408@tesla>
	 <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com>
	 <20080919142801.GA5816@senthil-lnx.users.atheros.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 5:01 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> I'll pull wireless-testing and run that kernel for another 8 hours.
> What's the URL for the repo? Surely you don't mean the
> wireless-testing on git.kernel.org that hasn't been touched for almost
> a week?

Yes, that's the guy. This week was the Kernel Summit and the Linux
Plumbers Conference too so there is understandably some lag in pulls
as developers are getting drunk.

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

> I kind of wish there was a better debugging facility in ath9k.

Patches are welcomed ;)

Also, we have a few interrupt levels you can use. In this case we are
debugging interrupts.

> With
> ATH_DBG_INTERRUPTS, I see several hundred messages per second, which
> fills log files up like crazy (I switched to ftrace_printk as Ingo
> suggested, which has alleviated this somewhat). Is there a way to make
> it less verbose (perhaps so that it prints data at a rate of no more
> than 2 or 3 messages per second)? Or maybe the rate at which it prints
> this stuff is indicative something's wrong?

No, interrupts do happen quite often so that is what you get, perhaps
we can enhance this by not printing on some interrupts but the point
is to debug interrupts after all. To help us debug in userspace in a
nicer way we can use sadc and sar. So you can try this:

On a window leave this running:

/usr/lib/sysstat/sadc -I 1 irqlog.sar

And when you are seeing your latency issues, run this:

sar -I 17 -f irqlog.sar | less

That is capital "i", this will show you the monitor results of number
of interrupts on IRQ 17. You want to see if the rate of change is huge
when you have latency issues. If not then its most likely an interrupt
storm by ath9k (which is my suspect right now) but something else.

  Luis
