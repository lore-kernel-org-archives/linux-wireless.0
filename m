Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44202 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaJRQAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 12:00:40 -0400
Message-ID: <54428EA7.8000302@candelatech.com> (sfid-20141018_180049_089998_661EF47B)
Date: Sat, 18 Oct 2014 09:00:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211-hwsim:  support creating radios with specific
 name.
References: <1413576721-22258-1-git-send-email-greearb@candelatech.com> <1413615195.10246.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1413615195.10246.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/17/2014 11:53 PM, Johannes Berg wrote:
> On Fri, 2014-10-17 at 13:12 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Otherwise, it can be very difficult to know which is which
>> if you are trying to do detailed testing.
>
> Having just implemented something with dynamic radios in the
> wpa_supplicant test suite, I'm having second thoughts about this.
>
> When you create a new radio, it returns the hwsim identifier, which
> allows you to find the wiphy name in sysfs easily. Why not just rename
> it afterwards from userspace?

I plan to create (and recreate) thousands of these, and it will be less efficient to
have to rename each of them, as well as making user-space code more complex.

I too was looking at the hostap testing code, and the ability to specify names
of wiphy and the stations on creation time (as some of my other patches allow)
should simplify such testing, as well as my own testing needs.

I have patches to enable hostap to use the kernel features, but have not posted
them since kernel patches are still in flux.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
