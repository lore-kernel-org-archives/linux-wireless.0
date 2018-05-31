Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37812 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932708AbeEaPxE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 11:53:04 -0400
Subject: Re: [PATCH] cfg80211: Add cumulative channel survey dump support.
To: vnaralas@codeaurora.org, Johannes Berg <johannes@sipsolutions.net>
References: <1526980556-26707-1-git-send-email-vnaralas@codeaurora.org>
 <1527069282.3759.16.camel@sipsolutions.net>
 <ebf1c95acb34649b3d2a5435142dc06a@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <7afee956-9f91-37f5-52d2-7cdc0686f213@candelatech.com> (sfid-20180531_175308_144480_831AD032)
Date: Thu, 31 May 2018 08:52:56 -0700
MIME-Version: 1.0
In-Reply-To: <ebf1c95acb34649b3d2a5435142dc06a@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/31/2018 02:06 AM, vnaralas@codeaurora.org wrote:
> On 2018-05-23 15:24, Johannes Berg wrote:
>> On Tue, 2018-05-22 at 14:45 +0530, Venkateswara Naralasetty wrote:
>>> This patch provides support to send accumulated survey data to
>>> user if low level drivers provides non-accumulated survey data.
>>
>> I think the commit log should say what you need this for?
>>
>> It's simultaneously a new flag, and a lot of code, but it's not clear
>> what the point is?
>>
>> johannes
>
> I will sent next version of patch with updated commit log.
>
> Providing you the earlier discussion of this patch to give quick overview about this patch.
> https://patchwork.kernel.org/patch/9701459/

It is simple to fix the firmware, it just has several bugs related to clearing the
accumulator as well as the 'real' values.  If you can find a QCA firmware engineer
that will accept patches I can show them how to fix this easily.  I recently
fixed this in my wave-1 firmware.  I posted patches to the ath10k driver to
support this a week or so ago, but not sure if Kalle will apply them.

And, it is likely that even if you don't use the 'clear' option, you are going to
get wraps in the firmware and that will just be other harder to debug bugs.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
