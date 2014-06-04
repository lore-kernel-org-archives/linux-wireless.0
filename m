Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52187 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaFDQsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 12:48:47 -0400
Message-ID: <538F4DEE.6040405@candelatech.com> (sfid-20140604_184903_508543_9DA16443)
Date: Wed, 04 Jun 2014 09:48:46 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/4] ath10k: provide firmware crash info via debugfs.
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com> <CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
In-Reply-To: <CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2014 02:04 AM, Michal Kazior wrote:
> On 3 June 2014 18:25,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Store the firmware crash registers and last 128 or so
>> firmware debug-log ids and present them to user-space
>> via debugfs.
>>
>> Should help with figuring out why the firmware crashed.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>
>> This series is compile-tested only at this point.  Hoping
>> for feedback on general approach at least.
>>
>>
>> drivers/net/wireless/ath/ath10k/core.h  |  41 +++++++++++
>>  drivers/net/wireless/ath/ath10k/debug.c | 124 ++++++++++++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/debug.h |  25 +++++++
>>  drivers/net/wireless/ath/ath10k/pci.c   |  86 +++++++++++++++++++++-
>>  4 files changed, 273 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
>> index 68ceef6..4068910 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -41,6 +41,8 @@
>>  #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
>>  #define ATH10K_NUM_CHANS 38
>>
>> +#define REG_DUMP_COUNT_QCA988X 60 /* from pci.h */
> 
> I don't like this.

You want me to make a different define for this that duplicates
the '60' value?  At least with my method above, we should get compile
errors if the values ever diverge in the two files.

>> +struct ath10k_tlv_dump_data {
>> +       u32 type; /* see ath10k_fw_error_dump_type above */
>> +       u32 tlv_len; /* in bytes */
>> +       u8 tlv_data[]; /* Pad to 32-bit boundaries as needed. */
>> +} __packed;
>> +
>> +struct ath10k_dump_file_data {
>> +       u32 len;
>> +       u32 magic; /* 0x01020304, tells us byte-order of host if we care */
>> +       struct ath10k_tlv_dump_data data; /* more may follow */
>> +} __packed;
>> +
>> +/* This will store at least the last 128 entries. */
>> +#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * 4)
> 
> Where does the 7 and 4 come from? Can't we use sizeof() to compute this?

It is from the guts of how the firmware does debug logs.

Each entry is a max of 7 32-bit integers in length.

> The 128 should probably be a separate #define?

I don't see why...dbglog messages are variable number of 32-bit
integers in length, so the 128 is fairly arbitrary.

>> +static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
>> +{
>> +       unsigned int len = (sizeof(ar->dbglog_entry_data)
>> +                           + sizeof(ar->reg_dump_values));
>> +       unsigned int sofar = 0;
>> +       char *buf;
>> +       struct ath10k_tlv_dump_data *dump_tlv;
>> +       struct ath10k_dump_file_data *dump_data;
>> +       int hdr_len = sizeof(*dump_data) - sizeof(dump_data->data);
> 
> You call this with conf_mutex held so it's a good idea to have a
> lockdep here, isn't it?

ok.

>> --- a/drivers/net/wireless/ath/ath10k/debug.h
>> +++ b/drivers/net/wireless/ath/ath10k/debug.h
>> @@ -19,6 +19,7 @@
>>  #define _DEBUG_H_
>>
>>  #include <linux/types.h>
>> +#include "pci.h"
>>  #include "trace.h"
> 
> Not really sure if we should be mixing pci in debug?
> 
> This actually gets me thinking we could have some stuff in hw.h that
> isn't really related to the transport. I can imagine usb transport
> would have pretty much the same hardware at the other side.

I don't see much benefit to the separate modules for ath10k anyway,
seems like it's currently a lot of overhead for no advantage.  Maybe
with a usb NIC is released it will make more sense.

>>  enum ath10k_debug_mask {
>> @@ -110,4 +111,28 @@ static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
>>  {
>>  }
>>  #endif /* CONFIG_ATH10K_DEBUG */
>> +
>> +
>> +/* Target debug log related defines and structs */
>> +
>> +/* Target is 32-bit CPU, so we just use u32 for
>> + * the pointers.  The memory space is relative to the
>> + * target, not the host.
>> + */
>> +struct dbglog_buf_s {
>> +       u32 next; /* pointer to dblog_buf_s. */
>> +       u32 buffer; /* pointer to u8 buffer */
>> +       u32 bufsize;
>> +       u32 length;
>> +       u32 count;
>> +       u32 free;
>> +} __packed;
>> +
>> +struct dbglog_hdr_s {
>> +       u32 dbuf; /* pointer to dbglog_buf_s */
>> +       u32 dropped;
>> +} __packed;
> 
> These structure names look strange. Why the _s suffix? Shouldn't these
> be called simply ath10k_dbglog_buf and ath10k_dbglog_hdr? Or
> ath10k_{fw/hw/dev/target}_dbglog_buf/hdr? (In case you want to have a
> clearer distinction these structures aren't ath10k's per se).

I can rename them, don't recall why I named them thus (similar patch has
been in my tree since last fall.)

> [...]
>> +       while (dbufp) {
>> +               struct dbglog_buf_s dbuf;
>> +
>> +               ret = ath10k_pci_diag_read_mem(ar, dbufp,
>> +                                              &dbuf, sizeof(dbuf));
>> +               if (ret != 0) {
>> +                       ath10k_err("could not read Debug Log Area: 0x%x\n",
>> +                                  dbufp);
>> +                       goto save_regs_and_restart;
>> +               }
>> +
>> +               /* We have a buffer of data */
>> +               /* TODO:  Do we need to worry about bit order on some
>> +                * architectures?  This seems to work fine with
>> +                * x86-64 host, at least.
>> +                */
> 
> ath10k_pci_diag* performs byte-swap so you're good as long as you read
> word-like data from the target. I suspect this might not work so great
> if you read something like, say, a mac address which might be stored
> as a raw byte stream instead.
> 
> What kind of data can we expect from the dbglog?

Any and all, it is up to user-space to decode because it requires
intimate knowledge of the firmware.  I think you might have seen
the tool I gave to QCA that decodes dbglog messages printed in ascii-hex
in kernel logs?  Same tool with tweak can decode this binary info.

Plz ask me off list if you want the tool and do not have it...I can
try to get it forwarded to you trough my QCA contacts.  The debug tool
cannot be made public w/out QCA's explicit consent, and no idea if
that would ever happen...but at least firmware devs under NDA can use it
or something similar...


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

