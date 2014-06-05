Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34539 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaFEPtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 11:49:10 -0400
Message-ID: <53909175.30009@candelatech.com> (sfid-20140605_174919_306848_F9E70519)
Date: Thu, 05 Jun 2014 08:49:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 1/4] ath10k: provide firmware crash info via debugfs.
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com> <CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com> <538F4DEE.6040405@candelatech.com> <8738fjppba.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8738fjppba.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 04:29 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
>> On 06/04/2014 02:04 AM, Michal Kazior wrote:
>>> On 3 June 2014 18:25,  <greearb@candelatech.com> wrote:
>>>
>>>> --- a/drivers/net/wireless/ath/ath10k/core.h
>>>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>>>> @@ -41,6 +41,8 @@
>>>>  #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
>>>>  #define ATH10K_NUM_CHANS 38
>>>>
>>>> +#define REG_DUMP_COUNT_QCA988X 60 /* from pci.h */
>>>
>>> I don't like this.
> 
> Me neither.
> 
>> You want me to make a different define for this that duplicates
>> the '60' value?  At least with my method above, we should get compile
>> errors if the values ever diverge in the two files.
> 
> There should be only one define. Somewhere (forgot where) Michal
> suggested hw.h, I think this define would be a good candidate to move
> there too.

Ok, I'll move it to hw.h

>>>> +/* This will store at least the last 128 entries. */
>>>> +#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * 4)
>>>
>>> Where does the 7 and 4 come from? Can't we use sizeof() to compute this?
>>
>> It is from the guts of how the firmware does debug logs.
>>
>> Each entry is a max of 7 32-bit integers in length.
>>
>>> The 128 should probably be a separate #define?
>>
>> I don't see why...
> 
> To make the code more readable.
> 
>> dbglog messages are variable number of 32-bit integers in length, so
>> the 128 is fairly arbitrary.
> 
> A person should immeaditely understand where the numbers are coming from
> and not start googling about it. The minimum is to put your description
> above to the comment. And it would be clearer to replace 4 with
> sizeof(u32).

Would the comments I put in the PATCH 1/4 combined with the sizeof(4)
be sufficient, or do you want actual defines?  To really understand
this code you need details from how the firmware encodes the messages.
I would rather a QCA person add that info just in case it is considered
protected info...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

