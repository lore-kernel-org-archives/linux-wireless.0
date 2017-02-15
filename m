Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36165 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdBOKzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:55:14 -0500
Received: by mail-pg0-f43.google.com with SMTP id v184so36187168pgv.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 02:55:13 -0800 (PST)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
 <1485250815.7244.8.camel@sipsolutions.net>
 <fd4c2573-caea-1cdc-ee33-f010bb0aad58@broadcom.com>
 <1487076714.4705.11.camel@sipsolutions.net>
 <deef3e83-b6d8-f99d-516d-dc6e99013560@broadcom.com>
 <1487077927.4705.14.camel@sipsolutions.net>
 <e2ec8547-4e0d-881b-5f4e-1e61d4b8b047@broadcom.com>
 <1487103101.6517.1.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <83361d12-d793-380d-6eec-7191f3d10d9f@broadcom.com> (sfid-20170215_115516_994519_2332AE79)
Date: Wed, 15 Feb 2017 11:55:10 +0100
MIME-Version: 1.0
In-Reply-To: <1487103101.6517.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-2-2017 21:11, Johannes Berg wrote:
> On Tue, 2017-02-14 at 21:09 +0100, Arend Van Spriel wrote:
>> On 14-2-2017 14:12, Johannes Berg wrote:
>>> On Tue, 2017-02-14 at 14:07 +0100, Arend Van Spriel wrote:
>>>
>>>>> No. But there was a size limit on how much older userspace
>>>>> could
>>>>> process before we did the splitting.
>>>>
>>>> I see. So basically adding stuff to (split_start == 0) is not
>>>> wanted.
>>>
>>> Correct.
>>
>> Uhm. Now I am staring at the code there and wonder about following.
>> Up until (split_start == 7) I see:
>>
>> 		state->split_start++;
>> 		if (state->split)
>> 			break;
>>
>> For the remaining cases the break is unconditional. Any idea how to
>> interpret that?
> 
> Yeah, actually, adding stuff to anything where split_start < 7 is
> therefore not wanted :-)
> 
> The thing is that we if no split is accepted by the userspace tool
> (state->split is false) then we have to send everything in one big
> message. This is everything until split_start == 7, I guess.
> 
> After that, there's only new stuff that such old userspace will be
> unable to interpret anyway, so the break is then unconditional - old
> userspace without split will never see those new capabilities, and new
> userspace can deal with the split.

Ok. Now I bumped into a nice comment which I should have seen earlier ;-)

		/*
		 * Any information below this point is only available to
		 * applications that can deal with it being split. This
		 * helps ensure that newly added capabilities don't break
		 * older tools by overrunning their buffers.
		 *
		 * We still increment split_start so that in the split
		 * case we'll continue with more data in the next round,
		 * but break unconditionally so unsplit data stops here.
		 */
		state->split_start++;
		break;
	case 9:

Oh, well. So actually the sched_scan_plan attributes in case 0 slipped
through the cracks.

Regards,
Arend
