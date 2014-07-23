Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36953 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaGWMpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 08:45:25 -0400
Message-ID: <53CFAE62.2050401@candelatech.com> (sfid-20140723_144528_432970_14F2E479)
Date: Wed, 23 Jul 2014 05:45:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3 1/5] ath10k: provide firmware crash info via debugfs.
References: <1406070154-6614-1-git-send-email-greearb@candelatech.com> <CA+BoTQnngYO_AzqQnxFpWQrez-q7Z=hBUNOt+H8FybE9+fq5fA@mail.gmail.com>
In-Reply-To: <CA+BoTQnngYO_AzqQnxFpWQrez-q7Z=hBUNOt+H8FybE9+fq5fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/23/2014 01:25 AM, Michal Kazior wrote:
> On 23 July 2014 01:02,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Store the firmware crash registers and last 128 or so
>> firmware debug-log ids and present them to user-space
>> via debugfs.
>>
>> Should help with figuring out why the firmware crashed.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> [...]
>> +struct ath10k_dump_file_data {
>> +       /* Dump file information */
>> +       char df_magic[16]; /* ATH10K-FW-DUMP */
>> +       u32 len;
>> +       u32 big_endian; /* 0x1 if host is big-endian */
>> +       u32 version; /* File dump version, 1 for now. */
>> +
>> +       /* Some info we can get from ath10k struct that might help. */
>> +       u32 chip_id;
>> +       u32 bus_type; /* 0 for now, in place for later hardware */
>> +       u32 target_version;
>> +       u32 fw_version_major;
>> +       u32 fw_version_minor;
>> +       u32 fw_version_release;
>> +       u32 fw_version_build;
>> +       u32 phy_capability;
>> +       u32 hw_min_tx_power;
>> +       u32 hw_max_tx_power;
>> +       u32 ht_cap_info;
>> +       u32 vht_cap_info;
>> +       u32 num_rf_chains;
>> +       char fw_ver[ETHTOOL_FWVERS_LEN]; /* Firmware version string */
>> +
>> +       /* Kernel related information */
>> +       u32 tv_sec_hi; /* time-of-day stamp, high 32-bits for seconds */
>> +       u32 tv_sec_lo; /* time-of-day stamp, low 32-bits for seconds */
>> +       u32 tv_nsec_hi; /* time-of-day stamp, nano-seconds, high bits */
>> +       u32 tv_nsec_lo; /* time-of-day stamp, nano-seconds, low bits */
>> +       u32 kernel_ver_code; /* LINUX_VERSION_CODE */
>> +       char kernel_ver[64]; /* VERMAGIC_STRING */
>> +
>> +       u8 unused[128]; /* Room for growth w/out changing binary format */
>> +
>> +       u8 data[0]; /* struct ath10k_tlv_dump_data + more */
>> +} __packed;
>
> I think it would be a lot better if this format had a fixed endianess
> (__le/__be instead of u32). But see below.
>
>
>> +static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
> [...]
>> +       getnstimeofday(&timestamp);
>> +       dump_data->tv_sec_hi = timestamp.tv_sec >> 32;
>> +       dump_data->tv_sec_lo = timestamp.tv_sec;
>> +       dump_data->tv_nsec_hi = timestamp.tv_nsec >> 32;
>> +       dump_data->tv_nsec_lo = timestamp.tv_nsec;
>> +
>> +       spin_lock_irqsave(&ar->data_lock, flags);
>
> You can't just use _irqsave with data_lock like that. You have to
> convert *all* data_lock usages from _bh to _irqsave.
>
> Is it really necessary to use the _irqsave here anyway? We can
> probably make sure dump function is never called directly from an
> interrupt. I think that's already the case anyway.

I can change to bh variant and make sure lockdep doesn't complain.

>> +/* Target debug log related defines and structs */
>> +
>> +/* Target is 32-bit CPU, so we just use u32 for
>> + * the pointers.  The memory space is relative to the
>> + * target, not the host.
>> + */
>> +struct ath10k_fw_dbglog_buf {
>> +       u32 next; /* pointer to dblog_buf_s. */
>> +       u32 buffer; /* pointer to u8 buffer */
>> +       u32 bufsize;
>> +       u32 length;
>> +       u32 count;
>> +       u32 free;
>> +} __packed;
>> +
>> +struct ath10k_fw_dbglog_hdr {
>> +       u32 dbuf; /* pointer to dbglog_buf_s */
>> +       u32 dropped;
>> +} __packed;
>
> These structures are target device specific, right? Since the target
> is little-endian I'd think these structures should be defined as such
> (i.e. __le32 instead of u32).
>
> But then ath10k_pci_diag_read/write_mem() do byte-swapping
> automatically (hint: they shouldn't, but since it's my fault I guess I
> should be the one to fix it up.. :).
>
> This would also explain why you defined a big_endian bool in the dump
> structure instead of using __be/__le and explicit conversion. It's all
> good until you start dumping RAM and try to deal with non-word data
> (e.g. mac addresses).

This can all be handled in the decode tool, so I'd like to just keep the
kernel bit as is.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
