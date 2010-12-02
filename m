Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42718 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab0LBHQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 02:16:09 -0500
Received: by wyb28 with SMTP id 28so7862065wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 23:16:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF73249.3040203@candelatech.com>
References: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
	<4CF6A8FD.6020508@candelatech.com>
	<AANLkTik7L-Ybcq6N=3daQefbycV3h9+=YtFV8_c3JW24@mail.gmail.com>
	<4CF73249.3040203@candelatech.com>
Date: Thu, 2 Dec 2010 12:46:08 +0530
Message-ID: <AANLkTinrQYN3_GpbfR=4xcJQ-moa32+QJtVorqq6xgR4@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 11:14 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 12/01/2010 09:09 PM, Mohammed Shafi wrote:
>>
>> On Thu, Dec 2, 2010 at 1:28 AM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 12/01/2010 03:00 AM, Senthil Balasubramanian wrote:
>>>>
>>>> AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
>>>> this status for MIC failed frames is buggy.
>>>>
>>>> Due to this, MIC failure events for broadcast frames are not sent to
>>>> supplicant resulted in AP disconnecting the STA.
>>>>
>>>> Able to pass Wifi Test case 5.2.18 with this fix.
>>>
>>> Please do not apply this yet.  As far as I can tell, either
>>> of these patches breaks multiple VIF scenarios.  I'm not
>>> sure exactly why, but I had to revert this to get any
>>> of my interfaces to associate.
>>
>> Ben can you please give some more information(or just point out some
>> link) regarding your test case,I can try it out.
>> thanks,
>> shafi
>
> Try this script, or something like it:
>
> http://www.spinics.net/lists/linux-wireless/msg60126.html
>
> Edit 'max' to create a small number of STA interfaces or you will probably
> have
> worse issues than them just not associating!
>
> You have to enable the nohwcrypt module option.
>
> Let me know if that doesn't work and I can probably put together something
> more specific.

thanks Ben.

>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
