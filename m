Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37836 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0LBFop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 00:44:45 -0500
Message-ID: <4CF73249.3040203@candelatech.com>
Date: Wed, 01 Dec 2010 21:44:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
References: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>	<4CF6A8FD.6020508@candelatech.com> <AANLkTik7L-Ybcq6N=3daQefbycV3h9+=YtFV8_c3JW24@mail.gmail.com>
In-Reply-To: <AANLkTik7L-Ybcq6N=3daQefbycV3h9+=YtFV8_c3JW24@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2010 09:09 PM, Mohammed Shafi wrote:
> On Thu, Dec 2, 2010 at 1:28 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 12/01/2010 03:00 AM, Senthil Balasubramanian wrote:
>>>
>>> AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
>>> this status for MIC failed frames is buggy.
>>>
>>> Due to this, MIC failure events for broadcast frames are not sent to
>>> supplicant resulted in AP disconnecting the STA.
>>>
>>> Able to pass Wifi Test case 5.2.18 with this fix.
>>
>> Please do not apply this yet.  As far as I can tell, either
>> of these patches breaks multiple VIF scenarios.  I'm not
>> sure exactly why, but I had to revert this to get any
>> of my interfaces to associate.
>
> Ben can you please give some more information(or just point out some
> link) regarding your test case,I can try it out.
> thanks,
> shafi

Try this script, or something like it:

http://www.spinics.net/lists/linux-wireless/msg60126.html

Edit 'max' to create a small number of STA interfaces or you will probably have
worse issues than them just not associating!

You have to enable the nohwcrypt module option.

Let me know if that doesn't work and I can probably put together something
more specific.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
