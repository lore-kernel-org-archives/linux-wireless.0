Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53358 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdBASFL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 13:05:11 -0500
Subject: Re: [PATCH v2] ath10k: add support for controlling tx power to a
 station
To: Ashok Raj Nagarajan <arnagara@codeaurora.org>
References: <1485888165-23504-1-git-send-email-arnagara@qti.qualcomm.com>
 <cbb69298-391d-b3d5-5a84-5792fe170f95@candelatech.com>
 <0c8b88d40b3adc0f09ade2780ed1d994@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        ath10k@lists.infradead.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <28c201cb-5546-0537-f85c-4f1b84a8d3f0@candelatech.com> (sfid-20170201_190756_189077_6C748F90)
Date: Wed, 1 Feb 2017 10:05:09 -0800
MIME-Version: 1.0
In-Reply-To: <0c8b88d40b3adc0f09ade2780ed1d994@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2017 09:44 AM, Ashok Raj Nagarajan wrote:
> On 2017-02-01 00:27, Ben Greear wrote:
>> On 01/31/2017 10:42 AM, Ashok Raj Nagarajan wrote:
>>> This patch will add the support to control the transmit power for traffic
>>> to a station associated with the AP. Userspace provide the transmit power
>>> value in mBm units and the allowed range is from 0 to 70. Underlying FW
>>
>> How did you come up with 70 mBm as the limit.  This is only 7dBm?
>>
>> I would expect it to match the range of normal tx-power which is likely up to
>> 30 dBm or so on some NICs (not counting regulatory limit).
>>
>
> I think I will have to re-word the commit log a bit. ath10k driver would get the value in dBm only and the range is from 0 to 70 dBm. Looking at the db.txt, I
> see a max value of 44 dm for a 60GHz channel. SO to be little future proof having a greater acceptable range from user. The final tx power will be calculated
> based on this extra parameter the user passes on, including the regulatory limit for the channel.

Why not just accept any value that fits within the storage (u16, probably).  The regulatory logic
and other constraints can already make sure that the tx-power is not out-of-bounds, so the user cannot
really break something by attempting to set a large value.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
