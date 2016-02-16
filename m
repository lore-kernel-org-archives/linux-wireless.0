Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34864 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbcBPPYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 10:24:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ross Green <rgkernel@gmail.com>
Cc: Emil Goode <emil.fsw@goode.io>, Shahar Patury <shaharp@ti.com>,
	Guy Mishol <guym@ti.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Uri Mashiach <uri.mashiach@compulab.co.il>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: wlcore: Fix regression in wlcore_set_partition()
References: <20160210012216.GA18819@lianli>
	<20160212094526.EC572611CE@smtp.codeaurora.org>
	<CANfgCY02_AkRi2EMNZsneK8UdwLvAWxF_X0ts6WZbaM0=5c63A@mail.gmail.com>
Date: Tue, 16 Feb 2016 17:24:15 +0200
In-Reply-To: <CANfgCY02_AkRi2EMNZsneK8UdwLvAWxF_X0ts6WZbaM0=5c63A@mail.gmail.com>
	(Ross Green's message of "Mon, 15 Feb 2016 15:01:49 +1100")
Message-ID: <87bn7gu19c.fsf@kamboji.qca.qualcomm.com> (sfid-20160216_162444_335335_89FCB557)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ross Green <rgkernel@gmail.com> writes:

> On Fri, Feb 12, 2016 at 8:45 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>>> The commit 3719c17e1816 ("wlcore/wl18xx: fw logger over sdio") introduced a
>>> regression causing the wlcore to time out and go into recovery. Reverting the
>>> changes regarding write of the last partition size brings the module back to
>>> it's functional state.
>>>
>>> Fixes: 3719c17e1816 ("wlcore/wl18xx: fw logger over sdio")
>>> Reported-by: Ross Green <rgkernel@gmail.com>
>>> Signed-off-by: Emil Goode <emil.fsw@goode.io>
>>> [kvalo@codeaurora.org: improved commit log]
>>
>> Thanks, applied to wireless-drivers.git.
>>
>> Kalle Valo
>
> I just tested linux-4.5-rc4 it appears the above fix missed the release for rc4!
> So the behaviour of firmware reset being called after the access of
> the last partition timesout.
>
> Again tested patch with the new release - 4.5-rc4 and found everything
> to work as expected again.
>
> So Hopefully for rc5 - Please!

It takes some time to get patches into Linus' tree. And being in a
conference and then getting sick is not really helping. I'm not sure if
this patch makes to rc5 on time, but I'll try.

-- 
Kalle Valo
