Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60900 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbcILQgb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 12:36:31 -0400
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
To: Johannes Berg <johannes@sipsolutions.net>,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
 <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
 <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
 <1473662637.4201.2.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <6c78bfe8-c760-6331-b188-9cf79334f08d@candelatech.com> (sfid-20160912_183634_664420_5DED29CB)
Date: Mon, 12 Sep 2016 09:36:29 -0700
MIME-Version: 1.0
In-Reply-To: <1473662637.4201.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2016 11:43 PM, Johannes Berg wrote:
> On Wed, 2016-09-07 at 18:20 +0000, Pedersen, Thomas wrote:
>> On 09/06/2016 12:07 PM, Ben Greear wrote:
>>>
>>> On 09/06/2016 12:00 PM, Thomas Pedersen wrote:
>>>>
>>>> Some drivers (ath10k) report MCS 9 @ 20MHz, which
>>>> technically isn't allowed. To get more meaningful value
>>>> than 0 out of this however, just cap the bitrate for 20MHz
>>>> to MCS 8.
>>>
>>> If it is actually reporting MCS9, why lie about it?  Report it up
>>> the stack as a proper value instead of hiding the issue?
>>
>> Good point, will send a v2 extrapolating the value to 86.5Mb/s.
>
> That makes no sense either, IMHO.
>
> Are you saying that ath10k actually somehow manages to use an invalid
> bitrate over the air?!
>
> It seems more likely that it's actually just misreporting what it's
> doing, and thus the issue should be fixed in ath10k.

I saw ath10k report the same value in my testing.

Hard to know what the actual on-air encoding rate is.

I do know that some ath10k firmware would run 1Mbps encoding
management frames on 5Mhz, which is also not per spec, for what that is worth.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
