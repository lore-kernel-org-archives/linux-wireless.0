Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59110 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab0INQJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 12:09:37 -0400
Received: by gwj17 with SMTP id 17so2412695gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 09:09:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C8F9A65.3040204@candelatech.com>
References: <1284442237-24425-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTikazs3A+=BXVm9+VZaOsRD2YFSkRSDJKQ4qGBfB@mail.gmail.com> <4C8F9A65.3040204@candelatech.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 14 Sep 2010 09:09:15 -0700
Message-ID: <AANLkTinU=4UawnznqaTBMTOOA2u3-7J6e3sJ8ASWQ-Y+@mail.gmail.com>
Subject: Re: [PATCH 00/10] ath9k / mac80211: power save fixes
To: Ben Greear <greearb@candelatech.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 8:53 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 09/14/2010 08:07 AM, Luis R. Rodriguez wrote:
>>
>> On Mon, Sep 13, 2010 at 10:30 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com>  wrote:
>>>
>>> Here are a bundle of joy of fixes for power save. Some of
>>> these are regressions, which sucks ass to find out about them
>>> so late. We *really* need a regression testbed for mac80211 and
>>> ath9k. Some stable fixes trickle down to 2.6.32 even.
>
> We're working on supporting ath9k for the virtual interfaces
> in our system, and we do our own regression testing.

Neat, so does Google, they talked about this at the Wireless summit.
They have stuffed their code into their version of autotest:

http://code.google.com/p/autotest/

The upstream autotest:

http://autotest.kernel.org/

I have yet to check this code out though.

> Aside from normal traffic passing, do you have any test
> cases you'd like to see run?

What I think we need is to take advantage of the random users of
wireless-testing / compat-wireless out there and their different APs
and get collection of test results of some basis tests. A very simple
series of test cases like authentication, association, enabling power
save and keeping that connection alive for a period of time, and some
simple iperf runs would go long way.

On very specific testsbeds though like yours and Google's we can focus
more on more complex items like roaming. We can actually still
accomplish automated roaming tests by using Orbit's mobile robot, as
it goes around a grid of APs. It would be very helpful if regression
tests had published results publicly. It would be really helpful if we
had more coordination between those who are doing regression tests.

>> The all in one git am'able file can be downloaded here:
>>
>>
>> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2010/09/all-ps-fixes-09-14-v1.patch
>
> Is there any way to get automated emails for commits going into
> wireless-testing?

You can subscribe to the RSS feed via http://git.kernel.org for it maybe.

> If these go in soon, I'd rather not deal with merging them into my own repo,
> but if it's going to take a while, it might be worth the effort.

Right.

  Luis
