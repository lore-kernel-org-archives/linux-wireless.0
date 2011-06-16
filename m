Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27838 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030184Ab1FPWGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 18:06:11 -0400
Message-ID: <4DFA7E52.5040200@gnu.org> (sfid-20110617_000616_643735_62961353)
Date: Thu, 16 Jun 2011 18:06:10 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: use BUG_ON and return -EINVAL if rate_lowest_index()
 fails
References: <20110615220252.1918.73638.stgit@mj.roinet.com> <4DF9C7F0.9090308@broadcom.com>
In-Reply-To: <4DF9C7F0.9090308@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/2011 05:08 AM, Arend van Spriel wrote:
> On 06/16/2011 12:02 AM, Pavel Roskin wrote:

>> - WARN_ON(1);
>> + /* If we cannot find any rate, we are in trouble. */
>> + BUG_ON(1);
>>
>> - return 0;
>> + return -EINVAL;
>> }
>
> I would expect some description what the caller should do when -EINVAL
> is returned. Could even argue whether you want a BUG_ON or allow the
> caller (driver) to reset the hardware, reassociate, etc. upon -EINVAL. I
> am not sure under which circumstances this could happen so there may
> really be no way out.

I'm proposing a simple change that replaces memory corruption and 
unpredictable behavior with a predictable stop.  If sysrq is enabled, 
the system can even be restarted by the keyboard.

The meaning of -EINVAL is symbolic.  It shows that we are not returning 
a fallback value.  There is no valid fallback value to return.

The callers should not try to initialize rate control on interfaces with 
no rates enabled.  Anyway, the fix is out of scope of my patch.

-- 
Regards,
Pavel Roskin
