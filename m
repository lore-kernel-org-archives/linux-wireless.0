Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34674 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935708AbeFRU5h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 16:57:37 -0400
Subject: Re: [PATCH] cfg80211: Add cumulative channel survey dump support.
To: Johannes Berg <johannes@sipsolutions.net>, vnaralas@codeaurora.org
References: <1526980556-26707-1-git-send-email-vnaralas@codeaurora.org>
 <1527069282.3759.16.camel@sipsolutions.net>
 <ebf1c95acb34649b3d2a5435142dc06a@codeaurora.org>
 <7afee956-9f91-37f5-52d2-7cdc0686f213@candelatech.com>
 <1529354772.3092.41.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <f5d74d35-b4c1-4654-b4d0-9729b9749f16@candelatech.com> (sfid-20180618_225742_875170_480BB808)
Date: Mon, 18 Jun 2018 13:57:34 -0700
MIME-Version: 1.0
In-Reply-To: <1529354772.3092.41.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2018 01:46 PM, Johannes Berg wrote:
> On Thu, 2018-05-31 at 08:52 -0700, Ben Greear wrote:
>>
>> On 05/31/2018 02:06 AM, vnaralas@codeaurora.org wrote:
>>> On 2018-05-23 15:24, Johannes Berg wrote:
>>>> On Tue, 2018-05-22 at 14:45 +0530, Venkateswara Naralasetty wrote:
>>>>> This patch provides support to send accumulated survey data to
>>>>> user if low level drivers provides non-accumulated survey data.
>>>>
>>>> I think the commit log should say what you need this for?
>>>>
>>>> It's simultaneously a new flag, and a lot of code, but it's not clear
>>>> what the point is?
>>>>
>>>> johannes
>>>
>>> I will sent next version of patch with updated commit log.
>>>
>>> Providing you the earlier discussion of this patch to give quick overview about this patch.
>>> https://patchwork.kernel.org/patch/9701459/
>>
>> It is simple to fix the firmware, it just has several bugs related to clearing the
>> accumulator as well as the 'real' values.  If you can find a QCA firmware engineer
>> that will accept patches I can show them how to fix this easily.  I recently
>> fixed this in my wave-1 firmware.  I posted patches to the ath10k driver to
>> support this a week or so ago, but not sure if Kalle will apply them.
>
> That would be nicer even, but I guess we still have to worry about older
> firmware? Perhaps not for survey support? Dunno.
>
> Obviously less code is better, but I can't really say how easy it would
> be to get firmware updates rolled out to people who'd need them ...
>
>> And, it is likely that even if you don't use the 'clear' option, you are going to
>> get wraps in the firmware and that will just be other harder to debug bugs.
>
> You have to use clear if you don't accumulate completely in fw, no?

At least some firmware is broken in numerous ways, and there is no clear way to
tell which firmware is broken how as far as I can tell.  It does appear to be fixed in
recent 10.4 (wave-2) firmware, so maybe they will fix 10.2 as well.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
