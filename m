Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52372 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFEL3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:29:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 1/4] ath10k: provide firmware crash info via debugfs.
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
	<538F4DEE.6040405@candelatech.com>
Date: Thu, 5 Jun 2014 14:29:29 +0300
In-Reply-To: <538F4DEE.6040405@candelatech.com> (Ben Greear's message of "Wed,
	04 Jun 2014 09:48:46 -0700")
Message-ID: <8738fjppba.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_132944_424220_CA1DA38B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/04/2014 02:04 AM, Michal Kazior wrote:
>> On 3 June 2014 18:25,  <greearb@candelatech.com> wrote:
>>
>>> --- a/drivers/net/wireless/ath/ath10k/core.h
>>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>>> @@ -41,6 +41,8 @@
>>>  #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
>>>  #define ATH10K_NUM_CHANS 38
>>>
>>> +#define REG_DUMP_COUNT_QCA988X 60 /* from pci.h */
>> 
>> I don't like this.

Me neither.

> You want me to make a different define for this that duplicates
> the '60' value?  At least with my method above, we should get compile
> errors if the values ever diverge in the two files.

There should be only one define. Somewhere (forgot where) Michal
suggested hw.h, I think this define would be a good candidate to move
there too.

>>> +struct ath10k_tlv_dump_data {
>>> +       u32 type; /* see ath10k_fw_error_dump_type above */
>>> +       u32 tlv_len; /* in bytes */
>>> +       u8 tlv_data[]; /* Pad to 32-bit boundaries as needed. */
>>> +} __packed;
>>> +
>>> +struct ath10k_dump_file_data {
>>> +       u32 len;
>>> +       u32 magic; /* 0x01020304, tells us byte-order of host if we care */
>>> +       struct ath10k_tlv_dump_data data; /* more may follow */
>>> +} __packed;
>>> +
>>> +/* This will store at least the last 128 entries. */
>>> +#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * 4)
>> 
>> Where does the 7 and 4 come from? Can't we use sizeof() to compute this?
>
> It is from the guts of how the firmware does debug logs.
>
> Each entry is a max of 7 32-bit integers in length.
>
>> The 128 should probably be a separate #define?
>
> I don't see why...

To make the code more readable.

> dbglog messages are variable number of 32-bit integers in length, so
> the 128 is fairly arbitrary.

A person should immeaditely understand where the numbers are coming from
and not start googling about it. The minimum is to put your description
above to the comment. And it would be clearer to replace 4 with
sizeof(u32).

-- 
Kalle Valo
