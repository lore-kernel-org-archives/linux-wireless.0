Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38195 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab2FHTm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 15:42:27 -0400
Received: by qadb17 with SMTP id b17so875156qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 12:42:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD25487.7050002@lwfinger.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
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
	<20120608201053.48548a11@milhouse>
	<4FD24332.3010202@lwfinger.net>
	<20120608203131.01dce8e3@milhouse>
	<4FD25487.7050002@lwfinger.net>
Date: Fri, 8 Jun 2012 21:42:25 +0200
Message-ID: <CAHsu+b9Z3iQL4nEKa9oEsJEHgD2viGoyr=0_=sjxtbkAgQRykA@mail.gmail.com> (sfid-20120608_214230_486876_AF1A05F9)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 8, 2012 at 9:37 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 06/08/2012 01:31 PM, Michael Büsch wrote:
>>
>> On Fri, 08 Jun 2012 13:23:46 -0500
>> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>>> On 06/08/2012 01:10 PM, Michael Büsch wrote:
>>>>
>>>> On Fri, 08 Jun 2012 12:43:06 -0500
>>>> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>>
>>>>> On 06/08/2012 11:33 AM, Michael Büsch wrote:
>>>>>>
>>>>>>
>>>>>> Larry, did you check with PIO?
>>>>>
>>>>>
>>>>> No, I only used DMA. With the latest patch, compilation is Ok, and DMA
>>>>> works for
>>>>> both kinds of firmware, while PIO fails for both.
>>>>
>>>>
>>>> Does PIO even work without that patch and with prop-firmware?
>>>
>>>
>>> No. That seems to be a different bug.
>>
>>
>> That's nice. Could you probably bisect it? It used to work at some point.
>>
>> PS:
>> I'm sorry that I'm not of much help these days, because I currently
>> don't have a working b43 device around :)
>
>
> No problem. Most of the time when I'm running b43, it is on one of my older
> test machines.
>
> I need to do a little more testing before I start a bisection of the PIO
> problem. My PPC Mac fails with kernel 2.6.32, which is as old as I have
> available. At the moment, I don't have the time to fire up an old i586
> notebook to see if we have a PIO problem, or an endian issue with PIO;
> however, I think Andre's wii is big endian.

Yeah, it's a 32bit powerpc.

>From my initial report:
The hw queues fail the check in ieee80211_check_queues(). When I hack
that function to always "return 0;" wlan works again.

Apart from the patch test runs that's what I'm running atm, so I'm
pretty sure you can assume its not a BE issue.

Regards,
Andre
