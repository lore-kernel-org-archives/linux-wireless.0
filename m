Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35729 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaHSPZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 11:25:24 -0400
Message-ID: <53F36C63.8040809@candelatech.com> (sfid-20140819_172528_129853_D1FF902C)
Date: Tue, 19 Aug 2014 08:25:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
References: <20140819082038.16842.46876.stgit@potku.adurom.net>	<20140819082253.16842.32433.stgit@potku.adurom.net> <CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>
In-Reply-To: <CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/19/2014 02:33 AM, Michal Kazior wrote:
> On 19 August 2014 10:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Store the firmware crash registers and last 128 or so
>> firmware debug-log ids and present them to user-space
>> via debugfs.
>>
>> Should help with figuring out why the firmware crashed.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
> [...]
>> +struct ath10k_dump_file_data {
>> +       /* dump file information */
>> +
>> +       /* "ATH10K-FW-DUMP" */
>> +       char df_magic[16];
>> +
>> +       __le32 len;
>> +
>> +       /* file dump version */
>> +       __le32 version;
>> +
>> +       /* some info we can get from ath10k struct that might help */
>> +
>> +       u8 uuid[16];
>> +
>> +       __le32 chip_id;
>> +
>> +       /* 0 for now, in place for later hardware */
>> +       __le32 bus_type;
>> +
>> +       __le32 target_version;
>> +       __le32 fw_version_major;
>> +       __le32 fw_version_minor;
>> +       __le32 fw_version_release;
>> +       __le32 fw_version_build;
>> +       __le32 phy_capability;
>> +       __le32 hw_min_tx_power;
>> +       __le32 hw_max_tx_power;
>> +       __le32 ht_cap_info;
>> +       __le32 vht_cap_info;
>> +       __le32 num_rf_chains;
>
> Hmm.. some of these values don't really change once driver is loaded
> so we could probably just export them as separate debugfs entries but
> perhaps that's an overkill just for dumping.

I think it will be easier for all involved if there is a single dump image that
has all needed info.  Likely the end user of the dump file will have little or no
interaction with the host that dumped the file to begin with.

>> +       dump_data->kernel_ver_code = cpu_to_le32(LINUX_VERSION_CODE);
>> +       strlcpy(dump_data->kernel_ver, VERMAGIC_STRING,
>> +               sizeof(dump_data->kernel_ver));
>> +
>> +       dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
>> +       dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
>> +
>> +       /* Gather dbg-log */
>> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
>> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
>> +       dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->dbglog_entry_data));
>
> Hmm should this really be sizeof()? Not next_idx (which effectively
> defines number of bytes of the dbglog)?

I haven't tried decoding this yet, but we may need to know the next_idx
to decode this properly.

>> +       memcpy(dump_tlv->tlv_data, &crash_data->dbglog_entry_data,
>> +              sizeof(crash_data->dbglog_entry_data));
>> +       sofar += sizeof(*dump_tlv) + sizeof(crash_data->dbglog_entry_data);
>> +
>> +       /* Gather crash-dump */
>> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
>> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGDUMP);
>> +       dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->reg_dump_values));
>> +       memcpy(dump_tlv->tlv_data, &crash_data->reg_dump_values,
>> +              sizeof(crash_data->reg_dump_values));
>> +       sofar += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);
>
> I haven't seen you mention that your latest patchset is based on my
> patches that remove implicit byte swap from some diag functions so I
> infer you're might've missed that reg_dump_values will be byte swapped
> on big-endian hosts and userspace will remain unaware of that since
> there is no endianess indication in the crash dump structure anymore.
>
> reg_dump_values must be swapped cpu_to_le32 here (or should be never
> implicit byte swapped in the first place).
>
> It's probably worth stating in the comments that
> ATH10K_FW_CRASH_DUMP_REGDUMP returns a list of __le32.
>
>
>> +               ret = ath10k_pci_diag_read_mem(ar, dbuf.buffer, buffer,
>> +                                              dbuf.length);
>> +               if (ret != 0) {
>> +                       ath10k_warn("failed to read debug log buffer from address 0x%x: %d\n",
>> +                                   dbuf.buffer, ret);
>> +                       kfree(buffer);
>> +                       return;
>> +               }
>> +
>> +               ath10k_debug_dbglog_add(ar, buffer, dbuf.length);
>> +               kfree(buffer);
>
> Is the `buffer` really a string of bytes (u8) or just u32 in disguise?
> If it's the former then on big-endian host the implicit byte swap will
> mess it up and userspace will have no way of knowing that now.

dbglog is array of 32 bit ints.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
