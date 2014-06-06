Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6247 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaFFGSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 02:18:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	<87egz3nxdn.fsf@kamboji.qca.qualcomm.com>
	<5390B632.7030305@candelatech.com>
Date: Fri, 6 Jun 2014 09:10:15 +0300
In-Reply-To: <5390B632.7030305@candelatech.com> (Ben Greear's message of "Thu,
	5 Jun 2014 11:25:54 -0700")
Message-ID: <87wqcumuuw.fsf@kamboji.qca.qualcomm.com> (sfid-20140606_081901_431927_135E36FD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/05/2014 09:18 AM, Kalle Valo wrote:
>
>>> +struct ath10k_tlv_dump_data {
>>> +	u32 type; /* see ath10k_fw_error_dump_type above */
>>> +	u32 tlv_len; /* in bytes */
>>> +	u8 tlv_data[]; /* Pad to 32-bit boundaries as needed. */
>>> +} __packed;
>>> +
>>> +struct ath10k_dump_file_data {
>>> +	/* Dump file information */
>>> +	u32 len;
>>> +	u32 magic; /* 0x01020304, tells us byte-order of host if we care */
>>> +	u32 version; /* File dump version, 1 for now. */
>> 
>> Actually I would prefer to have magic first and have ASCII string as
>> string, for example "ATH10K-FW-DUMP".
>
> I'd like magic number to stay, was planning to use it to detect byte
> ordering (ie, dumps might come from various different platforms, to
> be decoded on some different platform).

If you want to know the endianess, I would prefer to do it the proper
way, for example something like this:

#ifdef __BIG_ENDIAN
        dump_data->big_endian = 1;
#else
        dump_data->big_endian = 0;
#endif

>>> +	/* Some info we can get from ath10k struct that might help. */
>>> +	u32 chip_id;
>>> +	u32 target_version;
>> 
>> bus_type or something like that would be good to add already now.
>
> Can you be more specific on what info you want here?  I don't see
> any mention of bus_type in the ath10k dir.

I was thinking of adding a new field named "bus_type" which will contain
just zero for now. This is so that we don't need to make any changes to
the format if/when we add a new bus along with pci.

>>> +	u32 fw_version_minor;
>>> +	u16 fw_version_release;
>>> +	u16 fw_version_build;
>>> +	u32 phy_capability;
>>> +	u32 hw_min_tx_power;
>>> +	u32 hw_max_tx_power;
>>> +	u32 ht_cap_info;
>>> +	u32 vht_cap_info;
>>> +	u32 num_rf_chains;
>>> +	char fw_ver[64]; /* Firmware version string */
>> 
>> Can we reuse ETHTOOL_FWVERS_LEN? cfg80211 already uses that.
>> 
>> #define ETHTOOL_FWVERS_LEN	32
>
> I prefer not to..that way, firmware format will remain the same even if
> the kernel changes the fwvers-len some day.

That is defined in the ethtool user space interface so changing that
would break a lot of things. And also used by cfg80211 and other
drivers. I would prefer to be consistent here and use
ETHTOOL_FWVERS_LEN.

>>> @@ -488,6 +555,12 @@ struct ath10k {
>>>  
>>>  	struct dfs_pattern_detector *dfs_detector;
>>>  
>>> +	/* Used for crash-dump storage */
>>> +	/* Don't over-write dump info until someone reads the data. */
>>> +	bool crashed_since_read;
>>> +	struct ath10k_dbglog_entry_storage dbglog_entry_data;
>>> +	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
>> 
>> I think these should be in struct ath10k_debug.
>
> I did not do this because I figure we will want ethtool support w/out
> forcing debugfs to be enabled someday soon.

When we add ethtool support, it's easy to move these back. And then we
need to move the code out from debug.c anyway.

>>> +void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, u8 *buffer, int len)
>>> +{
>>> +	int i;
>>> +	int z = ar->dbglog_entry_data.next_idx;
>>> +
>>> +	/* Don't save any new logs until user-space reads this. */
>>> +	if (ar->crashed_since_read)
>>> +		return;
>> 
>> Locking? If this functions depends on something, please document that
>> with lockdep_assert_held().
>
> To be honest, I was going to ignore locking and assume that firmware
> will not crash that often.  Worst case would be a garbled crash dump
> as there is no memory allocation involved in gathering the crash,
> and the length of the crash dump will not change based on anything in
> the crash logic.

Ignoring locking means that in few years we have a big mess in our
hands. I prefer to do the locking right from day one.

> I'm a bit leery of adding spin-locks in the dump routine just for
> this, but I can add and use a new spin-lock if you prefer.

Why a new spinlock? I didn't review the locking requirements, but I
would first check ar->data_lock can be used.

> If so, any idea if we can do the reads of the target's memory while
> holding a spin-lock, or would I need some temporary buffers and only
> lock while copying that in to the storage in the 'ar'?

I don't see why you would need special locks for reading target's
memory. If there is something needed, pci.c should handle that. Michal?

-- 
Kalle Valo
