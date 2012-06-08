Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39253 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2FHS2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 14:28:43 -0400
Received: by qcro28 with SMTP id o28so986741qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 11:28:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339179084.5748.29.camel@jlt3.sipsolutions.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com>
	<1339167160.4901.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	<1339168452.5748.0.camel@jlt3.sipsolutions.net>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
	<CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	<1339171159.5748.11.camel@jlt3.sipsolutions.net>
	<CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	<4FD22727.7000500@lwfinger.net>
	<1339172904.5748.18.camel@jlt3.sipsolutions.net>
	<20120608183339.78a7fcbd@milhouse>
	<4FD239AA.9090708@lwfinger.net>
	<1339178163.5748.27.camel@jlt3.sipsolutions.net>
	<1339179084.5748.29.camel@jlt3.sipsolutions.net>
Date: Fri, 8 Jun 2012 20:28:42 +0200
Message-ID: <CAHsu+b8M=KGyp9PL5hJ6cxgF=1kGXHoUt7idLA+UD+UqoJW6uA@mail.gmail.com> (sfid-20120608_202847_300568_C3EF9EC9)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 8, 2012 at 8:11 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-08 at 19:56 +0200, Johannes Berg wrote:
>> On Fri, 2012-06-08 at 12:43 -0500, Larry Finger wrote:
>> > On 06/08/2012 11:33 AM, Michael Büsch wrote:
>> > >
>> > > Larry, did you check with PIO?
>> >
>> > No, I only used DMA. With the latest patch, compilation is Ok, and DMA works for
>> > both kinds of firmware, while PIO fails for both.
>>
>> Hmm, both with QoS enabled and disabled?. I don't really see what could
>> be causing this, sorry.
>>
>> One more thing that I just realised though is that mac80211 uses the #
>> of queues to determine whether to advertise QoS or not, so the whole
>> thing won't actually work anyway without more work :-(
>
> Maybe these two patches work:
>
> http://p.sipsolutions.net/b8912f8cad4cb3b2.txt
> http://p.sipsolutions.net/ad2677233e6917e8.txt
>
> still kinda hack like it always was, but ...

Those don't apply clean on 48d212a2eec, resolved a conflict, but
device worked and I could login ;)

But as soon as I ran `dmesg` (over ssh+wlan) I got a kernel crash. It
scrolled by too fast, but alot of b43 stuff starting with
__netif_schedule. Unsure if its because of these patches or unrelated.
