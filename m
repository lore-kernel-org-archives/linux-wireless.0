Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:63335 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaILQwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 12:52:04 -0400
Received: by mail-oi0-f46.google.com with SMTP id g201so696521oib.33
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2014 09:52:04 -0700 (PDT)
Message-ID: <541324B2.7040200@lwfinger.net> (sfid-20140912_185211_018127_DA86BC32)
Date: Fri, 12 Sep 2014 11:52:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: andrea.merello@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
CC: ralf@czekalla.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Rtl8187se regression [was: rtl8187se - serious regressions since
 merge out of staging into 818x]
References: <CAN8YU5NOApnft04+N3rSQF3j9d9N47-A6m4n-1-2KNHq+1EYKA@mail.gmail.com> <1472277.xX1dghvxoC@bs8> <CAN8YU5OHAmYp-7Ojti3aSeGWJr=dU0Xb=Du_w_QqPUezno_=DQ@mail.gmail.com>
In-Reply-To: <CAN8YU5OHAmYp-7Ojti3aSeGWJr=dU0Xb=Du_w_QqPUezno_=DQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2014 11:29 AM, Andrea Merello wrote:
>> Because of the problems I'am going now to a special site, where I have a local
>> networks (LAN/WLAN), good internet connection and root access to Linux
>> machines.
>> This should be a good thing to do real testing.
>
> Excellent!
> Thank you Bernhard!
>
>> 1.) Andrea, can you resend me the latest patches (perhaps against 3.16)
>> please?
>> (only to confirm that we are in "synchronous" mode.)
>
> Sure, I attach a cumulative patch, including all the changes I think
> may matter (signal strength fix not included)
>
>> 2.) Andrea, Larry, John are you interested to have root access to my laptop
>> using the rtl8187se?
>> (Perhaps it can stay there over the weekend too.)
>
> Thank you for offering this :)
> In case it turns out that you actually face performance regressions,
> then it might help me to make some experiments using your machine.
>
> I will do a register dump and I will try to tune some parameters in
> the driver. This should NOT crash the machine, but if it is vital for
> you that the machine remains alive, then maybe I will avoid at least
> certain experiments..
>
> Possibly tomorrow afternoon (Italian time) I will have some spare time
> to work on this.
>
>> 3.) My test for maximal troughput is to run a connection /dev/zero -> nc ->|->
>> nc -> /dev/null.
>> Any other ideas?
>
> Usually I use two Linux hosts (the DUT and my production system) and I
> use "iperf" program on both
> On the production system (the iperf server) I run
> iperf -s -u -b30M
> On the DUT I run
> iperf -c 192.168.1.2 -r -u -b30M
>
> This will cause an UDP data exchange and will perform both downstream
> and upstream throughput measurements.
> I usually do this (at least) two times, and I discard results from the
> first run, because rate selection algorithm might eventually need a
> bit settle to a "good" rate.
>
>> 4.) I think to have this setup ready about 11:30 UTC.
>
> I was at my workplace, I really couldn't do quicker than this..
> Sorry.. I hope we are still in time...
>
>> I'am open to any suggestion from your side.
>
> Tests that may also help are:
> - test performance regression when you are both close to the AP and
> enough far from it that performances significantly drops.
> - check if the rtl818x_pci driver and the old driver settles at
> (about) the same rates..

Hi,

I currently have a deadline to get some changes in rtlwifi into kernel 3.16, 
thus I have no time for testing the RTL8187SE. I do know that the whole issue of 
signal strength reporting for these chips is a problem.

Larry

