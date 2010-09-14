Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39117 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0INQZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 12:25:20 -0400
Message-ID: <4C8FA1E7.9060101@candelatech.com>
Date: Tue, 14 Sep 2010 09:25:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/10] ath9k / mac80211: power save fixes
References: <1284442237-24425-1-git-send-email-lrodriguez@atheros.com> <AANLkTikazs3A+=BXVm9+VZaOsRD2YFSkRSDJKQ4qGBfB@mail.gmail.com> <4C8F9A65.3040204@candelatech.com> <AANLkTinU=4UawnznqaTBMTOOA2u3-7J6e3sJ8ASWQ-Y+@mail.gmail.com>
In-Reply-To: <AANLkTinU=4UawnznqaTBMTOOA2u3-7J6e3sJ8ASWQ-Y+@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 09:09 AM, Luis R. Rodriguez wrote:
> On Tue, Sep 14, 2010 at 8:53 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 09/14/2010 08:07 AM, Luis R. Rodriguez wrote:
>>>
>>> On Mon, Sep 13, 2010 at 10:30 PM, Luis R. Rodriguez
>>> <lrodriguez@atheros.com>    wrote:
>>>>
>>>> Here are a bundle of joy of fixes for power save. Some of
>>>> these are regressions, which sucks ass to find out about them
>>>> so late. We *really* need a regression testbed for mac80211 and
>>>> ath9k. Some stable fixes trickle down to 2.6.32 even.
>>
>> We're working on supporting ath9k for the virtual interfaces
>> in our system, and we do our own regression testing.
>
> Neat, so does Google, they talked about this at the Wireless summit.
> They have stuffed their code into their version of autotest:
>
> http://code.google.com/p/autotest/
>
> The upstream autotest:
>
> http://autotest.kernel.org/
>
> I have yet to check this code out though.
>
>> Aside from normal traffic passing, do you have any test
>> cases you'd like to see run?
>
> What I think we need is to take advantage of the random users of
> wireless-testing / compat-wireless out there and their different APs
> and get collection of test results of some basis tests. A very simple
> series of test cases like authentication, association, enabling power
> save and keeping that connection alive for a period of time, and some
> simple iperf runs would go long way.
>
> On very specific testsbeds though like yours and Google's we can focus
> more on more complex items like roaming. We can actually still
> accomplish automated roaming tests by using Orbit's mobile robot, as
> it goes around a grid of APs. It would be very helpful if regression
> tests had published results publicly. It would be really helpful if we
> had more coordination between those who are doing regression tests.

Our normal testing efforts would be good at long-term traffic generation
(1+ days) using our tool which is somewhat similar to iperf.

We haven't bothered with roaming before, but might can work that in for
at least limited testing.  Maybe a laptop running hostapd strapped on a roomba
would be fun :)

When we can get the virtual station (and hopefully virtual APs) stuff
stable, we'll start doing some tests and try to figure out how to publish
it in a useful manner for others.

>>> The all in one git am'able file can be downloaded here:
>>>
>>>
>>> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2010/09/all-ps-fixes-09-14-v1.patch
>>
>> Is there any way to get automated emails for commits going into
>> wireless-testing?
>
> You can subscribe to the RSS feed via http://git.kernel.org for it maybe.

I was hoping someone had a post-receive trigger sending email to some list
that I could subscribe to.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
