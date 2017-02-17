Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52314 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932954AbdBQKbz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 05:31:55 -0500
Subject: Re: [linux-stable] 4fc2942b6e kernel BUG at
 kernel/time/hrtimer.c:109!
To: Thomas Gleixner <tglx@linutronix.de>
References: <20170217052607.glbumukvoz4pilvt@wfg-t540p.sh.intel.com>
 <alpine.DEB.2.20.1702171014430.3536@nanos>
 <0f58a1d0-a2e6-9430-7883-68e986ccb4c0@arm.com>
 <alpine.DEB.2.20.1702171115050.3536@nanos>
Cc: kernel test robot <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sasha Levin <alexander.levin@verizon.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
From: Marc Zyngier <marc.zyngier@arm.com>
Message-ID: <baadec00-8842-3604-b096-c01aa2ebde6a@arm.com> (sfid-20170217_113202_710503_38C59395)
Date: Fri, 17 Feb 2017 10:31:52 +0000
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1702171115050.3536@nanos>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/02/17 10:16, Thomas Gleixner wrote:
> On Fri, 17 Feb 2017, Marc Zyngier wrote:
> 
>> On 17/02/17 09:28, Thomas Gleixner wrote:
>>> On Fri, 17 Feb 2017, kernel test robot wrote:
>>>
>>>> Hi Marc,
>>>>
>>>> We find this oops in linux-4.4.y. The gcc-6 compiled mainline kernel is fine.
>>
>> The last bit is worrying, as mainline has the exact same bug. Has it
>> been tested the same way?
> 
> The thing is that we reverted that patch in mainline:
> 
> See: commit 82e88ff1ea948d83125a8aaa7c9809f03ccc500f

Ah, right. It got nuked as part of the whole MONOTONIC_RAW blunder.

> I don't know why I reverted that as well. I should have kept it. Darn. I
> cherry pick it and send it linus wards next week.

Yes, I still think this single patch is a valuable sanity check.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
