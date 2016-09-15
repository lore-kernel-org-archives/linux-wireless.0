Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37234 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753360AbcIOPO4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 11:14:56 -0400
Subject: Re: [PATCH v2 09/21] ath10k: print fw debug messages in hex.
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
 <1462986153-16318-10-git-send-email-greearb@candelatech.com>
 <87oa3qefac.fsf@kamboji.qca.qualcomm.com> <57D96910.2010608@candelatech.com>
 <87k2edb6kp.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <a26dfea0-9a18-69fc-e23c-cb223490822d@candelatech.com> (sfid-20160915_171515_887146_44E42480)
Date: Thu, 15 Sep 2016 08:14:55 -0700
MIME-Version: 1.0
In-Reply-To: <87k2edb6kp.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2016 07:06 AM, Valo, Kalle wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 09/14/2016 07:18 AM, Valo, Kalle wrote:
>>> greearb@candelatech.com writes:
>>>
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> This allows user-space tools to decode debug-log
>>>> messages by parsing dmesg or /var/log/messages.
>>>>
>>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>>
>>> Don't tracing points already provide the same information?
>>
>> Tracing tools are difficult to set up and may not be available on
>> random embedded devices.  And if we are dealing with bug reports from
>> the field, most users will not be able to set it up regardless.
>>
>> There are similar ways to print out hex, but the logic below creates
>> specific and parseable logs in the 'dmesg' output and similar.
>>
>> I have written a tool that can decode these messages into useful human-readable
>> text so that I can debug firmware issues both locally and from field reports.
>>
>> Stock firmware generates similar logs and QCA could write their own decode logic
>> for their firmware versions.
>
> Reinventing the wheel by using printk as the delivery mechanism doesn't
> sound like a good idea. IIRC Emmanuel talked about some kind of firmware
> debugging framework, he might have some ideas.

Waiting for magical frameworks to fix problems is even worse.

It has been years since ath10k has been in the kernel.  There is basically
still no way to debug what the firmware is doing.

My patch gives you something that can work right now, with the standard 'dmesg'
framework found in virtually all kernels new and old, and it has been proven
to be useful in the field.  The messages are also nicely interleaved with the
rest of the mac80211 stack messages and any other driver messages, so you have
context.

If someone wants to add support for a framework later, then by all means, post
the patches when it is ready.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
