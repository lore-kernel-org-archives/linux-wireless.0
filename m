Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51763 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaFFGTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 02:19:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 1/4] ath10k: provide firmware crash info via debugfs.
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
	<538F4DEE.6040405@candelatech.com>
	<8738fjppba.fsf@kamboji.qca.qualcomm.com>
	<53909175.30009@candelatech.com>
Date: Fri, 6 Jun 2014 09:13:09 +0300
In-Reply-To: <53909175.30009@candelatech.com> (Ben Greear's message of "Thu, 5
	Jun 2014 08:49:09 -0700")
Message-ID: <87sinimuq2.fsf@kamboji.qca.qualcomm.com> (sfid-20140606_081954_445439_6A1D5586)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>>>>> +/* This will store at least the last 128 entries. */
>>>>> +#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * 4)
>>>>
>>>> Where does the 7 and 4 come from? Can't we use sizeof() to compute this?
>>>
>>> It is from the guts of how the firmware does debug logs.
>>>
>>> Each entry is a max of 7 32-bit integers in length.
>>>
>>>> The 128 should probably be a separate #define?
>>>
>>> I don't see why...
>> 
>> To make the code more readable.
>> 
>>> dbglog messages are variable number of 32-bit integers in length, so
>>> the 128 is fairly arbitrary.
>> 
>> A person should immeaditely understand where the numbers are coming from
>> and not start googling about it. The minimum is to put your description
>> above to the comment. And it would be clearer to replace 4 with
>> sizeof(u32).
>
> Would the comments I put in the PATCH 1/4 combined with the sizeof(4)
> be sufficient, or do you want actual defines?

What you wrote about should be enough, I think you can skip the defines
for now. Something like:

        /* Each entry is a max of 7 32-bit integers in length, let's choose
         * arbitrarily 128 entries */

-- 
Kalle Valo
