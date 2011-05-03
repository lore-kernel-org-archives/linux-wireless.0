Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47548 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab1ECCip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 22:38:45 -0400
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: fix rtnl even race in register_netdevice()
References: <20110429172634.27130.25375.stgit@x201>
	<20110429.135339.200375209.davem@davemloft.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 03 May 2011 05:38:43 +0300
In-Reply-To: <20110429.135339.200375209.davem@davemloft.net> (David Miller's message of "Fri\, 29 Apr 2011 13\:53\:39 -0700 \(PDT\)")
Message-ID: <87mxj4h5jg.fsf@purkki.adurom.net> (sfid-20110503_043855_977755_2210E6FC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@adurom.com>
> Date: Fri, 29 Apr 2011 20:26:34 +0300
>
>> From: Kalle Valo <kalle.valo@atheros.com>
>> 
>> There's a race in register_netdevice so that the rtnl event is sent before
>> the device is actually ready. This was visible with flimflam, chrome os
>> connection manager:

[...]

>> The fix is to call netdev_register_kobject() after the device is added
>> to the list.
>> 
>> Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
>
> This is not correct.
>
> If you move the kobject registry around, you have to change the
> error handling cleanup to match.
>
> This change will leave the netdevice on all sorts of lists, it will
> also leak a reference to the device.
>
> I also think this points a fundamental problem with this change, in
> that you can't register the kobject after the device is added to
> the various lists in list_netdevice().
>
> Once it's in those lists, any thread of control can find the device
> and those threads of control may try to get at the data backed by
> the kobject and therefore they really expect it to be there by
> then.
>
> What you can do instead is try to delay the NETREG_REGISTERED
> setting, and block the problematic notifications by testing
> reg_state or similar.

Thanks for the review. I'll investigate more about this and send v2
once I found a better solution.

-- 
Kalle Valo
