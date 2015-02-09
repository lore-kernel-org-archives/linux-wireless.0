Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51718 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbbBIQEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 11:04:01 -0500
Message-ID: <54D8DA6F.7040805@candelatech.com> (sfid-20150209_170405_809814_FFE07904)
Date: Mon, 09 Feb 2015 08:03:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matti Laakso <malaakso@elisanet.fi>
Subject: Re: [RFT] ath10k: restart fw on tx-credit timeout
References: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>	<54D4E89A.7040602@candelatech.com> <CA+BoTQ=HqyGKOBdOmpWOn_VjH1UTWF9nN_PE0uanaGsdeJmB6Q@mail.gmail.com>
In-Reply-To: <CA+BoTQ=HqyGKOBdOmpWOn_VjH1UTWF9nN_PE0uanaGsdeJmB6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/08/2015 10:24 PM, Michal Kazior wrote:
> On 6 February 2015 at 17:15, Ben Greear <greearb@candelatech.com> wrote:
>> On 02/06/2015 04:05 AM, Michal Kazior wrote:
>>>
>>> It makes little sense to continue and let
>>> firmware-host state become inconsistent if a WMI
>>> command can't be submitted to firmware.
>>>
>>> This effectively prevents after-affects of
>>> tx-credit starvation bug which include spurious
>>> sta kickout events and inability to associate new
>>> stations after some time when acting as AP.
>>>
>>> This should also speed up recovery/teardown in
>>> some cases when firmware stops responding for some
>>> reason.
>>
>>
>> I have not seen a WMI timeout since I added keep-alive
>> and CE polling in my firmware, but the patch looks OK
>> to me.
>
> This is mainly aimed at the tx-credit starvation due to mgmt-tx being
> stuck on client powersave buffering.
>
>
>> You might add something about 'WMI' in that warning
>> message to make it more clear what is not being
>> responsive.
>
> Good point.
>
>
>> At least in my tests, I could continue
>> to receive network traffic while WMI was blocked.
>
> Yeah. Traffic works with the tx-credit starvation as well but what
> good is this if you have inconsistent driver-firmware state after
> failing to send a few commands?

I just mention it because someone debugging the system might
wonder why the firmware is 'locked up' while it is still passing traffic.

I agree with your patch in general.

If it is just powersave issue, could you force (overriding wmi tx-credits limit)
a flush at the 1 second mark and hope it recovers by 3 second timeout?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
