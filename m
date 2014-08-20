Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:55011 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaHTG2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 02:28:16 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so7410960wev.13
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 23:28:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53F36C63.8040809@candelatech.com>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082253.16842.32433.stgit@potku.adurom.net>
	<CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>
	<53F36C63.8040809@candelatech.com>
Date: Wed, 20 Aug 2014 08:28:14 +0200
Message-ID: <CA+BoTQ=ocpY2BDCGhMB7E9s4ykp18uXHMTc7rOn0qb7mDyZ5qw@mail.gmail.com> (sfid-20140820_082819_709789_A7700A26)
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2014 17:25, Ben Greear <greearb@candelatech.com> wrote:
> On 08/19/2014 02:33 AM, Michal Kazior wrote:
>> On 19 August 2014 10:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
>>> +       __le32 target_version;
>>> +       __le32 fw_version_major;
>>> +       __le32 fw_version_minor;
>>> +       __le32 fw_version_release;
>>> +       __le32 fw_version_build;
>>> +       __le32 phy_capability;
>>> +       __le32 hw_min_tx_power;
>>> +       __le32 hw_max_tx_power;
>>> +       __le32 ht_cap_info;
>>> +       __le32 vht_cap_info;
>>> +       __le32 num_rf_chains;
>>
>>
>> Hmm.. some of these values don't really change once driver is loaded
>> so we could probably just export them as separate debugfs entries but
>> perhaps that's an overkill just for dumping.
>
>
> I think it will be easier for all involved if there is a single dump image
> that
> has all needed info.  Likely the end user of the dump file will have little
> or no
> interaction with the host that dumped the file to begin with.

I think there's been this idea about moving dumping to udev somewhat,
no? Since this is just debugfs then I imagine you could have a
userspace program that would create the single blob/crash report from
things it thinks is important, e.g.. `uname -a`, debugfs entries (fw
stack traces, dbglog, etc), recent kernel log buffer, etc. It could
even all be stored in plaintext (with binary data encoded as a
hexdump). But that, I guess, could be cumbersome, at least initially,
until all major distros adapt.


>
>>> +       dump_data->kernel_ver_code = cpu_to_le32(LINUX_VERSION_CODE);
>>> +       strlcpy(dump_data->kernel_ver, VERMAGIC_STRING,
>>> +               sizeof(dump_data->kernel_ver));
>>> +
>>> +       dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
>>> +       dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
>>> +
>>> +       /* Gather dbg-log */
>>> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
>>> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
>>> +       dump_tlv->tlv_len =
>>> cpu_to_le32(sizeof(crash_data->dbglog_entry_data));
>>
>>
>> Hmm should this really be sizeof()? Not next_idx (which effectively
>> defines number of bytes of the dbglog)?
>
>
> I haven't tried decoding this yet, but we may need to know the next_idx
> to decode this properly.

So basically a (length, payload) encoding would be necessary here
instead of a single stream, right?


>>> +               ret = ath10k_pci_diag_read_mem(ar, dbuf.buffer, buffer,
>>> +                                              dbuf.length);
>>> +               if (ret != 0) {
>>> +                       ath10k_warn("failed to read debug log buffer from
>>> address 0x%x: %d\n",
>>> +                                   dbuf.buffer, ret);
>>> +                       kfree(buffer);
>>> +                       return;
>>> +               }
>>> +
>>> +               ath10k_debug_dbglog_add(ar, buffer, dbuf.length);
>>> +               kfree(buffer);
>>
>>
>> Is the `buffer` really a string of bytes (u8) or just u32 in disguise?
>> If it's the former then on big-endian host the implicit byte swap will
>> mess it up and userspace will have no way of knowing that now.
>
>
> dbglog is array of 32 bit ints.

Thanks, this clears things. Then it is necessary to byte-swap
cpu_to_le32 before calling debug_dbglog_add.


Michał
