Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39301 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaHRMhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 08:37:02 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so3576661wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2014 05:36:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878ummdo2l.fsf@kamboji.qca.qualcomm.com>
References: <20140809180552.29215.58612.stgit@potku.adurom.net>
	<20140809180805.29215.45232.stgit@potku.adurom.net>
	<CA+BoTQ=dO0kr+0tnXpJRoPd7iwGDtPj_cWM=vvMsRgGn1we5ow@mail.gmail.com>
	<878ummdo2l.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 18 Aug 2014 14:36:59 +0200
Message-ID: <CA+BoTQ=0sigYGooKwqy6LtTQXrkg2kP1htofgPRfryiUcwTyrA@mail.gmail.com> (sfid-20140818_143723_199864_8D879C7D)
Subject: Re: [PATCH v6 2/8] ath10k: provide firmware crash info via debugfs
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 August 2014 13:39, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 9 August 2014 20:08, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> Store the firmware crash registers and last 128 or so
>>> firmware debug-log ids and present them to user-space
>>> via debugfs.
>>>
>>> Should help with figuring out why the firmware crashed.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>>> ---
>>>  drivers/net/wireless/ath/ath10k/core.h  |   27 +++
>>>  drivers/net/wireless/ath/ath10k/debug.c |  273 +++++++++++++++++++++++++++++++
>>>  drivers/net/wireless/ath/ath10k/debug.h |   22 ++
>>>  drivers/net/wireless/ath/ath10k/hw.h    |   30 +++
>>>  drivers/net/wireless/ath/ath10k/pci.c   |  133 ++++++++++++++-
>>>  drivers/net/wireless/ath/ath10k/pci.h   |    3
>>>  6 files changed, 478 insertions(+), 10 deletions(-)
>> [...]
>>
>>> +struct ath10k_dump_file_data {
>>> +       /* dump file information */
>>> +
>>> +       /* "ATH10K-FW-DUMP" */
>>> +       char df_magic[16];
>>> +
>>> +       u32 len;
>>> +
>>> +       /* 0x1 if host is big-endian */
>>> +       u32 big_endian;
>>
>> This isn't entirely correct. Depending on host endianess you'll end up
>> with 0x1 or 0x1000000. This will still work if you do a boolean
>> evaluation of it in userspace or compare it to 0, but god forbid to
>> compare it with 0x1.
>
> That's true. Didn't you at one point suggest just always using little
> endian? I think that's simplest approach here.

Yes. I did point that out at some time ago.


>>> +       /* some info we can get from ath10k struct that might help */
>>> +
>>> +       u8 uuid[16];
>>> +
>>> +       u32 chip_id;
>>> +
>>> +       /* 0 for now, in place for later hardware */
>>> +       u32 bus_type;
>>
>> Maybe we should have an enum for that instead of using a hardcoded 0?
>
> We had that but you removed it in 3a0861fffd223 =)

.. right :-) I suppose we could just remove the bus_type then? We do
have an unused[128] for future expansion, don't we?


>> and/or the memory should be allocated outside this function completely
>> and make it consume the crashed_since_read (i.e. set it to false) once
>> it's done (while the data_lock is still held).
>
> You mean like allocating the memory in advance, for example during
> module probe time? Then we would have a big chunk of memory we don't use
> for anything most of the time.

I meant just moving it up in the call stack, e.g. to
ath10k_fw_crash_dump_open().


Michał
